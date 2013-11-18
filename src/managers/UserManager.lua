-----------------------------------------------------------------------------------------

UserManager = {}	

-----------------------------------------------------------------------------------------

function UserManager:new()  

	local object = {
		user 	= {}
	}

	setmetatable(object, { __index = UserManager })
	return object
end

-----------------------------------------------------------------------------------------

function UserManager:fetchPlayer()

	print("--- fetchPlayer true")
	native.setActivityIndicator( true )

	print("fetchPlayer")
	utils.postWithJSON(
	{}, 
	SERVER_URL .. "player", 
	function(result)
		print("result", result)
		print("--- fetchPlayer false")
		native.setActivityIndicator( false )

		if(result.isError) then
			print("fetchPlayer error : outside")
			router.openOutside()
		else
			local player = json.decode(result.response)
			if(not player) then 
				print("fetchPlayer no player : outside")
				router.openOutside()
			else 
				userManager:receivedPlayer(player, router.openHome)
			end
		end
	end
	)

end

-----------------------------------------------------------------------------------------

function UserManager:getPlayerByFacebookId()

	native.setActivityIndicator( true )
	utils.tprint("getPlayerByFacebookId")

	utils.postWithJSON({
		facebookData = facebook.data,
		accessToken = GLOBALS.savedData.facebookAccessToken
	}, 
	SERVER_URL .. "playerFromFB", 
	function(result)
		print("received PlayerByFacebookId")
		utils.tprint(result)
		print("-------------")
		print(result.isError)
		print(result.status)
		print(tostring(result.status == 401))
		print(tostring(result.status == '401'))
		print("-------------")
		
		native.setActivityIndicator( false )	

		if(result.isError) then
			print("--> PB with server")
			router.openOutside()
			
		elseif(result.status == 401 or result.status == '401') then
			print("--> signinFB")
			router.openSigninFB()
		else
			print("--> test player")
			response 							= json.decode(result.response)
			local player 						= response.player
			GLOBALS.savedData.authToken 	= response.authToken     

			userManager:receivedPlayer(player, router.openHome)
		end
	end
	)

end

-----------------------------------------------------------------------------------------

function UserManager:receivedPlayer(player, next)
	
	if(next == router.openHome) then
		sponsorpayTools:init(player.uid)
		viewManager.message(T "Welcome back" .. " " .. player.userName .. " !")
	end
	
	self:updatedPlayer(player, next)
end

-----------------------------------------------------------------------------------------

function UserManager:updatedPlayer(player, next)

	self.user 							= player
	self.user.totalBonusTickets 	= 0

	print("------------------------ updatedPlayer ")

	GLOBALS.savedData.user.uid 				= player.uid
	GLOBALS.savedData.user.email 				= player.email
	GLOBALS.savedData.user.userName 			= player.userName
	GLOBALS.savedData.user.firstName 		= player.firstName
	GLOBALS.savedData.user.lastName 			= player.lastName
	GLOBALS.savedData.user.birthDate 		= player.birthDate
	GLOBALS.savedData.user.referrerId 		= player.referrerId
	GLOBALS.savedData.user.sponsorCode 		= player.sponsorCode
	GLOBALS.savedData.user.facebookId 		= player.facebookId
	GLOBALS.savedData.user.twitterId 		= player.twitterId
	GLOBALS.savedData.user.twitterName 		= player.twitterName

	utils.saveTable(GLOBALS.savedData, "savedData.json")

	self:checkIdlePoints()

	viewManager.refreshHeaderPoints(player.currentPoints)
	lotteryManager:sumPrices()

	self:checkFanStatus(next)

end

-----------------------------------------------------------------------------------------

