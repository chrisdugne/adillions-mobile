-----------------------------------------------------------------------------------------
-- Project: Few requests to facebook
--
-- Date: Oct 1, 2013
--
-- Version: 1.0
--
-- File name	: Facebook.lua
-- 
-- Author: Chris Dugne @ Uralys - www.uralys.com
--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function login()
	print("--- facebook login")
	native.setActivityIndicator( true )
	coronaFacebook.login( FACEBOOK_APP_ID, loginListener, {"publish_stream", "email", "user_likes", "user_birthday", "friends_birthday", "publish_actions"} )
end

------------------------------------

local afterFacebookConnection

function connect(next)
	print("--- facebook connect")
	native.setActivityIndicator( true )
	coronaFacebook.login( FACEBOOK_APP_ID, connectListener, {"publish_stream", "email", "user_likes", "user_birthday", "friends_birthday", "publish_actions"} )
	afterFacebookConnection = next
end

------------------------------------

-- listener for "fbconnect" events
function loginListener( event )

	print("----->  FB loginListener")
	utils.tprint(event)

	if ( "session" == event.type ) then
		-- upon successful login, request list of friends of the signed in user
		if ( "login" == event.phase ) then

			if(event.token) then
				-- Fetch access token for use in Facebook's API
				print( "got the token" )

				GLOBALS.savedData.facebookAccessToken 	= event.token
				utils.saveTable(GLOBALS.savedData, "savedData.json")

				getMe()
			end

		elseif ( "loginFailed" == event.phase or "loginCancelled" == event.phase ) then

			print("--- false")
			native.setActivityIndicator( false )
			userManager:logout()

		end

	elseif ( "request" == event.type ) then
		native.setActivityIndicator( false )
		-- event.response is a JSON object from the FB server
		local response = event.response

		-- if request succeeds, create a scrolling list of friend names
		if ( not event.isError ) then
			response = json.decode( event.response )

			local data = response.data
			for i=1,#data do
				local name = data[i].name
				print( name )
			end
		end
	elseif ( "dialog" == event.type ) then
		native.setActivityIndicator( false )
		print( "dialog", event.response )
	end
end
------------------------------------

-- listener for "fbconnect" events
function connectListener( event )

	print("-----> FB  connectListener")
	utils.tprint(event)

	if ( "session" == event.type ) then
		-- upon successful login, request list of friends of the signed in user
		if ( "login" == event.phase ) then

			if(event.token) then
				-- Fetch access token for use in Facebook's API
				print( "got the token" )

				GLOBALS.savedData.facebookAccessToken 	= event.token
				utils.saveTable(GLOBALS.savedData, "savedData.json")

				mergeMe(afterFacebookConnection)
			end

		elseif ( "loginFailed" == event.phase or "loginCancelled"  == event.phase ) then
			print("--- false")	
			native.setActivityIndicator( false )
			viewManager.message(T "Connection failed")

		end
	elseif ( "request" == event.type ) then
		-- event.response is a JSON object from the FB server
		local response = event.response

		-- if request succeeds, create a scrolling list of friend names
		if ( not event.isError ) then
			response = json.decode( event.response )

			local data = response.data
			for i=1,#data do
				local name = data[i].name
				print( name )
			end
		end
	elseif ( "dialog" == event.type ) then
		print( "dialog", event.response )
	end
end

--
-----------------------------------------------------------------------------------------

--- Data returned if success
---{
--   "name": "Christophe Dugne-Esquevin",
--   "first_name": "Christophe",
--   "last_name": "Dugne-Esquevin",
--   "locale": "en_US",
--   "birthday": "10/16/1983",
--   "email": "chris.dugne\u0040uralys.com",
--   "id": "756469753",
--   "picture": {
--      "data": {
--         "url": "http://profile.ak.fbcdn.net/hprofile-ak-ash1/369905_756469753_990403215_q.jpg",
--         "is_silhouette": false
--      }
--   }
--}
function getMe(failure)
	if(GLOBALS.savedData.facebookAccessToken) then
		local url = "https://graph.facebook.com/me?fields=name,first_name,last_name,picture.type(large),locale,birthday,email&access_token=" .. GLOBALS.savedData.facebookAccessToken
		network.request(url , "GET", function(result)

			response = json.decode(result.response)
			native.setActivityIndicator( false )	      		

			if(not response.error) then
				print("--> connected to FB")
				utils.tprint(response)
				facebook.data = response

				userManager:getPlayerByFacebookId()
			elseif(failure) then
				print("--> old FB token")
				GLOBALS.savedData.facebookAccessToken = nil
				utils.saveTable(GLOBALS.savedData, "savedData.json")
				failure()
			end
		end)
	elseif(failure) then
		print("--> no FB token")
		failure()
	end
end

-----------------------------------------------------------------------------------------

function mergeMe(next)
	if(GLOBALS.savedData.facebookAccessToken) then
		print("mergeMe ! token -->", GLOBALS.savedData.facebookAccessToken)
		local url = "https://graph.facebook.com/me?fields=name,first_name,last_name,picture,locale,birthday,email&access_token=" .. GLOBALS.savedData.facebookAccessToken
		network.request(url , "GET", function(result)

			response = json.decode(result.response)   		
			native.setActivityIndicator( false )	   

			if(not response.error) then
				print("--> connected to FB")
				utils.tprint(response)
				facebook.data = response
				
				userManager:checkExistingUser(next)

			elseif(failure) then
				print("--> old FB token")
				failure()
			end
		end)
	elseif(failure) then
		print("--> no FB token")
		failure()
	end
end

-----------------------------------------------------------------------------------------

