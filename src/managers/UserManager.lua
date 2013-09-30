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
				self.user = GLOBALS.savedData.user
				router.openHome()	
			end
		end
	end
	)

end

-----------------------------------------------------------------------------------------

function UserManager:facebookListener( event )

    print( "event.name", event.name )  --"fbconnect"
    print( "event.type:", event.type ) --type is either "session", "request", or "dialog"
    print( "isError: " .. tostring( event.isError ) )
    print( "didComplete: " .. tostring( event.didComplete ) )

    --"session" events cover various login/logout events
    --"request" events handle calls to various Graph API calls
    --"dialog" events are standard popup boxes that can be displayed

    if ( "session" == event.type ) then
        --options are: "login", "loginFailed", "loginCancelled", or "logout"
        if ( "login" == event.phase ) then
            local access_token = event.token
            --code for tasks following a successful login
        end

    elseif ( "request" == event.type ) then
        print("facebook request")
        if ( not event.isError ) then
            local response = json.decode( event.response )
            --process response data here
        end

    elseif ( "dialog" == event.type ) then
        print( "dialog", event.response )
        --handle dialog results here
    end
end

-----------------------------------------------------------------------------------------

return UserManager