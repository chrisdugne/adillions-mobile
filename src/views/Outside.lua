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

--   	native.showPopup( "social", {
--   		service = "facebook",
--   		message = "Check out this photo!",
--   		listener = eventListener,
--   		image = {
--   			{ filename = "/assets/images/hud/button.png" },
--   			{ filename = "/assets/images/hud/ko.png" },
--   		},
--   		url = "http://uralys.com"
--   	} )

end

-----------------------------------------------------------------------------------------

function scene:refreshScene()

	viewManager.initBack()
	viewManager.initHeader()
	
	---------------------------------------------------------------
	
--   hud.titleText = display.newText( {
--		parent = hud,
--		text = APP_NAME,     
--		x = display.contentWidth*0.5,
--		y = HEADER_HEIGHT*0.5,
--		font = FONT,   
--		fontSize = 55,
--	} )
--	
--	hud.titleText:setTextColor(0,100,0)
	
	---------------------------------------------------------------
	
	viewManager.drawButton("test video", display.contentWidth*0.5, display.contentHeight *0.3, router.openVideo)
	
	viewManager.drawButton("_Login", display.contentWidth*0.5, display.contentHeight *0.7, router.openLogin)
	viewManager.drawButton("_Signin", display.contentWidth*0.5, display.contentHeight *0.8, router.openSignin)
	
	---------------------------------------------------------------
	
	hud.whyText = display.newText( {
		parent = hud,
		text = "_Pourquoi s'inscrire ?",     
		x = display.contentWidth*0.5,
		y = display.contentHeight *0.9,
		font = FONT,   
		fontSize = 18,
	} )

	hud.whyText:setTextColor(0,100,0)
	utils.onTouch(hud.whyText,  function(event) system.openURL( "http://soundcloud.com/velvetcoffee" ) end)

	---------------------------------------------------------------
	
	hud.CGU = display.newText( {
		parent = hud,
		text = "_CGU",     
		x = display.contentWidth*0.5,
		y = display.contentHeight *0.94,
		font = FONT,   
		fontSize = 21,
	} )

	hud.CGU:setTextColor(0,100,0)
	utils.onTouch(hud.CGU,  function(event) system.openURL( "http://soundcloud.com/velvetcoffee" ) end)
	
	---------------------------------------------------------------

	self.view:insert(hud)
		
	---------------------------------------------------------------
end

------------------------------------------

function scene:openOptions()
	router.openOptions()	
end

function scene:openPodiums()
	router.openPodiums()	
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