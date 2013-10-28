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

	native.setActivityIndicator( true )

	print("fetchPlayer")
	utils.postWithJSON(
	{}, 
	SERVER_URL .. "player", 
	function(result)
		print("result", result)
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

	print("getPlayerByFacebookId")
	native.setActivityIndicator( true )

	utils.postWithJSON({
		facebookData = facebook.data,
		accessToken = GLOBALS.savedData.facebookAccessToken
	}, 
	SERVER_URL .. "playerFromFB", 
	function(result)

		native.setActivityIndicator( false )	

		utils.tprint(result)

		if(result.isError or result.status == 401) then
			router.openSigninFB()
		else
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
	sponsorpayTools:init(player.uid)
	self:updatedPlayer(player, next)
end

-----------------------------------------------------------------------------------------

function UserManager:updatedPlayer(player, next)

	self.user 							= player
	self.user.totalBonusTickets 	= 0

	print("------------------------ updatedPlayer ")
	utils.tprint(self.user)

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
	
	local facebookFan 	= self.user.isFacebookFan
	local twitterFan 		= self.user.isTwitterFan
   
   userManager.user.totalBonusTickets = 0
	
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
		
			if(statusChanged) then
				self:updateFanStatus(next)
			else
				if(next) then
					next()
				end
			end

			---------------------------------------------------------
		end)
	end)
	
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
   	
   	lotteryManager:refreshNotifications(lotteryManager.nextLottery.date)

	end

	--------------------------------------------------------------------------------------

end

-----------------------------------------------------------------------------------------

function UserManager:checkIdlePoints(numbers)
	
	if(userManager.user.idlePoints > 0) then
		local title 	= T "You have earned" .. " :"
		local text		= ""
		viewManager.showPopup(title, text, function() userManager:convertIdlePoints() end)

		viewManager.newText({
			parent 			= hud.popup, 
			text	 			= userManager.user.idlePoints .. " pts",     
			x 					= display.contentWidth*0.5,
			y 					= display.contentHeight*0.4,
			fontSize 		= 120,
		})

		if(math.floor(userManager.user.idlePoints/POINTS_TO_EARN_A_TICKET) > 0) then
   		viewManager.newText({
   			parent 			= hud.popup, 
   			text	 			= "=",     
   			x 					= display.contentWidth*0.5,
   			y 					= display.contentHeight*0.5,
   			fontSize 		= 90,
   		})
   
   		local plural = ""
   		local nbTickets = math.floor(userManager.user.idlePoints/POINTS_TO_EARN_A_TICKET)
   		if(nbTickets > 1) then plural = "s" end
   
   		viewManager.newText({
   			parent 			= hud.popup, 
   			text	 			= nbTickets .. " ticket" .. plural,     
   			x 					= display.contentWidth*0.4,
   			y 					= display.contentHeight*0.6,
   			fontSize 		= 80,
   		})
   		
   		hud.popup.iconTicket 			= display.newImage( hud.popup, "assets/images/icons/ticket.png")
   		hud.popup.iconTicket.x 			= display.contentWidth*0.65
   		hud.popup.iconTicket.y 			= display.contentHeight*0.605
   		hud.popup.iconTicket:scale(1.5,1.5)
   	end

	elseif(userManager.user.currentPoints >= POINTS_TO_EARN_A_TICKET) then
		local title 	= T "You've earned a ticket" .. " !"
		local text		= ""
		viewManager.showPopup(title, text, function() userManager:convertCurrentPoints() end)

		hud.popup.iconPoints 			= display.newImage( hud.popup, "assets/images/points/points.".. POINTS_TO_EARN_A_TICKET .. ".png")
		hud.popup.iconPoints.x 			= display.contentWidth*0.3
		hud.popup.iconPoints.y 			= display.contentHeight*0.41
		hud.popup.iconPoints:scale(1.5,1.5)

		viewManager.newText({
			parent 			= hud.popup, 
			text	 			= POINTS_TO_EARN_A_TICKET .. " pts",     
			x 					= display.contentWidth*0.6,
			y 					= display.contentHeight*0.4,
			fontSize 		= 120,
		})
		
		viewManager.newText({
			parent 			= hud.popup, 
			text	 			= "=",     
			x 					= display.contentWidth*0.5,
			y 					= display.contentHeight*0.5,
			fontSize 		= 90,
		})

		viewManager.newText({
			parent 			= hud.popup, 
			text	 			= "1 ticket",     
			x 					= display.contentWidth*0.4,
			y 					= display.contentHeight*0.6,
			fontSize 		= 80,
		})

		hud.popup.iconTicket 			= display.newImage( hud.popup, "assets/images/icons/ticket.png")
		hud.popup.iconTicket.x 			= display.contentWidth*0.65
		hud.popup.iconTicket.y 			= display.contentHeight*0.605
		hud.popup.iconTicket:scale(1.5,1.5)
		
		hud.validate = display.newImage( hud.popup, I "ValidateON.png")  
   	hud.validate.x = display.contentWidth*0.5
   	hud.validate.y = display.contentHeight*0.75
   	
   	utils.onTouch(hud.validate, function()
   		utils.emptyGroup(hud.popup)
   		userManager:convertCurrentPoints()
   		lotteryManager.currentTicketIsFree = true
			router.openFillLotteryTicket()
   	end)
	end
