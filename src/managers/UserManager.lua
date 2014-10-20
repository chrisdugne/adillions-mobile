--------------------------------------------------------------------------------

UserManager = {}

--------------------------------------------------------------------------------

function UserManager:new()

    local object = {
        user               = {},
        tickets            = {},
        attemptFetchTicket = false,
        attemptFetchPlayer = 0
    }

    setmetatable(object, { __index = UserManager })
    return object
end

--------------------------------------------------------------------------------

function UserManager:getGlobals(onGoodVersion, onBadVersion)

    utils.get( SAILS_URL .. "/api/globals", function(result)

        if(result.isError) then
            -- android....
            print("globals on error...")
            timer.performWithDelay(2000, function()
                userManager:getGlobals(onGoodVersion, onBadVersion)
            end)

        else
            local response = json.decode(result.response)

            lotteryManager.globals                   = response.globals
            lotteryManager.globals.appStatus         = lotteryManager.globals.appStatus
            lotteryManager.globals.tweet             = lotteryManager.globals.tweet
            lotteryManager.globals.tweetTheme        = lotteryManager.globals.tweetTheme
            lotteryManager.globals.tweetShare        = lotteryManager.globals.tweetShare
            lotteryManager.globals.fbPost            = lotteryManager.globals.fbPost
            lotteryManager.globals.fbPostTheme       = lotteryManager.globals.fbPostTheme
            lotteryManager.globals.fbSharePrize      = lotteryManager.globals.fbSharePrize
            lotteryManager.globals.sms               = lotteryManager.globals.sms
            lotteryManager.globals.email             = lotteryManager.globals.email
            lotteryManager.globals.text48h           = lotteryManager.globals.text48h
            lotteryManager.globals.text3min          = lotteryManager.globals.text3min
            lotteryManager.globals.lastUpdatedPrizes = lotteryManager.globals.lastUpdatedPrizes

            lotteryManager.globals.minEuro           = lotteryManager.globals.minMoney.euro
            lotteryManager.globals.minUSD            = lotteryManager.globals.minMoney.usd

            VERSION_REQUIRED                        = lotteryManager.globals.versionRequired
            bannerManager.banners                   = lotteryManager.globals.banners

            time.setServerTime(response.serverTime)

            utils.get( SAILS_URL .. "/api/charity/levels", function(result)

                CHARITY_LEVELS = json.decode(result.response)
                utils.get( SAILS_URL .. "/api/ambassador/levels", function(result)
                    AMBASSADOR_LEVELS = json.decode(result.response)

                    if(APP_VERSION >= VERSION_REQUIRED) then
                        onGoodVersion()
                    else
                        print("onBadVersion")
                        onBadVersion()
                    end

                end)
            end)
        end
    end)
end

--------------------------------------------------------------------------------

function UserManager:fetchPlayer(next)
    native.setActivityIndicator( true )

    userManager.user.fanBonusTickets        = 0
    userManager.user.charityBonusTickets    = 0
    userManager.user.ambassadorBonusTickets = 0

    self.attemptFetchPlayer = self.attemptFetchPlayer + 1

    utils.put( SAILS_URL .. "/api/user/fetch", {
        country       = COUNTRY,
        mobileVersion = APP_VERSION
    },
    function(result)

        if(result.isError) then

            if(self.attemptFetchPlayer < 5) then
                utils.tprint(result)
                print("--> try again fetchPlayer")
                timer.performWithDelay(1000, function() userManager:fetchPlayer() end)

            else
                print("fetchPlayer error : outside")
                native.setActivityIndicator( false )
                router.openOutside()

            end

        else
            native.setActivityIndicator( false )

            self.attemptFetchPlayer = 0

            local player = json.decode(result.response)
            if(not player) then
                print("fetchPlayer no player : outside")
                router.openOutside()

            else
                userManager:receivedPlayer(player, function()
                    if(next) then
                        next()
                    else
                        router.openHome()
                    end
                end)
            end
        end
    end)

end

--------------------------------------------------------------------------------

function UserManager:readPlayer(next)
    native.setActivityIndicator( true )
    utils.get( SAILS_URL .. "/api/user", function(result)
        native.setActivityIndicator( false )
        local newData       = json.decode(result.response)
        self.user.userName  = newData.userName
        self.user.firstName = newData.firstName
        self.user.lastName  = newData.lastName
        self.user.birthDate = newData.birthDate
        self.user.email     = newData.email
        self.user.passports = newData.passports
        self.user.networks  = newData.networks
        self:refreshBonusTickets(next)
    end)

end

--------------------------------------------------------------------------------

function UserManager:receivedPlayer(player, next)

    native.setActivityIndicator( false )

    if(next == router.openHome) then
        viewManager.message(T "Welcome" .. " " .. player.userName .. " !")
    end

    ------------------------------------------------------------------
    -- backup transient data

    local totalWinnings         = self.user.totalWinnings       or 0
    local balance               = self.user.balance             or 0
    local pendingWinnings       = self.user.pendingWinnings     or 0
    local receivedWinnings      = self.user.receivedWinnings    or 0
    local totalGift             = self.user.totalGift           or 0

    ------------------------------------------------------------------
    -- retrieve data from server

    self.user = player

    ------------------------------------------------------------------
    -- put transient back

    self.user.totalWinnings    = self.user.totalWinnings       or totalWinnings
    self.user.balance          = self.user.balance             or balance
    self.user.pendingWinnings  = self.user.pendingWinnings     or pendingWinnings
    self.user.receivedWinnings = self.user.receivedWinnings    or receivedWinnings
    self.user.totalGift        = self.user.totalGift           or totalGift

    ------------------------------------------------------------------

    GLOBALS.savedData.user.uid           = player.uid
    GLOBALS.savedData.user.email         = player.email
    GLOBALS.savedData.user.userName      = player.userName
    GLOBALS.savedData.user.firstName     = player.firstName
    GLOBALS.savedData.user.lastName      = player.lastName
    GLOBALS.savedData.user.birthDate     = player.birthDate
    GLOBALS.savedData.user.referrerId    = player.referrerId
    GLOBALS.savedData.user.sponsorcode   = player.sponsorcode

    utils.saveTable(GLOBALS.savedData, "savedData.json")

    ------------------------------------------------------------------

    if(self.user.notifications) then
        self:checkNotifications()
    else
        self.user.notifications = {
            prizes   = 0,
            instants = 0,
            stocks   = 0
        }
    end

    ------------------------------------------------------------------

    if(player.newDrawing) then
        lotteryManager:refreshDeviceNotifications()
    end

    self:refreshBonusTickets(next)
end

--------------------------------------------------------------------------------

function UserManager:mayCashout(next)

    local min = lotteryManager.globals.minEuro
    if(not utils.isEuroCountry(COUNTRY)) then
        min = lotteryManager.globals.minUSD
    end

    return self.user.balance >= min
end

--------------------------------------------------------------------------------

function UserManager:refreshBonusTickets(next)
    self.user.fanBonusTickets        = 0
    self.user.charityBonusTickets    = 0
    self.user.ambassadorBonusTickets = 0

    self:setCharityBonus()
    self:setAmbassadorBonus()
    self:checkNetworksBonuses()

    next()
end

--------------------------------------------------------------------------------

function UserManager:setCharityBonus()
    local level = self:charityLevel()
    self.user.charityBonusTickets = self.user.charityBonusTickets + CHARITY_LEVELS[level].bonus
end

--------------------------------------------------------------------------------

function UserManager:setAmbassadorBonus()
    local level = self:ambassadorLevel()
    self.user.ambassadorBonusTickets = self.user.ambassadorBonusTickets + AMBASSADOR_LEVELS[level].bonus
end

--------------------------------------------------------------------------------

function UserManager:charityLevel()
    if(self.user.playedTickets == 0) then
       return CHARITY_LEVELS[1].level
    end

    for i = #CHARITY_LEVELS, 1, -1 do
        if(self.user.playedTickets >= tonumber(CHARITY_LEVELS[i].reach)) then
            return CHARITY_LEVELS[i].level
        end
    end
end

--------------------------------------------------------------------------------

function UserManager:ambassadorLevel()
    if(self.user.godChildren == 0) then
       return AMBASSADOR_LEVELS[1].level
    end

    for i = #AMBASSADOR_LEVELS, 1, -1 do
            if(self.user.godChildren >= tonumber(AMBASSADOR_LEVELS[i].reach)) then
            return AMBASSADOR_LEVELS[i].level
        end
    end
end

