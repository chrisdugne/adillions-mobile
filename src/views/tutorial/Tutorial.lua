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

 ---------------------------------------------------------------

 viewManager.initBack()

 ---------------------------------------------------------------
 
 hud.bottom     = display.newImageRect( hud, "assets/images/hud/Tuto_BottomBg.png", display.contentWidth, display.contentHeight*0.12)
 hud.bottom.x    = display.contentWidth*0.5
 hud.bottom.y    = display.contentHeight*0.94
 
 ---------------------------------------------------------------
 
 hud.tuto1       = display.newGroup()
 hud.tuto2       = display.newGroup()
 hud.tuto3       = display.newGroup()

 hud:insert(hud.tuto1)
 hud:insert(hud.tuto2)
 hud:insert(hud.tuto3)
 
 hud.tuto1.x = 0
 hud.tuto2.x = display.contentWidth
 hud.tuto3.x = display.contentWidth*2
 
 ---------------------------------------------------------------
 
 self:createTuto1()
 self:createTuto2()
 self:createTuto3()

 ---------------------------------------------------------------
 
 hud.close     = display.newImage( hud, "assets/images/hud/CroixClose.png")
 hud.close.x    = display.contentWidth*0.92
 hud.close.y    = display.contentHeight*0.04
 hud.close.alpha  = 0.45
 
 utils.onTouch(hud.close, function() self:exit() end)
 ---------------------------------------------------------------

 self.view:insert(hud)

 ---------------------------------------------------------------

end

------------------------------------------

function scene:createTuto1()

 hud.tuto1.welcome    = display.newImage( hud.tuto1, I "Tuto_Welcome.png")
 hud.tuto1.welcome.x    = display.contentWidth*0.5
 hud.tuto1.welcome.y    = display.contentHeight*0.08
 
 hud.tuto1.logo     = display.newImage( hud.tuto1, "assets/images/logo.png")
 hud.tuto1.logo.x     = display.contentWidth*0.5
 hud.tuto1.logo.y     = display.contentHeight*0.16
 hud.tuto1.logo:scale(1.5,1.5)

 hud.tuto1.bande     = display.newImageRect( hud.tuto1, "assets/images/hud/Tuto_SubHeader_Bg.png", display.contentWidth, display.contentHeight*0.18)
 hud.tuto1.bande.x    = display.contentWidth*0.5
 hud.tuto1.bande.y    = display.contentHeight*0.33

 hud.tuto1.longtext    = display.newImage( hud.tuto1, I "Tuto_SubHeader_Txt.png")
 hud.tuto1.longtext.x   = display.contentWidth*0.5
 hud.tuto1.longtext.y   = display.contentHeight*0.33

 --------------------

 hud.tuto1.longtext    = display.newImage( hud.tuto1, I "funded.png")
 hud.tuto1.longtext.x   = display.contentWidth*0.6
 hud.tuto1.longtext.y   = display.contentHeight*0.415
 
 --------------------
 
 hud.tuto1.ball1     = display.newImage( hud.tuto1, "assets/images/icons/watch.png")
 hud.tuto1.ball1.x    = display.contentWidth*0.15
 hud.tuto1.ball1.y    = display.contentHeight*0.52
 
 hud.tuto1.play    = display.newImage( hud.tuto1, "assets/images/icons/arrow_down.png")
 hud.tuto1.play.x    = display.contentWidth*0.15
 hud.tuto1.play.y    = display.contentHeight*0.585
 
 hud.tuto1.watch = viewManager.newText({
  parent    = hud.tuto1,
  text     = T "Watch", 
  fontSize   = 44,  
  x      = display.contentWidth * 0.3,
  y      = display.contentHeight* (0.52 + 0.015),
  anchorX   = 0,
  anchorY   = 1
 })
 
 
 hud.tuto1.anad = viewManager.newText({
  parent    = hud.tuto1,
  text     = T "an ad", 
  fontSize   = 44,  
  x      = hud.tuto1.watch.x + hud.tuto1.watch.width + display.contentWidth*0.02,
  y      = display.contentHeight* (0.52 + 0.015),
  anchorX   = 0,
  anchorY   = 1
 })
 
 --------------------
 
 hud.tuto1.ball2     = display.newImage( hud.tuto1, "assets/images/icons/ticket.tuto.png")
 hud.tuto1.ball2.x    = display.contentWidth*0.15
 hud.tuto1.ball2.y    = display.contentHeight*0.66
 
 hud.tuto1.play    = display.newImage( hud.tuto1, "assets/images/icons/arrow_down.png")
 hud.tuto1.play.x    = display.contentWidth*0.15
 hud.tuto1.play.y    = display.contentHeight*0.725
 
 hud.tuto1.fillout = viewManager.newText({
  parent    = hud.tuto1,
  text     = T "Fill out", 
  fontSize   = 44,  
  x      = display.contentWidth * 0.3,
  y      = display.contentHeight* (0.66 + 0.015),
  anchorX   = 0,
  anchorY   = 1
 })
 
 
 hud.tuto1.anad = viewManager.newText({
  parent    = hud.tuto1,
  text     = T "a ticket", 
  fontSize   = 44,  
  x      = hud.tuto1.fillout.x + hud.tuto1.fillout.width + display.contentWidth*0.02,
  y      = display.contentHeight*(0.66 + 0.015),
  anchorX   = 0,
  anchorY   = 1
 })
 
 --------------------
 
 hud.tuto1.ball3     = display.newImage( hud.tuto1, "assets/images/icons/win.png")
 hud.tuto1.ball3.x    = display.contentWidth*0.15
 hud.tuto1.ball3.y    = display.contentHeight*0.8
 
 hud.tuto1.win = viewManager.newText({
  parent    = hud.tuto1,
  text     = T "Try", 
  fontSize   = 44,  
--  font    = NUM_FONT,  
  x      = display.contentWidth * 0.3,
  y      = display.contentHeight*(0.8 + 0.015),
  anchorX   = 0,
  anchorY   = 1
 })
 
 hud.tuto1.anad = viewManager.newText({
  parent    = hud.tuto1,
  text     = T "your luck" .. " !", 
  fontSize   = 44,  
  x      = hud.tuto1.win.x + hud.tuto1.win.width + display.contentWidth*0.02,
  y      = display.contentHeight*(0.8 + 0.015),
  anchorX   = 0,
  anchorY   = 1
 })
 
 -------------------
 -- controls
 hud.tuto1.next = viewManager.newText({
  parent    = hud.tuto1,
  text     = T "NEXT",  
  anchorX   = 0.5,
  anchorY   = 1,
  y      = display.contentHeight*0.96,
  fontSize   = 52,  
  x      = display.contentWidth * 0.5,
 })
 
 hud.tuto1.next:setFillColor(255)
 
 hud.tuto1.arrowright   = display.newImage( hud.tuto1, "assets/images/hud/Tuto_ArrowRight.png")
 hud.tuto1.arrowright.anchorX    = 0.5
 hud.tuto1.arrowright.anchorY    = 1
 hud.tuto1.arrowright.x   = display.contentWidth*0.5 + hud.tuto1.next.contentWidth/2 + 50
 hud.tuto1.arrowright.y   = hud.tuto1.next.y
 

 utils.onTouch(hud.tuto1.next,    function()  self:goTuto(2) end)
 utils.onTouch(hud.tuto1.arrowright,  function()  self:goTuto(2) end)
