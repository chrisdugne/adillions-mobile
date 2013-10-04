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
	local marginTop =  display.contentHeight * 0.05
	local xGap =  display.contentWidth *0.12
	local yGap =  display.contentHeight *0.08
	
	--------------------------------------------------------------
	-- Classic nums

	local totalNums 		 = drawManager.nextDraw.maxNumbers  
	local nbNumPerLine	 = 7
	  
	------------------

	local nbLines =  totalNums/nbNumPerLine
	local nbRows =  totalNums/nbLines
	local nbOnlastLine = totalNums - math.floor(nbLines)*nbRows
	
	------------------
	
	for i = 1,nbRows do
   	for j = 1,nbLines do
   		viewManager.drawBallToPick((j-1)*nbRows+i, marginLeft + xGap*i, marginTop + yGap*j)
   	end
	end

	for i = 1,nbOnlastLine do
		viewManager.drawBallToPick(math.floor(nbLines)*nbRows+i, marginLeft + xGap*i, marginTop + yGap*(math.floor(nbLines)+1))
	end
	
	------------------
	
	drawManager:startSelection()
	
	------------------

	viewManager.setupView(0)
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