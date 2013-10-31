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
	hud.subheaderText.x 		= display.contentWidth*0.5
	hud.subheaderText.y 		= HEADER_HEIGHT * 1.4
	
	
	local subheaderAnimConfig 	= require("src.tools.Subheader")
	local subheaderSheet 		= graphics.newImageSheet( "assets/images/subheader/anim.sheet.png", subheaderAnimConfig.sheet )

   hud.subheaderAnim 		= display.newSprite( hud, subheaderSheet, subheaderAnimConfig:newSequence() )
   hud.subheaderAnim.x 		= display.contentWidth*0.5
   hud.subheaderAnim.y 		= HEADER_HEIGHT * 1.8

	hud.subheaderArrow 		= display.newImage(hud, "assets/images/subheader/Fleche.png")
	hud.subheaderArrow.x 	= display.contentWidth*0.715
	hud.subheaderArrow.y 	= HEADER_HEIGHT * 1.805
	
	self:animateSubheader()

	------------------

	utils.onTouch(hud.subheaderImage, function()
		shareManager:invite()
	end)

	------------------

	viewManager.newText({
		parent = hud, 
		text = T ("Welcome") .. " " .. userManager.user.firstName .. " !", 
		x = display.contentWidth*0.05,
		y = display.contentHeight*0.25,
		fontSize = 43,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	------------------

	lotteryManager:refreshNextLottery(function() self:drawNextLottery() end)

	------------------

	viewManager.setupView(1)
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

	local y = HEADER_HEIGHT * 3.7
	local top = HEADER_HEIGHT * 3

	----------------------------------------------------
	
	viewManager.newText({
		parent = hud, 
		text = T("Next drawing") .. " " .. lotteryManager:date(lotteryManager.nextLottery), 
		x = display.contentWidth*0.05,
		y = top,
		fontSize = 23,
		referencePoint = display.CenterLeftReferencePoint
	})

	-------------------------------
	local priceX
	
	if(lotteryManager.nextLottery.nbPlayers > lotteryManager.nextLottery.toolPlayers) then
		priceX = display.contentWidth*0.47
	else
		priceX = display.contentWidth*0.58
	end
	
	local price = lotteryManager:price(lotteryManager.nextLottery)

	viewManager.newText({
		parent = hud, 
		text = price,     
		x = priceX,
		y = top + display.contentHeight*0.08,
		fontSize = 73,
		font = NUM_FONT,
		referencePoint = display.CenterRightReferencePoint
	})

	-------------------------------
	
	hud.pictoCagnotte = display.newImage( hud, "assets/images/icons/cagnotte.png")  
	hud.pictoCagnotte.x = priceX + display.contentWidth*0.09
	hud.pictoCagnotte.y = top + display.contentHeight*0.08
	
	-------------------------------
	
	if(lotteryManager.nextLottery.nbPlayers > lotteryManager.nextLottery.toolPlayers) then	
	
   	hud.separateur = display.newImage( hud, "assets/images/icons/separateur.png")  
   	hud.separateur.x = display.contentWidth*0.65
   	hud.separateur.y = top + display.contentHeight*0.08
   	
   	-------------------------------
   
   	hud.pictoPlayers = display.newImage( hud, "assets/images/icons/players.png")  
   	hud.pictoPlayers.x = display.contentWidth*0.75
   	hud.pictoPlayers.y = top + display.contentHeight*0.05
   	
   	viewManager.newText({
   		parent = hud, 
   		text = T "Players" .. " :", 
   		x = display.contentWidth*0.75,
   		y = top + display.contentHeight*0.08,
   		fontSize = 24,
   	})
   	
   	viewManager.newText({
   		parent = hud, 
   		text = lotteryManager.nextLottery.nbPlayers , 
   		x = display.contentWidth*0.75,
   		y = top + display.contentHeight*0.11,
   		fontSize = 43,
   		font = NUM_FONT
   	})
   
   end

	-------------------------------

	hud.playButton = display.newImage( hud, I "filloutticket.button.png")  
	hud.playButton.x = display.contentWidth*0.5
	hud.playButton.y = top + display.contentHeight*0.21
	
	utils.onTouch(hud.playButton, function()
		self:play()
	end)
	
	-------------------------------
	-- theme
	
	viewManager.drawRemoteImage(lotteryManager.nextLottery.theme.image, hud, display.contentWidth*0.5, display.contentHeight * 0.75)
	
	hud.themeTitle = display.newImage( hud, I "theme.png")
	hud.themeTitle.x = display.contentWidth*0.5
	hud.themeTitle.y = display.contentHeight*0.85

	------------------
	
	facebook.checkThemeLiked()

	------------------
end

------------------------------------------

function scene:play( )
	if(lotteryManager:isGameAvailable()) then
		videoManager:play(router.openFillLotteryTicket)
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