--------------------------------------------------------------------------------

function UserManager:checkNetworksBonuses()

    if(self.user.networks.isFan) then
        self.user.fanBonusTickets = self.user.fanBonusTickets + FACEBOOK_FAN_TICKETS
    end

    if(self.user.networks.connectedToFacebook) then
        self.user.fanBonusTickets = self.user.fanBonusTickets + FACEBOOK_CONNECTION_TICKETS
    end

    if(self.user.networks.isFollower) then
        self.user.fanBonusTickets = self.user.fanBonusTickets + TWITTER_FAN_TICKETS
    end

    if(self.user.networks.connectedToTwitter) then
        self.user.fanBonusTickets = self.user.fanBonusTickets + TWITTER_CONNECTION_TICKETS
    end

end

--------------------------------------------------------------------------------

function UserManager:missingInfo()
    if(not self.user.email) then
        return T 'Please check your email'
    end

    if(not self.user.firstName) then
        return T 'Please check your first name'
    end

    if(not self.user.lastName) then
        return T 'Please check your last name'
    end

    if(not self.user.birthDate) then
        return T 'Please check your birthdate'
    end

    return false
end

--------------------------------------------------------------------------------

function UserManager:cashout(next)
    utils.get( SAILS_URL .. "/api/cashout", function(result)
        self:fetchPlayer(next)
    end)
end

--------------------------------------------------------------------------------

function UserManager:loadMoreTickets(skip, next)
    utils.get( SAILS_URL .. "/api/ticket/" .. skip, function(result)
        local response = json.decode(result.response);
        local tickets = response.tickets;
        local lotteries = response.lotteries;

        for t = 1, #tickets do
            for l = 1, #lotteries do
                if(tickets[t].lottery == lotteries[l].uid) then
                    tickets[t].lottery = lotteries[l]
                    break
                end
            end
        end

        utils.appendToTable(userManager.tickets, tickets)

        -- loadMoreTickets + attemptFetchTicket + MyTickets (with first etc)
        -- would need a clean refacto !!!!!!!
        --> #uglyAndNotReadableButItWorks
        if( self.attemptFetchTicket ) then
            next(tickets)
        else
            self.attemptFetchTicket = true;
            next(userManager.tickets)
        end

    end)
end

--------------------------------------------------------------------------------

function UserManager:storeLotteryTicket(numbers)

    native.setActivityIndicator( true )

    utils.post( SAILS_URL .. "/api/ticket/", {
        numbers = numbers,
    },
    function(result)
        native.setActivityIndicator( false )
        local response = json.decode(result.response)
        if(response == 'too late') then
            gameManager:open()
            viewManager.message(T "Waiting for drawing")
        else

            local setupDeviceNotification = function()
                local secondsToWait = lotteryManager.nextDrawing.ticketTimer * 60

                appManager:deviceNotification(
                    T 'You can fill out a new ticket !',
                    math.floor(secondsToWait),
                    'ticket-ready'
                )
            end

            if(userManager.hasUsedTimer) then
                userManager.hasUsedTimer = false
                self:giftInstants(-1, function()
                    setupDeviceNotification()
                end, true)
            else
                setupDeviceNotification()
            end

            table.insert(self.tickets, 1, response)
            self.user.lastTicketTime = response.timestamp
            lotteryManager:showLastTicket()
        end
    end)

    --- just to be sync waiting the post result
    -- updating availableTickets DURING popup display
    self.user.availableTickets = self.user.availableTickets - 1

end

--------------------------------------------------------------------------------

function UserManager:updatePlayer(next)

    self.user.lang      = LANG
    self.user.passports = nil
    self.user.tickets   = nil

    utils.put( SAILS_URL .. "/api/user/update", {
        user = self.user,
    }, next)

end

--------------------------------------------------------------------------------

function UserManager:hasTicketsToPlay()
    return self:remainingTickets()  > 0
end

function UserManager:remainingTickets()
    return self.user.availableTickets
            + self.user.temporaryBonusTickets
            + self.user.fanBonusTickets
            + self.user.charityBonusTickets
            + self.user.ambassadorBonusTickets
            - self.user.playedBonusTickets
end

function UserManager:totalAvailableTickets()
    return lotteryManager.nextDrawing.startTickets
            + self.user.temporaryBonusTickets
            + self.user.fanBonusTickets
            + self.user.charityBonusTickets
            + self.user.ambassadorBonusTickets
