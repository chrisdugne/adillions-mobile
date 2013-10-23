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

		if(result.isError) then
			print("getPlayerByFacebookId error : outside")
			router.openOutside()
		elseif(result.status == 401) then
			print("openSigninFB")
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

	self:updatedPlayer(player)
	
	facebook.isFacebookFan(next)
	
	print("=====================================================")
	print("receivedPlayer")
	print("sponsorpayTools init")
	sponsorpayTools:init()
end

-----------------------------------------------------------------------------------------

function UserManager:updatedPlayer(player, next)

	self.user 							= player
	self.user.totalBonusTickets 	= 0

	GLOBALS.savedData.user.uid 				= player.uid
	GLOBALS.savedData.user.email 				= player.email
	GLOBALS.savedData.user.userName 			= player.userName
	GLOBALS.savedData.user.firstName 		= player.firstName
	GLOBALS.savedData.user.lastName 			= player.lastName
	GLOBALS.savedData.user.birthDate 		= player.birthDate
	GLOBALS.savedData.user.referrerId 		= player.referrerId
	GLOBALS.savedData.user.facebookId 		= player.facebookId
	GLOBALS.savedData.user.twitterId 		= player.twitterId
	GLOBALS.savedData.user.twitterName 		= player.twitterName

	utils.saveTable(GLOBALS.savedData, "savedData.json")

	self:checkIdlePoints()
	
	if(next) then
		next()
	end
	
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
		
		self:updatePlayer()
      
   	----------------------------------------
   	
   	lotteryManager:refreshNotifications(lotteryManager.nextLottery.date)

	end

	--------------------------------------------------------------------------------------

end

-----------------------------------------------------------------------------------------

function UserManager:checkIdlePoints(numbers)

	if(userManager.user.idlePoints > 0) then
		local title 	= "_New points !"
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
   			x 					= display.contentWidth*0.5,
   			y 					= display.contentHeight*0.6,
   			fontSize 		= 80,
   		})
   	end
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

	utils.postWithJSON({
		user = self.user,
	}, 
	SERVER_URL .. "updatePlayer", 
	function(result)
		local player = json.decode(result.response)
		userManager:updatedPlayer(player, next)
	end
	)

end

-----------------------------------------------------------------------------------------

function UserManager:twitterConnection(twitterId, twitterName, accessToken, next)

	print("twitterConnection")

	GLOBALS.savedData.user.twitterId 					= twitterId
	GLOBALS.savedData.user.twitterName 					= twitterName
	GLOBALS.savedData.user.twitterAccessToken 		= accessToken
	
	utils.saveTable(GLOBALS.savedData, "savedData.json")
	
	self.user.twitterId 		= twitterId
	self.user.twitterName 	= twitterName
	
	self:updatePlayer(next)
end

-----------------------------------------------------------------------------------------

function UserManager:mergePlayerWithFacebook(next)

	GLOBALS.savedData.user.facebookId = facebook.data.id
	utils.saveTable(GLOBALS.savedData, "savedData.json")
	
	self.user.facebookId = facebook.data.id
	
	self:updatePlayer(next)
end

-----------------------------------------------------------------------------------------

function UserManager:logout()

	print("userManager:logout")
	router.openOutside()
	coronaFacebook.logout()
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