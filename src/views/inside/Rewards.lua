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

	local topBoard	= display.contentHeight * 0.1
	local optionsTop 		= 1

	self.top 				= HEADER_HEIGHT + 70
	self.yGap 				= 120
	self.fontSizeLeft 	= 27
	self.fontSizeRight 	= 29

	self.column1 = display.contentWidth*0.1
	self.column2 = display.contentWidth*0.9 

	------------------

	viewManager.initBoard()

	---------------------------------------------------------------------------------
	
	for i = 1, 26 do

   	hud.iconRang 			= display.newImage( hud.board, "assets/images/icons/rangs/Rang1.png")
   	hud.iconRang.x 		= display.contentWidth * 0.2
   	hud.iconRang.y 		= topBoard + self.yGap * (i-1)
   	hud.iconRang:scale 	(0.6,0.6)	
   	hud.board:insert(hud.iconRang)
   
   	viewManager.newText({
   		parent 			= hud.board, 
   		text	 			= i .."/26",     
   		x 					= display.contentWidth*0.45,
   		y 					= topBoard + self.yGap * (i-1) - display.contentHeight*0.005,
   		fontSize 		= 35,
   	})

   	hud.iconPieces 			= display.newImage( hud.board, "assets/images/icons/money.png")
   	hud.iconPieces.x 			= display.contentWidth * 0.86
   	hud.iconPieces.y 			= topBoard + self.yGap * (i-1) - display.contentHeight*0.01
		hud.board:insert(hud.iconPieces)
	end
	
	--------------------------

	hud.close 				= display.newImage( hud, I "popup.Bt_close.png")
	hud.close.x 			= display.contentWidth*0.5
	hud.close.y 			= display.contentHeight*0.85

	utils.onTouch(hud.close, function() router.openInfo() end)
	
	---------------------------------------------------------------------------------

	hud:insert(hud.board)
	
	-----------------------------

	viewManager.setupView(0)
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