function UserManager:checkFanStatus(next)

   print("checkFanStatus")

	local facebookFan 	= self.user.isFacebookFan
	local twitterFan 		= self.user.isTwitterFan

	userManager.user.totalBonusTickets = 0
	
	if(userManager.user.facebookId) then
		userManager.user.totalBonusTickets = userManager.user.totalBonusTickets + FACEBOOK_CONNECTION_TICKETS
	end

	if(userManager.user.twitterId) then
		userManager.user.totalBonusTickets = userManager.user.totalBonusTickets + TWITTER_CONNECTION_TICKETS
	end

	facebook.isFacebookFan(function()
		twitter.isTwitterFan(function(response)

			---------------------------------------------------------

			if(response) then
				utils.tprint(response)
				self.user.twitterFan = response.relationship.source.following
			end

			---------------------------------------------------------

			if(self.user.twitterFan) then
				userManager.user.totalBonusTickets = userManager.user.totalBonusTickets + FACEBOOK_FAN_TICKETS
			end

			if(self.user.facebookFan) then
				userManager.user.totalBonusTickets = userManager.user.totalBonusTickets + TWITTER_FAN_TICKETS
			end

			---------------------------------------------------------

			local statusChanged = false

			if(self.user.facebookFan ~= facebookFan) then
				statusChanged = true
				self.user.isFacebookFan = self.user.facebookFan
			end

			if(self.user.twitterFan ~= twitterFan) then
				statusChanged = true
				self.user.isTwitterFan = self.user.twitterFan
			end

			---------------------------------------------------------
			
			print("statusChanged ? " )
			print(statusChanged)

			if(statusChanged) then
				self:updateFanStatus(next)
			else
   			print("continue")
				if(next) then
					next()
				end
			end

			---------------------------------------------------------
		end)
	end)

end

-----------------------------------------------------------------------------------------

function UserManager:giveToCharity(next)
	viewManager.closePopup()
	
	print("giveToCharity")
	if(next)then  print("next ready") end
	utils.postWithJSON({}, 
		SERVER_URL .. "giveToCharity", 
		function(result)
			userManager:updatePlayer(next)
		end
	)
	
end

function UserManager:cashout(next)
	viewManager.closePopup()
	
	utils.postWithJSON({
			country = COUNTRY
		}, 
		SERVER_URL .. "cashout", 
		function(result)
			userManager:updatePlayer(next)
		end
	)
	
end

-----------------------------------------------------------------------------------------
-- en arrivant on check si on passe sur une nouvelle lotterie
-- ce check est donc fait avant le concertIdlePoints
-- donc les tickets convertis de idlepoints sont bien rajoutés aux nouveaux availableTickets

function UserManager:checkUserCurrentLottery()

	if(self.user.currentLotteryUID ~= lotteryManager.nextLottery.uid) then

		----------------------------------------

		self.user.currentLotteryUID 			= lotteryManager.nextLottery.uid
		self.user.availableTickets 			= START_AVAILABLE_TICKETS 
		self.user.playedBonusTickets 			= 0

		self.user.hasTweet						= false
		self.user.hasPostOnFacebook			= false
		self.user.hasTweetAnInvite				= false
		self.user.hasInvitedOnFacebook		= false

		self:updatePlayer()

		----------------------------------------

	end

	--------------------------------------------------------------------------------------

	lotteryManager:refreshNotifications(lotteryManager.nextLottery.date)
end

-----------------------------------------------------------------------------------------

