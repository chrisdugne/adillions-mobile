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

	---------------------------------------------------------------

	viewManager.initBack()

	---------------------------------------------------------------
	
	hud.bottom 				= display.newImageRect( hud, "assets/images/hud/Tuto_BottomBg.png", display.contentWidth, display.contentHeight*0.12)
	hud.bottom.x 			= display.contentWidth*0.5
	hud.bottom.y 			= display.contentHeight*0.94
	
	---------------------------------------------------------------
	
	hud.tuto1	 					= display.newGroup()
	hud.tuto2	 					= display.newGroup()
	hud.tuto3	 					= display.newGroup()

	hud:insert(hud.tuto1)
	hud:insert(hud.tuto2)
	hud:insert(hud.tuto3)
	
	hud.tuto1.x =	0
	hud.tuto2.x =	display.contentWidth
	hud.tuto3.x =	display.contentWidth*2
	
	---------------------------------------------------------------
	
	self:createTuto1()
	self:createTuto2()
	self:createTuto3()

	---------------------------------------------------------------
	
	hud.close 				= display.newImage( hud, "assets/images/hud/CroixClose.png")
	hud.close.x 			= display.contentWidth*0.92
	hud.close.y 			= display.contentHeight*0.04
	
	utils.onTouch(hud.close, function() self:exit() end)
	
	---------------------------------------------------------------

	self.view:insert(hud)

	---------------------------------------------------------------

end

------------------------------------------

