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
	self:drawScene() 
end

-----------------------------------------------------------------------------------------

function scene:drawScene()

	viewManager.initBoard()

	------------------

	local statusTop 			= 3
	local gainsTop 			= 10.5
	local detailsTop 			= 20
	local socialTop 			= 27
	local sponsorTop 			= 40
	local logoutTop 			= 49
		
	------------------

	self.top 				= HEADER_HEIGHT + display.contentHeight*0.1
	self.yGap 				= 60
	self.fontSizeLeft 	= 37
	self.fontSizeRight 	= 35

	self.column1 = display.contentWidth*0.07
	self.column2 = display.contentWidth*0.9 
	
	---------------------------------------------------------------
	-- Top picture
	---------------------------------------------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= userManager.user.userName,         
		x 					= display.contentWidth*0.4,
		y 					= self.top + display.contentHeight*0.02,
		fontSize 		= 35,
		referencePoint = display.CenterLeftReferencePoint
	})


	if(userManager.user.facebookId) then
   	display.loadRemoteImage( facebook.data.picture.data.url, "GET", function(event)
   		local picture = event.target	
   		hud.board:insert(picture)
   		picture.x = display.contentWidth*0.2
   		picture.y = self.top + display.contentHeight*0.02
   	end, 
   	"profilePicture", system.TemporaryDirectory)
   else
   	hud.dummyPicture 			= display.newImage( hud.board, "assets/images/hud/dummy.profile.png")
   	hud.dummyPicture.x 		= display.contentWidth*0.2
   	hud.dummyPicture.y 		= self.top + display.contentHeight*0.02
   	hud.board:insert(hud.dummyPicture)
   	
	end
	
	---------------------------------------------------------------
	-- Personal Details
	---------------------------------------------------------------
	
	hud.lineDetails 			= display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
	hud.lineDetails.x 		= display.contentWidth*0.5
	hud.lineDetails.y 		= self.top + self.yGap*detailsTop
	hud.board:insert(hud.lineDetails)

	hud.titleDetails 			= display.newImage( hud.board, I "details.png")  
	hud.titleDetails:setReferencePoint(display.CenterLeftReferencePoint);
	hud.titleDetails.x 		= display.contentWidth*0.05
	hud.titleDetails.y		= self.top + self.yGap*detailsTop
	hud.board:insert(hud.titleDetails)

	------------------
	
	self:drawTextEntry(T "First name" 	.. " : ", userManager.user.firstName, detailsTop+2)
	self:drawTextEntry(T "Last name" 	.. " : ", userManager.user.lastName, detailsTop+3)
	self:drawTextEntry(T "Email" 			.. " : ", userManager.user.email, detailsTop+4)
	self:drawTextEntry(T "Date of birth" 		.. " : ", utils.readableDate(utils.userManager.user.birthDate), detailsTop+5)

	---------------------------------------------------------------
	-- Status
	---------------------------------------------------------------
	
	hud.lineStatus 			= display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
	hud.lineStatus.x 			= display.contentWidth*0.5
	hud.lineStatus.y 			= self.top + self.yGap*statusTop
	hud.board:insert(hud.lineStatus)

	hud.titleStatus 			= display.newImage( hud.board, I "status.png")  
	hud.titleStatus:setReferencePoint(display.CenterLeftReferencePoint);
	hud.titleStatus.x 		= display.contentWidth*0.05
	hud.titleStatus.y			= self.top + self.yGap*statusTop
	hud.board:insert(hud.titleStatus)
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Total points" .. " : ",         
		x 					= self.column1,
		y 					= self.top + self.yGap*(statusTop+1),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterLeftReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= userManager.user.totalPoints .. " pts",     
		x 					= self.column1 + display.contentWidth*0.05,
		y 					= self.top + self.yGap*(statusTop+2),
		fontSize 		= 40,
		font				= NUM_FONT,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Bonus Tickets" .. " : ",         
		x 					= self.column2,
		y 					= self.top + self.yGap*(statusTop+1),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterRightReferencePoint
	})


	hud.iconTicket 			= display.newImage( hud.board, "assets/images/icons/PictoBonus.png")
	hud.iconTicket.x 			= self.column2 - display.contentWidth*0.05
	hud.iconTicket.y 			= self.top + self.yGap*(statusTop+2) + display.contentHeight*0.005
	hud.board:insert(hud.iconTicket)
	
	viewManager.newText({
		parent 			= hud.board, 
		text	 			= userManager.user.totalBonusTickets,     
		x 					= self.column2 - display.contentWidth*0.11,
		y 					= self.top + self.yGap*(statusTop+2),
		fontSize 		= self.fontSizeRight,
		font				= NUM_FONT,
		fontSize 		= 40,
		referencePoint = display.CenterRightReferencePoint
	})

	--------------------------

	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Charity profile",            
		x 					= self.column1,
		y 					= self.top + self.yGap*(statusTop+3.5),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterLeftReferencePoint
	})

	for i=1,5 do 
   	hud.iconCharity 			= display.newImage( hud.board, "assets/images/icons/CharitiesOFF.png")
   	hud.iconCharity.x 		= display.contentWidth*0.05 + i * display.contentWidth*0.05  
   	hud.iconCharity.y 		= self.top + self.yGap*(statusTop+4.5)
   	hud.board:insert(hud.iconCharity)
	end

	hud.iconCharity 			= display.newImage( hud.board, "assets/images/icons/CharitiesON.png")
	hud.iconCharity.x 		= display.contentWidth*0.1 
	hud.iconCharity.y 		= self.top + self.yGap*(statusTop+4.5)
	hud.board:insert(hud.iconCharity)
	
	local charity = {"Starter"}
	
	viewManager.newText({
		parent 			= hud.board, 
		text	 			= T(charity[1]),              
		x 					= self.column1 + display.contentWidth*0.07,
		y 					= self.top + self.yGap*(statusTop+5.5),
		fontSize 		= self.fontSizeRight,
		fontSize 		= 30,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Donation" .. " : ",         
		x 					= self.column2,
		y 					= self.top + self.yGap*(statusTop+3.5),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterRightReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= utils.displayPrice(userManager.user.totalGift, COUNTRY) ,        
		x 					= self.column2,
		y 					= self.top + self.yGap*(statusTop+4.5),
		font				= NUM_FONT,
		fontSize 		= 40,
		referencePoint = display.CenterRightReferencePoint
	})
	
	
	---------------------------------------------------------------
	-- Gains
	---------------------------------------------------------------
	
	hud.lineGains 			= display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
	hud.lineGains.x 			= display.contentWidth*0.5
	hud.lineGains.y 			= self.top + self.yGap*gainsTop
	hud.board:insert(hud.lineGains)

	hud.titleGains 			= display.newImage( hud.board, I "Gain.png")  
	hud.titleGains:setReferencePoint(display.CenterLeftReferencePoint);
	hud.titleGains.x 		= display.contentWidth*0.05
	hud.titleGains.y			= self.top + self.yGap*gainsTop
	hud.board:insert(hud.titleGains)
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Total gains" .. " : ",         
		x 					= self.column1,
		y 					= self.top + self.yGap*(gainsTop+1),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterLeftReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= utils.displayPrice(userManager.user.totalGains, COUNTRY) ,   
		x 					= self.column1 + display.contentWidth*0.26, 
		y 					= self.top + self.yGap*(gainsTop+2),
		fontSize 		= 40,
		font				= NUM_FONT,
		referencePoint = display.CenterRightReferencePoint
	})
	
	hud.iconMoney 			= display.newImage( hud.board, "assets/images/icons/money.png")
	hud.iconMoney.x 		= self.column1 + display.contentWidth*0.31
	hud.iconMoney.y 		= self.top + self.yGap*(gainsTop+2) - display.contentHeight*0.004
	hud.board:insert(hud.iconMoney)
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Gains payed" .. " : ",         
		x 					= self.column2,
		y 					= self.top + self.yGap*(gainsTop+1),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterRightReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= utils.displayPrice(userManager.user.receivedGains, COUNTRY) ,     
		x 					= self.column2 -  display.contentWidth*0.07,
		y 					= self.top + self.yGap*(gainsTop+2),
		fontSize 		= self.fontSizeRight,
		font				= NUM_FONT,
		fontSize 		= 40,
		referencePoint = display.CenterRightReferencePoint
	})
	
	hud.iconMoney 			= display.newImage( hud.board, "assets/images/icons/PictogainPayed.png")
	hud.iconMoney.x 		= self.column2 
	hud.iconMoney.y 		= self.top + self.yGap*(gainsTop+2)
	hud.board:insert(hud.iconMoney)
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Gains balance" .. " : ",         
		x 					= display.contentWidth*0.5,
		y 					= self.top + self.yGap*(gainsTop+4),
		fontSize 		= self.fontSizeLeft,
	})

	local balance = utils.displayPrice(userManager.user.balance, COUNTRY)
	if(userManager.user.pendingGains > 0) then
		balance = balance  .. " (" .. utils.displayPrice(userManager.user.pendingGains, COUNTRY) .. ")"
	end

	local totalGainsText = viewManager.newText({
		parent 			= hud.board, 
		text	 			= balance,   
		x 					= display.contentWidth*0.5, 
		y 					= self.top + self.yGap*(gainsTop+5),
		fontSize 		= 35,
		font				= NUM_FONT,
		referencePoint = display.CenterRightReferencePoint
	})
	
	hud.iconMoney 			= display.newImage( hud.board, "assets/images/icons/PictoBalance.png")
	hud.iconMoney.x 		= display.contentWidth*0.58
	hud.iconMoney.y 		= self.top + self.yGap*(gainsTop+5) - display.contentHeight*0.004
	hud.board:insert(hud.iconMoney)

	--------------------------
	
   hud.cashout 		= display.newImage( hud.board, I "cashout.button.png")  
   hud.cashout.x 		= display.contentWidth*0.5
   hud.cashout.y		= self.top + self.yGap*(gainsTop+7.5)
   hud.board:insert(hud.cashout)

	utils.onTouch(hud.cashout, function() 
		self:openCashout()
	end)
	
	---------------------------------------------------------------
	-- SOCIALS
	---------------------------------------------------------------
	
	hud.lineSocials 				= display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
	hud.lineSocials.x 			= display.contentWidth*0.5
	hud.lineSocials.y 			= self.top + self.yGap*socialTop
	hud.board:insert(hud.lineSocials)

	hud.titleSocials 				= display.newImage( hud.board, I "socials.png")  
	hud.titleSocials:setReferencePoint(display.CenterLeftReferencePoint);
	hud.titleSocials.x 			= display.contentWidth*0.05
	hud.titleSocials.y			= self.top + self.yGap*socialTop
	hud.board:insert(hud.titleSocials)
	
	---------------------------------------------------------------
	-- FACEBOOK
	---------------------------------------------------------------
	
	if(userManager.user.facebookId) then
      hud.facebookConnect 		= display.newImage( hud.board, I "facebook.connected.png")  
		hud.facebookConnect:setReferencePoint(display.CenterLeftReferencePoint)
		hud.facebookConnect.x 	= display.contentWidth*0.05
      hud.facebookConnect.y	= self.top + self.yGap*(socialTop+2.5)
      hud.board:insert(hud.facebookConnect)
	
   else
      hud.facebookConnect 		= display.newImage( hud.board, I "facebook.connect.button.png")  
		hud.facebookConnect:setReferencePoint(display.CenterLeftReferencePoint)
		hud.facebookConnect.x 	= display.contentWidth*0.05
      hud.facebookConnect.y	= self.top + self.yGap*(socialTop+2.5)
      hud.board:insert(hud.facebookConnect)
   
		utils.onTouch(hud.facebookConnect, function() 
			facebook.connect(function()
				router.resetScreen()
				self:refreshScene()
			end) 
		end)

	end

	if(userManager.user.facebookFan) then
		facebookFanTitle = T "Thank you for being a fan !"
		facebookFanState = "on"

		hud.facebookLikeDone 		= display.newImage( hud.board, I "facebook.like.done.png") 
		hud.facebookLikeDone:setReferencePoint(display.CenterLeftReferencePoint)
		hud.facebookLikeDone.x 	= display.contentWidth*0.05
		hud.facebookLikeDone.y	= self.top + self.yGap*(socialTop+5.2)
		hud.board:insert(hud.facebookLikeDone)
	else
		if(userManager.user.facebookId) then
			hud.facebookLike 		= display.newImage( hud.board, I "facebook.like.enabled.png")  
			hud.facebookLike:setReferencePoint(display.CenterLeftReferencePoint)
			hud.facebookLike.x 	= display.contentWidth*0.05
			hud.facebookLike.y	= self.top + self.yGap*(socialTop+5.2)
			hud.board:insert(hud.facebookLike)

			utils.onTouch(hud.facebookLike, function()
				-- todo : listener pour trouver qd revenir ?
				local url = "https://www.facebook.com/pages/Adillions/379432705492888"
				native.showWebPopup(0, 0, display.contentWidth, display.contentHeight, url) 
			end)
		else
			hud.facebookLikeDisabled 		= display.newImage( hud.board, I "facebook.like.disabled.png")
			hud.facebookLikeDisabled:setReferencePoint(display.CenterLeftReferencePoint)
			hud.facebookLikeDisabled.x 	= display.contentWidth*0.05
			hud.facebookLikeDisabled.y	= self.top + self.yGap*(socialTop+5.2)
			hud.board:insert(hud.facebookLikeDisabled)

		end
	end
	
	----------
	-- tickets icons
	
	local textBonus1 = viewManager.newText({
		parent 			= hud.board, 
		text	 			= FACEBOOK_CONNECTION_TICKETS,     
		x 					= display.contentWidth*0.89,
		y 					= self.top + self.yGap*(socialTop+2.5),
		font				= NUM_FONT,
		fontSize 		= 33,
		referencePoint = display.CenterRightReferencePoint
	})
	
   hud.facebookBonus1 		= display.newImage( hud.board, "assets/images/icons/PictoBonus.png")  
   hud.facebookBonus1.x 	= display.contentWidth*0.93
   hud.facebookBonus1.y		= self.top + self.yGap*(socialTop+2.5)
   hud.board:insert(hud.facebookBonus1)

	local textBonus2 = viewManager.newText({
		parent 			= hud.board, 
		text	 			= FACEBOOK_FAN_TICKETS,     
		x 					= display.contentWidth*0.48,
		y 					= self.top + self.yGap*(socialTop+5.2),
		font				= NUM_FONT,
		fontSize 		= 33,
		referencePoint = display.CenterRightReferencePoint
	})
	
   hud.facebookBonus2 		= display.newImage( hud.board, "assets/images/icons/PictoBonus.png")  
   hud.facebookBonus2.x 	= display.contentWidth*0.52
   hud.facebookBonus2.y		= self.top + self.yGap*(socialTop+5.2)
   hud.board:insert(hud.facebookBonus2)

	utils.setGreen(textBonus1)
	utils.setGreen(textBonus2)
	
	---------------------------------------------------------------
	-- TWITTER
	---------------------------------------------------------------
	
		
	if(twitter.connected) then
      hud.twitterConnect 				= display.newImage( hud.board, I "twitter.connected.png")  
		hud.twitterConnect:setReferencePoint(display.CenterLeftReferencePoint)
		hud.twitterConnect.x 	= display.contentWidth*0.05
      hud.twitterConnect.y				= self.top + self.yGap*(socialTop+8)
      hud.board:insert(hud.twitterConnect)

		twitterConnectedTitle = T "Connected"
		twitterConnectedState = "on"
		
   else
      hud.twitterConnect 				= display.newImage( hud.board, I "twitter.connect.button.png")  
		hud.twitterConnect:setReferencePoint(display.CenterLeftReferencePoint)
		hud.twitterConnect.x 	= display.contentWidth*0.05
      hud.twitterConnect.y				= self.top + self.yGap*(socialTop+8)
      hud.board:insert(hud.twitterConnect)
      
		utils.onTouch(hud.twitterConnect, function() 
			twitter.connect(function()
				router.resetScreen()
				self:refreshScene()
			end) 
		end)
			
	end
	
	if(userManager.user.twitterFan) then
		twitterFanTitle = T "Thank you for being a fan !"
		twitterFanState = "on"

		hud.twitterFollowing 		= display.newImage( hud.board, I "twitter.following.png")  
		hud.twitterFollowing:setReferencePoint(display.CenterLeftReferencePoint)
		hud.twitterFollowing.x 	= display.contentWidth*0.05
		hud.twitterFollowing.y	= self.top + self.yGap*(socialTop+10.7)
      hud.board:insert(hud.twitterFollowing)
	else
		if(twitter.connected) then
         hud.twitterFollow 		= display.newImage( hud.board, I "twitter.follow.png") 
         hud.twitterFollow:setReferencePoint(display.CenterLeftReferencePoint)
         hud.twitterFollow.x 	= display.contentWidth*0.05
         hud.twitterFollow.y	= self.top + self.yGap*(socialTop+10.7)
         hud.board:insert(hud.twitterFollow)
         
   		utils.onTouch(hud.twitterFollow, function()
   		
				native.setActivityIndicator( true )	 
   			twitter.follow(function()
					native.setActivityIndicator( false )		
   				userManager.user.twitterFan = true
   				router.resetScreen()
   				self:refreshScene()
   			end) 
   		end)
   	else
         hud.twitterFollowDisabled 		= display.newImage( hud.board, I "twitter.follow.disabled.png")
         hud.twitterFollowDisabled:setReferencePoint(display.CenterLeftReferencePoint)
         hud.twitterFollowDisabled.x 	= display.contentWidth*0.05
         hud.twitterFollowDisabled.y	= self.top + self.yGap*(socialTop+10.7)
         hud.board:insert(hud.twitterFollowDisabled)
		end
	end


	----------
	-- tickets icons
	
	local textBonus1 = viewManager.newText({
		parent 			= hud.board, 
		text	 			= FACEBOOK_CONNECTION_TICKETS,     
		x 					= display.contentWidth*0.89,
		y 					= self.top + self.yGap*(socialTop+8),
		font				= NUM_FONT,
		fontSize 		= 33,
		referencePoint = display.CenterRightReferencePoint
	})
	
   hud.facebookBonus1 		= display.newImage( hud.board, "assets/images/icons/PictoBonus.png")  
   hud.facebookBonus1.x 	= display.contentWidth*0.93
   hud.facebookBonus1.y		= self.top + self.yGap*(socialTop+8)
   hud.board:insert(hud.facebookBonus1)

	local textBonus2 = viewManager.newText({
		parent 			= hud.board, 
		text	 			= FACEBOOK_FAN_TICKETS,     
		x 					= display.contentWidth*0.48,
		y 					= self.top + self.yGap*(socialTop+10.7),
		font				= NUM_FONT,
		fontSize 		= 33,
		referencePoint = display.CenterRightReferencePoint
	})
	
   hud.facebookBonus2 		= display.newImage( hud.board, "assets/images/icons/PictoBonus.png")  
   hud.facebookBonus2.x 	= display.contentWidth*0.52
   hud.facebookBonus2.y		= self.top + self.yGap*(socialTop+10.7)
   hud.board:insert(hud.facebookBonus2)

	utils.setGreen(textBonus1)
	utils.setGreen(textBonus2)
	

	---------------------------------------------------------------------------------
	-- REFERRER
	---------------------------------------------------------------
	
	hud.lineSponsor 				= display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
	hud.lineSponsor.x 			= display.contentWidth*0.5
	hud.lineSponsor.y 			= self.top + self.yGap*sponsorTop
	hud.board:insert(hud.lineSponsor)

	hud.titleSponsor 				= display.newImage( hud.board, I "sponsor.png")  
	hud.titleSponsor:setReferencePoint(display.CenterLeftReferencePoint);
	hud.titleSponsor.x 			= display.contentWidth*0.05
	hud.titleSponsor.y			= self.top + self.yGap*sponsorTop
	hud.board:insert(hud.titleSponsor)
	
	-----------------------------------------------------------------

	hud.frameSponsor 				= display.newImage( hud.board, "assets/images/hud/Code.png")  
	hud.frameSponsor.x 			= display.contentWidth*0.5
	hud.frameSponsor.y			= self.top + self.yGap*(sponsorTop+2.2)
	hud.board:insert(hud.frameSponsor)
	
	viewManager.newText({
		parent 			= hud.board, 
		text	 			= userManager.user.sponsorCode,     
		x 					= display.contentWidth*0.5,
		y 					= self.top + self.yGap*(sponsorTop+2.2),
		fontSize 		= 45,
		font				= NUM_FONT,
	})
	
	
	hud.sponsorButton 		= display.newImage(hud.board, I "sponsor.button.png")
	hud.sponsorButton.x 		= display.contentWidth*0.5
	hud.sponsorButton.y 		=  self.top + self.yGap*(sponsorTop+5.5)
	hud.board:insert(hud.sponsorButton)
		
	utils.onTouch(hud.sponsorButton, function()
		shareManager:invite()
	end)
	
	-----------------------------------------------

	hud.logoutLine 			= display.newImage( hud.board, "assets/images/hud/Filet.png")  
	hud.logoutLine .x 		= display.contentWidth*0.5
	hud.logoutLine .y			= self.top + self.yGap*(logoutTop)
	hud.board:insert(hud.logoutLine )

	hud.logoutCadenas 			= display.newImage( hud.board, "assets/images/hud/Cadenas.png")  
	hud.logoutCadenas .x 		= display.contentWidth*0.5
	hud.logoutCadenas .y			= self.top + self.yGap*(logoutTop)
	hud.board:insert(hud.logoutCadenas )
	
	hud.board.logout = display.newImage( hud.board, I "Logout.png")  
	hud.board.logout.x = display.contentWidth*0.5
	hud.board.logout.y =  self.top + self.yGap * (logoutTop+2)
	hud.board:insert( hud.board.logout )	

	utils.onTouch(hud.board.logout, function()
		userManager:logout()
	end)	
	
	------------------

	hud:insert(hud.board)

	------------------

	viewManager.setupView(4)
	self.view:insert(hud)
