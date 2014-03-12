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
    hud.selection = display.newGroup()
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()

    ------------------

    utils.emptyGroup(hud.selection)

    ------------------

    local top =  HEADER_HEIGHT
    local xGap =  display.contentWidth *0.25
    local yGap =  display.contentHeight *0.23

    --------------------------------------------------------------

    viewManager.newText( {
        parent = hud,
        text = T "Select your Lucky Ball !",     
        x = display.contentWidth*0.05,
        y = top + display.contentHeight*0.08,
        font = FONT,   
        fontSize = 49,
        anchorX    = 0,
        anchorY    = 0.5,
    } )

    --------------------------------------------------------------
    -- Additional nums

    local totalNums    = 0  
    local nbNumPerLine  = 3

    if(lotteryManager.nextLottery.theme.balls) then
        totalNums = #lotteryManager.nextLottery.theme.balls.en
    else
        totalNums = #lotteryManager.nextLottery.theme.icons
    end

    ------------------

    local nbLines =  totalNums/nbNumPerLine
    local nbRows =  totalNums/nbLines
    local nbOnlastLine = totalNums - math.floor(nbLines)*nbRows

    ------------------

    for i = 1,nbRows do
        for j = 1,nbLines do
            viewManager.drawThemeToPick((j-1)*nbRows+i,  xGap*i, top + yGap*j)
        end
    end

    for i = 1,nbOnlastLine do
        viewManager.drawThemeToPick(math.floor(nbLines)*nbRows+i, xGap*i, top + yGap*(math.floor(nbLines)+1))
    end

    ------------------

    hud.selector   = display.newImageRect(hud, "assets/images/hud/selector.green.2.png", display.contentWidth*0.9, display.viewableContentHeight*0.114)
    hud.selector.x  = display.contentWidth*0.5
    hud.selector.y  = top + display.contentHeight*0.69

    ------------------

    hud.headerRect = display.newImageRect( hud, "assets/images/hud/game/header.game.png", display.contentWidth, HEADER_HEIGHT)  
    hud.headerRect.x = display.viewableContentWidth*0.5 
    hud.headerRect.y = HEADER_HEIGHT*0.5

    hud.logo = display.newImage( hud, "assets/images/hud/game/logo.game.png")  
    hud.logo.x = display.contentWidth*0.5
    hud.logo.y = HEADER_HEIGHT*0.5

    hud.close     = display.newImage( hud, "assets/images/hud/game/exit.game.png")
    hud.close.x    = display.contentWidth*0.89
    hud.close.y    = HEADER_HEIGHT/2

    utils.onTouch(hud.close, function() router.openHome() end)


    ------------------

    lotteryManager:refreshThemeSelectionDisplay()

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