function UserManager:checkIdlePoints()

	if(userManager.user.idlePoints > 0
	or userManager.user.currentPoints >= POINTS_TO_EARN_A_TICKET)  then
		
		local points 	= userManager.user.idlePoints + userManager.user.currentPoints
		viewManager.showPopup()

   	hud.popup.congratz 			= display.newImage( hud.popup, I "popup.Txt1.png")  
   	hud.popup.congratz.x 		= display.contentWidth*0.5
   	hud.popup.congratz.y			= display.contentHeight*0.25
   	
   	hud.popup.earnText = viewManager.newText({
   		parent 			= hud.popup,
   		text 				= T "You have earned" .. " :", 
   		fontSize			= 65,  
   		x 					= display.contentWidth * 0.5,
   		y 					= display.contentHeight*0.37,
   	})

		hud.popup.pointsText = viewManager.newText({
			parent 			= hud.popup, 
			text	 			= points .. " pts",     
			x 					= display.contentWidth*0.5,
			y 					= display.contentHeight*0.5,
			fontSize 		= 90,
		})

		if(math.floor(points/POINTS_TO_EARN_A_TICKET) > 0) then

			viewManager.newText({
				parent 			= hud.popup, 
				text	 			= "=",     
				x 					= display.contentWidth*0.5,
				y 					= display.contentHeight*0.6,
				fontSize 		= 90,
			})
			
			if(points == POINTS_TO_EARN_A_TICKET) then
      		hud.popup.iconPoints 			= display.newImage( hud.popup, "assets/images/icons/Points.png")
      		hud.popup.iconPoints.x 			= display.contentWidth*0.37
      		hud.popup.iconPoints.y 			= display.contentHeight*0.51
         	
         	hud.popup.pointsText:setReferencePoint(display.CenterLeftReferencePoint);
      		hud.popup.pointsText.x			= display.contentWidth*0.48
   		end

			hud.popup.iconTicket 			= display.newImage( hud.popup, "assets/images/icons/instant.ticket.png")
			hud.popup.iconTicket.x 			= display.contentWidth*0.3
			hud.popup.iconTicket.y 			= display.contentHeight*0.685

			local tickets = ""
			local nbTickets = math.floor(points/POINTS_TO_EARN_A_TICKET)
			if(nbTickets > 1) then 
				tickets = T "Instant Tickets" 
			else
				tickets = T "Instant Ticket" 
			end

			viewManager.newText({
				parent 			= hud.popup, 
				text	 			= nbTickets .. " " .. tickets,     
				x 					= display.contentWidth*0.4,
				y 					= display.contentHeight*0.685,
				fontSize 		= 40,
				font 				= NUM_FONT,
				referencePoint = display.CenterLeftReferencePoint 
			})
		end

		--------------------------
		
		local onClose = nil
		
		if(userManager.user.idlePoints > 0) then
   		userManager:convertIdlePoints()
   		onClose = function() 
   			viewManager.closePopup() 
   		end 
   	else
   		onClose = function() 
   			viewManager.closePopup()
      		userManager:convertCurrentPoints()
   		end
		end

		--------------------------

		hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
		hud.popup.close.x 			= display.contentWidth*0.5
		hud.popup.close.y 			= display.contentHeight*0.85

		utils.onTouch(hud.popup.close, onClose)


	end
end

-----------------------------------------------------------------------------------------

function UserManager:storeLotteryTicket(numbers)

	local extraTicket = userManager.user.extraTickets > 0
	native.setActivityIndicator( true )

	utils.postWithJSON({
		numbers = numbers,
		extraTicket = extraTicket
	}, 
	SERVER_URL .. "storeLotteryTicket", 
	function(result)

		native.setActivityIndicator( false )

		local player = json.decode(result.response)
		if(player) then 
			lotteryManager.wasExtraTicket = extraTicket
			userManager:receivedPlayer(player, router.openConfirmation)
		else 
			userManager:logout()
		end
	end
	)
end

-----------------------------------------------------------------------------------------

function UserManager:convertIdlePoints()

	local bonus = viewManager.newText({
		parent 			= hud, 
		text	 			= "+ " .. self.user.idlePoints,     
		x 					= display.contentWidth*0.97,
		y 					= display.contentHeight*0.05,
		fontSize 		= 65
	})

	transition.to(bonus, { time=1000, alpha=0, x=display.contentWidth*0.88 })

	---------------------------------------------

	self.user.currentPoints = self.user.currentPoints + self.user.idlePoints
	self.user.totalPoints 	= self.user.totalPoints + self.user.idlePoints
	self.user.idlePoints 	= 0

	---------------------------------------------

	self:convertCurrentPoints()
end

-----------------------------------------------------------------------------------------