end

--------------------------------------------------------------------------------

function UserManager:checkTicketTiming()
    local lastTime  = self.user.lastTicketTime
    local now       = time.now()

    local spentMillis = now - lastTime
    local h,m,s,ms = utils.getHoursMinSecMillis(spentMillis)
    print('checkTicketTiming lastTime : ' .. lastTime)
    if(tonumber(spentMillis) >= (lotteryManager.nextLottery.ticketTimer * 60 * 1000)) then
        print('TRUE : ' .. spentMillis)
        return true
    else
        self:openTimerPopup(lastTime)
        return false
    end

end

--------------------------------------------------------------------------------

function UserManager:passport(provider)
    if(self.user.passports) then
        for i = 1, #self.user.passports do
            if(self.user.passports[i].provider == provider) then
                return self.user.passports[i]
            end
        end
    end

    return nil
end

--------------------------------------------------------------------------------

function UserManager:logout()
    gameManager.initGameData()
    router.openOutside()
end

--------------------------------------------------------------------------------
-- NOTIFICATIONS
--------------------------------------------------------------------------------

function UserManager:checkNotifications()
    self:notifyPrizes(function()
        self:notifyStocks(function()
            if(self.user.notifications.instants > 0) then
                self:notifyInstants(self.user.notifications.instants)
            end
        end)
    end)
end

--------------------------------------------------------------------------------

function UserManager:notifyPrizes(next)
    if(self.user.notifications.prizes == 0) then
        next()
    else
        local totalPrice = ""
        if(utils.isEuroCountry(COUNTRY)) then
            totalPrice = self.user.notifications.prizes
        else
            totalPrice = self.user.notifications.prizesUSD
        end

        totalPrice = utils.displayPrice(totalPrice, COUNTRY)

        ----------------------------------------

        local popup = viewManager.showPopup(display.contentWidth*0.95, true)

        ----------------------------------------

        popup.bg   = display.newImage( popup, "assets/images/icons/notification/BG_Money.png")
        popup.bg.x = display.contentWidth*0.5
        popup.bg.y = display.contentHeight*0.5

        ----------------------------------------

        popup.congratz   = display.newImage( popup, I "popup.Txt1.png")
        popup.congratz.x = display.contentWidth*0.5
        popup.congratz.y = display.contentHeight*0.35

        popup.earnText      = viewManager.newText({
            parent   = popup,
            text     = T "You have won" .. " :",
            fontSize = 55,
            x        = display.contentWidth * 0.5,
            y        = display.contentHeight*0.42,
        })

        popup.prizeText = viewManager.newText({
            parent   = popup,
            text     = totalPrice,
            fontSize = 55,
            anchorX  = 1,
            anchorY  = 0.5,
            x        = display.contentWidth * 0.5,
            y        = display.contentHeight*0.53,
        })

        popup.iconPrize   = display.newImage( popup, "assets/images/icons/notification/prizes.popup.png")
        popup.iconPrize.x = display.contentWidth*0.64
        popup.iconPrize.y = display.contentHeight*0.53

        --------------------------

        if(userManager.user.networks.connectedToFacebook) then
            popup.share   = display.newImage( popup, I "share.notification.png")
            popup.share.x = display.contentWidth*0.5
            popup.share.y = display.contentHeight*0.68

            utils.onTouch(popup.share, function() shareManager:shareWinningsOnWall(totalPrice, popup) end)
        end

        ---------------------------------------------------------------

        popup.close   = display.newImage( popup, "assets/images/hud/CroixClose.png")
        popup.close.x = display.contentWidth*0.89
        popup.close.y = display.contentHeight*0.55 - display.contentWidth*0.95/2

        utils.onTouch(popup.close, function()
            viewManager.closePopup(popup, true, next)
        end)

    end
end

--------------------------------------------------------------------------------

