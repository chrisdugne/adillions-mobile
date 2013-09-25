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
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()
	self.webView = native.newWebView( 0, 0, display.contentWidth, display.contentHeight )
	self.webView:request( SERVER_URL .. "mlogin" )
	self.webView:addEventListener( "urlRequest", function(event) self:loginViewListener(event) end )
end

------------------------------------------

function scene:loginViewListener( event )

    if event.url then

    	if string.find(string.lower(event.url), SERVER_URL .. "loggedin") then
			self:closeWebView()    		
			local params = utils.getUrlParams(event.url);
			utils.tprint(params)

    	elseif event.url == SERVER_URL .. "backToMobile" then
			self:closeWebView()    		
		
		end

    end
end

function scene:closeWebView()
	self.webView:removeEventListener( "urlRequest", function(event) self:loginViewListener(event) end )
	self.webView:removeSelf()
	self.webView = nil
	router.openOutside()
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