end

-----------------------------------------------------------------------------------------

function UserManager:storeLotteryTicket(numbers)

	native.setActivityIndicator( true )

	utils.postWithJSON({
		numbers = numbers,
	}, 
	SERVER_URL .. "storeLotteryTicket", 
	function(result)

		native.setActivityIndicator( false )

		local player = json.decode(result.response)
		if(player) then 
			userManager:receivedPlayer(player, router.openConfirmation)
		else 
			router.openOutside() -- pirate ?
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
	-- recheck -> pour compter les currentPoints et convert to 1 more ticket !
	
	self:checkIdlePoints()

	---------------------------------------------

	self:updatePlayer()

end

-----------------------------------------------------------------------------------------

function UserManager:convertCurrentPoints()

	local bonus = viewManager.newText({
		parent 			= hud, 
		text	 			= "+ 1 Ticket",     
		x 					= display.contentWidth*0.97,
		y 					= display.contentHeight*0.05,
		fontSize 		= 65
	})

	transition.to(bonus, { time=1000, alpha=0, x=display.contentWidth*0.78 })

	---------------------------------------------

	self:convertPointsToTickets()

	---------------------------------------------

	self:updatePlayer()

end

-----------------------------------------------------------------------------------------

function UserManager:convertPointsToTickets()

	local conversion = false

	while (self.user.currentPoints >= POINTS_TO_EARN_A_TICKET) do
		self.user.currentPoints 		= self.user.currentPoints - POINTS_TO_EARN_A_TICKET
		self.user.availableTickets 	= self.user.availableTickets + 1
		conversion = true
	end

	return conversion
end

-----------------------------------------------------------------------------------------

function UserManager:updatePlayer(next)

	native.setActivityIndicator( true )	
		
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

	native.setActivityIndicator( true )	

	utils.postWithJSON({
		user = self.user,
	}, 
	SERVER_URL .. "updateFanStatus", 
	function(result)
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

	print("userManager:logout")
	router.openOutside()
	coronaFacebook.logout()
	twitter.logout()
	utils.initGameData()	
end

function UserManager:logoutViewListener( event )
	
    if event.url then
   	
   	print("userManager.logout")
	   print(event.url)
    	
    	if event.url == SERVER_URL .. "backToMobile" then
			self:closeWebView()    	
			print("logoutViewListener backToMobile : outside")	
      	router.openOutside()
   		native.setActivityIndicator( false )
      end
	end
	
end


function UserManager:closeWebView()
	self.webView:removeEventListener( "urlRequest", function(event) self:logoutViewListener(event) end )
	self.webView:removeSelf()
	self.webView = nil
end

-----------------------------------------------------------------------------------------

return UserManager