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
	local winningsTop 		= 10.5
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
	
--	---------------------------------------------------------------
--	-- Top picture
--	---------------------------------------------------------------
	
	viewManager.drawBorder( hud.board, 
		display.contentWidth*0.5, self.top + display.contentHeight*0.02, 
		display.contentWidth*0.9, 200,
		250,250,250
	)  
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= userManager.user.userName,         
		x 					= display.contentWidth*0.4,
		y 					= self.top + display.contentHeight*0.02,
		fontSize 		= 35,
		referencePoint = display.CenterLeftReferencePoint
	})


	if(GLOBALS.savedData.facebookAccessToken and facebook.data) then
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
	
--	---------------------------------------------------------------
--	-- Personal Details
--	---------------------------------------------------------------
	
	hud.lineDetails 			= display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
	hud.lineDetails.x 		= display.contentWidth*0.5
	hud.lineDetails.y 		= self.top + self.yGap*(detailsTop+0.7)
	hud.board:insert(hud.lineDetails)

	hud.titleDetails 			= display.newImage( hud.board, I "details.png")  
	hud.titleDetails:setReferencePoint(display.CenterLeftReferencePoint);
	hud.titleDetails.x 		= display.contentWidth*0.05
	hud.titleDetails.y		= self.top + self.yGap*(detailsTop+0.7)
	hud.board:insert(hud.titleDetails)

	------------------
	
	self:drawTextEntry(T "First name" 	.. " : ", userManager.user.firstName, detailsTop+2)
	self:drawTextEntry(T "Last name" 	.. " : ", userManager.user.lastName, detailsTop+3)
	self:drawTextEntry(T "Email" 			.. " : ", userManager.user.email, detailsTop+4)
	self:drawTextEntry(T "Date of birth" 		.. " : ", utils.readableDate(userManager.user.birthDate, false, true), detailsTop+5)

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
		text 				= T "Charity profile" .. " : ",            
		x 					= display.contentWidth*0.5,
		y 					= self.top + self.yGap*(statusTop+3.5),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterReferencePoint
	})

	for i=1,5 do 
   	hud.iconCharity 			= display.newImage( hud.board, "assets/images/icons/CharitiesOFF.png")
   	hud.iconCharity.x 		= display.contentWidth*0.35 + i * display.contentWidth*0.05  
   	hud.iconCharity.y 		= self.top + self.yGap*(statusTop+4.5)
   	hud.board:insert(hud.iconCharity)
	end

	hud.iconCharity 			= display.newImage( hud.board, "assets/images/icons/CharitiesON.png")
	hud.iconCharity.x 		= display.contentWidth*0.4
	hud.iconCharity.y 		= self.top + self.yGap*(statusTop+4.5)
	hud.board:insert(hud.iconCharity)
	
	local charity = {"Boy Scout", "Contributor", "Good Samaritan", "Donor", "Benefactor", "Major Donor", "Patron", "Philanthropist"}
	
	viewManager.newText({
		parent 			= hud.board, 
		text	 			= T(charity[1]),              
		x 					= display.contentWidth*0.5,
		y 					= self.top + self.yGap*(statusTop+5.5),
		fontSize 		= self.fontSizeRight,
		fontSize 		= 30,
		referencePoint = display.CenterReferencePoint
	})
	
	
