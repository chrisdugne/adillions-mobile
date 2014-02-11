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

	hud.subheaderImage 		= display.newImageRect(hud, "assets/images/subheader/subheader.bg.png", display.contentWidth, display.viewableContentHeight*0.14)
	hud.subheaderImage.x 	= display.contentWidth*0.5
	hud.subheaderImage.y 	= HEADER_HEIGHT * 1.5

	hud.subheaderText 		= display.newImage(hud, I "Questions.png")
	hud.subheaderText.x 		= display.contentWidth*0.6
	hud.subheaderText.y 		= HEADER_HEIGHT * 1.4
	
	
	local subheaderAnimConfig 	= require("src.tools.Subheader_"..LANG)
	local subheaderSheet 		= graphics.newImageSheet( "assets/images/subheader/anim.sheet."..LANG..".png", subheaderAnimConfig.sheet )

   hud.subheaderAnim 		= display.newSprite( hud, subheaderSheet, subheaderAnimConfig:newSequence() )
   hud.subheaderAnim.x 		= display.contentWidth*0.6
   hud.subheaderAnim.y 		= HEADER_HEIGHT * 1.8

	hud.subheaderButton 		= display.newImage(hud, "assets/images/subheader/button.subheader.png")
	hud.subheaderButton.x 	= display.contentWidth*0.15
	hud.subheaderButton.y 	= HEADER_HEIGHT * 1.6
	
	self:animateSubheader()

	------------------

	utils.onTouch(hud.subheaderImage, function()
		local next = function() router.openHome() end
		shareManager:invite(next)
	end)
	
	utils.onTouch(hud.subheaderButton, function()
		local next = function() router.openHome() end
		shareManager:invite(next)
	end)

	------------------

	lotteryManager:refreshNextLottery(function() self:drawNextLottery() end)

	------------------

	viewManager.setupView(0, 1)
	self.view:insert(hud)
	
end

------------------------------------------

function scene:animateSubheader()
	if(hud.subheaderAnim and hud.subheaderAnim.play) then
   	
   	hud.subheaderAnim:play()
   	
   	if(self.subheaderTimer) then
   		timer.cancel(self.subheaderTimer)
   	end
   	
   	self.subheaderTimer = timer.performWithDelay(4000, function() self:animateSubheader() end)
   end
end

------------------------------------------

