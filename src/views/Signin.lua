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
    self.webView = native.newWebView( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    self.webView:request( API_URL .. "msignin2?lang=" .. LANG  )
    self.webView:addEventListener( "urlRequest", function(event) self:signinViewListener(event) end )

    viewManager.initHeader()
    self.view:insert(hud)

end

------------------------------------------

function scene:signinViewListener( event )

    if event.url then

        print("---   signin listener")
        print(event.url)

        -- idem login
        if string.find(string.lower(event.url), API_URL .. "loggedin") then
            self:closeWebView()      
            local params = utils.getUrlParams(event.url);

            GLOBALS.savedData.authToken  = params.authToken         
            GLOBALS.savedData.user.email  = params.email   
            utils.saveTable(GLOBALS.savedData, "savedData.json")

            userManager:fetchPlayer()

        elseif event.url == API_URL .. "backToMobile" then
            self:closeWebView()      
            print("signin : backToMobile : outside")  
            router.openOutside()

        elseif event.url == API_URL .. "connectWithFB" then
            self:closeWebView()    
            facebook.login()
        end

    end
end

function scene:closeWebView()
    self.webView:removeEventListener( "urlRequest", function(event) self:signinViewListener(event) end )
    self.webView:removeSelf()
    self.webView = nil
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