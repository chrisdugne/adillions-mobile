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

	utils.postWithJSON(
   	{}, 
   	SERVER_URL .. "player", 
   	function(result)
   		if(result.isError) then
   			router.openOutside()
   		else
   
   			local player = json.decode(result.response)
   			if(not player) then 
   				router.openOutside()
   			else 
   				userManager:receivedPlayer(player)
   			end
   		end
	end
	)

end

-----------------------------------------------------------------------------------------

function UserManager:getPlayerByFacebookId()
	
	utils.postWithJSON({
		facebookData = facebook.data,
		accessToken = GLOBALS.savedData.facebookAccessToken
	}, 
	SERVER_URL .. "playerFromFB", 
	function(result)
			
		if(result.isError) then
			router.openOutside()
		elseif(result.status == 401) then
			print("openSigninFB")
			router.openSigninFB()
		else
			response 							= json.decode(result.response)
			local player 						= response.player
			GLOBALS.savedData.authToken 	= response.authToken     
			utils.saveTable(GLOBALS.savedData, "savedData.json")
			userManager:receivedPlayer(player)
		end
	end
	)

end

-----------------------------------------------------------------------------------------

function UserManager:receivedPlayer(player)
	
	self.user = player
	
	GLOBALS.savedData.user.uid 				= player.uid
	GLOBALS.savedData.user.email 				= player.email
	GLOBALS.savedData.user.userName 			= player.userName
	GLOBALS.savedData.user.firstName 		= player.firstName
	GLOBALS.savedData.user.lastName 			= player.lastName
	GLOBALS.savedData.user.birthDate 		= player.birthDate
	GLOBALS.savedData.user.referrerId 		= player.referrerId
	
	GLOBALS.savedData.user.currentPoints 	= player.currentPoints
	GLOBALS.savedData.user.idlePoints 		= player.idlePoints
	GLOBALS.savedData.user.totalPoints 		= player.totalPoints

	GLOBALS.savedData.user.facebookId 		= player.facebookId

	utils.saveTable(GLOBALS.savedData, "savedData.json")
	
	router.openHome()	
end

-----------------------------------------------------------------------------------------

function UserManager:storeLotteryTicket(ticket)
	print("-")
	utils.tprint(ticket)

	utils.postWithJSON({
   		ticket = ticket,
   	}, 
   	SERVER_URL .. "storeLotteryTicket", 
   	function(result)
   
   	end
	)
end

-----------------------------------------------------------------------------------------

return UserManager