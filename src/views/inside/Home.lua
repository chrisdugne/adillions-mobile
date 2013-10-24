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

	hud.subheaderImage 		= display.newImageRect(hud, "assets/images/01_SubHeader_Background.png", display.contentWidth, display.viewableContentHeight*0.14)
	hud.subheaderImage.x 	= display.contentWidth*0.5
	hud.subheaderImage.y 	= HEADER_HEIGHT * 1.75

	hud.subheaderText 		= display.newImage(hud, I "01_SubHeader_Txt.png")
	hud.subheaderText.x 		= display.contentWidth*0.5
	hud.subheaderText.y 		= HEADER_HEIGHT * 1.7
	
	------------------

	utils.onTouch(hud.subheaderImage, function()
		router.openInviteFriends()
	end)

	utils.onTouch(hud.subheaderText, function()
		router.openInviteFriends()
	end)

	------------------

	viewManager.newText({
		parent = hud, 
		text = T ("Welcome") .. " " .. userManager.user.firstName .. " !", 
		x = display.contentWidth*0.05,
		y = display.contentHeight*0.28,
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

function scene:drawNextLottery( event )

	local y = HEADER_HEIGHT * 3.7
	local top = HEADER_HEIGHT * 3.3

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

	local price = lotteryManager:price(lotteryManager.nextLottery)

	viewManager.newText({
		parent = hud, 
		text = price,     
		x = display.contentWidth*0.5,
		y = top + display.contentHeight*0.08,
		fontSize = 73,
		font = NUM_FONT,
		referencePoint = display.CenterRightReferencePoint
	})

	-------------------------------
	
	hud.pictoCagnotte = display.newImage( hud, "assets/images/icons/02_Main_PictoCagnotte.png")  
	hud.pictoCagnotte.x = display.contentWidth*0.56
	hud.pictoCagnotte.y = top + display.contentHeight*0.08
	
	hud.separateur = display.newImage( hud, "assets/images/icons/02_Main_Separateur.png")  
	hud.separateur.x = display.contentWidth*0.65
	hud.separateur.y = top + display.contentHeight*0.08
	
	-------------------------------

	hud.pictoPlayers = display.newImage( hud, "assets/images/icons/02_Main_PictoPlayers.png")  
	hud.pictoPlayers.x = display.contentWidth*0.75
	hud.pictoPlayers.y = top + display.contentHeight*0.05
	
	viewManager.newText({
		parent = hud, 
		text = "Players" .. " :", 
		x = display.contentWidth*0.75,
		y = top + display.contentHeight*0.08,
		fontSize = 19,
	})
	
	viewManager.newText({
		parent = hud, 
		text = lotteryManager.nextLottery.nbPlayers , 
		x = display.contentWidth*0.75,
		y = top + display.contentHeight*0.11,
		fontSize = 43,
		font = NUM_FONT
	})

	-------------------------------

	hud.playButton = display.newImage( hud, I "02_Main_BoutonTicket.png")  
	hud.playButton.x = display.contentWidth*0.5
	hud.playButton.y = top + display.contentHeight*0.25
	
	utils.onTouch(hud.playButton, function()
		self:play()
	end)
	
	-------------------------------
	-- theme

	------------------
	
--	facebook.likeTheme(theme)
	
	------------------

	viewManager.drawRemoteImage(lotteryManager.nextLottery.theme.image, hud, display.contentWidth*0.5, display.contentHeight * 0.75)

	hud.playButton = display.newImage( hud, I "02_Main_BoutonTicket.png")  
	hud.playButton.x = display.contentWidth*0.5
	hud.playButton.y = top + display.contentHeight*0.25

	------------------

end

------------------------------------------

function scene:play( )
	sponsorpayTools.afterVideoSeen = router.openFillLotteryTicket
	vungle.afterVideoSeen = router.openFillLotteryTicket

	sponsorpayTools:requestOffers()
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