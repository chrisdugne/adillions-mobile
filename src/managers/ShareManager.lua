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
	
   local multiLineText = display.newMultiLineText  
     {
           text = T "Earn points and get Instant Tickets",
           width = display.contentWidth*0.85,  
           left = display.contentWidth*0.5,
           font = FONT, 
           fontSize = 38,
           align = "center"
     }
	
	multiLineText:setReferencePoint(display.TopCenterReferencePoint)
	multiLineText.x = display.contentWidth*0.5
	multiLineText.y = display.contentHeight*0.42
	hud.popup:insert(multiLineText)         
	

	-----------------------------------
	-- Facebook
	-----------------------------------


	if(userManager.user.facebookId) then
		hud.popup.facebookShare 		= display.newImage( hud.popup, I "popup.facebook.share.png")  
   	hud.popup.facebookShare.x 		= display.contentWidth*0.5
   	hud.popup.facebookShare.y		= display.contentHeight*0.63
   
		utils.onTouch(hud.popup.facebookShare, function() 
			self:shareOnWall()
			analytics.event("Social", "facebookShare") 
		end)
		
	else
		hud.popup.facebookConnect 		= display.newImage( hud.popup, I "popup.facebook.connect.png")  
   	hud.popup.facebookConnect.x 	= display.contentWidth*0.5
   	hud.popup.facebookConnect.y	= display.contentHeight*0.63
   
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
		hud.popup.twitterShare 			= display.newImage( hud.popup, I "popup.twitter.share.png")  
   	hud.popup.twitterShare.x 		= display.contentWidth*0.5
   	hud.popup.twitterShare.y		= display.contentHeight*0.77	
   	
		utils.onTouch(hud.popup.twitterShare, function() 
   		self:tweetShare()
			analytics.event("Social", "twitterShare") 
		end)
		
	else
		hud.popup.twitterConnect 		= display.newImage( hud.popup, I "popup.twitter.connect.png")  
   	hud.popup.twitterConnect.x 	= display.contentWidth*0.5
		hud.popup.twitterConnect.y		= display.contentHeight*0.77

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
	hud.popup.close.y 			= display.contentHeight*0.12
	
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
	hud.popup.sms.y	= display.contentHeight*0.52

	utils.onTouch(hud.popup.sms, function() self:sms() end) 
	
	----------------------------------------------------------------------------------------------------

	hud.popup.email 		= display.newImage( hud.popup, I "popup.Btemail.png")  
	hud.popup.email.x 	= display.contentWidth*0.5
	hud.popup.email.y		= display.contentHeight*0.66

	utils.onTouch(hud.popup.email, function() self:email() end) 

	----------------------------------------------------------------------------------------------------

	if(userManager.user.facebookId) then
		hud.popup.facebookShare 		= display.newImage( hud.popup, I "popup.facebook.invite.png")  
   	hud.popup.facebookShare.x 		= display.contentWidth*0.5
   	hud.popup.facebookShare.y		= display.contentHeight*0.8
   
		utils.onTouch(hud.popup.facebookShare, function() 
   		router.openInviteFriends()
			analytics.event("Social", "openFacebookFriendList") 
		end)
		
	else
		hud.popup.facebookConnect 		= display.newImage( hud.popup, I "popup.facebook.connect.png")  
   	hud.popup.facebookConnect.x 	= display.contentWidth*0.5
   	hud.popup.facebookConnect.y	= display.contentHeight*0.8
   
		utils.onTouch(hud.popup.facebookConnect, function() 
			facebook.connect(function()
      		router.openInviteFriends()
				analytics.event("Social", "openFacebookFriendListAfterConnection") 
			end) 
		end)
		
	end

	----------------------------------------------------------------------------------------------------
	
	hud.popup.close 				= display.newImage( hud.popup, "assets/images/hud/CroixClose.png")
	hud.popup.close.x 			= display.contentWidth*0.88
	hud.popup.close.y 			= display.contentHeight*0.12
	
	utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)
	
end


-----------------------------------------------------------------------------------------

function ShareManager:noMoreTickets()

	----------------------------------------------------------------------------------------------------

	local title = ""
	local text	= ""

	viewManager.showPopup(title, text)
	
	----------------------------------------------------------------------------------------------------
	
	hud.popup.icon 			= display.newImage( hud.popup, "assets/images/icons/PictomaxTicket.png")
	hud.popup.icon.x 			= display.contentWidth*0.5
	hud.popup.icon.y 			= display.contentHeight*0.2

	hud.popup.icon 			= display.newImage( hud.popup, I "Sorry.png")
	hud.popup.icon.x 			= display.contentWidth*0.5
	hud.popup.icon.y 			= display.contentHeight*0.3
	
	----------------------------------------------------------------------------------------------------

	viewManager.newText({
		parent 			= hud.popup, 
		text	 			= T "You have reached the maximum",     
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.4,
		fontSize			= 37,
	})

	viewManager.newText({
		parent 			= hud.popup, 
		text	 			= T "number of tickets for this draw.",     
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.44,
		fontSize			= 37,
	})

	viewManager.newText({
		parent 			= hud.popup, 
		text	 			= T "You can gain Bonus Tickets by liking our",     
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.5,
		fontSize			= 37,
	})

	viewManager.newText({
		parent 			= hud.popup, 
		text	 			= T "Facebook page, following us on",     
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.54,
		fontSize			= 37,
	})
	
	viewManager.newText({
		parent 			= hud.popup, 
		text	 			= T "Twitter, etc.",     
		x 					= display.contentWidth * 0.5,
		y 					= display.contentHeight*0.58,
		fontSize			= 37,
	})
	
	--------------------------
	
	hud.popup.upgrade 			= display.newImage( hud.popup, I "UpgradeProfil.png")
	hud.popup.upgrade.x 			= display.contentWidth*0.5
	hud.popup.upgrade.y 			= display.contentHeight*0.7
	
	utils.onTouch(hud.popup.upgrade, function() 
		viewManager.closePopup() 
		router.openProfile()
	end)
	
	--------------------------
	
	hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
	hud.popup.close.x 			= display.contentWidth*0.5
	hud.popup.close.y 			= display.contentHeight*0.83
	
	utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)
	
	----------------------------------------------------------------------------------------------------
--
--	if(not userManager.user.facebookFan) then
--		
--		hud.popup.facebookIcon 			= display.newImage( hud.popup, "assets/images/icons/facebook.png")  
--		hud.popup.facebookIcon.x 		= display.contentWidth*0.28
--		hud.popup.facebookIcon.y		= display.contentHeight*0.65
--
--		viewManager.newText({
--			parent 			= hud.popup, 
--			text	 			= "+ " .. FACEBOOK_FAN_TICKETS,     
--			x 					= display.contentWidth * 0.56,
--			y 					= display.contentHeight*0.67,
--			width				= display.contentWidth*0.6,
--			height			= 120,
--			fontSize			= 47,
--			font				= NUM_FONT,
--			referencePoint = display.CenterLeftReferencePoint
--		})
--
--		hud.popup.facebookOnIcon 		= display.newImage( hud.popup, "assets/images/hud/on.png")  
--		hud.popup.facebookOnIcon.x 	= display.contentWidth*0.78
--   	hud.popup.facebookOnIcon.y		= display.contentHeight*0.65
--
--		hud.popup.facebookOnIcon 		= display.newImage( hud.popup, "assets/images/icons/instant.ticket.png")  
--   	hud.popup.facebookOnIcon.x 	= display.contentWidth*0.48
--   	hud.popup.facebookOnIcon.y		= display.contentHeight*0.65
--	else
--	
--		hud.popup.facebookConnect 		= display.newImage( hud.popup, I "popup.BtConnectFacebook.png")  
--   	hud.popup.facebookConnect.x 	= display.contentWidth*0.5
--   	hud.popup.facebookConnect.y	= display.contentHeight*0.65
--   
--		utils.onTouch(hud.popup.facebookConnect, function() 
--			facebook.connect(function()
--      		router.openInviteFriends()
--			end) 
--		end)
--		
--	end
--
--	----------------------------------------------------------------------------------------------------
--
--	if(not userManager.user.twitterFan) then
--		hud.popup.twitterIcon 			= display.newImage( hud.popup, "assets/images/icons/twitter.png")  
--		hud.popup.twitterIcon.x 		= display.contentWidth*0.28
--		hud.popup.twitterIcon.y		= display.contentHeight*0.77
--
--		viewManager.newText({
--			parent 			= hud.popup, 
--			text	 			= "+ " .. TWITTER_FAN_TICKETS,     
--			x 					= display.contentWidth * 0.56,
--			y 					= display.contentHeight*0.79,
--			width				= display.contentWidth*0.6,
--			height			= 120,
--			fontSize			= 47,
--			font				= NUM_FONT,
--			referencePoint = display.CenterLeftReferencePoint
--		})
--
--		hud.popup.twitterOnIcon 		= display.newImage( hud.popup, "assets/images/hud/on.png")  
--		hud.popup.twitterOnIcon.x 		= display.contentWidth*0.78
--   	hud.popup.twitterOnIcon.y		= display.contentHeight*0.77
--
--		hud.popup.twitterOnIcon 		= display.newImage( hud.popup, "assets/images/icons/instant.ticket.png")  
--   	hud.popup.twitterOnIcon.x 		= display.contentWidth*0.48
--   	hud.popup.twitterOnIcon.y		= display.contentHeight*0.77
--
--	else
--	
--		hud.popup.twitterConnect 		= display.newImage( hud.popup, I "popup.Bt2ConnectTwitter.png")  
--   	hud.popup.twitterConnect.x 	= display.contentWidth*0.5
--   	hud.popup.twitterConnect.y		= display.contentHeight*0.77
--   
--		utils.onTouch(hud.popup.twitterConnect, function() 
--			twitter.connect(function()
--      		self:tweetInvite()
--			end) 
--		end)
--	end
		
