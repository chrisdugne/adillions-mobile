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

    hud.bg = display.newImageRect( hud, "assets/images/hud/SignUp_Bg.jpg", display.contentWidth, display.contentHeight)  
    hud.bg.x = display.viewableContentWidth*0.5 
    hud.bg.y = display.viewableContentHeight*0.5

    hud.logo = display.newImage( hud, "assets/images/hud/Sign_Logo.png")  
    hud.logo.x = display.contentWidth*0.5 
    hud.logo.y = display.contentHeight*0.15

    hud.logo = display.newImage( hud, "assets/images/hud/SignUp_Earth.png")  
    hud.logo.x = display.contentWidth*0.5 
    hud.logo.y = display.contentHeight*0.38

    hud.logo = display.newImage( hud, "assets/images/hud/SignUp_BigBall.png")  
    hud.logo.x = display.contentWidth*0.27 
    hud.logo.y = display.contentHeight*0.38

    hud.logo = display.newImage( hud, "assets/images/hud/SignUp_MedBall.png")  
    hud.logo.x = display.contentWidth*0.17 
    hud.logo.y = display.contentHeight*0.04

    hud.logo = display.newImage( hud, "assets/images/hud/SignUp_MedBall2.png")  
    hud.logo.x = display.contentWidth*0.96 
    hud.logo.y = display.contentHeight*0.25

    hud.logo = display.newImage( hud, "assets/images/hud/SignUp_SmallBall.png")  
    hud.logo.x = display.contentWidth*0.9 
    hud.logo.y = display.contentHeight*0.05


    ---------------------------------------------------------------

    self.view:insert(hud)

    ---------------------------------------------------------------

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