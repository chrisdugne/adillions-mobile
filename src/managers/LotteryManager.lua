-----------------------------------------------------------------------------------------

LotteryManager = {} 

VALIDATE_Y = 0.92

-----------------------------------------------------------------------------------------

function LotteryManager:new()  

    local object = {
        nextLottery = {},
        currentSelection = {}
    }

    setmetatable(object, { __index = LotteryManager })
    return object
end

-----------------------------------------------------------------------------------------

function LotteryManager:refreshNextLottery(classic, waiting)

    utils.postWithJSON(
    {}, 
    SERVER_URL .. "nextLottery", 
    function(result)

        local response  = json.decode(result.response)
        local appStatus = json.decode(response.appStatus)
        
        self.nextLottery          = response.nextLottery
        self.nextDrawing          = response.nextDrawing
    
        self.nextLottery.theme    = json.decode(self.nextLottery.theme)
        self.nextDrawing.theme    = json.decode(self.nextDrawing.theme)
        self.nextLottery.rangs    = json.decode(self.nextLottery.rangs)
        self.nextDrawing.rangs    = json.decode(self.nextDrawing.rangs)
        
        userManager:checkUserCurrentLottery()
        
        if(appStatus.state ~= 1) then
            waiting()
        else
            classic()
        end
    end)    
end

-----------------------------------------------------------------------------------------
-- todo : timer + timer.cancel + random time 6000,10000

function LotteryManager:checkAppStatus(waiting)

    print("checkAppStatus")
    
    if(self.appStatusTimer) then
        timer.cancel(self.appStatusTimer)
    end
    
    utils.postWithJSON(
    {}, 
    SERVER_URL .. "appStatus", 
    function(result)
        local response  = json.decode(result.response)
        local appStatus = json.decode(response.appStatus)
        
        if(appStatus.state == 1) then
            if(lotteryManager.global.appStatus.state ~= 1) then
                print("game is back in the room : reload")
                gameManager:open()
            end
        else
            local lottery = response.lottery
            if(lottery.result) then lottery.result = json.decode(lottery.result) end
            lottery.theme = json.decode(lottery.theme)
            waiting(lottery)
            viewManager.refreshPlayButton(true)
            self.appStatusTimer = timer.performWithDelay(math.random(6000, 12000), function() self:checkAppStatus(waiting) end)
        end
        
    end)
    
end

-----------------------------------------------------------------------------------------

function LotteryManager:getFinishedLotteries(next)
    utils.postWithJSON(
    {}, 
    SERVER_URL .. "finishedLotteries", 
    function(result)
        self.finishedLotteries = json.decode(result.response)
        next()
    end)
end

-----------------------------------------------------------------------------------------

function LotteryManager:priceDollars(lottery)
    return math.min(lottery.maxPrice, math.max(lottery.minPrice, lottery.nbTickets/1000 * lottery.cpm)) 
end

function LotteryManager:price(lottery)
    return utils.convertAndDisplayPrice(self:priceDollars(lottery), COUNTRY, lottery.rateUSDtoEUR)
end

function LotteryManager:charityPerTicket(lottery)
    return lottery.charity / lottery.nbTickets
end

function LotteryManager:finalPrice(lottery)
    return utils.convertAndDisplayPrice(lottery.finalPrice, COUNTRY, lottery.rateUSDtoEUR )
end

function LotteryManager:date(lottery, viewDay, viewYear)
    return utils.timestampToReadableDate(lottery.date, viewDay, viewYear)
end

-----------------------------------------------------------------------------------------

function LotteryManager:refreshNotifications(lotteryDateMillis)

    system.cancelNotification()
    local now = time.now()

    ---------------------------------------------------------------------------------
    
    local _48hText  = translate(lotteryManager.global.text48h) 
    local _3minText = translate(lotteryManager.global.text3min) 
    
    ---------------------------------------------------------------------------------
    -- notif next lottery

    local _48hBefore = lotteryDateMillis/1000 - 48 * 60 * 60
    local _3minAfter = lotteryDateMillis/1000 + 3 * 60

    if(GLOBALS.options.notificationBeforeDraw and now < _48hBefore) then
        local notificationTimeSeconds = os.date( "!*t",  _48hBefore)

        local options = {
            alert = _48hText,
            badge = 1,
        }

        system.scheduleNotification( notificationTimeSeconds, options )
    end


    if(GLOBALS.options.notificationAfterDraw and now < _3minAfter) then
        local notificationTimeSeconds = os.date( "!*t", _3minAfter)

        local options = {
            alert = _3minText,
            badge = 1,
        }

        system.scheduleNotification( notificationTimeSeconds, options )
    end

    ---------------------------------------------------------------------------------
    -- notif lottery weeks later

    for week=1,4 do

        local _48hBefore = lotteryDateMillis/1000 - 48 * 60 * 60 + week * 7 * 24 * 60 * 60
        local _3minAfter = lotteryDateMillis/1000 + 3 * 60 + week * 7 * 24 * 60 * 60

        if(GLOBALS.options.notificationBeforeDraw) then
            local notificationTimeSeconds = os.date( "!*t",  _48hBefore)

            local options = {
                alert = _48hText,
                badge = 1,
            }

            system.scheduleNotification( notificationTimeSeconds, options )
        end


        if(GLOBALS.options.notificationAfterDraw) then
            local notificationTimeSeconds = os.date( "!*t", _3minAfter)

            local options = {
                alert = _3minText,
                badge = 1,
            }

            system.scheduleNotification( notificationTimeSeconds, options )
        end
    end

    ---------------------------------------------------------------------------------

