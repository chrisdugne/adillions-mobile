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
--
--Facebook.getAppAccessToken = function()
--{
--   $.ajax({  
--      type: "GET",  
--      url: "https://graph.facebook.com/oauth/access_token?client_id=" + this.FACEBOOK_APP_ID + "&client_secret=" + this.FACEBOOK_APP_SECRET + "&grant_type=client_credentials",
--      success: function (data, textStatus, jqXHR)
--      {
--         if(data.indexOf("access_token") == -1){
--            Facebook.appAccessToken = data 
--         }
--         else{
--            // IE
--            Facebook.appAccessToken = data.split("=")[1] 
--         }
--
--      },
--      error: function(jqXHR, textStatus, errorThrown)
--      {
--         alert(textStatus);
--      }
--   });
--}
--
--Facebook.getMe = function(next)
--{
--   $.ajax({  
--      type: "GET",  
--      url: "https://graph.facebook.com/me?fields=name,first_name,last_name,picture,locale,birthday,email&access_token="+ this.accessToken,
--      dataType: "jsonp",
--      success: function (data, textStatus, jqXHR)
--      {
--         Facebook.data = data
--         next();
--      },
--      error: function(jqXHR, textStatus, errorThrown)
--      {
--         alert(textStatus);
--      }
--   });
--}

