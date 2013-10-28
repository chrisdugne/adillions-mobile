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

	------------------

	hud.facebookIcon 			= display.newImage( hud, "assets/images/icons/facebook.png")  
	hud.facebookIcon.x 		= display.contentWidth*0.5
	hud.facebookIcon.y		= display.contentHeight*0.2

	utils.onTouch(hud.facebookIcon, function()
		system.openURL( "https://www.facebook.com/pages/Adillions/379432705492888" )
	end)

	------------------

	hud.twitterIcon 			= display.newImage( hud, "assets/images/icons/twitter.png")  
	hud.twitterIcon.x 		= display.contentWidth*0.5
	hud.twitterIcon.y		= display.contentHeight*0.3

	utils.onTouch(hud.twitterIcon, function()
		system.openURL( "http://www.twitter.com/adillions" )
	end)
	
	------------------
	
	viewManager.drawButton(hud, "_Reglement", display.contentWidth*0.5, display.contentHeight *0.4, function() system.openURL( "http://www.adillions.com" ) end)

	------------------
	
	viewManager.drawButton(hud, "_FAQ", display.contentWidth*0.5, display.contentHeight *0.5, function() system.openURL( "http://www.adillions.com" ) end)

	------------------

	viewManager.setupView(5)
	self.view:insert(hud)
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