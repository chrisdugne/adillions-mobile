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

local FB_APP_ID = "170148346520274"

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

function isFacebookFan(failure)
	if(GLOBALS.savedData.facebookAccessToken) then
   	local url = "https://graph.facebook.com/me/likes/"..FACEBOOK_PAGE_ID.."?access_token=" .. GLOBALS.savedData.facebookAccessToken
   	network.request(url , "GET", function(result)
   		
   		response = json.decode(result.response)
   		
   		print("----------")
   		utils.tprint(response)
   		print("----------")
   		utils.tprint(response.error)
   		print("----------")
   	
   		if(not response.error) then
   			print("1")
      	elseif(failure) then
   			print("f1")
      	end
   	end)
   elseif(failure) then
		print("f2")
   	failure()
   end
end
