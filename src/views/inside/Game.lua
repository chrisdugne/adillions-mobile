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
	
	viewManager.initBack()
	viewManager.drawButton("_back", display.contentWidth*0.3, display.contentHeight *0.04, router.openHome)
	
	------------------
	
	local marginLeft = display.contentWidth * 0.02
	local marginTop =  display.contentHeight * 0.1
	local xGap =  display.contentWidth *0.12
	local yGap =  display.contentHeight *0.08
	
	--------------------------------------------------------------
	-- Classic nums

	local totalNums = 32  
	local nbNumPerLine = 6
	  
	------------------

	local nbLines =  totalNums/nbNumPerLine
	local nbRows =  totalNums/nbLines
	local nbOnlastLine = totalNums - math.floor(nbLines)*nbRows
	
	------------------
	
	for i = 1,nbRows do
   	for j = 1,nbLines do
   		viewManager.drawBall((j-1)*nbRows+i, marginLeft + xGap*i, marginTop + yGap*j)
   	end
	end

	for i = 1,nbOnlastLine do
		viewManager.drawBall(math.floor(nbLines)*nbRows+i, marginLeft + xGap*i, marginTop + yGap*(math.floor(nbLines)+1))
	end
	
	--------------------------------------------------------------
	-- Additional nums
	
	marginTop =  display.contentHeight * 0.7
	
	totalNums 	= 7
	nbNumPerLine = 4
	
	nbLines =  totalNums/nbNumPerLine
	nbRows =  totalNums/nbLines
	nbOnlastLine = totalNums - math.floor(nbLines)*nbRows
	
	------------------
	
	for i = 1,nbRows do
   	for j = 1,nbLines do
   		viewManager.drawThemeSelection((j-1)*nbRows+i, marginLeft + xGap*i, marginTop + yGap*j)
   	end
	end

	for i = 1,nbOnlastLine do
		viewManager.drawThemeSelection(math.floor(nbLines)*nbRows+i, marginLeft + xGap*i, marginTop + yGap*(math.floor(nbLines)+1))
	end
	

	------------------

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