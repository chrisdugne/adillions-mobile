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

	viewManager.showPopup()
	analytics.event("Social", "popupShare") 
	
	----------------------------------------------------------------------------------------------------
	
	hud.popup.shareIcon 				= display.newImage( hud.popup, "assets/images/icons/PictoShare.png")  
	hud.popup.shareIcon.x 			= display.contentWidth*0.5
	hud.popup.shareIcon.y			= display.contentHeight*0.22

	hud.popup.shareText 				= display.newImage( hud.popup, I "popup.Txt3.png")  
	hud.popup.shareText.x 			= display.contentWidth*0.5
	hud.popup.shareText.y			= display.contentHeight*0.32
	
	
	hud.popup.earnText = viewManager.newText({
		parent 			= hud.popup,
		text 				= T "Earn points and get Instant Tickets", 
		fontSize			= 34,  
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.4,
	})

	-----------------------------------
	-- Facebook
	-----------------------------------


	if(userManager.user.facebookId) then
		hud.popup.facebookShare 		= display.newImage( hud.popup, I "popup.BtShareFacebook.png")  
   	hud.popup.facebookShare.x 		= display.contentWidth*0.5
   	hud.popup.facebookShare.y		= display.contentHeight*0.55
   
		utils.onTouch(hud.popup.facebookShare, function() 
			self:shareOnWall()
			analytics.event("Social", "facebookShare") 
		end)
		
	else
		hud.popup.facebookConnect 		= display.newImage( hud.popup, I "popup.BtConnectFacebook.png")  
   	hud.popup.facebookConnect.x 	= display.contentWidth*0.5
   	hud.popup.facebookConnect.y	= display.contentHeight*0.55
   
		utils.onTouch(hud.popup.facebookConnect, function() 
			facebook.connect(function()
				self:shareOnWall()
				analytics.event("Social", "facebookShareAfterConnection") 
			end) 
		end)
		
	end

	-----------------------------------
	-- Twitter
	-----------------------------------

	if(twitter.connected) then
		hud.popup.twitterShare 			= display.newImage( hud.popup, I "popup.BtShareTwitter.png")  
   	hud.popup.twitterShare.x 		= display.contentWidth*0.5
   	hud.popup.twitterShare.y		= display.contentHeight*0.67	
   	
		utils.onTouch(hud.popup.twitterShare, function() 
   		self:tweetShare()
			analytics.event("Social", "twitterShare") 
		end)
		
	else
		hud.popup.twitterConnect 		= display.newImage( hud.popup, I "popup.Bt2ConnectTwitter.png")  
   	hud.popup.twitterConnect.x 	= display.contentWidth*0.5
		hud.popup.twitterConnect.y		= display.contentHeight*0.67

		utils.onTouch(hud.popup.twitterConnect, function() 
			twitter.connect(function()
				analytics.event("Social", "twitterShareAfterConnection") 
				self:tweetShare()
			end) 
		end)

	end

	----------------------------------------------------------------------------------------------------
	
	hud.popup.close 				= display.newImage( hud.popup, "assets/images/hud/CroixClose.png")
	hud.popup.close.x 			= display.contentWidth*0.84
	hud.popup.close.y 			= display.contentHeight*0.2
	
	utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)
	

end

-----------------------------------------------------------------------------------------

function ShareManager:invite()

	----------------------------------------------------------------------------------------------------

	viewManager.showPopup()
	analytics.event("Social", "popupInvite") 
	
	----------------------------------------------------------------------------------------------------
	
	hud.popup.inviteIcon 			= display.newImage( hud.popup, "assets/images/icons/PictoInvite.png")  
	hud.popup.inviteIcon.x 			= display.contentWidth*0.5
	hud.popup.inviteIcon.y			= display.contentHeight*0.22

	hud.popup.inviteText 			= display.newImage( hud.popup, I "popup.Txt2.png")  
	hud.popup.inviteText.x 			= display.contentWidth*0.5
	hud.popup.inviteText.y			= display.contentHeight*0.32
	
	
	hud.popup.earnText = viewManager.newText({
		parent 			= hud.popup,
		text 				= T "Earn points and increase the jackpot", 
		fontSize			= 34,  
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.4,
	})

	----------------------------------------------------------------------------------------------------

	hud.popup.sms 		= display.newImage( hud.popup, I "popup.Btsms.png")  
	hud.popup.sms.x 	= display.contentWidth*0.5
	hud.popup.sms.y	= display.contentHeight*0.51

	utils.onTouch(hud.popup.sms, function() self:sms() end) 
	
	----------------------------------------------------------------------------------------------------

	hud.popup.email 		= display.newImage( hud.popup, I "popup.Btemail.png")  
	hud.popup.email.x 	= display.contentWidth*0.5
	hud.popup.email.y		= display.contentHeight*0.62

	utils.onTouch(hud.popup.email, function() self:email() end) 

	----------------------------------------------------------------------------------------------------

	if(userManager.user.facebookId) then
		hud.popup.facebookShare 		= display.newImage( hud.popup, I "popup.BtShareFacebook.png")  
   	hud.popup.facebookShare.x 		= display.contentWidth*0.5
   	hud.popup.facebookShare.y		= display.contentHeight*0.73
   
		utils.onTouch(hud.popup.facebookShare, function() 
   		router.openInviteFriends()
			analytics.event("Social", "openFacebookFriendList") 
		end)
		
	else
		hud.popup.facebookConnect 		= display.newImage( hud.popup, I "popup.BtConnectFacebook.png")  
   	hud.popup.facebookConnect.x 	= display.contentWidth*0.5
   	hud.popup.facebookConnect.y	= display.contentHeight*0.73
   
		utils.onTouch(hud.popup.facebookConnect, function() 
			facebook.connect(function()
      		router.openInviteFriends()
				analytics.event("Social", "openFacebookFriendListAfterConnection") 
			end) 
		end)
		
	end

	----------------------------------------------------------------------------------------------------
	
	hud.popup.close 				= display.newImage( hud.popup, "assets/images/hud/CroixClose.png")
	hud.popup.close.x 			= display.contentWidth*0.84
	hud.popup.close.y 			= display.contentHeight*0.2
	
	utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)
	
