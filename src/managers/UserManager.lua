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
   		local params = json.decode(result.response)
   		if(not params) then 
   			router.openOutside()
   		else 
         	GLOBALS.savedData.user.firstName 		= params.firstName
         	GLOBALS.savedData.user.lastName 			= params.lastName
         	GLOBALS.savedData.user.uid 				= params.uid
         	GLOBALS.savedData.user.referrerId 		= params.referrerId
         	GLOBALS.savedData.user.birthDate 		= params.birthDate
         
         	utils.saveTable(GLOBALS.savedData, "savedData.json")
			end
		end
	)

	self.user = GLOBALS.savedData.user
	router.openHome()	
end

-----------------------------------------------------------------------------------------

return UserManager