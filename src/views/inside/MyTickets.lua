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
	
   	------------------
   
   	local currentLottery = nil
   	self.lotteries 		= {}

   	------------------
   	-- compte le nombre de tickets pour calculer la hauteur de drawBorder
   	
   	for i = 1,#userManager.user.lotteryTickets do
   		
   		local ticket = userManager.user.lotteryTickets[i]
   		
   		if(currentLottery ~= ticket.lottery.uid) then
   			currentLottery = ticket.lottery.uid
   			self.lotteries[ticket.lottery.uid] = {}
   			self.lotteries[ticket.lottery.uid].nbTickets = 1
   		else
   			self.lotteries[ticket.lottery.uid].nbTickets = self.lotteries[ticket.lottery.uid].nbTickets + 1 
      	end
   	end
   	
   	------------------

		local nextLotteryHeight = self:drawNextLottery()
		self:drawPreviousLotteries(nextLotteryHeight)

   	------------------
   
   	hud:insert(hud.board)
   
   end
   
	------------------
	
	viewManager.setupView(2)
	viewManager.darkerBack()
	self.view:insert(hud)
	
end

-----------------------------------------------------------------------------------------

function scene:drawNextLottery()

	local marginLeft 		= display.contentWidth * 0.02
	local xGap 				= display.contentWidth *0.1
	local yGap 				= display.contentHeight *0.08
	local top 				= HEADER_HEIGHT + 80

	local nbNewTickets	= 0
	local currentLottery	= nil
	local borderHeight 	= 0
	
	for i = 1,#userManager.user.lotteryTickets do

		local ticket = userManager.user.lotteryTickets[i]
		
		if(ticket.lottery.uid == lotteryManager.nextLottery.uid) then
		
      	local numbers 	= json.decode(ticket.numbers)
			nbNewTickets 	= nbNewTickets + 1

   		if(type(ticket.lottery.theme) == "string") then ticket.lottery.theme	= json.decode(ticket.lottery.theme) end
   
   		if(currentLottery ~= ticket.lottery.uid) then
   			
   			-----
   			-- juste pour le premier ticket du coup.
   			
   			currentLottery 		= ticket.lottery.uid
   			local nbLotteries 	= 1
   			local nbTickets 		= self.lotteries[currentLottery].nbTickets
   			borderHeight			= yGap + yGap*nbTickets + 20
   			
				viewManager.drawBorder(
					hud.board, 
					display.contentWidth*0.5,													-- x 
					top + (yGap)*(nbNewTickets+nbLotteries-2) + borderHeight/2 - 55, 	-- y
					display.contentWidth*0.95, 												-- width
					borderHeight,																	-- height
					240,240,240
				)
   	
   			viewManager.newText({
   				parent = hud.board, 
   				text = T "Drawing" .. " " .. lotteryManager:date(ticket.lottery), 
         		x = display.contentWidth*0.4,
         		y = top + yGap*(nbNewTickets+nbLotteries-2), 
         		fontSize = 35
   			})
         
   		end
      	
      	viewManager.drawTicket(hud.board, ticket.lottery, numbers, marginLeft, top + 50 + yGap*(nbNewTickets-0.5))
   	
   	end
	end
   
   	
	return top + borderHeight + 20
	
end

-----------------------------------------------------------------------------------------

function scene:drawPreviousLotteries(top)

   	local marginLeft = display.contentWidth * 0.02
   	local xGap =  display.contentWidth *0.1
   	local yGap =  display.contentHeight *0.17
   	
   	------------------
   
   	local currentLottery 		= nil
   	local nbLotteries 			= 0
		local nbPreviousTickets		= 0
		
   	for i = 1,#userManager.user.lotteryTickets do

   		local ticket = userManager.user.lotteryTickets[i]
   		
   		if(ticket.lottery.uid ~= lotteryManager.nextLottery.uid) then
   		
         	-----------------------------------------------------------

         	local numbers 	= json.decode(ticket.numbers)
   			nbPreviousTickets = nbPreviousTickets + 1

      		if(type(ticket.lottery.theme) == "string") then ticket.lottery.theme	= json.decode(ticket.lottery.theme) end

         	-----------------------------------------------------------
      
      		if(currentLottery ~= ticket.lottery.uid) then
      			
      			currentLottery 		= ticket.lottery.uid
      			nbLotteries 			= nbLotteries + 1
      			local nbTickets 		= self.lotteries[currentLottery].nbTickets
      			local borderHeight	= yGap + yGap*nbTickets - 80
      			
   				viewManager.drawBorder(
   					hud.board, 
   					display.contentWidth*0.5,													-- x 
   					top + (yGap)*(nbPreviousTickets+nbLotteries-2) + borderHeight/2 - 55, 	-- y
   					display.contentWidth*0.95, 												-- width
   					borderHeight																	-- height
   				)
      	
      			viewManager.newText({
      				parent = hud.board, 
      				text = T "Drawing" .. " " .. lotteryManager:date(ticket.lottery), 
            		x = display.contentWidth*0.4,
            		y = top + yGap*(nbPreviousTickets+nbLotteries-2), 
            		fontSize = 35
      			})
            
            else
            
            	local separator = display.newImage(hud.board, "assets/images/icons/separateur.horizontal.png")
            	separator.x = display.contentWidth*0.5
            	separator.y = top + yGap*(nbPreviousTickets+nbLotteries-1.82)
            	hud.board:insert(separator)
      		end
         
         	-----------------------------------------------------------
         		
         	viewManager.drawTicket(hud.board, ticket.lottery, numbers, marginLeft, top + yGap*(nbPreviousTickets+nbLotteries-1.5))

         	-----------------------------------------------------------
      	
   			viewManager.newText({
   				parent = hud.board, 
   				text = T "Gain" .. " :", 
         		x = display.contentWidth*0.1,
         		y = top + yGap*(nbPreviousTickets+nbLotteries-1.1), 
         		fontSize = 29,
					referencePoint = display.CenterLeftReferencePoint
   			})
   		
   			viewManager.newText({
   				parent = hud.board, 
   				text =  "$ " .. (ticket.price or 0), 
         		x = display.contentWidth*0.87,
         		y = top + yGap*(nbPreviousTickets+nbLotteries-1.1), 
         		fontSize = 32,
         		font = NUM_FONT,
					referencePoint = display.CenterRightReferencePoint
   			})
   		
         	local iconMoney 	= display.newImage( hud.board, "assets/images/icons/money.png")
         	iconMoney.x 		= display.contentWidth*0.92
         	iconMoney.y	 		= top + yGap*(nbPreviousTickets+nbLotteries-1.12)
         	hud.board:insert(iconMoney)
   			
      	end
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