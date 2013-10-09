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
	lotteryManager:getFinishedLotteries()
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()
	utils.emptyGroup(hud)
	native.setActivityIndicator( true )
	
	if(lotteryManager.finishedLotteries) then
   	native.setActivityIndicator( false )
   	self:drawBoard()
   else
   	print("waiting for lotteries")
   	timer.performWithDelay(1000, function() self:refreshScene() end)
	end

	viewManager.setupView(3)
	self.view:insert(hud)
end
-----------------------------------------------------------------------------------------

function scene:drawBoard()

	viewManager.initBoard()
	
	------------------

	local marginLeft = display.contentWidth * 0.02
	local marginTop =  HEADER_HEIGHT + 70
	local xGap =  display.contentWidth *0.12
	local yGap =  display.contentHeight *0.4/aspectRatio

	------------------
	
	for i = 1,#lotteryManager.finishedLotteries do
		local lottery 	= lotteryManager.finishedLotteries[i]
		local numbers 	= json.decode(lottery.result)
		local theme 	= json.decode(lottery.theme)

		local price = lotteryManager:price(lottery)

		viewManager.newText({
			parent = hud.board, 
			text = lotteryManager:date(lottery), 
			x = display.contentWidth*0.5,
			y = marginTop + yGap*(i-1), 
		})

		viewManager.newText({
			parent = hud.board, 
			text = price, 
			x = display.contentWidth*0.75,
			y = marginTop + yGap*(i-1)+80, 
		})

		viewManager.newText({
			parent = hud.board, 
			text = lottery.nbWinners .. " _winners", 
			x = display.contentWidth*0.25,
			y = marginTop + yGap*(i-1)+80, 
		})

		for j = 1,#numbers-1 do
			viewManager.drawBall(hud.board, numbers[j], marginLeft + xGap*j, marginTop + yGap*(i-1) + 200)
		end
   	
   	viewManager.drawTheme(hud.board, numbers[6], marginLeft + xGap*6, marginTop + yGap*(i-1) + 200)
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