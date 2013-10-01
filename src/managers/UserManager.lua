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
			local player = json.decode(result.response)
			if(not player) then 
				router.openSigninFB()
			else 
				userManager:receivedPlayer(player)
   		end
		end
	end
	)

end

-----------------------------------------------------------------------------------------

function UserManager:receivedPlayer(player)
	GLOBALS.savedData.user.uid 				= player.uid
	GLOBALS.savedData.user.email 				= player.email
	GLOBALS.savedData.user.userName 			= player.userName
	GLOBALS.savedData.user.firstName 		= player.firstName
	GLOBALS.savedData.user.lastName 			= player.lastName
	GLOBALS.savedData.user.draws 				= player.draws

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