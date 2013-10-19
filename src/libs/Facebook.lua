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
--

---
-- todo from mlogin and msignin
-- 1 - open mlogin
-- 2 - remove FB.popupLogin and window.href "/connectWithFB"
-- 3 - listen here and call login
--
-- todo logout
-- todo cleanup login/signin/signinFB remove listeners + webviews
-- todo test android
--
function login()
	coronaFacebook.login( FACEBOOK_APP_ID, fblistener, {"publish_stream", "email", "user_likes", "user_birthday", "friends_birthday", "publish_actions"} )
end

-- listener for "fbconnect" events
function fblistener( event )
	
	print("----->   fblistener")
	utils.tprint(event)
	
    if ( "session" == event.type ) then
        -- upon successful login, request list of friends of the signed in user
        if ( "login" == event.phase ) then
            -- Fetch access token for use in Facebook's API
            local access_token = event.token
            print( access_token )
            
   			GLOBALS.savedData.facebookAccessToken 	= event.token
         	utils.saveTable(GLOBALS.savedData, "savedData.json")
   
   			facebook.getMe()
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
		print("token -->", GLOBALS.savedData.facebookAccessToken)
   	local url = "https://graph.facebook.com/me?fields=name,first_name,last_name,picture,locale,birthday,email&access_token=" .. GLOBALS.savedData.facebookAccessToken
   	network.request(url , "GET", function(result)
   		
   		response = json.decode(result.response)
   		
   		print("----------")
   		utils.tprint(response)
   		print("----------")
   		utils.tprint(response.error)
   		print("----------")
   	
   		if(not response.error) then
   			print("--> connected to FB")
      		utils.tprint(response)
				facebook.data = response

				native.setActivityIndicator( false )	      		
      		userManager:getPlayerByFacebookId()
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

	if(GLOBALS.savedData.facebookAccessToken) then
	
   	local url = "https://graph.facebook.com/me/likes/"..FACEBOOK_PAGE_ID.."?access_token=" .. GLOBALS.savedData.facebookAccessToken
			
   	network.request(url , "GET", function(result)
   		
   		response = json.decode(result.response)
   		
   		if(not response.error) then
   			if(response.data[1] ~= nil) then
   				userManager.user.facebookFan = true
   				userManager.user.totalBonusTickets = userManager.user.totalBonusTickets + FACEBOOK_FAN_TICKETS
   			else
					userManager.user.facebookFan = false 
   			end
      	end
			
			next()
   	end)
   else
   	next()
   end
end

-----------------------------------------------------------------------------------------
-- like de la page : ne marche pas : rediriger vers la page
-- 
function beFan()
	
	if(GLOBALS.savedData.facebookAccessToken) then

   	native.setActivityIndicator( true )

   	local url = "https://graph.facebook.com/".. FACEBOOK_PAGE_ID .."/likes?method=post&access_token=" .. GLOBALS.savedData.facebookAccessToken
   	print (url)
   	
   	network.request(url , "GET", function(result)
      	native.setActivityIndicator( false )
   		local response = json.decode(result.response)
   		
   		if(response.id) then
   			isFacebookFan()
   		end
   		
   	end)
   end

end

-----------------------------------------------------------------------------------------

function checkThemeLiked(theme, like)
	
	print("--------------------------")
	print("themeAlreadyLiked")
	
   local url = "https://graph.facebook.com/me/"..FACEBOOK_APP_NAMESPACE..":enjoy?"
   	    ..  "access_token=" .. GLOBALS.savedData.facebookAccessToken
   	    
	network.request(url , "GET", function(result)
   	native.setActivityIndicator( false )
   	local response = json.decode(result.response)
   	utils.tprint(response)
   	
   	local liked = false
   	
   	if(#response.data > 0) then 
   		for i = 1,#response.data do
   			if(response.data[i].data.theme.title == theme.title) then
   				liked = true
   			end
   		end 
   	end
   	
   	if(not liked) then
   		like()
   	end
	end)
end

-----------------------------------------------------------------------------------------

function likeTheme(theme)

	checkThemeLiked(theme, function()

		print("-----> Like theme !!!!")
		local locale			= facebook.data.locale

		local themeURL =  SERVER_OG_URL .. 'theme'
		.. '?title=' 			.. theme.title
		.. '&description=' 	.. theme.description
		.. '&imageURL='		.. theme.imageURL 
		.. '&locale='			.. locale

		themeURL = utils.urlEncode(themeURL)

		local url = "https://graph.facebook.com/me/"..FACEBOOK_APP_NAMESPACE..":enjoy?method=post"
		..  "&theme=" .. themeURL
		..  "&access_token=" .. GLOBALS.savedData.facebookAccessToken

		native.setActivityIndicator( true )

		network.request(url , "GET", function(result)
			native.setActivityIndicator( false )
			utils.tprint(result)
		end)
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

   		if(response.id) then
   			next()
   		end
   		
   	end)
   end
	
end

-----------------------------------------------------------------------------------------
-- WEB VIEW LISTENING - AUTH
-----------------------------------------------------------------------------------------

function initWeb()
	facebook.lastUrlNb = 0
end

function newUrl()
	facebook.lastUrlNb = facebook.lastUrlNb + 1
end

-----------------------------------------------------------------------------------------

function checkWebUrl(url, askToLoginFunction, askOauthRead)

    	if string.startsWith(url, "https://www.facebook.com/logout.php") then
    		askToLoginFunction()
			
    	elseif string.startsWith(url, "https://m.facebook.com/dialog/oauth?redirect_uri") then -- FB DE *&^%$ ne donne pas de access_token qd logout + login again (-> changeAccount)
    		print("-----> contains oauth?redirect_uri")
			local params = utils.getUrlParams(url);
			print(utils.urlDecode(params.redirect_uri))
			askOauthRead()
    	
    	elseif url == "https://m.facebook.com/dialog/oauth/read"
    	or url == "https://m.facebook.com/dialog/oauth/write" -- FB doesnt redirect here ... ex : Cancel during permissions
    	then 
    		print("-----> force relogin ?")
    		
    		local time = 8000
--    		if(string.startsWith(url, "https://m.facebook.com/dialog/oauth?redirect_uri")) then
--    			time = 100
--    		end
    		
    		local urlNb = facebook.lastUrlNb
    		timer.performWithDelay(time, function()
    			if(facebook.lastUrlNb == urlNb) then
    				print("stuck ! redirecting to login again ")
    				askToLoginFunction()
   			end
    		end)
			
    	elseif string.find(url, "error") then
    		print("-----> contains error ?")
    	
    	end
    	
end