end

-----------------------------------------------------------------------------------------

function scene:drawTextEntry(title, value, position, fontSizeLeft, fontSizeRight)

	viewManager.newText({
		parent 			= hud.board, 
		text 				= title,         
		x 					= self.column1,
		y 					= self.top + self.yGap*position,
		fontSize 		= fontSizeLeft or self.fontSizeLeft,
		referencePoint = display.CenterLeftReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= value,     
		x 					= self.column2,
		y 					= self.top + self.yGap*position,
		fontSize 		= fontSizeRight or self.fontSizeRight,
		font				= NUM_FONT,
		referencePoint = display.CenterRightReferencePoint
	})
	
end

-----------------------------------------------------------------------------------------

function scene:drawConnection(title, state, position)

	viewManager.newText({
		parent 			= hud.board, 
		text 				= title,         
		x 					= display.contentWidth*0.75,
		y 					= self.top + self.yGap*position,
		fontSize 		= 21,
		referencePoint = display.CenterRightReferencePoint
	})
	
	local light 	= display.newImage(hud.board, "assets/images/hud/".. state ..".png")
	light.x 			= display.contentWidth*0.8
	light.y 			= self.top + self.yGap*position + 3
	hud.board:insert(light)

end

-----------------------------------------------------------------------------------------

