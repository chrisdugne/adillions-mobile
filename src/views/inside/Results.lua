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

    self.backWithResults = false

    native.setActivityIndicator( true )
    viewManager.setupView(4)
    viewManager.darkerBack()
    self.view:insert(hud)

    lotteryManager:getFinishedLotteries(function()
        self.backWithResults = true
        self:drawBoard()
        hud.board:toBack()
        native.setActivityIndicator( false )
    end)

    -- hack android user idle
    timer.performWithDelay(5000, function()
        if(not self.backWithResults) then
            self:refreshScene()     
        end
    end)
end
-----------------------------------------------------------------------------------------

function scene:drawBoard()

    viewManager.initBoard()

    ------------------

    local marginLeft = display.contentWidth * 0.077
    local marginTop =  HEADER_HEIGHT + 115
    local xGap =  display.contentWidth *0.12
    local yGap =  display.contentHeight *0.76/aspectRatio

    ------------------

    for i = 1,#lotteryManager.finishedLotteries do

        ------------------------------------------------

        local lottery     = lotteryManager.finishedLotteries[i]
        local numbers     = json.decode(lottery.result)
        lottery.theme     = json.decode(lottery.theme)
        lottery.prizes    = json.decode(lottery.prizes)

        local y = marginTop + yGap*(i-1) + 195

        ------------------------------------------------

        viewManager.drawBorder(hud.board, display.contentWidth*0.5, y, display.contentWidth*0.95, 570)

        ------------------------------------------------

        viewManager.newText({
            parent = hud.board, 
            text = lotteryManager:date(lottery, true, true), 
            x = display.contentWidth*0.5,
            anchorX     = 0.5,
--            x = display.contentWidth*0.1,
--            anchorX     = 0,
            anchorY     = 0.5,
            y = marginTop + yGap*(i-1), 
            fontSize    = 44,
            font        = NUM_FONT, 
        })

        ------------------------------------------------

        for j = 1,#numbers-1 do
            viewManager.drawBall(hud.board, numbers[j], marginLeft + xGap*j, y - 50)
        end

        viewManager.drawTheme(hud.board, lottery, numbers[#numbers], marginLeft + xGap*#numbers, y - 50)

        ------------------------------------------------

        hud.iconWinners = display.newImage( hud.board, "assets/images/icons/winners.png")  
        hud.iconWinners.x = display.contentWidth*0.12
        hud.iconWinners.y = marginTop + yGap*(i-1)+270,
        hud.board:insert(hud.iconWinners)

        viewManager.newText({
            parent = hud.board, 
            text = lottery.nbWinners, 
            x = display.contentWidth*0.19,
            y = marginTop + yGap*(i-1)+270, 
            fontSize = 45,
            font = NUM_FONT,
            anchorX    = 0,
            anchorY    = 0.5,
        })

        local winners = T "Winner"
        if(lottery.nbWinners > 1) then
            winners = T "Winners"
        end

        viewManager.newText({
            parent = hud.board, 
            text = winners, 
            x = display.contentWidth*0.28,
            y = marginTop + yGap*(i-1)+270, 
            fontSize = 39,
            anchorX    = 0,
            anchorY    = 0.5,
        })

        ------------------------------------------------

        local price = lotteryManager:finalPrice(lottery)

        hud.iconMoney = display.newImage( hud.board, "assets/images/icons/money.png")  
        hud.iconMoney.x = display.contentWidth*0.12
        hud.iconMoney.y = marginTop + yGap*(i-1)+340,
        hud.board:insert(hud.iconMoney)

        viewManager.newText({
            parent = hud.board, 
            text = price, 
            x = display.contentWidth*0.19,
            y = marginTop + yGap*(i-1)+340, 
            fontSize = 45,
            font = NUM_FONT,
            anchorX    = 0,
            anchorY    = 0.5,
        })

        ------------------------------------------------

        hud.separator = display.newImage( hud.board, "assets/images/icons/separateur.big.png")  
        hud.separator.x = display.contentWidth*0.5
        hud.separator.y = marginTop + yGap*(i-1)+310,
        hud.board:insert(hud.separator)

        ------------------------------------------------

        hud.iconCharity = display.newImage( hud.board, "assets/images/icons/charity.png")  
        hud.iconCharity.x = display.contentWidth*0.64
        hud.iconCharity.y = marginTop + yGap*(i-1)+305,
        hud.board:insert(hud.iconCharity)

        viewManager.newText({
            parent    = hud.board, 
            text     = T "Charity", 
            x      = display.contentWidth*0.7,
            y      = marginTop + yGap*(i-1)+270, 
            fontSize   = 39,
            anchorX    = 0,
            anchorY    = 0.5,
        })


        viewManager.newText({
            parent   = hud.board, 
            text     = utils.convertAndDisplayPrice(lottery.charity, COUNTRY, lottery.rateUSDtoEUR), 
            x      = display.contentWidth*0.7,
            y      = marginTop + yGap*(i-1)+315, 
            fontSize   = 45,
            font     = NUM_FONT,
            anchorX    = 0,
            anchorY    = 0.5,
        })

        ------------------------------------------------
--
--        local more = viewManager.newText({
--            parent    = hud.board, 
--            text     = "+ " .. T "See more", 
--            x      = display.contentWidth*0.5,
--            y      = marginTop + yGap*(i-1)+420, 
--            fontSize   = 37,
--            font     = NUM_FONT
--        })

        hud.seemore = display.newImage( hud.board, I "seemore.png")  
        hud.seemore.x = display.contentWidth*0.5
        hud.seemore.y = marginTop + yGap*(i-1)+480
        hud.seemore.anchorY = 1
        hud.board:insert(hud.seemore)

        utils.onTouch(hud.seemore, function() self:openMoreResults(lottery) end)

    end

    ------------------

    hud:insert(hud.board)

end

------------------------------------------

function scene:openMoreResults( lottery )

    local top   = display.contentHeight * 0.3
    local yGap  = display.contentHeight * 0.082

    local popup = viewManager.showPopup()
    analytics.event("Gaming", "popupMoreResults") 

    viewManager.newText({
        parent = popup, 
        text = T "Drawing" .. " " .. lotteryManager:date(lottery, true, true), 
        x = display.contentWidth*0.5,
        y = display.contentHeight * 0.11,
        fontSize = 40,
    })


    hud.sep2   = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep2.x   = display.contentWidth*0.5
    hud.sep2.y   = display.contentHeight*0.16

    hud.sep   = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x   = display.contentWidth*0.5
    hud.sep.y   = display.contentHeight*0.25


    viewManager.newText({
        parent = popup, 
        text = T "Total", 
        x = display.contentWidth*0.45,
        y = display.contentHeight * 0.19,
        fontSize = 32,
        font = NUM_FONT
    })

    viewManager.newText({
        parent = popup, 
        text = T "winning Tickets", 
        x = display.contentWidth*0.45,
        y = display.contentHeight * 0.22,
        fontSize = 32,
        font = NUM_FONT
    })

    viewManager.newText({
        parent = popup, 
        text = T "Prize / ", 
        x = display.contentWidth*0.77,
        y = display.contentHeight * 0.19,
        fontSize = 32,
        font = NUM_FONT
    })

    viewManager.newText({
        parent = popup, 
        text = T "Winning Ticket", 
        x = display.contentWidth*0.77,
        y = display.contentHeight * 0.22,
        fontSize = 32,
        font = NUM_FONT
    })

    --- mobile : rang 1-6 only
    for i = 1, 6 do

        hud.iconRang   = display.newImage( popup, "assets/images/icons/rangs/Rang".. i .. ".png")
        hud.iconRang.x   = display.contentWidth * 0.2
        hud.iconRang.y   = top + yGap * (i-1) - display.contentHeight*0.005

        viewManager.newText({
            parent    = popup, 
            text    = lottery.prizes[i].winners,     
            x     = display.contentWidth*0.45,
            y     = top + yGap * (i-1) - display.contentHeight*0.005,
            fontSize   = 35,
            anchorX   = 1,
            anchorY   = 0.5,
        })

        viewManager.newText({
            parent    = popup, 
            text    = utils.convertAndDisplayPrice(lottery.prizes[i].share, COUNTRY, lottery.rateUSDtoEUR),     
            x     = display.contentWidth*0.8,
            y     = top + yGap * (i-1) - display.contentHeight*0.005,
            fontSize   = 35,
            anchorX   = 1,
            anchorY   = 0.5,
        })

        hud.iconPieces   = display.newImage( popup, "assets/images/icons/money.png")
        hud.iconPieces.x  = display.contentWidth * 0.86
        hud.iconPieces.y  = top + yGap * (i-1) - display.contentHeight*0.01

    end

    --------------------------

    popup.close    = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x    = display.contentWidth*0.5
    popup.close.y    = display.contentHeight*0.85

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

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