--	--------------------------
--	
--	viewManager.newText({
--		parent 			= hud.board, 
--		text 				= T "Donation" .. " : ",         
--		x 					= self.column2,
--		y 					= self.top + self.yGap*(statusTop+3.5),
--		fontSize 		= self.fontSizeLeft,
--		referencePoint = display.CenterRightReferencePoint
--	})
--
--	viewManager.newText({
--		parent 			= hud.board, 
--		text	 			= utils.displayPrice(userManager.user.totalGift, COUNTRY) ,        
--		x 					= self.column2,
--		y 					= self.top + self.yGap*(statusTop+4.5),
--		font				= NUM_FONT,
--		fontSize 		= 40,
--		referencePoint = display.CenterRightReferencePoint
--	})
	
	
	---------------------------------------------------------------
	-- winnings
	---------------------------------------------------------------
	
	hud.lineWinnings 			= display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
	hud.lineWinnings.x 			= display.contentWidth*0.5
	hud.lineWinnings.y 			= self.top + self.yGap*winningsTop
	hud.board:insert(hud.lineWinnings)

	hud.titleWinnings 			= display.newImage( hud.board, I "Gain.png")  
	hud.titleWinnings:setReferencePoint(display.CenterLeftReferencePoint);
	hud.titleWinnings.x 		= display.contentWidth*0.05
	hud.titleWinnings.y			= self.top + self.yGap*winningsTop
	hud.board:insert(hud.titleWinnings)
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Total winnings" .. " : ",         
		x 					= self.column1,
		y 					= self.top + self.yGap*(winningsTop+1),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterLeftReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= utils.displayPrice(userManager.user.totalWinnings, COUNTRY) ,   
		x 					= self.column1 + display.contentWidth*0.26, 
		y 					= self.top + self.yGap*(winningsTop+2),
		fontSize 		= 40,
		font				= NUM_FONT,
		referencePoint = display.CenterRightReferencePoint
	})
	
	hud.iconMoney 			= display.newImage( hud.board, "assets/images/icons/money.png")
	hud.iconMoney.x 		= self.column1 + display.contentWidth*0.31
	hud.iconMoney.y 		= self.top + self.yGap*(winningsTop+2) - display.contentHeight*0.004
	hud.board:insert(hud.iconMoney)
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Payed" .. " : ",         
		x 					= self.column2,
		y 					= self.top + self.yGap*(winningsTop+1),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterRightReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= utils.displayPrice(userManager.user.receivedWinnings, COUNTRY) ,     
		x 					= self.column2 -  display.contentWidth*0.07,
		y 					= self.top + self.yGap*(winningsTop+2),
		fontSize 		= self.fontSizeRight,
		font				= NUM_FONT,
		fontSize 		= 40,
		referencePoint = display.CenterRightReferencePoint
	})
	
	hud.iconMoney 			= display.newImage( hud.board, "assets/images/icons/PictogainPayed.png")
	hud.iconMoney.x 		= self.column2 
	hud.iconMoney.y 		= self.top + self.yGap*(winningsTop+2) - display.contentHeight*0.004
	hud.board:insert(hud.iconMoney)
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Balance" .. " : ",         
		x 					= display.contentWidth*0.5,
		y 					= self.top + self.yGap*(winningsTop+4),
		fontSize 		= self.fontSizeLeft,
	})

	local balance = utils.displayPrice(userManager.user.balance, COUNTRY)
	if(userManager.user.pendingWinnings > 0) then
		balance = balance  .. " (" .. utils.displayPrice(userManager.user.pendingWinnings, COUNTRY) .. ")"
	end

	local totalWinningsText = viewManager.newText({
		parent 			= hud.board, 
		text	 			= balance,   
		x 					= display.contentWidth*0.5, 
		y 					= self.top + self.yGap*(winningsTop+5),
		fontSize 		= 40,
		font				= NUM_FONT,
		referencePoint = display.CenterRightReferencePoint
	})
	
	hud.iconMoney 			= display.newImage( hud.board, "assets/images/icons/PictoBalance.png")
	hud.iconMoney.x 		= display.contentWidth*0.58
	hud.iconMoney.y 		= self.top + self.yGap*(winningsTop+5) - display.contentHeight*0.004
	hud.board:insert(hud.iconMoney)

	--------------------------
	
   hud.cashout 		= display.newImage( hud.board, I "cashout.button.png")  
   hud.cashout.x 		= display.contentWidth*0.5
   hud.cashout.y		= self.top + self.yGap*(winningsTop+7.5)
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
	
--	if(GLOBALS.savedData.facebookAccessToken) then
	if(userManager.user.facebookId) then
      hud.facebookConnect 		= display.newImage( hud.board, "assets/images/icons/facebook.connected.png")  
		hud.facebookConnect:setReferencePoint(display.CenterLeftReferencePoint)
		hud.facebookConnect.x 	= display.contentWidth*0.05
		hud.facebookConnect.y	= self.top + self.yGap*(socialTop+2.5)
		hud.board:insert(hud.facebookConnect)

		hud.facebookName = viewManager.newText({
			parent 			= hud.board, 
			text	 			= userManager.user.userName,   
			x 					= display.contentWidth*0.25, 
			y 					= self.top + self.yGap*(socialTop+2.5),
			fontSize 		= 37,
			referencePoint = display.CenterLeftReferencePoint
		})
	
   else
      hud.facebookConnect 		= display.newImage( hud.board, I "popup.facebook.connect.png")  
		hud.facebookConnect:setReferencePoint(display.CenterLeftReferencePoint)
		hud.facebookConnect.x 	= display.contentWidth*0.05
      hud.facebookConnect.y	= self.top + self.yGap*(socialTop+2.5)
      hud.board:insert(hud.facebookConnect)
   
		utils.onTouch(hud.facebookConnect, function() 
			facebook.connect(function()
				if(userManager.user.facebookId) then
					print("must connect to " .. userManager.user.userName .. " Facebook account")
				end
				router.resetScreen()
				self:refreshScene()
			end) 
		end)

	end

	if(userManager.user.facebookFan) then
		-- fan
		hud.facebookLikeDone 		= display.newImage( hud.board, I "facebook.like.done.png") 
		hud.facebookLikeDone:setReferencePoint(display.CenterLeftReferencePoint)
		hud.facebookLikeDone.x 	= display.contentWidth*0.05
		hud.facebookLikeDone.y	= self.top + self.yGap*(socialTop+5.2)
		hud.board:insert(hud.facebookLikeDone)
	else
		hud.facebookLike 		= display.newImage( hud.board, I "facebook.like.enabled.png")  
		hud.facebookLike:setReferencePoint(display.CenterLeftReferencePoint)
		hud.facebookLike.x 	= display.contentWidth*0.05
		hud.facebookLike.y	= self.top + self.yGap*(socialTop+5.2)
		hud.board:insert(hud.facebookLike)
	
		if(GLOBALS.savedData.facebookAccessToken) then
   		-- pas fan et connecte
			utils.onTouch(hud.facebookLike, function()
				self:openFacebookPage()
			end)

		else
			-- pas fan et pas connecte
			utils.onTouch(hud.facebookLike, function()
				facebook.connect(function()
					if(userManager.user.facebookId) then
						print("must connect to " .. userManager.user.userName .. " Facebook account")
					end
					router.resetScreen()
					self:refreshScene()
				end) 
			end)
--			hud.facebookLikeDisabled 		= display.newImage( hud.board, I "facebook.like.disabled.png")
--			hud.facebookLikeDisabled:setReferencePoint(display.CenterLeftReferencePoint)
--			hud.facebookLikeDisabled.x 	= display.contentWidth*0.05
--			hud.facebookLikeDisabled.y	= self.top + self.yGap*(socialTop+5.2)
--			hud.board:insert(hud.facebookLikeDisabled)
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
		x 					= display.contentWidth*0.89,
		y 					= self.top + self.yGap*(socialTop+5.2),
		font				= NUM_FONT,
		fontSize 		= 33,
		referencePoint = display.CenterRightReferencePoint
	})
	
   hud.facebookBonus2 		= display.newImage( hud.board, "assets/images/icons/PictoBonus.png")  
   hud.facebookBonus2.x 	= display.contentWidth*0.93
   hud.facebookBonus2.y		= self.top + self.yGap*(socialTop+5.2)
   hud.board:insert(hud.facebookBonus2)

	utils.setGreen(textBonus1)
	utils.setGreen(textBonus2)
	
	---------------------------------------------------------------
	-- TWITTER
	---------------------------------------------------------------
		