function scene:openCashout()

	-----------------------------------

	viewManager.showPopup()
	analytics.event("Gaming", "opencashout") 
	
	----------------------------------------------------------------------------------------------------
	
	hud.popup.shareIcon 				= display.newImage( hud.popup, "assets/images/icons/PictoShare.png")  
	hud.popup.shareIcon.x 			= display.contentWidth*0.5
	hud.popup.shareIcon.y			= display.contentHeight*0.17

	----------------------------------------------------------------------------------------------------
	
	local min = 10
	if(not utils.isEuroCountry(COUNTRY)) then
		min = 15
	end
	
	if(userManager.user.balance > min) then
		hud.cashoutEnabled 				= display.newImage( hud.popup, I "twitter.connected.png")  
		hud.cashoutEnabled.x 			= display.contentWidth*0.5
      hud.cashoutEnabled.y				= display.contentHeight*0.6
   	utils.onTouch(hud.cashoutEnabled, function() self.openConfirmCashout() end)
   else
		hud.cashoutDisabled 				= display.newImage( hud.popup, I "twitter.connect.button.png")  
		hud.cashoutDisabled.x 			= display.contentWidth*0.5
      hud.cashoutDisabled.y			= display.contentHeight*0.6
	end
	
	if(userManager.user.balance > 0) then
   	hud.giveToCharity 				= display.newImage( hud.popup, I "twitter.connected.png")  
   	hud.giveToCharity.x 				= display.contentWidth*0.5
      hud.giveToCharity.y				= display.contentHeight*0.73
   	utils.onTouch(hud.giveToCharity, function() self.openGiveToCharity() end)
   else
		hud.giftDisabled 					= display.newImage( hud.popup, I "twitter.connect.button.png")  
		hud.giftDisabled.x 				= display.contentWidth*0.5
      hud.giftDisabled.y				= display.contentHeight*0.73
	end

	
	----------------------------------------------------------------------------------------------------
	
	hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
	hud.popup.close.x 			= display.contentWidth*0.5
	hud.popup.close.y 			= display.contentHeight*0.86
	
	utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)
	

end

-----------------------------------------------------------------------------------------

function scene:openGiveToCharity()

	-----------------------------------

	viewManager.showPopup()
	analytics.event("Gaming", "openGiveToCharity") 
	
	----------------------------------------------------------------------------------------------------
	
	hud.popup.shareIcon 				= display.newImage( hud.popup, "assets/images/icons/PictoShare.png")  
	hud.popup.shareIcon.x 			= display.contentWidth*0.5
	hud.popup.shareIcon.y			= display.contentHeight*0.17

	----------------------------------------------------------------------------------------------------
	
	hud.giveToCharity 				= display.newImage( hud.popup, I "twitter.connected.png")  
	hud.giveToCharity.x 				= display.contentWidth*0.5
   hud.giveToCharity.y				= display.contentHeight*0.6

	local refresh = function() scene:refreshScene() end
	
	utils.onTouch(hud.giveToCharity, function() 
		analytics.event("Gaming", "giveToCharity") 
		userManager:giveToCharity(function()
			router.resetScreen()
			refresh()
		end) 
	end)
	
	----------------------------------------------------------------------------------------------------
	
	hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
	hud.popup.close.x 			= display.contentWidth*0.5
	hud.popup.close.y 			= display.contentHeight*0.86
	
	utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)

end

-----------------------------------------------------------------------------------------

function scene:openConfirmCashout()

	-----------------------------------

	viewManager.showPopup()
	analytics.event("Gaming", "openConfirmCashout") 
	
	----------------------------------------------------------------------------------------------------
	
	hud.popup.shareIcon 				= display.newImage( hud.popup, "assets/images/icons/PictoShare.png")  
	hud.popup.shareIcon.x 			= display.contentWidth*0.5
	hud.popup.shareIcon.y			= display.contentHeight*0.17

	----------------------------------------------------------------------------------------------------
	
	hud.confirm 						= display.newImage( hud.popup, I "twitter.connected.png")  
	hud.confirm.x 						= display.contentWidth*0.5
   hud.confirm.y						= display.contentHeight*0.6

	local refresh = function() scene:refreshScene() end
	
	utils.onTouch(hud.confirm, function() 
		analytics.event("Gaming", "cashout")
		native.setActivityIndicator( true ) 
		userManager:cashout(function()
   		native.setActivityIndicator( false ) 
			router.resetScreen()
			refresh()
		end) 
	end)
	
	----------------------------------------------------------------------------------------------------
	
	hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
	hud.popup.close.x 			= display.contentWidth*0.5
	hud.popup.close.y 			= display.contentHeight*0.86
	
	utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)
	

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