end

------------------------------------------

function scene:createTuto2()

 hud.tuto2.bg    = display.newImageRect( hud.tuto2, "assets/images/hud/Tuto_2_Bg.png", display.contentWidth, display.contentHeight*0.88)  
 hud.tuto2.bg.x    = display.viewableContentWidth*0.5 
 hud.tuto2.bg.y   = display.viewableContentHeight*0.44

 hud.tuto2.visuel   = display.newImage( hud.tuto2, "assets/images/hud/world.png")  
 hud.tuto2.visuel.x  = display.viewableContentWidth*0.5 
 hud.tuto2.visuel.y  = display.viewableContentHeight*0.5
 
 hud.tuto2.title    = display.newImage( hud.tuto2, I "Tuto_Txt2.png")
 hud.tuto2.title.x   = display.contentWidth*0.5
 hud.tuto2.title.y   = display.contentHeight*0.15

 hud.tuto2.finalText1 = viewManager.newText({
  parent    = hud.tuto2,
  text     = T "Each new player contributes", 
  fontSize   = 45,  
  x      = display.contentWidth * 0.5,
  y      = display.contentHeight*0.78,
 })

 hud.tuto2.finalText1:setFillColor(40/255)

 hud.tuto2.finalText2 = viewManager.newText({
  parent    = hud.tuto2,
  text     = T "to increase the jackpot", 
  fontSize   = 45,  
  x      = display.contentWidth * 0.5,
  y      = display.contentHeight*0.82,
 })

 hud.tuto2.finalText2:setFillColor(40/255)
 
 -------------------
 -- controls
 
 hud.tuto2.next = viewManager.newText({
  parent    = hud.tuto2,
  text     = T "NEXT",       
  anchorX   = 1,
  anchorY   = 1,
  fontSize   = 52,  
  x      = display.contentWidth * 0.86,
  y      = display.contentHeight*0.96,
 })

 hud.tuto2.next:setFillColor(255)
 
 hud.tuto2.arrowright   = display.newImage( hud.tuto2, "assets/images/hud/Tuto_ArrowRight.png")
      
 hud.tuto2.arrowright.anchorX   = 0.5
 hud.tuto2.arrowright.anchorY   = 1
 hud.tuto2.arrowright.x   = display.contentWidth*0.9
 hud.tuto2.arrowright.y   = hud.tuto2.next.y
 
 hud.tuto2.previous = viewManager.newText({
  parent    = hud.tuto2,
  text     = T "PREVIOUS",            
  anchorX   = 0,
  anchorY   = 1,
  fontSize   = 52,  
  x      = display.contentWidth * 0.14,
  y      = display.contentHeight*0.96,
 })
 
 hud.tuto2.previous:setFillColor(255)

 hud.tuto2.arrowleft   = display.newImage( hud.tuto2, "assets/images/hud/Tuto_ArrowLeft.png")
 
 hud.tuto2.arrowleft.anchorX   = 0.5
 hud.tuto2.arrowleft.anchorY   = 1
 hud.tuto2.arrowleft.x  = display.contentWidth*0.1
 hud.tuto2.arrowleft.y  = hud.tuto2.next.y

 utils.onTouch(hud.tuto2.next,    function()  self:goTuto(3) end)
 utils.onTouch(hud.tuto2.arrowright,  function()  self:goTuto(3) end)
 utils.onTouch(hud.tuto2.previous,   function()  self:goTuto(1) end)
 utils.onTouch(hud.tuto2.arrowleft,   function()  self:goTuto(1) end)
 
