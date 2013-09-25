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
--
--function UserManager:autoLogIn()
--	print("autologin")
--	utils.postWithJSON({
--			email = "dede@plop.com"
--		}, 
--		SERVER_URL .. "player", 
--		function(result)
--			utils.tprint(result)
--   		local params = json.decode(result.response)
--   		if(not params) then 
--   			router.openOutside()
--   		else 
--         	utils.tprint(params)
--   			self:userLoggedIn(params)
--			end
--		end
--	)
--	
----   $.ajax({
----      type: "POST",  
----      url: "/autoLogIn",
----      dataType: "json",
----      success: function (player){
----         if(player){
----            App.user.set("firstName", player.firstName)
----            App.user.set("lastName", player.lastName)
----            App.user.set("email", player.email)
----            App.user.set("loggedIn", true)
----            App.message("Welcome back " + player.firstName + " " + player.lastName + " !", true)
----         }
----      }
----   });
--
--	
--end

------------------------------------------

return UserManager