function scene:drawNextLottery( event )

	local y 						= HEADER_HEIGHT * 3.7
	local top 					= HEADER_HEIGHT * 3
	local timerLegendSize 	= 17
	local timerLegendY 		= top + display.contentHeight * 0.04
	local timerY 				= top + display.contentHeight * 0.01

	-------------------------------

	viewManager.newText({
		parent = hud, 
		text = T "Next drawing" .. " : ", 
		x = display.contentWidth*0.17,
		y = top - display.contentHeight * 0.044,
		fontSize = 40,
      anchorX 			= 0,
      anchorY 			= 0.5,
	})

	hud.separator 			= display.newImage(hud, "assets/images/icons/separateur.horizontal.png")
	hud.separator.x 		= display.contentWidth*0.5
	hud.separator.y 		= top - display.contentHeight * 0.02
            	
	hud.pictoTimer			= display.newImage( hud, "assets/images/icons/TimerPicto.png")  
	hud.pictoTimer.x 		= display.contentWidth*0.2
	hud.pictoTimer.y 		= timerY 
	
	hud.timerDisplay = viewManager.newText({
		parent = hud, 
		text = '',     
		x = display.contentWidth*0.5,
		y = timerY - 5 ,
		fontSize = 53,
		font = NUM_FONT
	})
	
	viewManager.refreshHomeTimer()

	-------------------------------
	
	local daysX = display.contentWidth*0.305
	if(LANG == "en") then daysX = display.contentWidth*0.3 end
	
	viewManager.newText({
		parent = hud, 
		text = T "DAYS", 
		x = daysX,
		y = timerLegendY,
		fontSize = timerLegendSize,
	})

	viewManager.newText({
		parent = hud, 
		text = T "HRS", 
		x = display.contentWidth*0.437,
		y = timerLegendY,
		fontSize = timerLegendSize,
	})

	viewManager.newText({
		parent = hud, 
		text = T "MIN", 
		x = display.contentWidth*0.567,
		y = timerLegendY,
		fontSize = timerLegendSize,
	})

	viewManager.newText({
		parent = hud, 
		text = T "SEC", 
		x = display.contentWidth*0.698,
		y = timerLegendY,
		fontSize = timerLegendSize,
	})
	
	----------------------------------------------------
	
	local priceX
	if(lotteryManager.nextDrawing.nbPlayers > lotteryManager.nextDrawing.toolPlayers) then
		priceX = display.contentWidth*0.42
	else
		priceX = display.contentWidth*0.58
	end
	
	-------------------------------
	
	hud.priceDisplay = viewManager.newText({
		parent = hud, 
		text = '',     
		x = priceX ,
		y = top + display.contentHeight*0.12,
		fontSize = 73,
		font = NUM_FONT,
      anchorX 			= 1,
      anchorY 			= 0.5,
	})
	
	hud.priceCurrentDisplay = 0
	viewManager.animatePrice()

	-------------------------------
	
	hud.pictoCagnotte = display.newImage( hud, "assets/images/icons/cagnotte.png")  
	hud.pictoCagnotte.x = priceX + display.contentWidth*0.16
	hud.pictoCagnotte.y = top + display.contentHeight*0.12
	
	-------------------------------
	
	if(lotteryManager.nextDrawing.nbPlayers > lotteryManager.nextDrawing.toolPlayers) then	
	
   	hud.separateur = display.newImage( hud, "assets/images/icons/separateur.png")  
   	hud.separateur.x = display.contentWidth*0.7
   	hud.separateur.y = top + display.contentHeight*0.12
   	
   	-------------------------------
   
   	hud.pictoPlayers = display.newImage( hud, "assets/images/icons/players.png")  
   	hud.pictoPlayers.x = display.contentWidth*0.85
   	hud.pictoPlayers.y = top + display.contentHeight*0.09
   	
   	viewManager.newText({
   		parent = hud, 
   		text = T "Players" .. " :", 
   		x = display.contentWidth*0.85,
   		y = top + display.contentHeight*0.12,
   		fontSize = 24,
   	})
   	
   	viewManager.newText({
   		parent = hud, 
   		text = lotteryManager.nextDrawing.nbPlayers , 
   		x = display.contentWidth*0.85,
   		y = top + display.contentHeight*0.15,
   		fontSize = 43,
   		font = NUM_FONT
   	})
   
   end

	-------------------------------
	
	if(lotteryManager.nextDrawing.uid == lotteryManager.nextLottery.uid) then
   	if(userManager.user.extraTickets > 0) then
      	hud.playButton = display.newImage( hud, I "fillout.instant.ticket.png")
      else  
      	hud.playButton = display.newImage( hud, I "filloutticket.button.png")
      end
	
		utils.onTouch(hud.playButton, function()
			self:play()
		end)
		
   else  
   	hud.playButton = display.newImage( hud, I "waiting.png")
   	hud.playButton.alpha = 0.5
   end
	
	hud.playButton.x = display.contentWidth*0.5
	hud.playButton.y = top + display.contentHeight*0.24
	
	
	-------------------------------
	-- theme
	
	local url = ""
	if(lotteryManager.nextDrawing.theme.mobile) then
		url = lotteryManager.nextDrawing.theme.mobile[LANG]
	else
		url = lotteryManager.nextDrawing.theme.image -- to remove from 1.1 on production
	end
	
	viewManager.drawRemoteImage(url, hud, display.contentWidth*0.5, display.contentHeight * 0.75, 1, 1, function(image) image:toBack() end, lotteryManager.nextDrawing.theme.uid)
	
	------------------
	
	facebook.checkThemeLiked()

	------------------
end

------------------------------------------

function scene:play()
	if(userManager:hasTicketsToPlay()) then
		if(userManager:checkTicketTiming()) then
   		videoManager:play(router.openFillLotteryTicket, true)
   	end
   else
   	shareManager:noMoreTickets()
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