end

------------------------------------------

function scene:createTuto3()


 hud.tuto3.bg    = display.newImageRect( hud.tuto3, "assets/images/hud/Tuto_2_Bg.png", display.contentWidth, display.contentHeight*0.88)  
 hud.tuto3.bg.x    = display.viewableContentWidth*0.5 
 hud.tuto3.bg.y   = display.viewableContentHeight*0.44
 
 hud.tuto3.title    = display.newImage( hud.tuto3, I "Tuto_Txt3.png")
 hud.tuto3.title.x   = display.contentWidth*0.5
 hud.tuto3.title.y   = display.contentHeight*0.13
 
 hud.tuto3.finalText1 = viewManager.newText({
  parent    = hud.tuto3,
  text     = T "... give to charity !", 
  fontSize   = 45,  
  x      = display.contentWidth * 0.5,
  y      = display.contentHeight*0.78,
 })

 hud.tuto3.finalText1:setFillColor(40/255)

 hud.tuto3.finalText2 = viewManager.newText({
  parent    = hud.tuto3,
  text     = T "... likely you are to win the jackpot !", 
  fontSize   = 45,  
  x      = display.contentWidth * 0.5,
  y      = display.contentHeight*0.82,
 })

 hud.tuto3.finalText2:setFillColor(40/255)

 -------------------

 hud.tuto3.charityprofile = viewManager.newText({
  parent    = hud.tuto3,
  text     = T "Charity Profile", 
  fontSize   = 32,  
  x      = display.contentWidth * 0.5,
  y      = display.contentHeight*0.315,
 })

 hud.tuto3.charityprofile:setFillColor(40/255)

 hud.tuto3.winners = viewManager.newText({
  parent    = hud.tuto3,
  text     = T "Winners", 
  fontSize   = 32,  
  x      = display.contentWidth * 0.3,
  y      = display.contentHeight* 0.72,
 })

 hud.tuto3.winners:setFillColor(40/255)

 hud.tuto3.charity = viewManager.newText({
  parent    = hud.tuto3,
  text     = T "Charities", 
  fontSize   = 32,  
  x      = display.contentWidth * 0.7,
  y      = display.contentHeight* 0.72,
 })

 hud.tuto3.charity:setFillColor(40/255)

 -------------------
 
 hud.tuto3.play    = display.newImage( hud.tuto3, "assets/images/hud/tuto3/Body.png")
 hud.tuto3.play.x    = display.contentWidth*0.5
 hud.tuto3.play.y    = display.contentHeight*0.25

 
 hud.tuto3.play    = display.newImage( hud.tuto3, "assets/images/hud/tuto3/CharityLevel.png")
 hud.tuto3.play.x    = display.contentWidth*0.5
 hud.tuto3.play.y    = display.contentHeight*0.35

 hud.tuto3.play    = display.newImage( hud.tuto3, "assets/images/hud/tuto3/Bar.png")
 hud.tuto3.play.x    = display.contentWidth*0.5
 hud.tuto3.play.y    = display.contentHeight*0.4
 
 hud.tuto3.play    = display.newImage( hud.tuto3, "assets/images/hud/tuto3/Time.png")
 hud.tuto3.play.x    = display.contentWidth*0.5
 hud.tuto3.play.y    = display.contentHeight*0.45
 
 hud.tuto3.play    = display.newImage( hud.tuto3, "assets/images/hud/tuto3/Bar.png")
 hud.tuto3.play.x    = display.contentWidth*0.5
 hud.tuto3.play.y    = display.contentHeight*0.49
 
 hud.tuto3.play    = display.newImage( hud.tuto3, "assets/images/hud/tuto3/Fund.png")
 hud.tuto3.play.x    = display.contentWidth*0.5
 hud.tuto3.play.y    = display.contentHeight*0.55
 
 hud.tuto3.play    = display.newImage( hud.tuto3, "assets/images/hud/tuto3/Bar3.png")
 hud.tuto3.play.x    = display.contentWidth*0.5
 hud.tuto3.play.y    = display.contentHeight*0.63
 
 hud.tuto3.play    = display.newImage( hud.tuto3, "assets/images/hud/tuto3/Winners.png")
 hud.tuto3.play.x    = display.contentWidth*0.3
 hud.tuto3.play.y    = display.contentHeight*0.65
 
 hud.tuto3.play    = display.newImage( hud.tuto3, "assets/images/hud/tuto3/Charities.png")
 hud.tuto3.play.x    = display.contentWidth*0.7
 hud.tuto3.play.y    = display.contentHeight*0.65
 
 -------------------
 -- controls
 
 hud.tuto3.play    = display.newImage( hud.tuto3, I "Tuto_bt_Play.png")
 hud.tuto3.play.x    = display.contentWidth*0.75
 hud.tuto3.play.y    = display.contentHeight*0.94

 hud.tuto3.arrowleft   = display.newImage( hud.tuto3, "assets/images/hud/Tuto_ArrowLeft.png")
 hud.tuto3.arrowleft.x  = display.contentWidth*0.1
 hud.tuto3.arrowleft.y  = display.contentHeight*0.94
 
 hud.tuto3.previous = viewManager.newText({
  parent    = hud.tuto3,
  text     = T "PREVIOUS",         
  anchorX   = 0,
  anchorY   = 1,
  fontSize   = 52,  
  x      = display.contentWidth * 0.14,
  y      = display.contentHeight*0.96,
 })
 
 hud.tuto3.previous:setFillColor(255)

 utils.onTouch(hud.tuto3.previous,  function() self:goTuto(2) end)
 utils.onTouch(hud.tuto3.arrowleft,  function() self:goTuto(2) end)
 utils.onTouch(hud.tuto3.play,   function() self:play() end)
 
