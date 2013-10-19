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
			router.openOutside()
		else
			local player = json.decode(result.response)
			if(not player) then 
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

	utils.saveTable(GLOBALS.savedData, "savedData.json")

	facebook.isFacebookFan(next)
end

-----------------------------------------------------------------------------------------
-- en arrivant on check si on passe sur une nouvelle lotterie
-- ce check est donc fait avant le concertIdlePoints
-- donc les tickets convertis de idlepoints sont bien rajoutés aux nouveaux availableTickets

function UserManager:checkUserCurrentLottery()

	if(self.user.currentLotteryUID ~= lotteryManager.nextLottery.uid) then
		self.user.currentLotteryUID 			= lotteryManager.nextLottery.uid
		self.user.availableTickets 			= START_AVAILABLE_TICKETS 
		self.user.playedBonusTickets 			= 0
		
		self:updatePlayer()
	end
	
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
		if(next) then
			next()
		end
	end
	)

end

-----------------------------------------------------------------------------------------

function UserManager:logout()

	if(self.user.facebookId) then
   	native.setActivityIndicator( true )
   	
   	self.webView = native.newWebView( 0, 0, 1, 1 )
   	self.webView:request( SERVER_URL .. "mlogout" )
   	self.webView:addEventListener( "urlRequest", function(event) self:logoutViewListener(event) end )
   	
   else
		router.openOutside()
   end
   
end

function UserManager:logoutViewListener( event )
	
    if event.url then
   	
   	print("userManager.logout")
	   print(event.url)
    	
    	if event.url == SERVER_URL .. "backToMobile" then
			self:closeWebView()    		
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