function UserManager:notifyStocks(next)

    if(self.user.notifications.stocks == 0) then
        next()
    else
        ----------------------------------------

        local popup = viewManager.showPopup(display.contentWidth*0.95, true)

        ----------------------------------------

        popup.bg   = display.newImage( popup, "assets/images/icons/notification/BG_Bonus.png")
        popup.bg.x = display.contentWidth*0.5
        popup.bg.y = display.contentHeight*0.5

        ----------------------------------------

        popup.congratz   = display.newImage( popup, I "popup.Txt1.png")
        popup.congratz.x = display.contentWidth*0.5
        popup.congratz.y = display.contentHeight*0.35

        popup.earnText = viewManager.newText({
            parent   = popup,
            text     = T "You have won" .. " :",
            fontSize = 55,
            x        = display.contentWidth * 0.5,
            y        = display.contentHeight*0.42,
        })

        popup.prizeText = viewManager.newText({
            parent   = popup,
            text     = self.user.notifications.stocks,
            fontSize = 75,
            anchorX  = 1,
            anchorY  = 0.5,
            x        = display.contentWidth * 0.44,
            y        = display.contentHeight*0.52,
        })

        popup.iconTicket   = display.newImage( popup, "assets/images/icons/notification/stocks.popup.png")
        popup.iconTicket.x = display.contentWidth*0.57
        popup.iconTicket.y = display.contentHeight*0.53

        --------------------------

        popup.close   = display.newImage( popup, I "popup.Bt_close.png")
        popup.close.x = display.contentWidth*0.5
        popup.close.y = display.contentHeight*0.7

        utils.onTouch(popup.close, function()
            viewManager.closePopup(popup, true, next)
        end)

        ----------------------------------------

        self.user.notifications.stocks = 0
    end
end

--------------------------------------------------------------------------------

function UserManager:giftInstants(nbInstants, next, doNotNotify)
    self.user.extraTickets = self.user.extraTickets + nbInstants
    self:updatePlayer(function()
        viewManager.refreshHeaderContent()
        if(not doNotNotify) then
            self:notifyInstants(nbInstants, function()
                if(next) then
                    next()
                end
            end)

        else
            if(next) then
                next()
            end
        end
    end)

end

--------------------------------------------------------------------------------

function UserManager:giftStock(nbStock, next)
    self.user.notifications.stocks = nbStock
    self:notifyStocks(function()
        viewManager.refreshHeaderContent()
        if(next) then
            next()
        end
    end)
end

--------------------------------------------------------------------------------

function UserManager:notifyInstants(num, next)

    local popup = viewManager.showPopup(display.contentWidth*0.95, true)

    ----------------------------------------

    popup.bg   = display.newImage( popup, "assets/images/icons/notification/BG_Instant.png")
    popup.bg.x = display.contentWidth*0.5
    popup.bg.y = display.contentHeight*0.5

    ----------------------------------------

    popup.congratz   = display.newImage( popup, I "popup.Txt1.png")
    popup.congratz.x = display.contentWidth*0.5
    popup.congratz.y = display.contentHeight*0.35

    popup.earnText = viewManager.newText({
        parent   = popup,
        text     = T "You have won" .. " :",
        fontSize = 55,
        x        = display.contentWidth * 0.5,
        y        = display.contentHeight*0.42,
    })

    popup.prizeText = viewManager.newText({
        parent   = popup,
        text     = num,
        fontSize = 75,
        anchorX  = 1,
        anchorY  = 0.5,
        x        = display.contentWidth * 0.44,
        y        = display.contentHeight*0.52,
    })

    popup.iconTicket   = display.newImage( popup, "assets/images/icons/notification/instants.popup.png")
    popup.iconTicket.x = display.contentWidth*0.57
    popup.iconTicket.y = display.contentHeight*0.53

    --------------------------

    popup.close   = display.newImage( popup, "assets/images/hud/CroixClose.png")
    popup.close.x = display.contentWidth*0.89
    popup.close.y = display.contentHeight*0.55 - display.contentWidth*0.95/2

    utils.onTouch(popup.close, function()
        viewManager.closePopup(popup)
    end)

    -- @TIMER_ASSETS
    popup.play   = display.newImage( popup, I "play.png")
    popup.play.x = display.contentWidth*0.5
    popup.play.y = display.contentHeight*0.7

    utils.onTouch(popup.play, function()
        viewManager.closePopup(popup)
    end)

    --------------------------

    if(next) then
        next()
    end
end

--------------------------------------------------------------------------------

