-----------------------------------------------------------------------------------------

ShareManager = {}	

-----------------------------------------------------------------------------------------

function ShareManager:new()  

	local object = {
	}

	setmetatable(object, { __index = ShareManager })
	return object
end

-----------------------------------------------------------------------------------------

function ShareManager:share()

	-----------------------------------

	local title = "_Share"
	local text = "_Share with friends to get VIP points and more tickets !"
	viewManager.showPopup(title, text)

	-----------------------------------
	-- SMS
	-----------------------------------

	viewManager.drawButton(hud.popup, "SMS", display.contentWidth*0.5, display.contentHeight*0.4, function()
		local options =
		{
			body = "_I've just played a ticket on Adillions !\n Join me and please use my sponsor code when you sign in : " .. userManager.user.sponsorCode
		}
		native.showPopup("sms", options)
	end)

	-----------------------------------
	-- Email
	-----------------------------------

	viewManager.drawButton(hud.popup, "Email", display.contentWidth*0.5, display.contentHeight*0.5, function()
		local options =
		{
			body = "<html><body>I've just played a ticket on Adillions !\n _Join me on <a href='http://www.adillions.com'>Adillions</a> !<br/> Please use my sponsor code when you sign in : " .. userManager.user.sponsorCode .. "</body></html>",
			isBodyHtml = true,
			subject = "Adillions",
		}
		native.showPopup("mail", options)
	end)

	-----------------------------------
	-- Facebook
	-----------------------------------

	if(userManager.user.facebookId) then
		viewManager.drawButton(hud.popup, "Facebook", display.contentWidth*0.5, display.contentHeight*0.65, function() self:shareOnWall() end)

		hud.popup.facebookIcon 			= display.newImage( hud.popup, "assets/images/icons/facebook.png")  
   	hud.popup.facebookIcon.x 		= display.contentWidth*0.28
   	hud.popup.facebookIcon.y		= display.contentHeight*0.65
   	
	else
		hud.popup.facebookConnect 		= display.newImage( hud.popup, I "facebook.connect.button.png")  
   	hud.popup.facebookConnect.x 	= display.contentWidth*0.5
   	hud.popup.facebookConnect.y	= display.contentHeight*0.65
   
		utils.onTouch(hud.popup.facebookConnect, function() 
			facebook.connect(function()
				self:shareOnWall()
			end) 
		end)
   	
	end

	-----------------------------------
	-- Twitter
	-----------------------------------

	if(twitter.connected) then
		viewManager.drawButton(hud.popup, "Twitter", display.contentWidth*0.5, display.contentHeight*0.77, function()
   		self:tweetShare()
		end)
		
		hud.popup.twitterIcon 			= display.newImage( hud.popup, "assets/images/icons/twitter.png")  
   	hud.popup.twitterIcon.x 		= display.contentWidth*0.28
   	hud.popup.twitterIcon.y			= display.contentHeight*0.77
   	
	else
	
		hud.popup.twitterConnect 		= display.newImage( hud.popup, I "twitter.connect.button.png")  
   	hud.popup.twitterConnect.x 	= display.contentWidth*0.5
   	hud.popup.twitterConnect.y		= display.contentHeight*0.77
   
		utils.onTouch(hud.popup.twitterConnect, function() 
			twitter.connect(function()
      		self:tweetShare()
			end) 
		end)
		
	end


end

-----------------------------------------------------------------------------------------

