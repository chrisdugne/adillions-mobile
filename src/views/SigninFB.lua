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
	
	local url = SERVER_URL .. "msigninFB"
	url = url .. "?last_name=" 	.. facebook.data.last_name
	url = url .. "&first_name=" 	.. facebook.data.first_name
	url = url .. "&picture_url=" 	.. utils.urlEncode(facebook.data.picture.data.url)
	url = url .. "&birth_date=" 	.. facebook.data.birthday
	url = url .. "&email=" 			.. facebook.data.email
	url = url .. "&facebookName=" .. facebook.data.name
	url = url .. "&facebookId=" 	.. facebook.data.id
	url = url .. "&lang=" 			.. LANG

	self.webView = native.newWebView( 0, 0, display.contentWidth, display.contentHeight )
	self.webView:request( url )
	self.webView:addEventListener( "urlRequest", function(event) self:signinFBViewListener(event) end )
	
	viewManager.initHeader()
	self.view:insert(hud)
end

------------------------------------------

function scene:signinFBViewListener( event )

    if event.url then

		print("---   signinFBViewListener")
		print(event.url)
	
   	if event.url == SERVER_URL .. "backToMobile" then
			self:closeWebView()   
			print("signinFB : backToMobile : outside")		 		
      	router.openOutside()

   	elseif event.url == SERVER_URL .. "requireLogout" then  -- changeAccount
			self:closeWebView()
			print("signinFB : requireLogout")		 		
			userManager:logout()    		

    	elseif string.find(event.url, "signedIn") then
			self:closeWebView()    		
			local playerRealNames = utils.getUrlParams(event.url);
			
			GLOBALS.savedData.authToken 				= playerRealNames.authToken
      	utils.saveTable(GLOBALS.savedData, "savedData.json")

			userManager:fetchPlayer()
			
		end

    end
end

function scene:closeWebView()
	self.webView:removeEventListener( "urlRequest", function(event) self:signinFBViewListener(event) end )
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