end


-----------------------------------------------------------------------------------------

function ShareManager:noMoreTickets()

	----------------------------------------------------------------------------------------------------

	local title = ""
	local text	= ""

	viewManager.showPopup(title, text)
	
	----------------------------------------------------------------------------------------------------

	viewManager.newText({
		parent 			= hud.popup, 
		text	 			= T "You have reached the maximum number of tickets for this draw.",     
		x 					= display.contentWidth * 0.16,
		y 					= display.contentHeight*0.25,
		width				= display.contentWidth*0.6,
		height			= 120,
		fontSize			= 37,
		referencePoint = display.CenterLeftReferencePoint
	})

	viewManager.newText({
		parent 			= hud.popup, 
		text	 			= T "You can gain Bonus Tickets by liking our Facebook page or following us on Twitter.",     
		x 					= display.contentWidth * 0.16,
		y 					= display.contentHeight*0.36,
		width				= display.contentWidth*0.6,
		height			= 170,
		fontSize			= 37,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	--------------------------
	
	hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
	hud.popup.close.x 			= display.contentWidth*0.5
	hud.popup.close.y 			= display.contentHeight*0.5
	
	utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)
	
	----------------------------------------------------------------------------------------------------

	if(not userManager.user.facebookFan) then
		
		hud.popup.facebookIcon 			= display.newImage( hud.popup, "assets/images/icons/facebook.png")  
		hud.popup.facebookIcon.x 		= display.contentWidth*0.28
		hud.popup.facebookIcon.y		= display.contentHeight*0.65

		viewManager.newText({
			parent 			= hud.popup, 
			text	 			= "+ " .. FACEBOOK_FAN_TICKETS,     
			x 					= display.contentWidth * 0.56,
			y 					= display.contentHeight*0.67,
			width				= display.contentWidth*0.6,
			height			= 120,
			fontSize			= 47,
			font				= NUM_FONT,
			referencePoint = display.CenterLeftReferencePoint
		})

		hud.popup.facebookOnIcon 		= display.newImage( hud.popup, "assets/images/hud/on.png")  
		hud.popup.facebookOnIcon.x 	= display.contentWidth*0.78
   	hud.popup.facebookOnIcon.y		= display.contentHeight*0.65

		hud.popup.facebookOnIcon 		= display.newImage( hud.popup, "assets/images/icons/instant.ticket.png")  
   	hud.popup.facebookOnIcon.x 	= display.contentWidth*0.48
   	hud.popup.facebookOnIcon.y		= display.contentHeight*0.65
	else
	
		hud.popup.facebookConnect 		= display.newImage( hud.popup, I "popup.BtConnectFacebook.png")  
   	hud.popup.facebookConnect.x 	= display.contentWidth*0.5
   	hud.popup.facebookConnect.y	= display.contentHeight*0.65
   
		utils.onTouch(hud.popup.facebookConnect, function() 
			facebook.connect(function()
      		router.openInviteFriends()
			end) 
		end)
		
	end

	----------------------------------------------------------------------------------------------------

	if(not userManager.user.twitterFan) then
		hud.popup.twitterIcon 			= display.newImage( hud.popup, "assets/images/icons/twitter.png")  
		hud.popup.twitterIcon.x 		= display.contentWidth*0.28
		hud.popup.twitterIcon.y		= display.contentHeight*0.77

		viewManager.newText({
			parent 			= hud.popup, 
			text	 			= "+ " .. TWITTER_FAN_TICKETS,     
			x 					= display.contentWidth * 0.56,
			y 					= display.contentHeight*0.79,
			width				= display.contentWidth*0.6,
			height			= 120,
			fontSize			= 47,
			font				= NUM_FONT,
			referencePoint = display.CenterLeftReferencePoint
		})

		hud.popup.twitterOnIcon 		= display.newImage( hud.popup, "assets/images/hud/on.png")  
		hud.popup.twitterOnIcon.x 		= display.contentWidth*0.78
   	hud.popup.twitterOnIcon.y		= display.contentHeight*0.77

		hud.popup.twitterOnIcon 		= display.newImage( hud.popup, "assets/images/icons/instant.ticket.png")  
   	hud.popup.twitterOnIcon.x 		= display.contentWidth*0.48
   	hud.popup.twitterOnIcon.y		= display.contentHeight*0.77

	else
	
		hud.popup.twitterConnect 		= display.newImage( hud.popup, I "popup.Bt2ConnectTwitter.png")  
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

function ShareManager:sms()
	analytics.event("Social", "askSMS") 
	
	local options = {
		body = "_Join me on www.adillions.com !\n Please use my sponsor code when you sign in : " .. userManager.user.sponsorCode
	}

	native.showPopup("sms", options)
end

-----------------------------------------------------------------------------------------

function ShareManager:email()
	analytics.event("Social", "askEmail")
	 
	local options =
	{
		body = "<html><body>_Join me on <a href='http://www.adillions.com'>Adillions</a> !<br/> Please use my sponsor code when you sign in : " .. userManager.user.sponsorCode .. "</body></html>",
		isBodyHtml = true,
		subject = "Adillions",
	}
	
	native.showPopup("mail", options)
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
--   			userManager:checkIdlePoints() fait au retour de updatePlayer non ?
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
--   			userManager:checkIdlePoints() fait au retour de updatePlayer non ?
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