function ShareManager:invite()

	----------------------------------------------------------------------------------------------------

	local title = "_Be an Adillions' Ambassador !"
	local text	= "_Earn free additional tickets by referring people to Adillions"

	viewManager.showPopup(title, text)
	
	----------------------------------------------------------------------------------------------------

	viewManager.drawButton(hud.popup, "SMS", display.contentWidth*0.5, display.contentHeight*0.4, function()
		local options =
		{
			body = "_Join me on www.adillions.com !\n Please use my sponsor code when you sign in : " .. userManager.user.sponsorCode
		}
		native.showPopup("sms", options)
	end)

	----------------------------------------------------------------------------------------------------

	viewManager.drawButton(hud.popup, "email", display.contentWidth*0.5, display.contentHeight*0.5, function()
		local options =
		{
			body = "<html><body>_Join me on <a href='http://www.adillions.com'>Adillions</a> !<br/> Please use my sponsor code when you sign in : " .. userManager.user.sponsorCode .. "</body></html>",
			isBodyHtml = true,
			subject = "Adillions",
		}
		native.showPopup("mail", options)
	end)

	----------------------------------------------------------------------------------------------------

	if(userManager.user.facebookId) then
		viewManager.drawButton(hud.popup, "Facebook", display.contentWidth*0.5, display.contentHeight*0.65, function()
   		router.openInviteFriends()
		end)
		
		hud.popup.facebookIcon 			= display.newImage( hud.popup, "assets/images/icons/facebook.png")  
   	hud.popup.facebookIcon.x 		= display.contentWidth*0.28
   	hud.popup.facebookIcon.y		= display.contentHeight*0.65
	else
	
		hud.popup.facebookConnect 		= display.newImage( hud.popup, I "facebook.connect.button.png")  
   	hud.popup.facebookConnect.x 	= display.contentWidth*0.5
   	hud.popup.facebookConnect.y	= display.contentHeight*0.65
   
		utils.onTouch(hud.popup.facebookConnect, function() 
			facebook.connect(function()
      		router.openInviteFriends()
			end) 
		end)
		
	end

	----------------------------------------------------------------------------------------------------

	if(twitter.connected) then
		viewManager.drawButton(hud.popup, "Twitter", display.contentWidth*0.5, display.contentHeight*0.77, function()
   		self:tweetInvite()
		end)

		hud.popup.twitterIcon 			= display.newImage( hud.popup, "assets/images/icons/twitter.png")  
   	hud.popup.twitterIcon.x 		= display.contentWidth*0.28
   	hud.popup.twitterIcon.y			= display.contentHeight*0.77
	else
	
		hud.popup.twitterConnect 		= display.newImage( hud.popup, I "twitter.connect.button.png")  
   	hud.popup.twitterConnect.x 	= display.contentWidth*0.5
   	hud.popup.twitterConnect.y		= display.contentHeight*0.77
   
		utils.onTouch(hud.popup.twitterConnect, function() 
			twitter.connect(function()
      		self:tweetInvite()
			end) 
		end)
	end

end

-----------------------------------------------------------------------------------------

function ShareManager:shareOnWall()
	
	facebook.postOnWall("I've just played a ticket on Adillions !\n Next Lottery : ".. lotteryManager:date(lotteryManager.nextLottery) .." \n_Join me there and please use my sponsor code when you sign in : " .. userManager.user.sponsorCode, function()
		
		viewManager.showPopup(T "Thank you" .. "  !", T "Successfully posted on your wall !", function()
			if(not userManager.user.hasPostOnFacebook) then
      		viewManager.showPoints(NB_POINTS_PER_POST)
	   		userManager.user.currentPoints = userManager.user.currentPoints + NB_POINTS_PER_POST
   			userManager.user.hasPostOnFacebook = true
   			userManager:updatePlayer()
   			userManager:checkIdlePoints()
   		end 
		end)
		
		hud.popup.facebookIcon 			= display.newImage( hud.popup, "assets/images/icons/facebook.png")  
   	hud.popup.facebookIcon.x 		= display.contentWidth*0.5
   	hud.popup.facebookIcon.y			= display.contentHeight*0.5
   	hud.popup.facebookIcon:scale(1.5,1.5)
		
	end)
end

-----------------------------------------------------------------------------------------

function ShareManager:tweetInvite()
	
	twitter.tweetMessage("_Join me on www.adillions.com !\n Please use my sponsor code when you sign in : " .. userManager.user.sponsorCode, function()
		
		viewManager.showPopup(T "Thank you" .. " !", T "Successfully tweeted", function()
			if(not userManager.user.hasTweetAnInvite) then
      		viewManager.showPoints(NB_POINTS_PER_TWEET)
      		userManager.user.currentPoints = userManager.user.currentPoints + NB_POINTS_PER_TWEET
   			userManager.user.hasTweetAnInvite = true
   			userManager:updatePlayer()
      		userManager:checkIdlePoints() 
   		end
		end)
		
		hud.popup.twitterIcon 			= display.newImage( hud.popup, "assets/images/icons/twitter.png")  
   	hud.popup.twitterIcon.x 		= display.contentWidth*0.5
   	hud.popup.twitterIcon.y			= display.contentHeight*0.5
   	hud.popup.twitterIcon:scale(1.5,1.5)
		
	end)
end

function ShareManager:tweetShare()
	
	twitter.tweetMessage("_I've just played a ticket on Adillions !\n Join me and please use my sponsor code when you sign in : " .. userManager.user.sponsorCode, function()
	
		viewManager.showPopup(T "Thank you" .. " !", T "Successfully tweeted", function()
			if(not userManager.user.hasTweet) then
   			viewManager.showPoints(NB_POINTS_PER_TWEET)
   			userManager.user.currentPoints = userManager.user.currentPoints + NB_POINTS_PER_TWEET
   			userManager.user.hasTweet = true
   			userManager:updatePlayer()
   			userManager:checkIdlePoints()
   		end 
		end)
		
		hud.popup.twitterIcon 			= display.newImage( hud.popup, "assets/images/icons/twitter.png")  
   	hud.popup.twitterIcon.x 		= display.contentWidth*0.5
   	hud.popup.twitterIcon.y			= display.contentHeight*0.5
   	hud.popup.twitterIcon:scale(1.5,1.5)
   	
	end)
end

-----------------------------------------------------------------------------------------

return ShareManager