function UserManager:openPrizes()

    local top   = display.contentHeight * 0.35
    local yGap  = display.contentHeight * 0.082

    local popup = viewManager.showPopup()

    --------------------------

    hud.picto   = display.newImage(popup, "assets/images/icons/PrizeTitle.png")
    hud.picto.x = display.contentWidth*0.14
    hud.picto.y = display.contentHeight*0.15
    hud.picto:scale(0.7,0.7)

    hud.title       = display.newImage(popup, I "Prize.png")

    hud.title.anchorX = 0
    hud.title.anchorY = 0.5
    hud.title.x       = display.contentWidth*0.22
    hud.title.y       = display.contentHeight*0.15

    hud.sep   = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x = display.contentWidth*0.5
    hud.sep.y = display.contentHeight*0.2

    --------------------------

    viewManager.newText({
        parent   = popup,
        text     = T "Match",
        x        = display.contentWidth*0.45,
        y        = display.contentHeight * 0.255,
        fontSize = 32,
        font     = NUM_FONT
    })

    viewManager.newText({
        parent   = popup,
        text     = T "Prize",
        x        = display.contentWidth * 0.8,
        y        = display.contentHeight * 0.24,
        fontSize = 32,
        font     = NUM_FONT
    })

    viewManager.newText({
        parent   = popup,
        text     = T "breakdown",
        x        = display.contentWidth * 0.8,
        y        = display.contentHeight * 0.27,
        fontSize = 32,
        font     = NUM_FONT
    })

    local matches  = lotteryManager.nextDrawing.rangs.matches[LANG]
    local percents = lotteryManager.nextDrawing.rangs.percents

    for i = 1, #matches do

        hud.iconRang    = display.newImage( popup, "assets/images/icons/rangs/R".. i .. ".png")
        hud.iconRang.x   = display.contentWidth * 0.2
        hud.iconRang.y   = top + yGap * (i-1)

        viewManager.newText({
            parent   = popup,
            text     = matches[i],
            x        = display.contentWidth*0.45,
            y        = top + yGap * (i-1) ,
            fontSize = 35,
        })

        viewManager.newText({
            parent   = popup,
            text     = percents[i] .. '%',
            x        = display.contentWidth*0.75,
            y        = top + yGap * (i-1) ,
            fontSize = 35,
        })

        hud.iconPieces   = display.newImage( popup, "assets/images/icons/PictoPrize.png")
        hud.iconPieces.x = display.contentWidth * 0.86
        hud.iconPieces.y = top + yGap * (i-1) - display.contentHeight*0.0005

    end

    ---------------------------------------------------------------

    local lastUpdatedPrizes = translate(lotteryManager.globals.lastUpdatedPrizes)

    viewManager.newText({
        parent      = popup,
        text        = lastUpdatedPrizes,
        x           = display.contentWidth*0.1,
        y           = display.contentHeight * 0.88,
        fontSize    = 26,
        font        = FONT,
        anchorX     = 0,
        anchorY     = 0.5,
    })

    viewManager.newText({
        parent      = popup,
        text        = "* " .. T "Lucky Ball",
        x           = display.contentWidth*0.1,
        y           = display.contentHeight * 0.91,
        fontSize    = 26,
        font        = FONT,
        anchorX     = 0,
        anchorY     = 0.5,
    })

    ---------------------------------------------------------------

    popup.close         = display.newImage( popup, "assets/images/hud/CroixClose.png")
    popup.close.x       = display.contentWidth*0.89
    popup.close.y       = display.contentHeight*0.085

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

end

--------------------------------------------------------------------------------

