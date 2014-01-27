-----------------------------------------------------------------------------------------

UserManager = {}	

-----------------------------------------------------------------------------------------
 
 -- attemptFBPlayer pour compter les getPlayerByFacebookId pour android reco apres retour app
function UserManager:new()  

	local object = {
		user 						= {},
		attemptFBPlayer 		= 0,
		attemptFetchPlayer 	= 0
	}

	setmetatable(object, { __index = UserManager })
	return object
end

-----------------------------------------------------------------------------------------

function UserManager:fetchPlayer()

	native.setActivityIndicator( true )
	print("fetchPlayer")
	self.attemptFetchPlayer = self.attemptFetchPlayer + 1 
	
	utils.postWithJSON(
	{}, 
	SERVER_URL .. "player", 
	function(result)

		if(result.isError) then
			if(self.attemptFetchPlayer < 5) then
      		print("--> try again fetchPlayer")
   			self:fetchPlayer()
   		else
				print("fetchPlayer error : outside")
				router.openOutside()
			end
		else
   		native.setActivityIndicator( false )
			self.attemptFetchPlayer = 0
   		
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
	print("getPlayerByFacebookId")
	self.attemptFBPlayer = self.attemptFBPlayer + 1 

	utils.postWithJSON({
		facebookData = facebook.data,
		accessToken = GLOBALS.savedData.facebookAccessToken
	}, 
	SERVER_URL .. "playerFromFB", 
	function(result)
		print("received PlayerByFacebookId")
		
		if(result.status < 0 and self.attemptFBPlayer < 3) then
   		print("--> try again getPlayerByFacebookId")
			self:getPlayerByFacebookId()
		else
   		native.setActivityIndicator( false )	
			self.attemptFBPlayer = 0
   
   		if(result.isError) then
   			print("--> error = signinFB")
   			router.openSigninFB()
   			--			router.openOutside()
   
   		elseif(result.status == 401 or result.status == '401') then
   			print("--> 401 = signinFB")
   			router.openSigninFB()
   		else
   			print("--> test player")
   			response 							= json.decode(result.response)
   			local player 						= response.player
   			GLOBALS.savedData.authToken 	= response.authToken     
   
   			userManager:receivedPlayer(player, router.openHome)
   		end
		end

	end
	)

end

-----------------------------------------------------------------------------------------

function UserManager:checkExistPlayerByFacebookId(proceedWithMerge)

	native.setActivityIndicator( true )
	print("checkExistPlayerByFacebookId")

	utils.postWithJSON({
		facebookData = facebook.data,
	}, 
	SERVER_URL .. "existFBPlayer", 
	function(result)
		native.setActivityIndicator( false )
		
		if(result.isError) then
			timer.performWithDelay(1000, userManager:checkExistPlayerByFacebookId(proceedWithMerge))
		else
   		local response = json.decode(result.response)
   		local existPlayer = response.existPlayer
   
   		if(not existPlayer) then
   			print("--> not existPlayer")
   			proceedWithMerge()
   
   		else
   			print("--> got player")
   			twitter.logout()
   			gameManager:tryAutoOpenFacebookAccount()
   		end
		end	
	end
	)

end

-----------------------------------------------------------------------------------------

function UserManager:receivedPlayer(player, next)

	if(next == router.openHome) then
		sponsorpayTools:init(player.uid)
		viewManager.message(T "Welcome" .. " " .. player.userName .. " !")
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
	GLOBALS.savedData.user.isFacebookFan 	= player.isFacebookFan
	GLOBALS.savedData.user.isTwitterFan 	= player.isTwitterFan

	utils.saveTable(GLOBALS.savedData, "savedData.json")

	self:checkIdlePoints()

	viewManager.refreshHeaderPoints(player.currentPoints)
	lotteryManager:sumPrices()

	self:checkFanStatus(next)

end

-----------------------------------------------------------------------------------------

function UserManager:checkExistingUser(next)
	self:checkExistPlayerByFacebookId(function()
		print("proceed with merge", userManager.user.facebookId, facebook.data.id)
			self:showConfirmMerge(next)
	end)
end

-----------------------------------------------------------------------------------------
-- popup affichee uniquement si facebookId libre pour adillions
-- (sinon on a logout puis login le user FB existant)
-- si confirm : on pose link facebookId, 
function UserManager:showConfirmMerge(next)

	-----------------

	viewManager.showPopup()

	hud.popup.shareIcon 				= display.newImage( hud.popup, "assets/images/icons/PictoInfo.png")  
	hud.popup.shareIcon.x 			= display.contentWidth*0.5
	hud.popup.shareIcon.y			= display.contentHeight*0.22

	hud.popup.shareIcon 				= display.newImage( hud.popup, I "watchout.png")  
	hud.popup.shareIcon.x 			= display.contentWidth*0.5
	hud.popup.shareIcon.y			= display.contentHeight*0.31

	-----------------

	local message = ""
	if(LANG == "fr") then
		message = "Vous allez connecter le compte Facebook " .. facebook.data.name .. " avec le compte Adillions de " .. userManager.user.firstName
	else
		message = "You are about to connect " .. facebook.data.name .. " Facebook profile with " .. userManager.user.firstName .. "'s Adillions account"
	end

	local multiLineText = display.newMultiLineText  
	{
		text = message,
		width = display.contentWidth*0.85,  
		left = display.contentWidth*0.5,
		font = FONT, 
		fontSize = 38,
		align = "center"
	}

	multiLineText:setReferencePoint(display.TopCenterReferencePoint)
	multiLineText.x = display.contentWidth*0.5
	multiLineText.y = display.contentHeight*0.42
	hud.popup:insert(multiLineText)      

	-----------------

	hud.popup.confirm 				= display.newImage( hud.popup, I "confirm.png")
	hud.popup.confirm.x 				= display.contentWidth*0.5
	hud.popup.confirm.y 				= display.contentHeight*0.71

	utils.onTouch(hud.popup.confirm, function() 
		viewManager.closePopup()
		userManager:mergePlayerWithFacebook(next)
	end)

	hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
	hud.popup.close.x 			= display.contentWidth*0.5
	hud.popup.close.y 			= display.contentHeight*0.83

	utils.onTouch(hud.popup.close, function()
		viewManager.closePopup()
	end)


end


-----------------------------------------------------------------------------------------
-- popup affichee uniquement si facebookId pas libre et nouveau compte FB
function UserManager:showWrongAccount()

	-----------------

	viewManager.showPopup()

	hud.popup.shareIcon 				= display.newImage( hud.popup, "assets/images/icons/PictoInfo.png")  
	hud.popup.shareIcon.x 			= display.contentWidth*0.5
	hud.popup.shareIcon.y			= display.contentHeight*0.22

	hud.popup.shareIcon 				= display.newImage( hud.popup, I "Sorry.png")  
	hud.popup.shareIcon.x 			= display.contentWidth*0.5
	hud.popup.shareIcon.y			= display.contentHeight*0.31

	-----------------

	local message = ""
	local message2 = ""

	if(LANG == "fr") then
		message = "Le compte Adillions de " .. userManager.user.firstName .. " est déjà lié au profil Facebook de " .. userManager.user.userName
		message2 = "Il n’est pas possible de connecter plusieurs comptes Facebook au même compte Adillions, veuillez vous connecter avec " .. userManager.user.userName
	else
		message = "The Adillions account " .. userManager.user.firstName .. " is already linked to " .. userManager.user.userName .. " Facebook profile"
		message2 = "It is not possible to connect multiple Facebook profiles to a single Adillions account, please log in with " .. userManager.user.userName .. " profile"
	end

	local multiLineText = display.newMultiLineText  
	{
		text = message,
		width = display.contentWidth*0.85,  
		left = display.contentWidth*0.5,
		font = FONT, 
		fontSize = 38,
		align = "center"
	}

	multiLineText:setReferencePoint(display.TopCenterReferencePoint)
	multiLineText.x = display.contentWidth*0.5
	multiLineText.y = display.contentHeight*0.42
	hud.popup:insert(multiLineText)      

	local multiLineText = display.newMultiLineText  
	{
		text = message2,
		width = display.contentWidth*0.85,  
		left = display.contentWidth*0.5,
		font = FONT, 
		fontSize = 38,
		align = "center"
	}

	multiLineText:setReferencePoint(display.TopCenterReferencePoint)
	multiLineText.x = display.contentWidth*0.5
	multiLineText.y = display.contentHeight*0.56
	hud.popup:insert(multiLineText)      

	-----------------

	hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
	hud.popup.close.x 			= display.contentWidth*0.5
	hud.popup.close.y 			= display.contentHeight*0.83

	utils.onTouch(hud.popup.close, function()
		viewManager.closePopup()
	end)


end

-----------------------------------------------------------------------------------------

function UserManager:checkFanStatus(next)

	print("checkFanStatus")

	local facebookFan 	= self.user.isFacebookFan
	local twitterFan 		= self.user.isTwitterFan

	print(facebookFan, twitterFan)
	
	userManager.user.totalBonusTickets = 0

--	if(GLOBALS.savedData.facebookAccessToken) then
	if(userManager.user.facebookId) then
		userManager.user.totalBonusTickets = userManager.user.totalBonusTickets + FACEBOOK_CONNECTION_TICKETS
		print("FACEBOOK_CONNECTION totalBonusTickets +" .. FACEBOOK_CONNECTION_TICKETS)
	end

--	if(twitter.connected) then
	if(userManager.user.twitterId) then
		userManager.user.totalBonusTickets = userManager.user.totalBonusTickets + TWITTER_CONNECTION_TICKETS
		print("TWITTER_CONNECTION totalBonusTickets +" .. TWITTER_CONNECTION_TICKETS)
	end

	facebook.isFacebookFan(function()
		twitter.isTwitterFan(function(response)

			---------------------------------------------------------

			if(response) then
				self.user.twitterFan = response.relationship.source.following
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

			if(self.user.isFacebookFan) then
				userManager.user.totalBonusTickets = userManager.user.totalBonusTickets + FACEBOOK_FAN_TICKETS
				print("FACEBOOK_FAN totalBonusTickets +" .. FACEBOOK_FAN_TICKETS)
			end

			if(self.user.isTwitterFan) then
				userManager.user.totalBonusTickets = userManager.user.totalBonusTickets + TWITTER_FAN_TICKETS
				print("TWITTER_FAN totalBonusTickets +" .. TWITTER_FAN_TICKETS)
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
	local now = os.time() * 1000 -- diff de 1min entre ce time et celui de heroku + play ? donc on utilise celui ci
	
	native.setActivityIndicator( true )

	utils.postWithJSON({
		numbers = numbers,
		extraTicket = extraTicket,
		creationTime = now
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
			print("multiFB")
			analytics.event("Social", "multiFB") 

			-- cancel FB connection		
			userManager.user.facebookId 				= nil
			GLOBALS.savedData.user.facebookId 		= nil
			GLOBALS.savedData.user.facebookName	 	= nil
			GLOBALS.savedData.facebookAccessToken 	= nil
			utils.saveTable(GLOBALS.savedData, "savedData.json")

			self:showMultiAccountPopup(next)
		end

	end)

end

-----------------------------------------------------------------------------------------

function UserManager:showMultiAccountPopup(next)

	viewManager.showPopup()

	hud.popup.shareIcon 				= display.newImage( hud.popup, "assets/images/icons/PictoInfo.png")  
	hud.popup.shareIcon.x 			= display.contentWidth*0.5
	hud.popup.shareIcon.y			= display.contentHeight*0.22

	hud.popup.shareText 				= display.newImage( hud.popup, I "important.png")  
	hud.popup.shareText.x 			= display.contentWidth*0.5
	hud.popup.shareText.y			= display.contentHeight*0.32

	local text1 = facebook.data.name .. "’s Facebook account is already an Adillions user"
	if(LANG == "fr") then text1 = "Le compte Facebook " .. facebook.data.name .. " est \n déjà un utilisateur d’Adillions" end


	local multiLineText = display.newMultiLineText  
	{
		text = text1,
		width = display.contentWidth*0.65,  
		left = display.contentWidth*0.5,
		font = FONT, 
		fontSize = 30,
		align = "center"
	}

	multiLineText:setReferencePoint(display.TopCenterReferencePoint)
	multiLineText.x = display.contentWidth*0.5
	multiLineText.y = display.contentHeight*0.42
	hud.popup:insert(multiLineText)      


	local multiLineText2 = display.newMultiLineText  
	{
		text = T "If this is not your Facebook account, you must log out this Facebook session on your device and log in with your own Facebook profile in order to connect your accounts",
		width = display.contentWidth*0.65,  
		left = display.contentWidth*0.5,
		font = FONT, 
		fontSize = 28,
		align = "center"
	}

	multiLineText2:setReferencePoint(display.TopCenterReferencePoint)
	multiLineText2.x = display.contentWidth*0.5
	multiLineText2.y = display.contentHeight*0.58
	hud.popup:insert(multiLineText2)      

	hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
	hud.popup.close.x 			= display.contentWidth*0.5
	hud.popup.close.y 			= display.contentHeight*0.83

	utils.onTouch(hud.popup.close, function() 
		viewManager.closePopup()
		if(next) then
			next()
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

function UserManager:hasTicketsToPlay()
	return self.user.availableTickets + self.user.totalBonusTickets - self.user.playedBonusTickets  > 0
end

-----------------------------------------------------------------------------------------

function UserManager:checkTicketTiming()

	print("checkTicketTiming")
	local lastTime = 0
	local now = os.time() * 1000

	for i = 1,#self.user.lotteryTickets do
		local ticket = self.user.lotteryTickets[i]
		print("---")
		utils.tprint(ticket)
		if((self.user.currentLotteryUID == ticket.lottery.uid) and (ticket.creationDate > lastTime) and (ticket.type == 1)) then
			lastTime = ticket.creationDate
		end
	end

	local spentMillis = now - lastTime
	local h,m,s,ms = utils.getHoursMinSecMillis(spentMillis)

	if(tonumber(spentMillis) >= (lotteryManager.nextLottery.ticketTimer * 60 * 1000) or self.user.extraTickets > 0) then
		return true
	else
		----------------------------------------------------------------------------------------------------

		viewManager.showPopup()

		----------------------------------------------------------------------------------------------------

		hud.popup.icon 			= display.newImage( hud.popup, "assets/images/icons/PictoSablier.png")
		hud.popup.icon.x 			= display.contentWidth*0.5
		hud.popup.icon.y 			= display.contentHeight*0.2

		hud.popup.icon 			= display.newImage( hud.popup, I "Sorry.png")
		hud.popup.icon.x 			= display.contentWidth*0.5
		hud.popup.icon.y 			= display.contentHeight*0.3

		----------------------------------------------------------------------------------------------------

		local fontSize = 40
		
		local multiLineText = display.newMultiLineText  
		{
			text = T "You can fill out a new Ticket in :", 
			width = display.contentWidth*0.75,  
			left = display.contentWidth*0.5,
			font = FONT, 
			fontSize = fontSize,
			align = "center",
			spaceY = display.contentWidth*0.022
		}

		multiLineText.x = display.contentWidth*0.5
		multiLineText.y = display.contentHeight*0.37
		hud.popup:insert(multiLineText)         
		
		hud.popup.pictoTimer			= display.newImage( hud.popup, "assets/images/icons/Tuto_2_picto2.png")  
--		hud.popup.pictoTimer.x 		= display.contentWidth*0.3
		hud.popup.pictoTimer.x 		= display.contentWidth*0.37
		hud.popup.pictoTimer.y 		= display.contentHeight*0.46

		hud.popup.timerDisplay = viewManager.newText({
			parent = hud.popup, 
			text = '',     
			x = display.contentWidth*0.57,
			y = display.contentHeight*0.45,
			fontSize = 53,
			font = NUM_FONT
		})

		viewManager.refreshPopupTimer(lastTime)

		-------------------------------
		
		local timerLegendY 		= display.contentHeight*0.48
		local timerLegendSize 	= 22
		
--		viewManager.newText({
--			parent = hud.popup, 
--			text = T "HRS", 
--			x = display.contentWidth*0.437,
--			y = timerLegendY,
--			fontSize = timerLegendSize,
--			referencePoint = display.CenterReferencePoint
--		})

		viewManager.newText({
			parent = hud.popup, 
			text = T "MIN", 
			x = display.contentWidth*0.498,
--			x = display.contentWidth*0.567,
			y = timerLegendY,
			fontSize = timerLegendSize,
			referencePoint = display.CenterReferencePoint
		})

		viewManager.newText({
			parent = hud.popup, 
			text = T "SEC", 
			x = display.contentWidth*0.638,
--			x = display.contentWidth*0.698,
			y = timerLegendY,
			fontSize = timerLegendSize,
			referencePoint = display.CenterReferencePoint
		})

		----------------------------------------------------
		
		local multiLineText = display.newMultiLineText  
		{
			text = T "Get Instant Tickets by inviting your \nfriends, sharing your activity, liking \nour theme, etc.", 
			width = display.contentWidth*0.75,  
			left = display.contentWidth*0.5,
			font = FONT, 
			fontSize = fontSize,
			align = "center",
			spaceY = display.contentWidth*0.022
		}

		multiLineText.x = display.contentWidth*0.5
		multiLineText.y = display.contentHeight*0.65
		hud.popup:insert(multiLineText)         

		--------------------------

		hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
		hud.popup.close.x 			= display.contentWidth*0.5
		hud.popup.close.y 			= display.contentHeight*0.83

		utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)

		return false
	end

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