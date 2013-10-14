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
	
	------------------
	
	if(userManager.user.lotteryTickets) then

   	local marginLeft = display.contentWidth * 0.02
   	local marginTop =  HEADER_HEIGHT - 20
   	local xGap =  display.contentWidth *0.1
   	local yGap =  display.contentHeight *0.10
   	
   	------------------
   
   	local currentLottery = nil
   	local nbLotteries 	= 0
   	
   	for i = 1,#userManager.user.lotteryTickets do
   		
   		local ticket = userManager.user.lotteryTickets[i]
      	local numbers = json.decode(ticket.numbers)
   
   		if(currentLottery ~= ticket.lottery.uid) then
   			currentLottery = ticket.lottery.uid
   			nbLotteries = nbLotteries + 1
   			
   			viewManager.newText({
   				parent = hud.board, 
   				text = lotteryManager:date(ticket.lottery), 
         		x = display.contentWidth*0.5,
         		y = marginTop + yGap*(i+nbLotteries-1), 
   			})
         
   		end
      	
      	viewManager.drawTicket(hud.board, numbers, marginLeft, marginTop + yGap*(i+nbLotteries))
   	end
   
   	------------------
   
   	hud:insert(hud.board)
   
   end
   
	------------------
	
	viewManager.setupView(2)
	self.view:insert(hud)
	
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