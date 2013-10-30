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

	local optionsTop 		= 13

	self.top 				= HEADER_HEIGHT + 70
	self.yGap 				= 60
	self.fontSizeLeft 	= 27
	self.fontSizeRight 	= 29

	self.column1 = display.contentWidth*0.1
	self.column2 = display.contentWidth*0.9 

	------------------

	viewManager.initBoard()

	------------------
	
	hud.facebookIcon 			= display.newImage( hud.board, "assets/images/icons/facebook.png")  
	hud.facebookIcon.x 		= display.contentWidth*0.5
	hud.facebookIcon.y		= display.contentHeight*0.2
	hud.board:insert(hud.facebookIcon)

	utils.onTouch(hud.facebookIcon, function()
		system.openURL( "https://www.facebook.com/pages/Adillions/379432705492888" )
	end)

	------------------

	hud.twitterIcon 			= display.newImage( hud.board, "assets/images/icons/twitter.png")  
	hud.twitterIcon.x 		= display.contentWidth*0.5
	hud.twitterIcon.y		= display.contentHeight*0.3
	hud.board:insert(hud.twitterIcon)

	utils.onTouch(hud.twitterIcon, function()
		system.openURL( "http://www.twitter.com/adillions" )
	end)
	
	------------------
	
	viewManager.drawButton(hud.board, "_Reglement", display.contentWidth*0.5, display.contentHeight *0.4, function() system.openURL( "http://www.adillions.com" ) end)

	------------------
	
	viewManager.drawButton(hud.board, "_FAQ", display.contentWidth*0.5, display.contentHeight *0.5, function() system.openURL( "http://www.adillions.com" ) end)

	---------------------------------------------------------------------------------
	-- Options
	---------------------------------------------------------------

	local function beforeDrawSwitchListener( event )
		GLOBALS.options.notificationBeforeDraw = event.target.isOn
		utils.saveTable(GLOBALS.options, "options.json")
		
   	lotteryManager:refreshNotifications(lotteryManager.nextLottery.date)
	end
	
	local function afterDrawSwitchListener( event )
		GLOBALS.options.notificationAfterDraw = event.target.isOn
		utils.saveTable(GLOBALS.options, "options.json")
	
   	lotteryManager:refreshNotifications(lotteryManager.nextLottery.date)	
	end

	---------------------------------------------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Notification 48h before the next draw",         
		x 					= self.column1,
		y 					= self.top + self.yGap*(optionsTop-0.5),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterLeftReferencePoint
	})

	local beforeDrawSwitch = widget.newSwitch
	{
		left 							= display.contentWidth*0.8,
		top 							= self.top + self.yGap*(optionsTop-0.7),
		initialSwitchState	 	= GLOBALS.options.notificationBeforeDraw,
		onPress 						= beforeDrawSwitchListener,
		onRelease 					= beforeDrawSwitchListener,
	}

	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Notification for the results",         
		x 					= self.column1,
		y 					= self.top + self.yGap*(optionsTop+0.5),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterLeftReferencePoint
	})


	local afterDrawSwitch = widget.newSwitch
	{
		left 							= display.contentWidth*0.8,
		top 							= self.top + self.yGap*(optionsTop+0.3),
		initialSwitchState	 	= GLOBALS.options.notificationAfterDraw,
		onPress 						= afterDrawSwitchListener,
		onRelease 					= afterDrawSwitchListener,
	}


	hud.board:insert( beforeDrawSwitch )	
	hud.board:insert( afterDrawSwitch )	

	------------------

	hud:insert(hud.board)
	
	-----------------------------

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