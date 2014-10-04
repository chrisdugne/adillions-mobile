-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--   unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()

    local title   = utils.urlEncode(T "Try your luck on Adillions !")
    local message   = utils.urlEncode(T "It's a free, fun and responsible game")

    local redirect_uri  = utils.urlEncode(API_URL.."backToMobile")
    local url           = "https://www.facebook.com/dialog/apprequests?app_id=".. FACEBOOK_APP_ID .. "&message=".. message .."&title=".. title .."&data=".. userManager.user.sponsorCode .."&redirect_uri=" .. redirect_uri .."&access_token=" .. GLOBALS.savedData.facebookAccessToken

    self.webView = native.newWebView( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    self.webView:request( url )
    self.webView:addEventListener( "urlRequest", function(event) self:inviteListener(event) end )
end

------------------------------------------

function scene:inviteListener( event )

    if event.url then
        print (event.url)

        if string.startsWith(event.url, API_URL .. "backToMobile?request=")
        or string.startsWith(event.url, "https://m.facebook.com/home.php") then
            self:closeWebView()
            if(self.next) then
                self.next()
            end

        elseif string.startsWith(event.url, API_URL .. "backToMobile") then

            self:closeWebView()
            if(self.next) then
                self.next()
            end
            local params = utils.getUrlParams(event.url);

            if(params.request) then
                print("-----> request " .. params.request )
                viewManager.message("Invitations sent !")
            end

        end

    end
end

function scene:closeWebView()
    self.webView:removeEventListener( "urlRequest", function(event) self:loginViewListener(event) end )
    self.webView:removeSelf()
    self.webView = nil
end

------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local params = event.params
    if(params) then
        self.next = params.next
    end
    self:refreshScene()
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene