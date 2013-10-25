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
			body = "_I've just played a ticket on Adillions !\n Join me and please use my referrer code when you sign in : " .. userManager.user.uid
		}
		native.showPopup("sms", options)
	end)

	-----------------------------------
	-- Email
	-----------------------------------

	viewManager.drawButton(hud.popup, "Email", display.contentWidth*0.5, display.contentHeight*0.5, function()
		local options =
		{
			body = "<html><body>I've just played a ticket on Adillions !\n _Join me on <a href='http://www.adillions.com'>Adillions</a> !<br/> Please use my referrer code when you sign in : " .. userManager.user.uid .. "</body></html>",
			isBodyHtml = true,
			subject = "Adillions",
		}
		native.showPopup("mail", options)
	end)

	-----------------------------------
	-- Facebook
	-----------------------------------

	if(userManager.user.facebookId) then
		viewManager.drawButton(hud.popup, "Facebook", display.contentWidth*0.5, display.contentHeight*0.6, function()
			facebook.postOnWall("_I've just played a ticket on Adillions !\n Next Lottery : ".. lotteryManager:date(lotteryManager.nextLottery) .." \n_Join me there and please use my referrer code when you sign in : " .. userManager.user.uid, function()
				viewManager.showPopup("_Thank you !", "_Successfully posted on your wall")
			end)
		end)
	else
		viewManager.drawButton(hud.popup, "_Connect with Facebook", display.contentWidth*0.5, display.contentHeight*0.6, function()
		end,
		display.contentWidth*0.6)
	end

	-----------------------------------
	-- Twitter
	-----------------------------------

	if(userManager.user.twitterId) then
		viewManager.drawButton(hud.popup, "Twitter", display.contentWidth*0.5, display.contentHeight*0.7, function()
		end)
	else
		viewManager.drawButton(hud.popup, "_Connect with Twitter", display.contentWidth*0.5, display.contentHeight*0.7, function()
		end,
		display.contentWidth*0.6)
	end


end

-----------------------------------------------------------------------------------------


function ShareManager:invite()

	local title = "_Be an Adillions' Ambassador !"
	local text	= "_Earn free additional tickets by referring people to Adillions"
	viewManager.showPopup(title, text)

	viewManager.drawButton(hud.popup, "SMS", display.contentWidth*0.5, display.contentHeight*0.4, function()
		local options =
		{
			body = "_Join me on www.adillions.com !\n Please use my referrer code when you sign in : " .. userManager.user.uid
		}
		native.showPopup("sms", options)
	end)

	viewManager.drawButton(hud.popup, "email", display.contentWidth*0.5, display.contentHeight*0.5, function()
		local options =
		{
			body = "<html><body>_Join me on <a href='http://www.adillions.com'>Adillions</a> !<br/> Please use my referrer code when you sign in : " .. userManager.user.uid .. "</body></html>",
			isBodyHtml = true,
			subject = "Adillions",
		}
		native.showPopup("mail", options)
	end)

	if(userManager.user.facebookId) then
		viewManager.drawButton(hud.popup, "Facebook", display.contentWidth*0.5, display.contentHeight*0.6, function()
   		router.openInviteFriends()
		end)
	else
		viewManager.drawButton(hud.popup, "_Connect with Facebook", display.contentWidth*0.5, display.contentHeight*0.6, function()
			facebook.connect(function()
				router.resetScreen()
				self:refreshScene()
			end) 
		end,
		display.contentWidth*0.6)
	end



	if(userManager.user.twitterId) then
		viewManager.drawButton(hud.popup, "Twitter", display.contentWidth*0.5, display.contentHeight*0.7, function()
			twitter.tweetMessage("_Join me on www.adillions.com !\n Please use my referrer code when you sign in : " .. userManager.user.uid, function()
				viewManager.showPopup("_Thank you !", "_Successfully tweeted")
			end)
		end)
	else
		viewManager.drawButton(hud.popup, "_Connect with Twitter", display.contentWidth*0.5, display.contentHeight*0.7, function()
			twitter.connect(function()
				print("refresh profile")
				router.resetScreen()
				self:refreshScene()
			end)
		end,
		display.contentWidth*0.6)
	end

end

-----------------------------------------------------------------------------------------

return ShareManager