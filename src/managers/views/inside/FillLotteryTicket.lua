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
	hud.selection = display.newGroup()
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()
	
	------------------

	hud.balls = {}
	
	------------------
	
	local marginLeft = display.contentWidth * 0.02
	local top =  HEADER_HEIGHT * 2
	local xGap =  display.contentWidth *0.12
	local yGap =  display.contentHeight *0.07
	
	--------------------------------------------------------------
	-- Actions
	-- 
--	 3 actions random / favorites / restart
--	 
--	viewManager.newText({
--		parent = hud, 
--		text = T "Random",     
--		x = display.contentWidth*0.2,
--		y = top - display.contentHeight*0.07,
--		fontSize = 33,
--	})
--
--	hud.separateur = display.newImage( hud, "assets/images/icons/separateur.png")  
--	hud.separateur.x = display.contentWidth*0.35
--	hud.separateur.y = top - display.contentHeight*0.065
--
--	viewManager.newText({
--		parent = hud, 
--		text = T "Favorites",     
--		x = display.contentWidth*0.5,
--		y = top - display.contentHeight*0.07,
--		fontSize = 33,
--	})
--
--	hud.separateur = display.newImage( hud, "assets/images/icons/separateur.png")  
--	hud.separateur.x = display.contentWidth*0.65
--	hud.separateur.y = top - display.contentHeight*0.065
--
--	viewManager.newText({
--		parent = hud, 
--		text = T "Restart",     
--		x = display.contentWidth*0.8,
--		y = top - display.contentHeight*0.07,
--		fontSize = 33,
--	})
--	
--	
	--------------------------------------------------------------
	-- Actions
	-- 
--	 2 actions random / restart

	local random = viewManager.newText({
		parent = hud, 
		text = T "Random",     
		x = display.contentWidth*0.3,
		y = top - display.contentHeight*0.07,
		fontSize = 33,
	})
	
	utils.onTouch(random, function()
		router.resetScreen()
		self:refreshScene()
		self:randomSelection()
	end)

	hud.separateur = display.newImage( hud, "assets/images/icons/separateur.png")  
	hud.separateur.x = display.contentWidth*0.5
	hud.separateur.y = top - display.contentHeight*0.065

	local restart = viewManager.newText({
		parent = hud, 
		text = T "Clear all",     
		x = display.contentWidth*0.7,
		y = top - display.contentHeight*0.07,
		fontSize = 33,
	})
	
	utils.onTouch(restart, function()
		router.resetScreen()
		self:refreshScene()
	end)
	
	--------------------------------------------------------------
	-- Classic nums

	local totalNums 		 = lotteryManager.nextLottery.maxNumbers  
	local nbNumPerLine	 = 7
	  
	------------------

	local nbLines =  totalNums/nbNumPerLine
	local nbRows =  totalNums/nbLines
	local nbOnlastLine = totalNums - math.floor(nbLines)*nbRows
	
	------------------
	
	for i = 1,nbRows do
   	for j = 1,nbLines do
   		local ballNum = (j-1)*nbRows+i
			viewManager.drawBallToPick(ballNum, marginLeft + xGap*i, top + yGap*(j-1))
		end
	end

	for i = 1,nbOnlastLine do
		local ballNum = math.floor(nbLines)*nbRows+i
		viewManager.drawBallToPick(ballNum, marginLeft + xGap*i, top + yGap*math.floor(nbLines))
	end

	------------------

	hud.selector = display.newImage( hud, "assets/images/hud/selector.green.png")  
	hud.selector.x = display.contentWidth*0.5
	hud.selector.y = top + display.contentHeight*0.55

	------------------

	lotteryManager:startSelection()

	------------------

	viewManager.setupView(0)
	self.view:insert(hud)
end

------------------------------------------

function scene:getNum()

	local num 				= math.random(1,49)
	local alreadyChosen 	= false

	for n = 1,#lotteryManager.currentSelection do
		if(num == lotteryManager.currentSelection[n]) then
			alreadyChosen = true
		end
	end

	if not alreadyChosen then
		return num
	else  
		return self:getNum()
	end
end

------------------------------------------

function scene:randomSelection()
	for i=1,5 do
		lotteryManager:addToSelection (self:getNum())
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