function isFacebookFan(next)

	-- default : celui de la db, meme si non connecte
	-- triche possible : cancel fan et ne plus se connecter avec facebook.
	userManager.user.facebookFan = userManager.user.isFacebookFan

	print("------------------------ isFacebookFan ")
	if(GLOBALS.savedData.facebookAccessToken) then

		local url = "https://graph.facebook.com/me/likes/"..FACEBOOK_PAGE_ID.."?access_token=" .. GLOBALS.savedData.facebookAccessToken
		network.request(url , "GET", function(result)

			response = json.decode(result.response)

			if(not response.error) then
				if(response.data[1] ~= nil) then
					userManager.user.facebookFan = true
				else
					userManager.user.facebookFan = false
				end
			end

			if(next) then
				next()
			end
		end)
	else
		print("------------------------ gonext ")
		if(next) then
			next()
		end
	end
end

-----------------------------------------------------------------------------------------

function showLikeThemeButton()
	hud.likeThemeButton		= display.newImage( hud, "assets/images/icons/like.png")  
	hud.likeThemeButton.x 	= display.contentWidth*0.1
	hud.likeThemeButton.y 	= display.contentHeight*0.85

	utils.onTouch(hud.likeThemeButton, function()
		facebook.likeTheme()
		display.remove(hud.likeThemeButton)
	end)
end

function checkThemeLiked()

	print("=========> checkThemeLiked")
	if(GLOBALS.savedData.facebookAccessToken) then

		local theme = lotteryManager.nextLottery.theme

		local url = "https://graph.facebook.com/me/"..FACEBOOK_APP_NAMESPACE..":enjoy?"
		..  "access_token=" .. GLOBALS.savedData.facebookAccessToken

		print(url)

		network.request(url , "GET", function(result)
			local response = json.decode(result.response)
			local liked = false
   		print("=========> response")

			if(#response.data > 0) then 
				for i = 1,#response.data do
					-- FB.OG BUG pas possible de rajouter uid today... check title pour linstant
					--   			if(response.data[i].data.theme.uid == theme.uid) then
					if(response.data[i].data.theme.title == theme.title) then
						liked = true
					end
				end 
			end

			if(not liked) then
				print("theme Not liked")
				showLikeThemeButton()
			else
				print("themeAlreadyLiked")
			end
		end)
	end
end

-----------------------------------------------------------------------------------------

function likeTheme()

	local theme = lotteryManager.nextLottery.theme

	print("--- true")
	native.setActivityIndicator( true )
	print("-----> Like theme !!!!")
	utils.tprint(theme)

	local locale			= facebook.data.locale

	local themeURL =  SERVER_OG_URL .. 'theme'
	.. '?title=' 			.. theme.title
	.. '&uid=' 				.. theme.uid
	.. '&description=' 	.. theme.description
	.. '&imageURL='		.. theme.image 
	.. '&locale='			.. locale

	themeURL = utils.urlEncode(themeURL)

	local url = "https://graph.facebook.com/me/"..FACEBOOK_APP_NAMESPACE..":enjoy?method=post"
	..  "&theme=" .. themeURL
	..  "&access_token=" .. GLOBALS.savedData.facebookAccessToken


	network.request(url , "GET", function(result)
		local response = json.decode(result.response)
		native.setActivityIndicator( false )
		print("--- false")
		utils.tprint(response)
		if(response.id) then
			viewManager.showPoints(NB_POINTS_PER_THEME_LIKED)
			userManager.user.currentPoints = userManager.user.currentPoints + NB_POINTS_PER_THEME_LIKED
			userManager:updatePlayer()
--			userManager:checkIdlePoints() ? pas besoin ici ?
		elseif(response.error.code == 200) then
			facebook.reloginDone = function() facebook.checkThemeLiked() end
			coronaFacebook.login( FACEBOOK_APP_ID, askPermissionListener, {"publish_stream", "email", "user_likes", "user_birthday", "friends_birthday", "publish_actions"} )   			
		end
	end)
end

-----------------------------------------------------------------------------------------

--/PROFILE_ID/feed
function postOnWall(message, next)

	if(GLOBALS.savedData.facebookAccessToken) then

		native.setActivityIndicator( true )

		local url = "https://graph.facebook.com/"..userManager.user.facebookId .."/feed?method=post&message="..utils.urlEncode(message).."&access_token=" .. GLOBALS.savedData.facebookAccessToken
		print (url)
		network.request(url , "GET", function(result)
			native.setActivityIndicator( false )
			local response = json.decode(result.response)
			utils.tprint(response)

			if(response.id ~= nil) then
   			print("---> next !")
				next()
			elseif(response.error.code == 200) then
				facebook.reloginDone = nil
				coronaFacebook.login( FACEBOOK_APP_ID, askPermissionListener, {"publish_stream", "email", "user_likes", "user_birthday", "friends_birthday", "publish_actions"} )
			else   			
   			print(response.id)
   			
   			if(response.error ~= nil) then
   				print(response.error.code)
   			end
   			
   			print("???")
			end

		end)
	end

end

-----------------------------------------------------------------------------------------

function askPermissionListener( event )

	print("----->  FB askPermissionListener")

	if ( "session" == event.type ) then
		-- upon successful login, request list of friends of the signed in user
		if ( "login" == event.phase ) then

			if(event.token) then
				-- Fetch access token for use in Facebook's API
				GLOBALS.savedData.facebookAccessToken 	= event.token
				utils.saveTable(GLOBALS.savedData, "savedData.json")

				if( facebook.reloginDone) then
					facebook.reloginDone()
				end
			end

		end
	end
end