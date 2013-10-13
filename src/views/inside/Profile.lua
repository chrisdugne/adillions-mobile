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

function scene:drawTextEntry(title, value, position)

	viewManager.newText({
		parent 			= hud.board, 
		text 				= title,         
		x 					= self.column1,
		y 					= self.top + self.yGap*position,
		fontSize 		= self.fontSize,
		referencePoint = display.CenterLeftReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= value,     
		x 					= self.column2,
		y 					= self.top + self.yGap*position,
		fontSize 		= self.fontSize,
		referencePoint = display.CenterLeftReferencePoint
	})
	
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()

	viewManager.initBoard()

	------------------

	self.top 		= HEADER_HEIGHT + 70
	self.yGap 		= 60
	self.fontSize 	= 40

	self.column1 = display.contentWidth*0.08
	self.column2 = display.contentWidth*0.4 
	
	------------------
	
	viewManager.drawBorder(hud.board, display.contentWidth*0.5, self.top, display.contentWidth*0.9, self.yGap * 1.5)
	self:drawTextEntry("_userName : ", userManager.user.userName, 0)
	
	viewManager.drawBorder(hud.board, display.contentWidth*0.5, self.top + self.yGap*3, display.contentWidth*0.9, self.yGap * 3.5)
	self:drawTextEntry("_firstName : ", userManager.user.firstName, 2)
	self:drawTextEntry("_lastName : ", userManager.user.lastName, 3)
	self:drawTextEntry("_birthDate : ", userManager.user.birthDate, 4)

	viewManager.drawBorder(hud.board, display.contentWidth*0.5, self.top + self.yGap*6.5, display.contentWidth*0.9, self.yGap * 2.5)
	self:drawTextEntry("_currentPoints : ", userManager.user.currentPoints, 6)
	self:drawTextEntry("_totalPoints : ", userManager.user.totalPoints, 7)
	
	------------------

	hud:insert(hud.board)
   	
	------------------

	viewManager.setupView(4)
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