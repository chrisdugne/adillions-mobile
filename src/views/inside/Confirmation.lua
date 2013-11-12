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

	-------------------------------

	viewManager.newText({
		parent = hud, 
		text = T ("Your selection !"), 
		x = display.contentWidth*0.05,
		y = display.contentHeight*0.12,
		fontSize = 43,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	viewManager.newText({
		parent = hud, 
		text = T("Drawing") .. " " .. lotteryManager:date(lotteryManager.nextLottery), 
		x = display.contentWidth*0.05,
		y = display.contentHeight*0.15,
		fontSize = 23,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	-------------------------------

	viewManager.drawSelection(hud, lotteryManager.currentSelection)

	-------------------------------

	hud.separateur = display.newImage( hud, "assets/images/icons/separateur.horizontal.png")  
	hud.separateur.x = display.contentWidth*0.5
	hud.separateur.y = display.contentHeight*0.3
	
	-------------------------------

	local nbTickets = (userManager.user.availableTickets + userManager.user.totalBonusTickets - userManager.user.playedBonusTickets)

	-- juste au moment ou le player gagne son 8e point
	-- avant le record -> refresh du nbTickets ici a la mano
	if(userManager.user.currentPoints == POINTS_TO_EARN_A_TICKET) then
		nbTickets = nbTickets + 1
	end

	hud.pictoTicket = display.newImage( hud, "assets/images/icons/ticket.png")  
	hud.pictoTicket.x = display.contentWidth*0.5
	hud.pictoTicket.y = display.contentHeight*0.35
	
	viewManager.newText({
		parent = hud, 
		text = T "Tickets to play" .. " :", 
		x = display.contentWidth*0.5,
		y = display.contentHeight*0.38,
		fontSize = 24,
	})
	
	viewManager.newText({
		parent = hud, 
		text = nbTickets, 
		x = display.contentWidth*0.5,
		y = display.contentHeight*0.41,
		fontSize = 43,
		font = NUM_FONT
	})

	-------------------------------

	hud.playButton = display.newImage( hud, I "filloutnewticket.button.png")  
	hud.playButton.x = display.contentWidth*0.5
	hud.playButton.y = display.contentHeight*0.5
	
	if(nbTickets > 0) then
   	utils.onTouch(hud.playButton, function()
   		self:play()
   	end)
   else
   	shareManager:noMoreTickets()

   	utils.onTouch(hud.playButton, function()
	   	shareManager:noMoreTickets()
   	end)
   end
	
	-------------------------------

	hud.separateur2 = display.newImage( hud, "assets/images/icons/separateur.horizontal.png")  
	hud.separateur2.x = display.contentWidth*0.5
	hud.separateur2.y = display.contentHeight*0.6
	
	hud.more = display.newImage( hud, I "more.png")  
	hud.more.x = display.contentWidth*0.5
	hud.more.y = display.contentHeight*0.65

	-------------------------------

	hud.inviteButton = display.newImage( hud, I "invite.button.png")  
	hud.inviteButton.x = display.contentWidth*0.3
	hud.inviteButton.y = display.contentHeight*0.78

	hud.shareButton = display.newImage( hud, I "share.button.png")  
	hud.shareButton.x = display.contentWidth*0.7
	hud.shareButton.y = display.contentHeight*0.78
	
	utils.onTouch(hud.inviteButton, function()
		shareManager:invite()
	end)

	utils.onTouch(hud.shareButton, function()
		shareManager:share()
	end)

	-------------------------------
	-- Setup
	------------------

	viewManager.setupView(0)

	------------------
	
	if(not lotteryManager.wasExtraTicket) then
		viewManager.showPoints(NB_POINTS_PER_TICKET)
	end
	
	lotteryManager.wasExtraTicket = false

	------------------

	self.view:insert(hud)

end

------------------------------------------

function scene:play()
	videoManager:play(router.openFillLotteryTicket, true)
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