function UserManager:openTimerPopup(lastTime)

    local popup = viewManager.showPopup()
    userManager.hasUsedTimer = false

    ----------------------------------------------------------------------------

    popup.bgImage   = display.newImage( popup, "assets/images/hud/home/timer.bg.png")
    popup.bgImage.x = display.contentWidth*0.5
    popup.bgImage.y = display.contentHeight*0.5

    ----------------------------------------------------------------------------
    --                             Header
    ----------------------------------------------------------------------------

    local headerY = popup.bg.y - popup.bg.contentHeight*0.5

    popup.header         = display.newImageRect(popup, "assets/images/hud/timer/timer.header.png", popup.bg.contentWidth*0.9583, display.viewableContentHeight*0.08)
    popup.header.anchorY = 0
    popup.header.x       = display.contentWidth*0.5
    popup.header.y       = headerY

    local headerContentY = headerY + popup.header.contentHeight*0.5

    ----------------------------------------------------------------------------

    popup.box1   = display.newImage( popup, "assets/images/hud/timer/timer.box.png")
    popup.box1.x = display.contentWidth*0.29
    popup.box1.y = headerContentY

    popup.icon1   = display.newImage( popup, "assets/images/hud/timer/timer.ticket.png")
    popup.icon1.x = popup.box1.x - popup.box1.contentWidth*0.5
    popup.icon1.y = headerContentY

    popup.button1   = display.newImage( popup, "assets/images/hud/timer/timer.plus.png")
    popup.button1.x = popup.box1.x + popup.box1.contentWidth*0.32
    popup.button1.y = headerContentY

    popup.availableTickets = viewManager.newText({
        parent   = popup,
        text     = self:remainingTickets() .. " / " .. self:totalAvailableTickets(),
        fontSize = 45,
        anchorX  = 1,
        anchorY  = 0.6,
        x        = popup.button1.x - popup.button1.contentWidth*0.55,
        y        = popup.button1.y
    })

    ----------------------------------------------------------------------------

    popup.box2   = display.newImage( popup, "assets/images/hud/timer/timer.box.png")
    popup.box2.x = display.contentWidth*0.73
    popup.box2.y = headerContentY

    popup.icon2   = display.newImage( popup, "assets/images/hud/timer/timer.booster.png")
    popup.icon2.x = popup.box2.x - popup.box2.contentWidth*0.5
    popup.icon2.y = headerContentY

    popup.button2   = display.newImage( popup, "assets/images/hud/timer/timer.plus.png")
    popup.button2.x = popup.box2.x + popup.box2.contentWidth*0.32
    popup.button2.y = headerContentY

    popup.extraTickets = viewManager.newText({
        parent   = popup,
        text     = self.user.extraTickets,
        fontSize = 45,
        anchorX  = 1,
        anchorY  = 0.6,
        x        = popup.button2.x - popup.button2.contentWidth*0.55,
        y        = headerContentY
    })

    ----------------------------------------------------------------------------

    utils.onTouch(popup.button1, function()
        shareManager:moreTickets(popup)
    end)

    utils.onTouch(popup.button2, function()
        shareManager:shareForInstants(popup)
    end)

    ----------------------------------------------------------------------------
    --                             Content
    ----------------------------------------------------------------------------

    popup.multiLineText = display.newText({
        parent   = popup,
        text     = T "You can fill out a new Ticket in :",
        width    = display.contentWidth*0.85,
        height   = display.contentHeight*0.25,
        x        = display.contentWidth*0.5,
        y        = display.contentHeight*0.345,
        font     = FONT,
        fontSize = 47,
        align    = "center",
    })

    popup.multiLineText:setFillColor(0)

    popup.pictoTimer   = display.newImage( popup, "assets/images/hud/home/timer.timer.png")
    popup.pictoTimer.x = display.contentWidth*0.37
    popup.pictoTimer.y = display.contentHeight*0.31

    popup.timerDisplay = viewManager.newText({
        parent   = popup,
        text     = '',
        x        = display.contentWidth*0.57,
        y        = display.contentHeight*0.305,
        fontSize = 53,
        font     = NUM_FONT
    })

    viewManager.refreshPopupTimer(popup, lastTime)

    -------------------------------

    local timerLegendY   = display.contentHeight*0.335
    local timerLegendSize  = 22

    popup.minText = viewManager.newText({
        parent   = popup,
        text     = T "MIN",
        x        = display.contentWidth*0.5,
        y        = timerLegendY,
        fontSize = timerLegendSize,
    })

    popup.secText = viewManager.newText({
        parent   = popup,
        text     = T "SEC",
        x        = display.contentWidth*0.638,
        y        = timerLegendY,
        fontSize = timerLegendSize,
    })

    ----------------------------------------------------

    popup.textor1   = display.newImage( popup, I "timer.or.png")
    popup.textor1.x = display.contentWidth*0.5
    popup.textor1.y = display.contentHeight*0.4

    ----------------------------------------------------

    popup.playNow   = display.newImage( popup, I "timer.play.png")
    popup.playNow.x = display.contentWidth*0.5
    popup.playNow.y = display.contentHeight*0.52

    utils.onTouch(popup.playNow, function()

        if(self.user.extraTickets > 0) then

            display.remove(popup.multiLineText)
            display.remove(popup.minText)
            display.remove(popup.secText)
            display.remove(popup.pictoTimer)
            display.remove(popup.playNow)
            display.remove(popup.textor1)
            display.remove(popup.textor2)
            display.remove(popup.increase)
            display.remove(popup.close)

            transition.to(popup.timerDisplay, {
                x = display.contentWidth*0.5,
                y = display.contentHeight*0.5,
                xScale = 1.8,
                yScale = 1.8
            })

            viewManager.countdownTimer(function()
                userManager.hasUsedTimer = true
                viewManager.closePopup(popup)
                gameManager:startTicket()
            end)

        else
            shareManager:shareForInstants(popup)
        end

    end)

    ----------------------------------------------------

    popup.textor2   = display.newImage( popup, I "timer.or.png")
    popup.textor2.x = display.contentWidth*0.5
    popup.textor2.y = display.contentHeight*0.63

    --------------------------

    popup.increase   = display.newImage( popup, I "timer.jackpot.png")
    popup.increase.x = display.contentWidth*0.5
    popup.increase.y = display.contentHeight*0.74

    utils.onTouch(popup.increase, function()
        analytics.event("Gaming", "increaseJackpot")
        viewManager.closePopup(popup)
        videoManager:play(function()
             userManager:openIncreaseConfirmation()
        end, true)
    end)

    --------------------------

    popup.close   = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x = display.contentWidth*0.5
    popup.close.y = display.contentHeight*0.89

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)
end