end

------------------------------------------

function scene:goTuto(tuto)
 if(hud.tuto1.transition) then transition.cancel(hud.tuto1.transition) end
 if(hud.tuto2.transition) then transition.cancel(hud.tuto2.transition) end
 if(hud.tuto3.transition) then transition.cancel(hud.tuto3.transition) end

 hud.tuto1.transition = transition.to(hud.tuto1, { time=300, x= (1-tuto)*display.contentWidth })
 hud.tuto2.transition = transition.to(hud.tuto2, { time=300, x= (2-tuto)*display.contentWidth })
 hud.tuto3.transition = transition.to(hud.tuto3, { time=300, x= (3-tuto)*display.contentWidth })
end

------------------------------------------

function scene:exit()
 if(hud.tuto1.transition) then transition.cancel(hud.tuto1.transition) end
 if(hud.tuto2.transition) then transition.cancel(hud.tuto2.transition) end
 if(hud.tuto3.transition) then transition.cancel(hud.tuto3.transition) end

 GLOBALS.savedData.requireTutorial = false
 utils.saveTable(GLOBALS.savedData, "savedData.json")
 
 if(userManager.user and userManager.user.uid) then
  router.openInfo()
 else
  router.openOutside()
 end

end

function scene:play()
 if(hud.tuto1.transition) then transition.cancel(hud.tuto1.transition) end
 if(hud.tuto2.transition) then transition.cancel(hud.tuto2.transition) end
 if(hud.tuto3.transition) then transition.cancel(hud.tuto3.transition) end

 GLOBALS.savedData.requireTutorial = false
 utils.saveTable(GLOBALS.savedData, "savedData.json")
 
 if(userManager.user and userManager.user.uid) then
  router.openHome()
 else
  router.openOutside()
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