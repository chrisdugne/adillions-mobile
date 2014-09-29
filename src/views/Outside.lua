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

    gameManager:initGameData(not GLOBALS.savedData.requireTutorial)


    local a = "http://api-play-stage.adillions.com/loggedin?authToken=5774af87-8f2d-41aa-8928-ac598c9c3dd5"
    local b = "loggedin"

    if (string.find(a, b)) then
        print("-------> 1")
    else
        print("-------> 2")
    end

    ----------
    --
    --
    hud.bg   = display.newImageRect( hud, "assets/images/hud/SignUp_Bg.jpg", display.contentWidth, display.contentHeight)
    hud.bg.x = display.viewableContentWidth*0.5
    hud.bg.y = display.viewableContentHeight*0.5

    hud.logo   = display.newImage( hud, "assets/images/hud/Sign_Logo.png")
    hud.logo.x = display.contentWidth*0.5
    hud.logo.y = display.contentHeight*0.15

    hud.logo   = display.newImage( hud, "assets/images/hud/SignUp_Earth.png")
    hud.logo.x = display.contentWidth*0.5
    hud.logo.y = display.contentHeight*0.38

    hud.logo   = display.newImage( hud, "assets/images/hud/SignUp_BigBall.png")
    hud.logo.x = display.contentWidth*0.27
    hud.logo.y = display.contentHeight*0.38

    hud.logo   = display.newImage( hud, "assets/images/hud/SignUp_MedBall.png")
    hud.logo.x = display.contentWidth*0.17
    hud.logo.y = display.contentHeight*0.04

    hud.logo   = display.newImage( hud, "assets/images/hud/SignUp_MedBall2.png")
    hud.logo.x = display.contentWidth*0.96
    hud.logo.y = display.contentHeight*0.25

    hud.logo   = display.newImage( hud, "assets/images/hud/SignUp_SmallBall.png")
    hud.logo.x = display.contentWidth*0.9
    hud.logo.y = display.contentHeight*0.05

    ---------------------------------------------------------------

    -- hud.fb = display.newImage( hud, I "Sign_Facebook.png")
    -- hud.fb.x = display.contentWidth*0.5
    -- hud.fb.y = display.contentHeight*0.6

    -- utils.onTouch(hud.fb, facebook.login)

    -- hud.textFB = viewManager.newText({
    --     parent   = hud,
    --     text     = T "(We will never post without your consent)",
    --     fontSize = 30,
    --     x        = display.contentWidth * 0.5,
    --     y        = display.contentHeight*0.665
    -- })

    ---------------------------------------------------------------

    -- hud.line   = display.newImage( hud, "assets/images/hud/Sign_Filet.png")
    -- hud.line.x = display.contentWidth*0.5
    -- hud.line.y = display.contentHeight*0.7

    -- hud.textor = viewManager.newText({
    --     parent   = hud,
    --     text     = "or",
    --     fontSize = 39,
    --     x        = display.contentWidth * 0.5,
    --     y        = display.contentHeight*0.694
    -- })

    -- hud.textor.alpha = 0.4

    ---------------------------------------------------------------

    hud.login   = display.newImage( hud, I "Sign_Login.png")
    hud.login.x = display.contentWidth*0.5
    -- hud.login.y = display.contentHeight*0.71
    hud.login.y = display.contentHeight*0.79

    utils.onTouch(hud.login, function() signinManager:openLogin() end)

    hud.signin   = display.newImage( hud, I "Sign_Signup.png")
    hud.signin.x = display.contentWidth*0.5
    hud.signin.y = display.contentHeight*0.91

    utils.onTouch(hud.signin, function() signinManager:openSignin() end)

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