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

--    hud.subheaderImage   = display.newImageRect(hud, "assets/images/hud/home/subheader.bg.png", display.contentWidth, display.viewableContentHeight*0.075)
--    hud.subheaderImage.x  = display.contentWidth*0.5
--    hud.subheaderImage.y  = HEADER_HEIGHT - 3
--    hud.subheaderImage.anchorY  = 0

    hud.subheaderText           = display.newImage(hud, I "home.subheader.title.png")
    hud.subheaderText.anchorX   = 0
    hud.subheaderText.x         = display.contentWidth  * 0.11
    hud.subheaderText.y         = display.contentHeight * 0.15
    
--    hud.subheaderText.y  = display.contentHeight * 0.15
--
    ------------------
    
    print("home asks to refreshNextLottery")
    lotteryManager:refreshNextLottery(function() 
        self:drawNextLottery(false) 
    end,function() 
        self:drawNextLottery(true) 
    end)

    ------------------

    viewManager.setupView(0, 1)
    self.view:insert(hud)

end

------------------------------------------

function scene:animateSubheader()
    if(hud.subheaderAnim and hud.subheaderAnim.play) then

        hud.subheaderAnim:play()

        if(self.subheaderTimer) then
            timer.cancel(self.subheaderTimer)
        end

        self.subheaderTimer = timer.performWithDelay(4000, function() self:animateSubheader() end)
    end
end

------------------------------------------

function scene:drawNextLottery( waitingForDrawing )
    
--    userManager:giftStock(2, function()
--        userManager:showStatus() 
--    end)
    
--    userManager.user.notifications.prizes = 22.3
--    userManager.user.notifications.prizesUSD = 32.3
--    userManager:notifyPrizes()

--    userManager.user.notifications.instants = 2
--    userManager:notifyInstants()

--    lotteryManager.currentSelection = {1,2,3,4,5,6}
--    lotteryManager:showLastTicket()

    if(router.view ~= router.HOME) then
        return
    end
    
    local y                 = HEADER_HEIGHT * 3.7
    local top               = HEADER_HEIGHT * 2.5
    local timerLegendSize   = 17
    local timerLegendY      = top + display.contentHeight * 0.025
    local timerY            = top

    -------------------------------
    -- home.prize.png

    hud.pictoTimer      = display.newImage( hud, "assets/images/hud/home/home.timer.png")  
    hud.pictoTimer.x    = display.contentWidth*0.5
    hud.pictoTimer.y    = timerY  + display.contentWidth*0.012 
    
    -------------------------------

    hud.timerDisplay = viewManager.newText({
        parent = hud, 
        text = '',     
        x = display.contentWidth*0.8,
        y = timerY - 5 ,
        fontSize = 53,
        font = NUM_FONT
    })
    
    hud.timerDisplay.anchorX = 1
    
    viewManager.refreshHomeTimer()

    -------------------------------

    local paddingTextX = display.contentWidth*0.068
    local daysX = display.contentWidth*0.305
    if(LANG == "en") then daysX = display.contentWidth*0.3 end

    viewManager.newText({
        parent = hud, 
        text = T "DAYS", 
        x = daysX + paddingTextX,
        y = timerLegendY,
        fontSize = timerLegendSize,
    })

    viewManager.newText({
        parent = hud, 
        text = T "HRS", 
        x = display.contentWidth*0.437 + paddingTextX,
        y = timerLegendY,
        fontSize = timerLegendSize,
    })

    viewManager.newText({
        parent = hud, 
        text = T "MIN", 
        x = display.contentWidth*0.567 + paddingTextX,
        y = timerLegendY,
        fontSize = timerLegendSize,
    })

    viewManager.newText({
        parent = hud, 
        text = T "SEC", 
        x = display.contentWidth*0.698 + paddingTextX,
        y = timerLegendY,
        fontSize = timerLegendSize,
    })

    ----------------------------------------------------

    local priceX
    local priceY = top + display.contentHeight*0.13
    if(lotteryManager.nextDrawing.nbPlayers > lotteryManager.nextDrawing.toolPlayers) then
        priceX = display.contentWidth*0.4
    else
        priceX = display.contentWidth*0.8
    end

    hud.pictoPrize      = display.newImage( hud, "assets/images/hud/home/home.prize.png")  
    hud.pictoPrize.x    = display.contentWidth*0.5
    hud.pictoPrize.y    = priceY
    
    
    utils.onTouch(hud.pictoPrize, function()
        analytics.event("Links", "prizesFromHome") 
        userManager:openPrizes()
    end)
    
    
    -------------------------------

    hud.priceDisplay = viewManager.newText({
        parent = hud, 
        text = '',     
        x = priceX ,
        y = priceY,
        fontSize = 83,
        font = NUM_FONT,
        anchorX    = 1,
        anchorY    = 0.5,
    })

    hud.priceCurrentDisplay = 0
    viewManager.animatePrice()

    -------------------------------

    if(lotteryManager.nextDrawing.nbPlayers > lotteryManager.nextDrawing.toolPlayers) then 

        hud.separateur = display.newImage( hud, "assets/images/icons/separateur.png")  
        hud.separateur.x = display.contentWidth*0.7
        hud.separateur.y = top + display.contentHeight*0.12

        -------------------------------

        hud.pictoPlayers = display.newImage( hud, "assets/images/icons/players.png")  
        hud.pictoPlayers.x = display.contentWidth*0.85
        hud.pictoPlayers.y = top + display.contentHeight*0.09

        viewManager.newText({
            parent = hud, 
            text = T "Players" .. " :", 
            x = display.contentWidth*0.85,
            y = top + display.contentHeight*0.12,
            fontSize = 24,
        })

        viewManager.newText({
            parent = hud, 
            text = lotteryManager.nextDrawing.nbPlayers , 
            x = display.contentWidth*0.85,
            y = top + display.contentHeight*0.15,
            fontSize = 43,
            font = NUM_FONT
        })

    end

    -------------------------------
    
    if(waitingForDrawing) then
        lotteryManager:checkAppStatus(function(lottery)
            bannerManager:waitingForDrawing(lottery)
        end)
    else
        viewManager.refreshPlayButton()
        bannerManager:start()
    end
    
    -------------------------------
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