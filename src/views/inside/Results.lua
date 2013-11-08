-----------------------------------------------------------------------------------------
--
-- AppHome.lua
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()

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
	native.setActivityIndicator( true )
	viewManager.setupView(3)
	self.view:insert(hud)

	lotteryManager:getFinishedLotteries(function()
   	native.setActivityIndicator( false )
   	self:drawBoard()

   	viewManager.setupView(3)
   	viewManager.darkerBack()
   	self.view:insert(hud)
	end)

end
-----------------------------------------------------------------------------------------

function scene:drawBoard()

	viewManager.initBoard()
	
	------------------

	local marginLeft = display.contentWidth * 0.04
	local marginTop =  HEADER_HEIGHT + 70
	local xGap =  display.contentWidth *0.12
	local yGap =  display.contentHeight *0.7/aspectRatio

	------------------
	
	for i = 1,#lotteryManager.finishedLotteries do

		------------------------------------------------

		local lottery 				= lotteryManager.finishedLotteries[i]
		local numbers 				= json.decode(lottery.result)
		lottery.theme 				= json.decode(lottery.theme)

		local y = marginTop + yGap*(i-1) + 185
	
		------------------------------------------------
	
		viewManager.drawBorder(hud.board, display.contentWidth*0.5, y, display.contentWidth*0.95, 500)
	
		------------------------------------------------

		viewManager.newText({
			parent = hud.board, 
			text = T "Drawing" .. " " .. lotteryManager:date(lottery), 
			x = display.contentWidth*0.1,
			y = marginTop + yGap*(i-1), 
			fontSize = 38,
			referencePoint = display.CenterLeftReferencePoint
		})

		------------------------------------------------
		
   	for j = 1,#numbers-1 do
   		viewManager.drawBall(hud.board, numbers[j], marginLeft + xGap*j, y - 50)
   	end
   	
   	viewManager.drawTheme(hud.board, lottery, numbers[#numbers], marginLeft + xGap*#numbers + 20, y - 50)

		------------------------------------------------

   	hud.iconWinners = display.newImage( hud.board, "assets/images/icons/winners.png")  
   	hud.iconWinners.x = display.contentWidth*0.12
   	hud.iconWinners.y = marginTop + yGap*(i-1)+270,
   	hud.board:insert(hud.iconWinners)

		viewManager.newText({
			parent = hud.board, 
			text = lottery.nbWinners, 
			x = display.contentWidth*0.19,
			y = marginTop + yGap*(i-1)+270, 
			fontSize = 45,
			font = NUM_FONT,
			referencePoint = display.CenterLeftReferencePoint
		})

		viewManager.newText({
			parent = hud.board, 
			text = T "Winners", 
			x = display.contentWidth*0.28,
			y = marginTop + yGap*(i-1)+270, 
			fontSize = 27,
			referencePoint = display.CenterLeftReferencePoint
		})
		
		------------------------------------------------

		local price = lotteryManager:finalPrice(lottery)
		
   	hud.iconMoney = display.newImage( hud.board, "assets/images/icons/money.png")  
   	hud.iconMoney.x = display.contentWidth*0.12
   	hud.iconMoney.y = marginTop + yGap*(i-1)+340,
   	hud.board:insert(hud.iconMoney)

		viewManager.newText({
			parent = hud.board, 
			text = price, 
			x = display.contentWidth*0.19,
			y = marginTop + yGap*(i-1)+340, 
			fontSize = 45,
			font = NUM_FONT,
			referencePoint = display.CenterLeftReferencePoint
		})

		------------------------------------------------

   	hud.separator = display.newImage( hud.board, "assets/images/icons/separateur.big.png")  
   	hud.separator.x = display.contentWidth*0.5
   	hud.separator.y = marginTop + yGap*(i-1)+310,
   	hud.board:insert(hud.separator)

		------------------------------------------------

   	hud.iconCharity = display.newImage( hud.board, "assets/images/icons/charity.png")  
   	hud.iconCharity.x = display.contentWidth*0.64
   	hud.iconCharity.y = marginTop + yGap*(i-1)+305,
   	hud.board:insert(hud.iconCharity)

		viewManager.newText({
			parent 			= hud.board, 
			text 				= T "Charity", 
			x 					= display.contentWidth*0.7,
			y 					= marginTop + yGap*(i-1)+270, 
			fontSize 		= 27,
			referencePoint = display.CenterLeftReferencePoint
		})
		

		viewManager.newText({
			parent			= hud.board, 
			text 				= "US$ " .. lottery.charity , 
			x 					= display.contentWidth*0.7,
			y 					= marginTop + yGap*(i-1)+315, 
			fontSize 		= 45,
			font 				= NUM_FONT,
			referencePoint = display.CenterLeftReferencePoint
		})
	
   	
   end
   
	------------------

	hud:insert(hud.board)
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