--	if(twitter.connected) then
	if(userManager.user.twitterId) then
      hud.twitterConnect 				= display.newImage( hud.board, "assets/images/icons/twitter.connected.png")  
		hud.twitterConnect:setReferencePoint(display.CenterLeftReferencePoint)
		hud.twitterConnect.x 	= display.contentWidth*0.05
      hud.twitterConnect.y				= self.top + self.yGap*(socialTop+8)
      hud.board:insert(hud.twitterConnect)

		hud.twitterName = viewManager.newText({
			parent 			= hud.board, 
			text	 			= userManager.user.twitterName,   
			x 					= display.contentWidth*0.25, 
			y 					= self.top + self.yGap*(socialTop+8),
			fontSize 		= 37,
			referencePoint = display.CenterLeftReferencePoint
		})
			
   else
      hud.twitterConnect 				= display.newImage( hud.board, I "popup.twitter.connect.png")  
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
		-- fan
		hud.twitterFollowing 		= display.newImage( hud.board, I "twitter.following.png")  
		hud.twitterFollowing:setReferencePoint(display.CenterLeftReferencePoint)
		hud.twitterFollowing.x 	= display.contentWidth*0.05
		hud.twitterFollowing.y	= self.top + self.yGap*(socialTop+10.7)
      hud.board:insert(hud.twitterFollowing)
	else
      hud.twitterFollow 		= display.newImage( hud.board, I "twitter.follow.png") 
      hud.twitterFollow:setReferencePoint(display.CenterLeftReferencePoint)
      hud.twitterFollow.x 	= display.contentWidth*0.05
      hud.twitterFollow.y	= self.top + self.yGap*(socialTop+10.7)
      hud.board:insert(hud.twitterFollow)
      
		if(twitter.connected) then
   		-- pas fan et connecté
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
			-- pas fan et pas connecté
			utils.onTouch(hud.twitterFollow, function()
				twitter.connect(function()
					native.setActivityIndicator( true )	 
					twitter.follow(function()
						native.setActivityIndicator( false )		
						userManager.user.twitterFan = true
						router.resetScreen()
						self:refreshScene()
					end) 
				end) 
			end)
			--         hud.twitterFollowDisabled 		= display.newImage( hud.board, I "twitter.follow.disabled.png")
			--         hud.twitterFollowDisabled:setReferencePoint(display.CenterLeftReferencePoint)
--         hud.twitterFollowDisabled.x 	= display.contentWidth*0.05
--         hud.twitterFollowDisabled.y	= self.top + self.yGap*(socialTop+10.7)
--         hud.board:insert(hud.twitterFollowDisabled)
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
		x 					= display.contentWidth*0.89,
		y 					= self.top + self.yGap*(socialTop+10.7),
		font				= NUM_FONT,
		fontSize 		= 33,
		referencePoint = display.CenterRightReferencePoint
	})
	
   hud.facebookBonus2 		= display.newImage( hud.board, "assets/images/icons/PictoBonus.png")  
   hud.facebookBonus2.x 	= display.contentWidth*0.93
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
		display.remove(hud.board.logout)
		userManager:logout()
	end)	
	
	------------------

	hud:insert(hud.board)

	------------------

	viewManager.setupView(4)
	self.view:insert(hud)
end

-----------------------------------------------------------------------------------------

function scene:openFacebookPage()
	native.showWebPopup(0, 0, display.contentWidth, display.contentHeight, FACEBOOK_PAGE) 
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
	
	hud.popup.shareIcon 				= display.newImage( hud.popup, "assets/images/icons/PictoInfo.png")  
	hud.popup.shareIcon.x 			= display.contentWidth*0.5
	hud.popup.shareIcon.y			= display.contentHeight*0.15
	
	hud.popup.TxtInformation 		= display.newImage( hud.popup, I "TxtInformation.png")  
	hud.popup.TxtInformation.x 	= display.contentWidth*0.5
	hud.popup.TxtInformation.y		= display.contentHeight*0.23

	----------------------------------------------------------------------------------------------------
	
   local value = ""
   if(utils.isEuroCountry(COUNTRY)) then
   	value = "10€"
   else
   	value = "US$15"
	end

	local multiLineText = display.newMultiLineText  
	{
		text = T "You can cash out when your winnings \n have reached a minimum total \n balance of " .. value,
		width = display.contentWidth*0.8,  
		left = display.contentWidth*0.5,
		font = FONT, 
		fontSize = 40,
		align = "center"
	}

	multiLineText:setReferencePoint(display.TopCenterReferencePoint)
	multiLineText.x = display.contentWidth*0.5
	multiLineText.y = display.contentHeight*0.4
	hud.popup:insert(multiLineText)         

	----------------------------------------------------------------------------------------------------
	
	local min = 10
	if(not utils.isEuroCountry(COUNTRY)) then
		min = 15
	end
	
	if(userManager.user.balance >= min) then
		hud.cashoutEnabled 				= display.newImage( hud.popup, I "cashout.on.png")  
		hud.cashoutEnabled.x 			= display.contentWidth*0.5
      hud.cashoutEnabled.y				= display.contentHeight*0.72
   	utils.onTouch(hud.cashoutEnabled, function() self.openConfirmCashout() end)
   else
		hud.cashoutDisabled 				= display.newImage( hud.popup, I "cashout.off.png")  
		hud.cashoutDisabled.x 			= display.contentWidth*0.5
      hud.cashoutDisabled.y			= display.contentHeight*0.72
	end
	
