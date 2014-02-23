-----------------------------------------------------------------------------------------
--
-- AppHome.lua
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

    print("signinFB")
    print(facebook.data.name)
    print(utils.urlEncode(facebook.data.name))

    -- not facebook.data.birthday permission
    if(not facebook.data.birthday) then
        facebook.data.birthday = ""
    end
    -- not facebook.data.email permission
    if(not facebook.data.email) then
        facebook.data.email = ""
    end

    local url = SERVER_URL .. "msigninFB"
    url = url .. "?last_name="     .. utils.urlEncode(facebook.data.last_name)
    url = url .. "&first_name="    .. utils.urlEncode(facebook.data.first_name)
    url = url .. "&picture_url="   .. utils.urlEncode(facebook.data.picture.data.url)
    url = url .. "&birth_date="    .. facebook.data.birthday
    url = url .. "&email="         .. facebook.data.email
    url = url .. "&facebookName="  .. utils.urlEncode(facebook.data.name)
    url = url .. "&facebookId="    .. facebook.data.id
    url = url .. "&lang="          .. LANG

    self.signinFBWebView = native.newWebView( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    self.signinFBWebView:request(url)
    self.signinFBWebView:addEventListener( "urlRequest", function(event) self:signinFBViewListener(event) end )

end

------------------------------------------

function scene:signinFBViewListener( event )

    if event.url then

        if event.url == SERVER_URL .. "backToMobile" then
            self:closeWebView()   
            router.openOutside()

        elseif event.url == SERVER_URL .. "requireLogout" then  -- changeAccount
            self:closeWebView()
            print("signinFB : requireLogout")     
            userManager:logout()      

        elseif string.find(event.url, "signedIn") then
            self:closeWebView()      
            local playerRealNames = utils.getUrlParams(event.url);

            GLOBALS.savedData.authToken = playerRealNames.authToken
            utils.saveTable(GLOBALS.savedData, "savedData.json")

            userManager:fetchPlayer()

        end
    end
end

function scene:closeWebView()
    self.signinFBWebView:removeEventListener( "urlRequest", function(event) self:signinFBViewListener(event) end )
    self.signinFBWebView:removeSelf()
    self.signinFBWebView = nil
end

------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
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