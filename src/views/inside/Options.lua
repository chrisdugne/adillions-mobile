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
--   unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()

 ------------------

 local optionsTop  = 1

 self.top    = HEADER_HEIGHT + 70
 self.yGap    = 120
 self.fontSizeLeft  = 27
 self.fontSizeRight  = 29

 self.column1 = display.contentWidth*0.1
 self.column2 = display.contentWidth*0.9 

 ------------------

 viewManager.initBoard()

 ---------------------------------------------------------------------------------
 -- Options
 ---------------------------------------------------------------

 local function beforeDrawSwitchListener( event )
  GLOBALS.options.notificationBeforeDraw = event.target.isOn
  utils.saveTable(GLOBALS.options, "options.json")
  
    lotteryManager:refreshNotifications(lotteryManager.nextLottery.date)
 end
 
 local function afterDrawSwitchListener( event )
  GLOBALS.options.notificationAfterDraw = event.target.isOn
  utils.saveTable(GLOBALS.options, "options.json")
 
    lotteryManager:refreshNotifications(lotteryManager.nextLottery.date) 
 end

 ---------------------------------------------------------------
 
 viewManager.newText({
  parent    = hud.board, 
  text    = T "Notification 48h before the next draw",         
  x     = self.column1,
  y     = self.top + self.yGap*(optionsTop-0.5),
  fontSize   = self.fontSizeLeft,
        anchorX   = 0,
        anchorY   = 0.5,
 })
 
 viewManager.newText({
  parent    = hud.board, 
  text    = "ewqrtfore the next draw",         
  x     = self.column2,
  y     = self.top + self.yGap*(optionsTop),
  fontSize   = self.fontSizeLeft,
        anchorX   = 0,
        anchorY   = 0.5,
 })

 local beforeDrawSwitch = widget.newSwitch
 {
  left                      = display.contentWidth*0.8,
  top                       = self.top + self.yGap*(optionsTop-0.55),
  initialSwitchState        = GLOBALS.options.notificationBeforeDraw,
  onPress                   = beforeDrawSwitchListener,
  onRelease                 = beforeDrawSwitchListener,
 }
 
 beforeDrawSwitch:scale(2,2) 

 viewManager.newText({
  parent    = hud.board, 
  text    = T "Notification for the results",         
  x     = self.column1,
  y     = self.top + self.yGap*(optionsTop+0.5),
  fontSize   = self.fontSizeLeft,
      anchorX    = 0,
      anchorY    = 0.5,
 })


 local afterDrawSwitch = widget.newSwitch
 {
  left      = display.contentWidth*0.8,
  top      = self.top + self.yGap*(optionsTop+0.45),
  initialSwitchState   = GLOBALS.options.notificationAfterDraw,
  onPress     = afterDrawSwitchListener,
  onRelease     = afterDrawSwitchListener,
 }

 afterDrawSwitch:scale(3,3) 

 hud.board:insert( beforeDrawSwitch ) 
 hud.board:insert( afterDrawSwitch ) 

 ------------------

 hud:insert(hud.board)
 
 -----------------------------

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