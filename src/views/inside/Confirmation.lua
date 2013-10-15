-----------------------------------------------------------------------------------------
--
-- AppHome.lua
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()
local widget = require "widget"

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()

	viewManager.initBoard()

	-------------------------------
	-- REJOUER
	------------------

	viewManager.drawTicket(hud.board, lotteryManager.currentSelection, display.contentWidth*0.14, display.contentHeight*0.25)
	hud:insert(hud.board)

	-------------------------------

	local nbTickets = (userManager.user.availableTickets + userManager.user.totalBonusTickets - userManager.user.playedBonusTickets) .. "    _tickets to play"

	viewManager.newText({
		parent = hud, 
		text = nbTickets, 
		x = display.contentWidth*0.5,
		y = display.contentHeight*0.35,
		fontSize = 33
	})

	-------------------------------

	viewManager.drawButton(hud, "_Jouer !", display.contentWidth*0.5, display.contentHeight*0.5, router.openFillLotteryTicket)

	-------------------------------

	hud.sharePanel = display.newImageRect( hud, "assets/images/menus/panel.simple.png", display.contentWidth, display.contentHeight*0.4)  
	hud.sharePanel.x = display.contentWidth*0.5
	hud.sharePanel.y = display.contentHeight*0.8

	viewManager.newText({
		parent = hud, 
		text = "_Share with friends to get VIP points and more tickets !", 
		x = display.contentWidth*0.5,
		y = display.contentHeight*0.7,
		fontSize = 29
	})

	viewManager.drawButton(hud, "_Share", display.contentWidth*0.5, display.contentHeight*0.8, function() self:openShareMenu() end)

	-------------------------------
	-- PARTAGER
	------------------


	-------------------------------
	-- Setup
	------------------

	viewManager.setupView(0)

	------------------

	viewManager.showPoints(NB_POINTS_PER_TICKET)

	------------------

	self.view:insert(hud)

end

------------------------------------------

function scene:openShareMenu()

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

------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	self:refreshScene()
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene