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
		
		print("result", result)
		native.setActivityIndicator( false )	
		
		if(result.isError) then
			router.openOutside()
		elseif(result.status == 401) then
			print("openSigninFB")
			router.openSigninFB()
		else
			response 							= json.decode(result.response)
			local player 						= json.decode(response.player)
			GLOBALS.savedData.authToken 	= response.authToken     
			
			userManager:receivedPlayer(player, router.openHome)
		end
	end
	)

end

-----------------------------------------------------------------------------------------

function UserManager:receivedPlayer(player, next)
	
	print("-->receivedPlayer")
	utils.tprint(player)
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
	
	next()	
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
   				utils.tprint(player)
   				userManager:receivedPlayer(player, router.openMyTickets)
   			else 
   				router.openOutside() -- pirate ?
   			end
   	end
	)
end

-----------------------------------------------------------------------------------------

return UserManager