end

-----------------------------------------------------------------------------------------

function LotteryManager:sumPrices()

    userManager.user.totalWinnings   = 0
    userManager.user.balance     = 0
    userManager.user.totalGift    = 0
    userManager.user.receivedWinnings = 0
    userManager.user.pendingWinnings  = 0

    if(userManager.user.lotteryTickets) then
        for i = 1,#userManager.user.lotteryTickets do
            local ticket = userManager.user.lotteryTickets[i]
            local value  = utils.countryPrice(ticket.price or 0, COUNTRY, ticket.lottery.rateUSDtoEUR)
            userManager.user.totalWinnings = userManager.user.totalWinnings + value

            if(ticket.status == BLOCKED) then
                userManager.user.balance = userManager.user.balance + value
            elseif(ticket.status == GIFT) then
                userManager.user.totalGift = userManager.user.totalGift + value
            elseif(ticket.status == PENDING) then
                userManager.user.pendingWinnings = userManager.user.pendingWinnings + value
            else
                userManager.user.receivedWinnings = userManager.user.receivedWinnings + value
            end
        end
    end

end

-----------------------------------------------------------------------------------------

function LotteryManager:addToSelection(num)
    self.currentSelection[#self.currentSelection+1] = num
    self:refreshNumberSelectionDisplay()

    viewManager.drawBallPicked(num)
end

function LotteryManager:removeFromSelection(num)
    local indexToDelete
    for k,n in pairs(self.currentSelection) do
        if(num == n) then
            indexToDelete = k
        end 
    end
    table.remove(self.currentSelection, indexToDelete)
    self:refreshNumberSelectionDisplay()

    local x = hud.balls[num].x
    local y = hud.balls[num].y
    display.remove(hud.balls[num])

    viewManager.drawBallToPick(num,x,y)

end

function LotteryManager:canAddToSelection()
    return #self.currentSelection < self.nextLottery.maxPicks
end

-----------------------------------------------------------------------------------------

function LotteryManager:addToAdditionalSelection(ball)
    if(self.currentAdditionalBall) then
        self.currentAdditionalBall.selected = false
        self.currentAdditionalBall.alpha = 0.3
    end

    self.currentAdditionalBall = ball
    self.currentAdditionalBall.selected = true
    self.currentAdditionalBall.alpha = 1
    self:refreshThemeSelectionDisplay()
end

function LotteryManager:cancelAdditionalSelection()
    self.currentAdditionalBall.selected = false
    self.currentAdditionalBall.alpha = 0.3
    self.currentAdditionalBall = nil
    self:refreshThemeSelectionDisplay()
end

-----------------------------------------------------------------------------------------

function LotteryManager:startSelection()
    self.currentSelection = {}
    self.currentAdditionalBall = nil
    self:refreshNumberSelectionDisplay()
end

-----------------------------------------------------------------------------------------

function LotteryManager:refreshNumberSelectionDisplay()

    -------------------------------------
    -- erase

    utils.emptyGroup(hud.selection)
    table.sort(self.currentSelection)

    -------------------------------------
    -- display

    local nbSelected  = 0
    local marginLeft  =  hud.selector.x - 360
    local xGap    =  120
    local top    =  hud.selector.y

    -------------------------------------
    -- numbers

    for i = 1,self.nextLottery.maxPicks do
        local num = self.currentSelection[i]
        if(self.currentSelection[i]) then

            local x = marginLeft + i*xGap

            viewManager.drawSelectedBall(num, x, top, function()
                self:removeFromSelection(num)
            end)

            nbSelected = nbSelected + 1 
        end
    end

    -------------------------------------
    -- ok button

    if(#self.currentSelection == self.nextLottery.maxPicks) then
        hud.validate = display.newImage( hud.selection, I "ValidateON.png")  
        hud.validate.x = display.contentWidth*0.5
        hud.validate.y = display.contentHeight*VALIDATE_Y

        utils.onTouch(hud.validate, function()
            videoManager:play(router.openSelectAdditionalNumber)
        end)

        hud.selector.alpha = 0.3
    else
        hud.validate = display.newImage( hud.selection, I "ValidateOFF.png")  
        hud.validate.x = display.contentWidth*0.5
        hud.validate.y = display.contentHeight*VALIDATE_Y

        hud.selector.alpha = 1
    end

end

-----------------------------------------------------------------------------------------

function LotteryManager:refreshThemeSelectionDisplay()

    -------------------------------------
    -- erase

    utils.emptyGroup(hud.selection)

    -------------------------------------
    -- display

    local nbSelected  = 0
    local marginLeft  =  display.contentWidth*0.015
    local xGap    =  display.contentWidth*0.14
    local top    =  hud.selector.y

    -------------------------------------
    -- numbers

    for i = 1,self.nextLottery.maxPicks do

        local num = self.currentSelection[i]
        local x = marginLeft + i*xGap

        viewManager.drawBall(hud, num, marginLeft + xGap*i, hud.selector.y, true)
        if(self.currentSelection[i]) then nbSelected = nbSelected + 1 end

    end

    -------------------------------------
    -- additional theme

    viewManager.drawSelectedAdditional(self.currentAdditionalBall, marginLeft + xGap*(self.nextLottery.maxPicks+1), hud.selector.y, function()
        self:cancelAdditionalSelection()
    end)

    if(self.currentAdditionalBall) then nbSelected = nbSelected + 1 end

    -------------------------------------
    -- ok button

    if(nbSelected == self.nextLottery.maxPicks+1) then
        hud.validate = display.newImage( hud.selection, I "ValidateON.png")  
        hud.validate.x = display.contentWidth*0.5
        hud.validate.y = display.contentHeight*VALIDATE_Y

        hud.selector.alpha = 0.3

        utils.onTouch(hud.validate, function()
            display.remove(hud.validate)
            self:validateSelection()
        end)

    else

        hud.selector.alpha = 1

        hud.validate = display.newImage( hud.selection, I "ValidateOFF.png")  
        hud.validate.x = display.contentWidth*0.5
        hud.validate.y = display.contentHeight*VALIDATE_Y
    end

end

-----------------------------------------------------------------------------------------

function LotteryManager:validateSelection()
    self.currentSelection[self.nextLottery.maxPicks+1] = self.currentAdditionalBall.num

    -- security (tim a reussi a enregistrer plusieurs LB...?) ---
    if(#self.currentSelection == (self.nextLottery.maxPicks+1)) then
        userManager:storeLotteryTicket(self.currentSelection)
    end
end

-----------------------------------------------------------------------------------------

function LotteryManager:showLastTicket()

    local popup = viewManager.showPopup(display.contentWidth, true)
    
    ----------------------------------------
    
    popup.header            = display.newImageRect(popup, "assets/images/hud/confirmation/confirmation.title.bg.png", popup.bg.contentWidth*0.95835, display.viewableContentHeight*0.08)
    popup.header.anchorY    = 0
    popup.header.x          = display.contentWidth*0.5
    popup.header.y          = popup.bg.y - popup.bg.contentHeight*0.5
    
    popup.title = display.newImage( popup, I "confirmation.title.png")  
    popup.title.x = display.contentWidth*0.5
    popup.title.y = popup.header.y +  popup.header.contentHeight*0.5
    
    ---------------------------------------

    viewManager.newText({
        parent = popup, 
        text = T("Next drawing") .. " : " .. lotteryManager:date(lotteryManager.nextLottery), 
        x = display.contentWidth*0.5,
        y = display.contentHeight*0.326,
        fontSize = 48,
        font = NUM_FONT,
    })
    
    ----------------------------------------

    local nbTickets = userManager:remainingTickets()
    local lineY     = display.contentHeight*0.57

    popup.pictoTicket = display.newImage( popup, "assets/images/hud/confirmation/confirmation.ticket.png")  
    popup.pictoTicket.x = display.contentWidth*0.81
    popup.pictoTicket.y = lineY
    popup.pictoTicket.anchorY = 0.45
    popup.pictoTicket.anchorX = 1

    local remainingTickets = T "Remaining Ticket"
    if(nbTickets > 1) then
        remainingTickets = T "Remaining Tickets"
    end

    viewManager.newText({
        parent = popup, 
        text = remainingTickets .. " :", 
        x = display.contentWidth*0.19,
        y = lineY,
        fontSize = 44,
        anchorX    = 0,
        anchorY    = 0.5,
    })

    viewManager.newText({
        parent = popup, 
        text = nbTickets, 
        x = popup.pictoTicket.x - popup.pictoTicket.contentWidth - display.contentWidth*0.01,
        y = lineY,
        fontSize = 54,
        font = NUM_FONT,
        anchorX    = 1,
        anchorY    = 0.45,
    })
    
    ----------------------------------------

    popup.imageBG        = display.newImage( popup, "assets/images/hud/confirmation/confirmation.bg.png")
    popup.imageBG.x      = display.contentWidth*0.5
    popup.imageBG.y      = display.contentHeight*0.53

    ----------------------------------------
    
    viewManager.drawSelection(popup, lotteryManager.currentSelection, display.contentHeight*0.45)

    --------------------------

    popup.close    = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x    = display.contentWidth*0.5
    popup.close.y    = display.contentHeight*0.7

    utils.onTouch(popup.close, function()
        router.openHome() 
        viewManager.closePopup(popup)
    end)


end

-----------------------------------------------------------------------------------------

return LotteryManager