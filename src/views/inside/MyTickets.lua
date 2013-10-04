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
	
--	local board = display.newGroup()

	-- Our ScrollView listener
   local function scrollListener( event )
       local phase = event.phase
       local direction = event.direction
   
       if "began" == phase then
           print( "Began" )
       elseif "moved" == phase then
           print( "Moved" )
       elseif "ended" == phase then
           print( "Ended" )
       end
   
       -- If we have reached one of the scrollViews limits
       if event.limitReached then
           if "up" == direction then
               print( "Reached Top Limit" )
           elseif "down" == direction then
               print( "Reached Bottom Limit" )
           elseif "left" == direction then
               print( "Reached Left Limit" )
           elseif "right" == direction then
               print( "Reached Right Limit" )
           end
       end

		return true
	end

	local board = widget.newScrollView
	{
		top = 0,
		left = 0,
		width = display.contentWidth,
		height = display.contentHeight - HEADER_HEIGHT - MENU_HEIGHT,
		bottomPadding = HEADER_HEIGHT,
		hideBackground = true,
		id = "onBottom",
		listener = scrollListener,
		horizontalScrollDisabled = true,
		verticalScrollDisabled = false,
	}

	------------------

	local marginLeft = display.contentWidth * 0.02
	local marginTop =  30
	local xGap =  display.contentWidth *0.12
	local yGap =  display.contentHeight *0.10
	
	------------------

	for i = 1,#userManager.user.drawTickets do
		local ticket = userManager.user.drawTickets[i]
   	local numbers = json.decode(ticket.numbers)
   	
   	for j = 1,#numbers-1 do
   		print (numbers[j])
			viewManager.drawBall(board, numbers[j], marginLeft + xGap*j, marginTop + yGap*i)
   	end
	end

	------------------

	hud:insert(board)
   
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