end

-----------------------------------------------------------------------------------------

function ShareManager:sms()
	analytics.event("Social", "askSMS") 

	local body = T "Join me on Adillions and get a chance to win the jackpot !" 
	body = body .. "\n\n" 
	body = body .. T "Free, fun and easy - Sign up now using my sponsorship code : " 
	body = body .. userManager.user.sponsorCode
	body = body .. "\n\n" 
	body = body .. T "More players = a bigger jackpot !"
	body = body .. "\n\n" 
	body = body .. T "Dowload the free app on the App Store or Google Play / Play on Facebook and on www.adillions.com"
	body = body .. "\n\n" 
	body = body .. T "Adillions in a few words: A global, responsible and viral lottery funded by advertising" 
	
	local options = {
		body = body
	}

	native.showPopup("sms", options)
end

-----------------------------------------------------------------------------------------

function ShareManager:email()
	analytics.event("Social", "askEmail")

	local body = "<html><body>" 
	body = body .. T "Join me on Adillions and get a chance to win the jackpot !"
	body = body .. "<br/><br/>" 
	body = body .. T "Free, fun and easy - Sign up now using my sponsorship code : " 
	body = body .. userManager.user.sponsorCode
	body = body .. "<br/><br/>" 
	body = body .. T "More players = a bigger jackpot !"
	body = body .. "<br/><br/>" 
	body = body .. T "Dowload the free app on the App Store or Google Play / Play on Facebook and on www.adillions.com"
	body = body .. "<br/><br/>" 
	body = body .. T "Adillions in a few words: A global, responsible and viral lottery funded by advertising" 
	body = body .. "</body></html>" 
	 
	local options =
	{
		body = body,
		isBodyHtml = true,
		subject = "Adillions",
	}
	
	native.showPopup("mail", options)
end

-----------------------------------------------------------------------------------------

function ShareManager:shareOnWall()
	
	local text = T "I have just played a free lottery ticket on Adillions. You too, get a chance to win the jackpot !" 
	text = text .. "\n\n" 
	text = text .. T "Dowload the free app on the App Store or Google Play or play on Facebook and on www.adillions.com" 
	text = text .. "\n\n" 
	text = text .. T "Adillions in a few words: A global, responsible and viral lottery funded by advertising"
	
	facebook.postOnWall(text, function()
	
		print("---> postOnWall next")
		viewManager.closePopup()
		viewManager.message(T "Thank you" .. " !  " .. T "Successfully posted on your wall !")
		if(not userManager.user.hasPostOnFacebook) then
			viewManager.showPoints(NB_POINTS_PER_POST)
			userManager.user.currentPoints = userManager.user.currentPoints + NB_POINTS_PER_POST
			userManager.user.hasPostOnFacebook = true
			userManager:updatePlayer()
		end 
	end)
end

-----------------------------------------------------------------------------------------

function ShareManager:tweetShare()

	local text = T "I have just played a free lottery ticket on Adillions. You too, get a chance to win the jackpot !" .. "\n www.adillions.com"

	twitter.tweetMessage(text, function()

		viewManager.closePopup()
		viewManager.message(T "Thank you" .. " !  " .. T "Successfully tweeted")
		if(not userManager.user.hasTweet) then
			viewManager.showPoints(NB_POINTS_PER_TWEET)
			userManager.user.currentPoints = userManager.user.currentPoints + NB_POINTS_PER_TWEET
			userManager.user.hasTweet = true
			userManager:updatePlayer()
		end 
	end)
end

-----------------------------------------------------------------------------------------

return ShareManager