----------------------------------------

function UserManager:openIncreaseConfirmation()

    ---------------------------------------------------------------

    local height    = display.contentHeight * 0.8
    local top       = (display.contentHeight - height) * 0.5
    local yGap      = display.contentHeight * 0.082

    local popup     = viewManager.showPopup(height, false, true)

    ---------------------------------------------------------------

--    popup.bg                = display.newImage( popup, "assets/images/hud/home/BG_adillions.png")
--    popup.bg.x              = display.contentWidth*0.5
--    popup.bg.y              = display.contentHeight*0.5

    popup.schema            = display.newImage( popup, "assets/images/hud/confirmation/increase.schema.png")
    popup.schema.x          = display.contentWidth*0.5
    popup.schema.y          = top + height*0.15

    popup.multiLineText = display.newText({
        parent      = popup,
        text        = T "You successfully contributed to increase the Prize Fund and the Charity Fund",
        width       = display.contentWidth*0.75,
        height      = height*0.4,
        x           = display.contentWidth*0.5,
        y           = top + height*0.6,
        anchorY     = 0,
        font        = FONT,
        fontSize    = 50,
        align       = "center"
    })

    popup.multiLineText:setFillColor(0)

    popup.congratz          = display.newImage( popup, I "increase.congratulations.png")
    popup.congratz.x        = display.contentWidth*0.5
    popup.congratz.y        = top + height*0.3

    ---------------------------------------------------------------

    popup.increase         = display.newImage( popup, I "increase.again.png")
    popup.increase.x       = display.contentWidth*0.5
    popup.increase.y       = top + height * 0.79

    utils.onTouch(popup.increase, function()
        analytics.event("Gaming", "increaseJackpotAgain")
        videoManager:play(function()
             viewManager.closePopup(popup)
             userManager:openIncreaseConfirmation()
        end, true)
    end)

    ---------------------------------------------------------------

    popup.textBottom = display.newText({
        parent      = popup,
        text        = T "You should not use this feature without a free connection (cf. terms)",
        x           = display.contentWidth*0.1,
        y           = top + height - display.contentHeight * 0.03,
        font        = FONT,
        fontSize    = 23
    })

    popup.textBottom.anchorX = 0
    popup.textBottom.anchorY = 1
    popup.textBottom:setFillColor(0)

    ---------------------------------------------------------------

    popup.close         = display.newImage( popup, "assets/images/hud/CroixClose.png")
    popup.close.anchorY = 0
    popup.close.y       = top + display.contentHeight * 0.01
    popup.close.x       = display.contentWidth*0.89

    utils.onTouch(popup.close, function()
        router.openHome()
        viewManager.closePopup(popup)
    end)

end

--------------------------------------------------------------------------------

return UserManager