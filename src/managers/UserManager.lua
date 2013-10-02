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

	utils.postWithJSON({
		email = GLOBALS.savedData.user.email
	}, 
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
		facebookData = facebook.data
	}, 
	SERVER_URL .. "playerFromFB", 
	function(result)
		if(result.isError) then
			router.openOutside()
		else
			utils.tprint(result.response)
			local player = json.decode(result.response.player)
			if(not player) then 
   			print("openSigninFB")
				router.openSigninFB()
			else 
				GLOBALS.savedData.authToken 	= json.decode(result.response.authToken)     
   			print("getPlayerByFacebookId | got token", GLOBALS.savedData.authToken)
      		utils.saveTable(GLOBALS.savedData, "savedData.json")
				userManager:receivedPlayer(player)
   		end
		end
	end
	)

end

-----------------------------------------------------------------------------------------

function UserManager:receivedPlayer(player)
	
	print("---")
	utils.tprint(player)
	print("---")

	GLOBALS.savedData.user.uid 				= player.uid
	GLOBALS.savedData.user.email 				= player.email
	GLOBALS.savedData.user.userName 			= player.userName
	GLOBALS.savedData.user.firstName 		= player.firstName
	GLOBALS.savedData.user.lastName 			= player.lastName
	GLOBALS.savedData.user.birthDate 		= player.birthDate
	GLOBALS.savedData.user.referrerId 		= player.referrerId
	
	GLOBALS.savedData.user.drawTickets 		= player.drawTickets
	GLOBALS.savedData.user.lotteryTickets 	= player.lotteryTickets

	GLOBALS.savedData.user.currentPoints 	= player.currentPoints
	GLOBALS.savedData.user.idlePoints 		= player.idlePoints
	GLOBALS.savedData.user.totalPoints 		= player.totalPoints

	GLOBALS.savedData.user.facebookId 		= player.facebookId

	utils.saveTable(GLOBALS.savedData, "savedData.json")
	self.user = GLOBALS.savedData.user
	
	router.openHome()	
end

-----------------------------------------------------------------------------------------

return UserManager