function scene:createTuto1()

	hud.tuto1.welcome 			= display.newImage( hud.tuto1, I "Tuto_Welcome.png")
	hud.tuto1.welcome.x 			= display.contentWidth*0.5
	hud.tuto1.welcome.y 			= display.contentHeight*0.08
	
	hud.tuto1.logo 				= display.newImage( hud.tuto1, "assets/images/logo.png")
	hud.tuto1.logo.x 				= display.contentWidth*0.5
	hud.tuto1.logo.y 				= display.contentHeight*0.16
	hud.tuto1.logo:scale(1.5,1.5)

	hud.tuto1.bande 				= display.newImageRect( hud.tuto1, "assets/images/hud/Tuto_SubHeader_Bg.png", display.contentWidth, display.contentHeight*0.18)
	hud.tuto1.bande.x 			= display.contentWidth*0.5
	hud.tuto1.bande.y 			= display.contentHeight*0.33

	hud.tuto1.longtext 			= display.newImage( hud.tuto1, I "Tuto_SubHeader_Txt.png")
	hud.tuto1.longtext.x 		= display.contentWidth*0.5
	hud.tuto1.longtext.y 		= display.contentHeight*0.33

	hud.tuto1.eachweek = viewManager.newText({
		parent 			= hud.tuto1,
		text 				= T "Each week" .. " :", 
		fontSize			= 48,  
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.46,
	})
	
	hud.tuto1.ball1 				= display.newImage( hud.tuto1, "assets/images/hud/TutoBall1.png")
	hud.tuto1.ball1.x 			= display.contentWidth*0.3
	hud.tuto1.ball1.y 			= display.contentHeight*0.58
	
	hud.tuto1.theme = viewManager.newText({
		parent 			= hud.tuto1,
		text 				= T "theme", 
		fontSize			= 44,  
		x 					= display.contentWidth * 0.4,
		y 					= display.contentHeight*0.56,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	hud.tuto1.ball2 				= display.newImage( hud.tuto1, "assets/images/hud/TutoBall1.png")
	hud.tuto1.ball2.x 			= display.contentWidth*0.3
	hud.tuto1.ball2.y 			= display.contentHeight*0.69
	
	hud.tuto1.theme = viewManager.newText({
		parent 			= hud.tuto1,
		text 				= T "draw on", 
		fontSize			= 44,  
		x 					= display.contentWidth * 0.4,
		y 					= display.contentHeight*0.67,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	hud.tuto1.youtube 			= display.newImage( hud.tuto1, "assets/images/hud/Youtube.png")
	hud.tuto1.youtube.x 			= display.contentWidth*0.4 + hud.tuto1.theme.contentWidth + 90
	hud.tuto1.youtube.y 			= display.contentHeight*0.675
	
	hud.tuto1.ball3 				= display.newImage( hud.tuto1, "assets/images/hud/TutoBall1.png")
	hud.tuto1.ball3.x 			= display.contentWidth*0.3
	hud.tuto1.ball3.y 			= display.contentHeight*0.8
	
	hud.tuto1.theme = viewManager.newText({
		parent 			= hud.tuto1,
		text 				= T "chance to win", 
		fontSize			= 44,  
		x 					= display.contentWidth * 0.4,
		y 					= display.contentHeight*0.78,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	-------------------
	-- controls
	hud.tuto1.next = viewManager.newText({
		parent 			= hud.tuto1,
		text 				= T "NEXT", 
		fontSize			= 49,  
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.93,
	})
	
	hud.tuto1.next:setTextColor(255)
	
	hud.tuto1.arrowright 		= display.newImage( hud.tuto1, "assets/images/hud/Tuto_ArrowRight.png")
	hud.tuto1.arrowright.x 		= display.contentWidth*0.5 + hud.tuto1.next.contentWidth/2 + 50
	hud.tuto1.arrowright.y 		= display.contentHeight*0.93
	

	utils.onTouch(hud.tuto1.next, 			function() 	self:goTuto(2) end)
	utils.onTouch(hud.tuto1.arrowright, 	function() 	self:goTuto(2) end)
end

------------------------------------------

function scene:createTuto2()

	hud.tuto2.bg 		= display.newImageRect( hud.tuto2, "assets/images/hud/Tuto_2_Bg.jpg", display.contentWidth, display.contentHeight*0.88)  
	hud.tuto2.bg.x	 	= display.viewableContentWidth*0.5 
	hud.tuto2.bg.y 	= display.viewableContentHeight*0.44
	
	hud.tuto2.title 			= display.newImage( hud.tuto2, I "Tuto_Txt2.png")
	hud.tuto2.title.x 		= display.contentWidth*0.5
	hud.tuto2.title.y 		= display.contentHeight*0.15
	
	hud.tuto2.watchIcon 		= display.newImage( hud.tuto2, "assets/images/icons/Tuto_2_picto1.png")
	hud.tuto2.watchIcon.x 	= display.contentWidth*0.5
	hud.tuto2.watchIcon.y 	= display.contentHeight*0.27

	hud.tuto2.watch = viewManager.newText({
		parent 			= hud.tuto2,
		text 				= T "Watch an ad", 
		fontSize			= 39,  
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.33
	})
	
	hud.tuto2.watch:setTextColor(40)
	
	hud.tuto2.arrow1 		= display.newImage( hud.tuto2, "assets/images/hud/Tuto_ArrowDown.png")
	hud.tuto2.arrow1.x 	= display.contentWidth*0.5
	hud.tuto2.arrow1.y 	= display.contentHeight*0.39
	
	hud.tuto2.ticketIcon 		= display.newImage( hud.tuto2, "assets/images/icons/Tuto_2_picto2.png")
	hud.tuto2.ticketIcon.x 	= display.contentWidth*0.5
	hud.tuto2.ticketIcon.y 	= display.contentHeight*0.46

	hud.tuto2.obtain = viewManager.newText({
		parent 			= hud.tuto2,
		text 				= T "Get a lottery ticket", 
		fontSize			= 39,  
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.52
	})
	
	hud.tuto2.obtain:setTextColor(40)
	
	hud.tuto2.arrow2 		= display.newImage( hud.tuto2, "assets/images/hud/Tuto_ArrowDown.png")
	hud.tuto2.arrow2.x 	= display.contentWidth*0.5
	hud.tuto2.arrow2.y 	= display.contentHeight*0.58
	
	hud.tuto2.winIcon 		= display.newImage( hud.tuto2, "assets/images/icons/Tuto_2_picto3.png")
	hud.tuto2.winIcon.x 	= display.contentWidth*0.5
	hud.tuto2.winIcon.y 	= display.contentHeight*0.65

	hud.tuto2.win = viewManager.newText({
		parent 			= hud.tuto2,
		text 				= T "Win the Jackpot", 
		fontSize			= 39,  
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.71
	})

	hud.tuto2.win:setTextColor(40)

	hud.tuto2.finalText1 = viewManager.newText({
		parent 			= hud.tuto2,
		text 				= T "Several prize categories and lottery", 
		fontSize			= 39,  
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.78,
	})

	hud.tuto2.finalText1:setTextColor(40)

	hud.tuto2.finalText2 = viewManager.newText({
		parent 			= hud.tuto2,
		text 				= T "Tickets are available for each draw", 
		fontSize			= 39,  
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.82,
	})

	hud.tuto2.finalText2:setTextColor(40)
	
	-------------------
	-- controls
	
	hud.tuto2.arrowright 		= display.newImage( hud.tuto2, "assets/images/hud/Tuto_ArrowRight.png")
	hud.tuto2.arrowright.x 		= display.contentWidth*0.9
	hud.tuto2.arrowright.y 		= display.contentHeight*0.93
	
	hud.tuto2.next = viewManager.newText({
		parent 			= hud.tuto2,
		text 				= T "NEXT",       
		fontSize			= 49,  
		x 					= display.contentWidth * 0.86,
		y 					= display.contentHeight*0.93,
		referencePoint = display.CenterRightReferencePoint
	})

	hud.tuto2.next:setTextColor(255)
	
	hud.tuto2.arrowleft 		= display.newImage( hud.tuto2, "assets/images/hud/Tuto_ArrowLeft.png")
	hud.tuto2.arrowleft.x 	= display.contentWidth*0.1
	hud.tuto2.arrowleft.y 	= display.contentHeight*0.93
	
	hud.tuto2.previous = viewManager.newText({
		parent 			= hud.tuto2,
		text 				= T "PREVIOUS",       
		fontSize			= 49,  
		x 					= display.contentWidth * 0.14,
		y 					= display.contentHeight*0.93,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	hud.tuto2.previous:setTextColor(255)


	utils.onTouch(hud.tuto2.next, 			function() 	self:goTuto(3) end)
	utils.onTouch(hud.tuto2.arrowright, 	function() 	self:goTuto(3) end)
	utils.onTouch(hud.tuto2.previous, 		function() 	self:goTuto(1) end)
	utils.onTouch(hud.tuto2.arrowleft, 		function() 	self:goTuto(1) end)
	
end

------------------------------------------

function scene:createTuto3()

	hud.tuto3.bg 			= display.newImageRect( hud.tuto3, "assets/images/hud/Tuto_2_Bg.png", display.contentWidth, display.contentHeight*0.88)  
	hud.tuto3.bg.x	 		= display.viewableContentWidth*0.5 
	hud.tuto3.bg.y 		= display.viewableContentHeight*0.44

	hud.tuto3.visuel 		= display.newImage( hud.tuto3, "assets/images/hud/Tuto_3_Visuel.png")  
	hud.tuto3.visuel.x 	= display.viewableContentWidth*0.5 
	hud.tuto3.visuel.y 	= display.viewableContentHeight*0.5
	
	hud.tuto3.title 			= display.newImage( hud.tuto3, I "Tuto_Txt3.png")
	hud.tuto3.title.x 		= display.contentWidth*0.5
	hud.tuto3.title.y 		= display.contentHeight*0.15

	hud.tuto3.finalText1 = viewManager.newText({
		parent 			= hud.tuto3,
		text 				= T "Invite your friends to make", 
		fontSize			= 39,  
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.78,
	})

	hud.tuto3.finalText1:setTextColor(40)

	hud.tuto3.finalText2 = viewManager.newText({
		parent 			= hud.tuto3,
		text 				= T "the jackpot bigger", 
		fontSize			= 39,  
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.82,
	})

	hud.tuto3.finalText2:setTextColor(40)
	
	-------------------
	-- controls
	
	hud.tuto3.play 			= display.newImage( hud.tuto3, I "Tuto_bt_Play.png")
	hud.tuto3.play.x 			= display.contentWidth*0.75
	hud.tuto3.play.y 			= display.contentHeight*0.93

	hud.tuto3.arrowleft 		= display.newImage( hud.tuto3, "assets/images/hud/Tuto_ArrowLeft.png")
	hud.tuto3.arrowleft.x 	= display.contentWidth*0.1
	hud.tuto3.arrowleft.y 	= display.contentHeight*0.93
	
	hud.tuto3.previous = viewManager.newText({
		parent 			= hud.tuto3,
		text 				= T "PREVIOUS",       
		fontSize			= 49,  
		x 					= display.contentWidth * 0.14,
		y 					= display.contentHeight*0.93,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	hud.tuto3.previous:setTextColor(255)

	utils.onTouch(hud.tuto3.previous, 	function()	self:goTuto(2) end)
	utils.onTouch(hud.tuto3.arrowleft, 	function()	self:goTuto(2) end)
	utils.onTouch(hud.tuto3.play, 		function()	self:play() end)
	
end

------------------------------------------

function scene:goTuto(tuto)
	if(hud.tuto1.transition) then transition.cancel(hud.tuto1.transition) end
	if(hud.tuto2.transition) then transition.cancel(hud.tuto2.transition) end
	if(hud.tuto3.transition) then transition.cancel(hud.tuto3.transition) end

	hud.tuto1.transition = transition.to(hud.tuto1, { time=300, x= (1-tuto)*display.contentWidth })
	hud.tuto2.transition = transition.to(hud.tuto2, { time=300, x= (2-tuto)*display.contentWidth })
	hud.tuto3.transition = transition.to(hud.tuto3, { time=300, x= (3-tuto)*display.contentWidth })
end

------------------------------------------

function scene:exit()
	if(hud.tuto1.transition) then transition.cancel(hud.tuto1.transition) end
	if(hud.tuto2.transition) then transition.cancel(hud.tuto2.transition) end
	if(hud.tuto3.transition) then transition.cancel(hud.tuto3.transition) end

	GLOBALS.savedData.requireTutorial = false
	utils.saveTable(GLOBALS.savedData, "savedData.json")
	
	if(userManager.user and userManager.user.uid) then
		router.openInfo()
	else
		router.openOutside()
	end

end

function scene:play()
	if(hud.tuto1.transition) then transition.cancel(hud.tuto1.transition) end
	if(hud.tuto2.transition) then transition.cancel(hud.tuto2.transition) end
	if(hud.tuto3.transition) then transition.cancel(hud.tuto3.transition) end

	GLOBALS.savedData.requireTutorial = false
	utils.saveTable(GLOBALS.savedData, "savedData.json")
	
	if(userManager.user and userManager.user.uid) then
		router.openHome()
	else
		router.openOutside()
	end
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