function UserManager:convertCurrentPoints()

	---------------------------------------------

	local nbTickets = self:convertPointsToTickets()

	---------------------------------------------
	
	local plural = ""
	if(nbTickets > 1) then plural = 's' end
	viewManager.message("+ " .. nbTickets .. T "Instant Ticket" .. plural)
--
--	local bonus = viewManager.newText({
--		parent 			= hud.popup, 
--		text	 			= "+ " .. nbTickets .. "Tickets",     
--		x 					= display.contentWidth*0.97,
--		y 					= display.contentHeight*0.05,
--		fontSize 		= 65
--	})
--
--	transition.to(bonus, { time=1000, alpha=0, x=display.contentWidth*0.78 })

	---------------------------------------------

	self:updatePlayer()

end

-----------------------------------------------------------------------------------------

function UserManager:convertPointsToTickets()

	print("convertPointsToTickets")
	local conversion = 0

	while (self.user.currentPoints >= POINTS_TO_EARN_A_TICKET) do
		self.user.currentPoints = self.user.currentPoints - POINTS_TO_EARN_A_TICKET
		self.user.extraTickets 	= self.user.extraTickets + 1
		conversion = conversion + 1
	end

	print(conversion)
	return conversion
end

-----------------------------------------------------------------------------------------

function UserManager:updatePlayer(next)

	print("------------- updatePlayer ")
	if(next) then
   	print("next ready")
	end
	
	native.setActivityIndicator( true )
	self.user.lang = LANG

	utils.postWithJSON({
		user = self.user,
	}, 
	SERVER_URL .. "updatePlayer", 
	function(result)

		native.setActivityIndicator( false )

		local player = json.decode(result.response)
		if(player) then
			userManager:updatedPlayer(player, next)
		else
			if(next) then
				next()
			end
		end

	end)

end

-----------------------------------------------------------------------------------------

function UserManager:updateFanStatus(next)

	print("--- updateFanStatus true")
	native.setActivityIndicator( true )	

	utils.postWithJSON({
		user = self.user,
	}, 
	SERVER_URL .. "updateFanStatus", 
	function(result)
		print("--- updateFanStatus false")
		native.setActivityIndicator( false )
		if(next) then
			next()
		end

	end)
end

-----------------------------------------------------------------------------------------

function UserManager:twitterConnection(twitterId, twitterName, next)

	GLOBALS.savedData.user.twitterId 					= twitterId
	GLOBALS.savedData.user.twitterName 					= twitterName

	utils.saveTable(GLOBALS.savedData, "savedData.json")

	self.user.twitterId 		= twitterId
	self.user.twitterName 	= twitterName

	self:updatePlayer(next)
end

-----------------------------------------------------------------------------------------

function UserManager:mergePlayerWithFacebook(next)

	GLOBALS.savedData.user.facebookId 		= facebook.data.id
	GLOBALS.savedData.user.facebookName	 	= facebook.data.name

	utils.saveTable(GLOBALS.savedData, "savedData.json")

	self.user.facebookId 	= facebook.data.id
	self.user.facebookName 	= facebook.data.name

	self:updatePlayer(next)
end

-----------------------------------------------------------------------------------------

function UserManager:logout()
	coronaFacebook.logout()
	twitter.logout()
	gameManager.initGameData()	
	router.openOutside()
end
--
--function UserManager:logoutViewListener( event )
--
--	if event.url then
--
--		print("userManager.logout")
--		print(event.url)
--
--		if event.url == SERVER_URL .. "backToMobile" then
--			self:closeWebView()    	
--			print("logoutViewListener backToMobile : outside")	
--			router.openOutside()
--			
--			
--			print("--- logout false")	
--			native.setActivityIndicator( false )
--		end
--	end
--
--end
--
--
--function UserManager:closeWebView()
--	self.webView:removeEventListener( "urlRequest", function(event) self:logoutViewListener(event) end )
--	self.webView:removeSelf()
--	self.webView = nil
--end

-----------------------------------------------------------------------------------------

return UserManager