--	if(userManager.user.balance > 0) then
--   	hud.giveToCharity 				= display.newImage( hud.popup, I "donate.on.png")  
--   	hud.giveToCharity.x 				= display.contentWidth*0.5
--      hud.giveToCharity.y				= display.contentHeight*0.73
--   	utils.onTouch(hud.giveToCharity, function() self.openGiveToCharity() end)
--   else
--		hud.giftDisabled 					= display.newImage( hud.popup, I "donate.off.png")  
--		hud.giftDisabled.x 				= display.contentWidth*0.5
--      hud.giftDisabled.y				= display.contentHeight*0.73
--	end

	
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
	
	hud.popup.shareIcon 				= display.newImage( hud.popup, "assets/images/icons/PictoCoeur.png")  
	hud.popup.shareIcon.x 			= display.contentWidth*0.5
	hud.popup.shareIcon.y			= display.contentHeight*0.15

	hud.popup.thanks 					= display.newImage( hud.popup, I "thanks.png")  
	hud.popup.thanks.x 				= display.contentWidth*0.5
	hud.popup.thanks.y				= display.contentHeight*0.23

	----------------------------------------------------------------------------------------------------

   local multiLineText = display.newMultiLineText  
     {
           text = T "Your winnings will be donated to Adillions Solidarity \n and Sustainable Development Fund \n \n \n Soon users will be able to \n directly choose their own charity …",
           width = display.contentWidth*0.8,  
           left = display.contentWidth*0.5,
           font = FONT, 
           fontSize = 40,
           align = "center"
     }
	
	multiLineText:setReferencePoint(display.TopCenterReferencePoint)
	multiLineText.x = display.contentWidth*0.5
	multiLineText.y = display.contentHeight*0.3
	hud.popup:insert(multiLineText)         

	----------------------------------------------------------------------------------------------------
	
	hud.giveToCharity 				= display.newImage( hud.popup, I "confirm.png")  
	hud.giveToCharity.x 				= display.contentWidth*0.5
   hud.giveToCharity.y				= display.contentHeight*0.7

	local refresh = function() scene:refreshScene() end
	
	utils.onTouch(hud.giveToCharity, function() 
		analytics.event("Gaming", "giveToCharity") 
		userManager:giveToCharity(function()
			router.resetScreen()
			refresh()
			viewManager.message(T "Thank you" .. "!")
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
	
	hud.popup.shareIcon 				= display.newImage( hud.popup, "assets/images/icons/PictoGain2.png")  
	hud.popup.shareIcon.x 			= display.contentWidth*0.5
	hud.popup.shareIcon.y			= display.contentHeight*0.15

	hud.popup.congratz 				= display.newImage( hud.popup, I "TxtCongratulations.png")  
	hud.popup.congratz.x 			= display.contentWidth*0.5
	hud.popup.congratz.y				= display.contentHeight*0.23

	----------------------------------------------------------------------------------------------------

	local multiLineText = display.newMultiLineText  
	{
		text = T "You will receive your winnings within 4 to 8 weeks \n \n  We will contact you by email in the coming days to proceed with the payment",
		width = display.contentWidth*0.7,  
		left = display.contentWidth*0.5,
		font = FONT, 
		fontSize = 40,
		spaceY = display.contentWidth*0.022,
		align = "center"
	}

	multiLineText:setReferencePoint(display.TopCenterReferencePoint)
	multiLineText.x = display.contentWidth*0.5
	multiLineText.y = display.contentHeight*0.37
	hud.popup:insert(multiLineText)         

	----------------------------------------------------------------------------------------------------

	hud.confirm 						= display.newImage( hud.popup, I "confirm.png")  
	hud.confirm.x 						= display.contentWidth*0.5
	hud.confirm.y						= display.contentHeight*0.7

	local refresh = function() scene:refreshScene() end
	
	utils.onTouch(hud.confirm, function() 
		analytics.event("Gaming", "cashout")
		native.setActivityIndicator( true ) 
		userManager:cashout(function()
   		native.setActivityIndicator( false ) 
			router.resetScreen()
			refresh()
			viewManager.message(T "Congratulations !")
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