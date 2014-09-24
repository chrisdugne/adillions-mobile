--------------------------------------------------------------------------------

UserManager = {}

--------------------------------------------------------------------------------

function UserManager:new()

    local object = {
        user               = {},
        attemptFBPlayer    = 0,       -- attemptFBPlayer pour compter les getPlayerByFacebookId pour android reco apres retour app
        attemptFetchPlayer = 0,

        userHasReceivedBonus = false    -- while receiving BT and IT, set to true. One updatedPlayer after all bonus are received
    }

    setmetatable(object, { __index = UserManager })
    return object
end

--------------------------------------------------------------------------------

function UserManager:getGlobals(onGoodVersion, onBadVersion)

    utils.get( NODE_URL .. "/api/globals", function(result)

        if(result.isError) then
            -- android....
            print("globals on error...")
            timer.performWithDelay(2000, function()
                userManager:getGlobals(onGoodVersion, onBadVersion)
            end)

        else

            local response = json.decode(result.response)

            lotteryManager.global                   = response.global
            lotteryManager.global.appStatus         = lotteryManager.global.appStatus
            lotteryManager.global.tweet             = lotteryManager.global.tweet
            lotteryManager.global.tweetTheme        = lotteryManager.global.tweetTheme
            lotteryManager.global.tweetShare        = lotteryManager.global.tweetShare
            lotteryManager.global.fbPost            = lotteryManager.global.fbPost
            lotteryManager.global.fbPostTheme       = lotteryManager.global.fbPostTheme
            lotteryManager.global.fbSharePrize      = lotteryManager.global.fbSharePrize
            lotteryManager.global.sms               = lotteryManager.global.sms
            lotteryManager.global.email             = lotteryManager.global.email
            lotteryManager.global.text48h           = lotteryManager.global.text48h
            lotteryManager.global.text3min          = lotteryManager.global.text3min
            lotteryManager.global.lastUpdatedPrizes = lotteryManager.global.lastUpdatedPrizes

            lotteryManager.global.minEuro           = lotteryManager.global.minMoney.euro
            lotteryManager.global.minUSD            = lotteryManager.global.minMoney.usd

            time.setServerTime(response.serverTime)
            TIMER                                   = lotteryManager.global.lastUpdate or response.serverTime
            VERSION_REQUIRED                        = response.global.versionRequired
            bannerManager.banners                   = lotteryManager.global.banners

            utils.get( NODE_URL .. "/api/charity/levels", function(result)

                CHARITY_LEVELS = json.decode(result.response)
                utils.get( NODE_URL .. "/api/ambassador/levels", function(result)
                    AMBASSADOR_LEVELS = json.decode(result.response)

                    if(APP_VERSION >= VERSION_REQUIRED) then
                        print("onGoodVersion")
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

function UserManager:refreshPlayer()
    gameManager:open()
end

--------------------------------------------------------------------------------

function UserManager:fetchPlayer()

    print("fetchPlayer")
    native.setActivityIndicator( true )

    userManager.user.fanBonusTickets        = 0
    userManager.user.charityBonusTickets    = 0
    userManager.user.ambassadorBonusTickets = 0

    self.attemptFetchPlayer = self.attemptFetchPlayer + 1

    utils.postWithJSON({
        mobileVersion = APP_VERSION,
        country       = COUNTRY
    },
    API_URL .. "player",
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
                print("receivedPlayer")
                userManager:receivedPlayer(player, function()
                    print("fetch success, openHOme")
                    router.openHome()
                end)
            end
        end
    end
    )

end

--------------------------------------------------------------------------------

function UserManager:getPlayerByFacebookId()

    native.setActivityIndicator( true )
    print("getPlayerByFacebookId")
    self.attemptFBPlayer = self.attemptFBPlayer + 1

    utils.postWithJSON({
        mobileVersion   = APP_VERSION,
        country         = COUNTRY,
        facebookData    = facebook.data,
        accessToken     = GLOBALS.savedData.facebookAccessToken
    },
    API_URL .. "playerFromFB",
    function(result)
        print("received PlayerByFacebookId")

        if(result.status < 0 and self.attemptFBPlayer < 3) then
            print("--> try again getPlayerByFacebookId")
            timer.performWithDelay(1000, function() userManager:getPlayerByFacebookId() end)
        else
            native.setActivityIndicator( false )
            self.attemptFBPlayer = 0

            if(result.isError) then
                print("--> error = signinFB")
                signinManager:openSigninFB()

            elseif(result.status == 401 or result.status == '401') then
                print("--> 401 = signinFB")
                signinManager:openSigninFB()
            else
                print("--> test player")
                response        = json.decode(result.response)
                local player       = response.player
                GLOBALS.savedData.authToken  = response.authToken

                userManager:receivedPlayer(player, router.openHome)
            end
        end

    end
    )

end

--------------------------------------------------------------------------------

function UserManager:loadMoreTickets(lastLotteryUID, onReceivedTickets)
    utils.postWithJSON({
            lastLotteryUID = lastLotteryUID
        },
        API_URL .. "lotteryTickets",
        function(result)
            onReceivedTickets(json.decode(result.response))
        end
    )
end

--------------------------------------------------------------------------------

function UserManager:checkExistPlayerByFacebookId(proceedWithMerge, connectionSuccessful, beforeForceLogin)

    native.setActivityIndicator( true )
    print("checkExistPlayerByFacebookId")

    utils.postWithJSON({
        facebookData = facebook.data,
    },
    API_URL .. "isMeFBPlayer",
    function(result)
        native.setActivityIndicator( false )

        if(result.isError) then
            timer.performWithDelay(1000, function() userManager:checkExistPlayerByFacebookId(proceedWithMerge, connectionSuccessful, beforeForceLogin) end)
        else
            local response = json.decode(result.response)
            local uid = response.uid
            print("--> uid " .. uid)

            if(uid == 'free') then
                proceedWithMerge() -- contains connectionSuccessful for next step

            elseif(uid == self.user.uid) then
                connectionSuccessful()

            else
                twitter.logout()
                beforeForceLogin()
                gameManager:tryAutoOpenFacebookAccount()
            end
        end
    end
    )

end

--------------------------------------------------------------------------------

function UserManager:receivedPlayer(player, next)

    print('------->  ' .. player.godChildren)
    native.setActivityIndicator( false )

    if(next == router.openHome) then
        sponsorpayTools:init(player.uid)
        viewManager.message(T "Welcome" .. " " .. player.userName .. " !")
    end

    self:updatedPlayer(player, next)
end

--------------------------------------------------------------------------------

function UserManager:updatedPlayer(player, next)

    print("------------------------ updatedPlayer ")

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

    self.user.totalWinnings         = self.user.totalWinnings       or totalWinnings
    self.user.balance               = self.user.balance             or balance
    self.user.pendingWinnings       = self.user.pendingWinnings     or pendingWinnings
    self.user.receivedWinnings      = self.user.receivedWinnings    or receivedWinnings
    self.user.totalGift             = self.user.totalGift           or totalGift

    ------------------------------------------------------------------

    GLOBALS.savedData.user.uid              = player.uid
    GLOBALS.savedData.user.email            = player.email
    GLOBALS.savedData.user.userName         = player.userName
    GLOBALS.savedData.user.firstName        = player.firstName
    GLOBALS.savedData.user.lastName         = player.lastName
    GLOBALS.savedData.user.birthDate        = player.birthDate
    GLOBALS.savedData.user.referrerId       = player.referrerId
    GLOBALS.savedData.user.sponsorCode      = player.sponsorCode
    GLOBALS.savedData.user.facebookId       = player.facebookId
    GLOBALS.savedData.user.twitterId        = player.twitterId
    GLOBALS.savedData.user.twitterName      = player.twitterName
    GLOBALS.savedData.user.isFacebookFan    = player.isFacebookFan
    GLOBALS.savedData.user.isTwitterFan     = player.isTwitterFan

    utils.saveTable(GLOBALS.savedData, "savedData.json")

    ------------------------------------------------------------------

    if(self.user.notifications) then
        self.user.notifications = json.decode(self.user.notifications)
        self:checkNotifications()
    else
        self.user.notifications = {
            prizes      = 0,
            instants    = 0,
            stocks      = 0
        }
    end

    ------------------------------------------------------------------

    self:refreshBonusTickets(next)
end

--------------------------------------------------------------------------------

function UserManager:refreshBonusTickets(next)

    print("-------------------------- refreshBonusTickets ")
    self.user.fanBonusTickets       = 0
    self.user.charityBonusTickets   = 0
    self.user.ambassadorBonusTickets   = 0

    self:setCharityBonus()
    self:setAmbassadorBonus()

    self:checkFanStatus(function()
        --- NOTE : pour remettre le OG theme il faut virer le next d'ici et decommenter checkThemeLiked
        -- facebook.checkThemeLiked(next)
        if(next) then
            next()
        end
    end)



end

--------------------------------------------------------------------------------

function UserManager:checkExistingUser(connectionSuccessful, beforeForceLogin)
    self:checkExistPlayerByFacebookId(function()
        self:showConfirmMerge(connectionSuccessful)
    end, connectionSuccessful, beforeForceLogin)
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
    for i = #CHARITY_LEVELS, 1, -1 do
        if(self.user.totalPlayedTickets >= tonumber(CHARITY_LEVELS[i].reach)) then
            return CHARITY_LEVELS[i].level
        end
    end
end

--------------------------------------------------------------------------------

function UserManager:ambassadorLevel()
    for i = #AMBASSADOR_LEVELS, 1, -1 do
        if(self.user.godChildren >= tonumber(AMBASSADOR_LEVELS[i].reach)) then
            return AMBASSADOR_LEVELS[i].level
        end
    end
end

--------------------------------------------------------------------------------
-- popup affichee uniquement si facebookId libre pour adillions
-- (sinon on a logout puis login le user FB existant)
-- si confirm : on pose link facebookId,
function UserManager:showConfirmMerge(next)

    -----------------

    local popup = viewManager.showPopup()

    popup.infoBG                    = display.newImage(popup, "assets/images/hud/info.bg.png")
    popup.infoBG.x                  = display.contentWidth*0.5
    popup.infoBG.y                  = display.contentHeight * 0.5

    popup.shareIcon                 = display.newImage( popup, "assets/images/icons/PictoInfo.png")
    popup.shareIcon.x               = display.contentWidth*0.5
    popup.shareIcon.y               = display.contentHeight*0.22

    popup.shareIcon                 = display.newImage( popup, I "watchout.png")
    popup.shareIcon.x               = display.contentWidth*0.5
    popup.shareIcon.y               = display.contentHeight*0.31

    -----------------

    local message = ""
    if(LANG == "fr") then
        message = "Vous allez connecter le compte Facebook " .. facebook.data.name .. " avec le compte Adillions de " .. self.user.firstName
    else
        message = "You are about to connect " .. facebook.data.name .. " Facebook profile with " .. self.user.firstName .. "'s Adillions account"
    end

    popup.multiLineText = display.newText({
        parent          = popup,
        text            = message,
        width           = display.contentWidth*0.6,
        height          = display.contentHeight*0.25,
        x               = display.contentWidth*0.5,
        y               = display.contentHeight*0.5,
        font            = FONT,
        fontSize        = 44,
        align           = "center",
    })

    popup.multiLineText:setFillColor(0)

    -----------------

    popup.confirm       = display.newImage( popup, I "confirm.png")
    popup.confirm.x     = display.contentWidth*0.5
    popup.confirm.y     = display.contentHeight*0.65

    utils.onTouch(popup.confirm, function()
        viewManager.closePopup(popup)
        userManager:mergePlayerWithFacebook(next)
    end)

    -----------------

    popup.close         = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x       = display.contentWidth*0.5
    popup.close.y       = display.contentHeight*0.83

    utils.onTouch(popup.close, function()
        viewManager.message(T "Connection failed")
        viewManager.closePopup(popup)
    end)


end


--------------------------------------------------------------------------------
-- popup affichee uniquement si facebookId pas libre et nouveau compte FB
function UserManager:showWrongAccount()

    -----------------

    local popup = viewManager.showPopup()

    popup.shareIcon    = display.newImage( popup, "assets/images/icons/PictoInfo.png")
    popup.shareIcon.x    = display.contentWidth*0.5
    popup.shareIcon.y   = display.contentHeight*0.22

    popup.shareIcon    = display.newImage( popup, I "Sorry.png")
    popup.shareIcon.x    = display.contentWidth*0.5
    popup.shareIcon.y   = display.contentHeight*0.31

    -----------------

    local message = ""
    local message2 = ""

    if(LANG == "fr") then
        message = "Le compte Adillions de " .. self.user.firstName .. " est déjà lié au profil Facebook de " .. self.user.userName
        message2 = "Il n’est pas possible de connecter plusieurs comptes Facebook au même compte Adillions, veuillez vous connecter avec " .. self.user.userName
    else
        message = "The Adillions account " .. self.user.firstName .. " is already linked to " .. self.user.userName .. " Facebook profile"
        message2 = "It is not possible to connect multiple Facebook profiles to a single Adillions account, please log in with " .. self.user.userName .. " profile"
    end


    popup.multiLineText = display.newText({
        parent = popup,
        text   = message,
        width  = display.contentWidth*0.6,
        height  = display.contentHeight*0.25,
        x    = display.contentWidth*0.5,
        y    = display.contentHeight*0.5,
        font   = FONT,
        fontSize = 38,
        align  = "center",
    })


    popup.multiLineText2 = display.newText({
        parent = popup,
        text   = message2,
        width  = display.contentWidth*0.6,
        height  = display.contentHeight*0.25,
        x    = display.contentWidth*0.5,
        y    = display.contentHeight*0.67,
        font   = FONT,
        fontSize = 38,
        align  = "center",
    })

    popup.multiLineText:setFillColor(0)
    popup.multiLineText2:setFillColor(0)

    -----------------

    popup.close     = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x    = display.contentWidth*0.5
    popup.close.y    = display.contentHeight*0.83

    utils.onTouch(popup.close, function()
        viewManager.closePopup(popup)
    end)

end

--------------------------------------------------------------------------------

function UserManager:checkFanStatus(next)

    print("--------------------------------")
    print("checkFanStatus")

    local facebookFan  = self.user.isFacebookFan
    local twitterFan  = self.user.isTwitterFan

    print(facebookFan, twitterFan)

    if(self.user.facebookId) then
        self.user.fanBonusTickets = self.user.fanBonusTickets + FACEBOOK_CONNECTION_TICKETS
        print("FACEBOOK_CONNECTION fanBonusTickets +" .. FACEBOOK_CONNECTION_TICKETS)
    end

    if(self.user.twitterId) then
        self.user.fanBonusTickets = self.user.fanBonusTickets + TWITTER_CONNECTION_TICKETS
        print("TWITTER_CONNECTION fanBonusTickets +" .. TWITTER_CONNECTION_TICKETS)
    end

    facebook.isFacebookFan(function()
        twitter.isTwitterFan(function(response)

            ---------------------------------------------------------

            if(response) then
                self.user.twitterFan = response.relationship.source.following
            end

            ---------------------------------------------------------

            local statusChanged     = false
            local notifyFBBonus     = false
            local notifyTWBonus     = false

            if(self.user.facebookFan ~= facebookFan) then
                statusChanged = true
                self.user.isFacebookFan = self.user.facebookFan
                notifyFBBonus = true
            end

            if(self.user.twitterFan ~= twitterFan) then
                statusChanged = true
                self.user.isTwitterFan = self.user.twitterFan
                notifyTWBonus = true
            end

            ---------------------------------------------------------

            if(self.user.isFacebookFan) then
                self.user.fanBonusTickets = self.user.fanBonusTickets + FACEBOOK_FAN_TICKETS
                print("FACEBOOK_FAN fanBonusTickets +" .. FACEBOOK_FAN_TICKETS)
            end

            if(self.user.isTwitterFan) then
                self.user.fanBonusTickets = self.user.fanBonusTickets + TWITTER_FAN_TICKETS
                print("TWITTER_FAN fanBonusTickets +" .. TWITTER_FAN_TICKETS)
            end

            ---------------------------------------------------------

            if(statusChanged) then
                self:updateFanStatus(next, notifyFBBonus, notifyTWBonus)

            else
                -- just connected to twitter and not following : bonus = TWITTER_CONNECTION_TICKETS
                if(self.requireTwitterConnectionTickets) then
                    self.requireTwitterConnectionTickets = false
                    userManager:giftStock(TWITTER_CONNECTION_TICKETS, function()
                        if(next) then
                            next()
                        end
                    end)
                else
                    print("just go next after fan status been checked")
                    if(next) then
                        next()
                    end
                end

            end


            ---------------------------------------------------------
        end)
    end)

end

--------------------------------------------------------------------------------

function UserManager:giveToCharity(next)
    viewManager.closePopup(popup)

    print("giveToCharity")
    if(next)then  print("next ready") end
    utils.postWithJSON({},
    API_URL .. "giveToCharity",
    function(result)
        userManager:updatePlayer(next)
    end
    )

end

function UserManager:cashout(next)
    viewManager.closePopup(popup)

    utils.postWithJSON({},
    API_URL .. "cashout",
    function(result)
        userManager:updatePlayer(next)
    end
    )

end

--------------------------------------------------------------------------------

function UserManager:storeLotteryTicket(numbers)

    native.setActivityIndicator( true )
    local extraTicket = self.user.extraTickets > 0

    utils.postWithJSON({
        numbers = numbers,
        extraTicket = extraTicket
    },
    API_URL .. "storeLotteryTicket",
    function(result)
        native.setActivityIndicator( false )
        local player = json.decode(result.response)
        if(player) then
            utils.tprint(player)
            lotteryManager.wasExtraTicket = extraTicket
            userManager:receivedPlayer(player, function()
                lotteryManager:showLastTicket()
            end)
        else
            gameManager:open()
            viewManager.message(T "Waiting for drawing")
        end
    end
    )

    --- just to be sync waiting the post result
    -- updating availableTickets DURING popup display
    if(extraTicket) then
        self.user.extraTickets = self.user.extraTickets - 1
    end

    self.user.availableTickets = self.user.availableTickets - 1

    --- end sync
    -------------

end

--------------------------------------------------------------------------------

function UserManager:updatePlayer(next)

    print("------------- updatePlayer ")
    self.user.lotteryTickets = nil -- just remove all that long json useless for updates (BUG 2014-02-03). it'll be back at server callback.
    self.user.lang = LANG
    self.userBackup = {}

    -- themeLiked is only client side, and fetched at startup
    self.userBackup.themeLiked = self.user.themeLiked

    utils.postWithJSON({
        user = self.user,
    },
    API_URL .. "updatePlayer",
    function(result)

        local player = json.decode(result.response)

        if(player) then
            player.themeLiked = self.userBackup.themeLiked
            userManager:updatedPlayer(player, next)
        else
            print("multiFB")
            analytics.event("Social", "multiFB")

            -- cancel FB connection
            self.user.facebookId     = nil
            GLOBALS.savedData.user.facebookId   = nil
            GLOBALS.savedData.user.facebookName   = nil
            GLOBALS.savedData.facebookAccessToken  = nil
            utils.saveTable(GLOBALS.savedData, "savedData.json")

            self:showMultiAccountPopup(next)
        end


    end)

end

--------------------------------------------------------------------------------

function UserManager:showMultiAccountPopup(next)

    local popup = viewManager.showPopup()

    popup.shareIcon     = display.newImage( popup, "assets/images/icons/PictoInfo.png")
    popup.shareIcon.x    = display.contentWidth*0.5
    popup.shareIcon.y   = display.contentHeight*0.22

    popup.shareText     = display.newImage( popup, I "important.png")
    popup.shareText.x    = display.contentWidth*0.5
    popup.shareText.y   = display.contentHeight*0.32

    -------------------------------------------------------

    local text1 = facebook.data.name .. "'s Facebook account is already an Adillions user"
    if(LANG == "fr") then text1 = "Le compte Facebook " .. facebook.data.name .. " est \n déjà un utilisateur d’Adillions" end

    popup.multiLineText = display.newText({
        parent = popup,
        text   = text1,
        width  = display.contentWidth*0.6,
        height  = display.contentHeight*0.25,
        x    = display.contentWidth*0.5,
        y    = display.contentHeight*0.5,
        font   = FONT,
        fontSize = 38,
        align  = "center",
    })

    popup.multiLineText2 = display.newText({
        parent = popup,
        text   = T "If this is not your Facebook account, you must log out this Facebook session on your device and log in with your own Facebook profile in order to connect your accounts",
        width  = display.contentWidth*0.6,
        height  = display.contentHeight*0.25,
        x    = display.contentWidth*0.5,
        y    = display.contentHeight*0.63,
        font   = FONT,
        fontSize = 38,
        align  = "center",
    })

    popup.multiLineText:setFillColor(0)
    popup.multiLineText2:setFillColor(0)

    -------------------------------------------------------

    popup.close     = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x    = display.contentWidth*0.5
    popup.close.y    = display.contentHeight*0.83

    utils.onTouch(popup.close, function()
        viewManager.closePopup(popup)
        if(next) then
            next()
        end
    end)
end

--------------------------------------------------------------------------------

function UserManager:updateFanStatus(next, notifyFBBonus, notifyTWBonus)

    utils.postWithJSON({
        facebookFan  = self.user.facebookFan,
        twitterFan   = self.user.twitterFan,
    },
    API_URL .. "updateFanStatus",
    function(result)

        if(notifyFBBonus or userManager.requireFacebookConnectionTickets) then

            local bonus = 0
            if(notifyFBBonus) then bonus = bonus + FACEBOOK_FAN_TICKETS end
            if(userManager.requireFacebookConnectionTickets) then bonus = bonus + FACEBOOK_CONNECTION_TICKETS end
            userManager.requireFacebookConnectionTickets = false

            timer.performWithDelay(1500, function()
                userManager:giftStock(bonus, function() end)
            end)

        elseif(notifyTWBonus or self.requireTwitterConnectionTickets) then
            local bonus = 0

            if(notifyTWBonus) then
                bonus = bonus + TWITTER_FAN_TICKETS
            end

            if(self.requireTwitterConnectionTickets) then
                bonus = bonus + TWITTER_CONNECTION_TICKETS
                self.requireTwitterConnectionTickets = false
            end

            timer.performWithDelay(1500, function()
                userManager:giftStock(bonus, function() end)
            end)

        end

        if(next) then
            next()
        end

    end)
end

--------------------------------------------------------------------------------

function UserManager:twitterConnection(twitterId, twitterName, next)

    GLOBALS.savedData.user.twitterId        = twitterId
    GLOBALS.savedData.user.twitterName      = twitterName

    utils.saveTable(GLOBALS.savedData, "savedData.json")

    self.user.twitterId   = twitterId
    self.user.twitterName  = twitterName

    self:updatePlayer(next)
end

--------------------------------------------------------------------------------

function UserManager:mergePlayerWithFacebook(next)

    GLOBALS.savedData.user.facebookId   = facebook.data.id
    GLOBALS.savedData.user.facebookName   = facebook.data.name

    utils.saveTable(GLOBALS.savedData, "savedData.json")

    self.user.facebookId  = facebook.data.id
    self.user.facebookName  = facebook.data.name

    self:updatePlayer(next)
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
    return lotteryManager.nextLottery.startTickets
            + self.user.temporaryBonusTickets
            + self.user.fanBonusTickets
            + self.user.charityBonusTickets
            + self.user.ambassadorBonusTickets
end

--------------------------------------------------------------------------------

function UserManager:checkTicketTiming()

    local lastTime  = 0
    local now       = time.now()

    for i = 1,#self.user.lotteryTickets do
        local ticket = self.user.lotteryTickets[i]
        if((self.user.currentLotteryUID == ticket.lottery.uid) and (ticket.creationDate > lastTime) and (ticket.type == 1)) then
            lastTime = ticket.creationDate
        end
    end

    local spentMillis = now - lastTime
    local h,m,s,ms = utils.getHoursMinSecMillis(spentMillis)

    if(tonumber(spentMillis) >= (lotteryManager.nextLottery.ticketTimer * 60 * 1000)) then
        return true
    else
        self:openTimerPopup(lastTime)
        return false
    end

end

--------------------------------------------------------------------------------

function UserManager:logout()
    coronaFacebook.logout()
    twitter.logout()
    gameManager.initGameData()
    router.openOutside()
end

--------------------------------------------------------------------------------
-- NOTIFICATIONS
--------------------------------------------------------------------------------

function UserManager:checkNotifications()

    self.userHasReceivedBonus = false

    self:notifyPrizes(function()
        self:notifyStocks(function()
            self:notifyInstants(function()

                if(self.userHasReceivedBonus) then
                    self:updatePlayer()
                end

            end)
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

        popup.bg        = display.newImage( popup, "assets/images/icons/notification/BG_Money.png")
        popup.bg.x      = display.contentWidth*0.5
        popup.bg.y      = display.contentHeight*0.5

        ----------------------------------------

        popup.congratz   = display.newImage( popup, I "popup.Txt1.png")
        popup.congratz.x  = display.contentWidth*0.5
        popup.congratz.y = display.contentHeight*0.35

        popup.earnText      = viewManager.newText({
            parent           = popup,
            text     = T "You have won" .. " :",
            fontSize   = 55,
            x      = display.contentWidth * 0.5,
            y      = display.contentHeight*0.42,
        })

        popup.prizeText = viewManager.newText({
            parent    = popup,
            text    = totalPrice,
            fontSize  = 55,
            anchorX   = 1,
            anchorY   = 0.5,
            x     = display.contentWidth * 0.5,
            y     = display.contentHeight*0.53,
        })

        popup.iconPrize   = display.newImage( popup, "assets/images/icons/notification/prizes.popup.png")
        popup.iconPrize.x   = display.contentWidth*0.64
        popup.iconPrize.y   = display.contentHeight*0.53

        --------------------------

        if(userManager.user.facebookId) then
            popup.share    = display.newImage( popup, I "share.notification.png")
            popup.share.x    = display.contentWidth*0.5
            popup.share.y    = display.contentHeight*0.68

            utils.onTouch(popup.share, function() shareManager:shareWinningsOnWall(totalPrice, popup) end)
        end

        ---------------------------------------------------------------

        popup.close    = display.newImage( popup, "assets/images/hud/CroixClose.png")
        popup.close.x    = display.contentWidth*0.89
        popup.close.y    = display.contentHeight*0.55 - display.contentWidth*0.95/2

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

        popup.bg        = display.newImage( popup, "assets/images/icons/notification/BG_Bonus.png")
        popup.bg.x      = display.contentWidth*0.5
        popup.bg.y      = display.contentHeight*0.5

        ----------------------------------------

        popup.congratz   = display.newImage( popup, I "popup.Txt1.png")
        popup.congratz.x  = display.contentWidth*0.5
        popup.congratz.y = display.contentHeight*0.35

        popup.earnText = viewManager.newText({
            parent    = popup,
            text    = T "You have won" .. " :",
            fontSize  = 55,
            x     = display.contentWidth * 0.5,
            y     = display.contentHeight*0.42,
        })

        popup.prizeText = viewManager.newText({
            parent    = popup,
            text    = self.user.notifications.stocks,
            fontSize  = 75,
            anchorX         = 1,
            anchorY         = 0.5,
            x     = display.contentWidth * 0.44,
            y     = display.contentHeight*0.52,
        })

        popup.iconTicket   = display.newImage( popup, "assets/images/icons/notification/stocks.popup.png")
        popup.iconTicket.x   = display.contentWidth*0.57
        popup.iconTicket.y   = display.contentHeight*0.53

        --------------------------

        popup.close    = display.newImage( popup, I "popup.Bt_close.png")
        popup.close.x    = display.contentWidth*0.5
        popup.close.y    = display.contentHeight*0.7

        utils.onTouch(popup.close, function()
            viewManager.closePopup(popup, true, next)
        end)

        ----------------------------------------

        self.user.notifications.stocks = 0
    end
end

--------------------------------------------------------------------------------

function UserManager:giftInstants(nbInstants, next)
    self.user.idlePoints = self.user.idlePoints + nbInstants

    self:notifyInstants(function()
        self:updatePlayer()
        if(next) then
            next()
        end
    end)
end

--------------------------------------------------------------------------------

function UserManager:giftStock(nbStock, next)
    self.user.notifications.stocks = nbStock
    self:notifyStocks(function()
        if(next) then
            next()
        end
    end)
end

--------------------------------------------------------------------------------

function UserManager:notifyInstants(next)

    if(self.user.notifications.instants + self.user.idlePoints > 0) then

        ----------------------------------------

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
            text     = self.user.notifications.instants + self.user.idlePoints,
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

        ----------------------------------------

        self.user.extraTickets    = self.user.extraTickets + self.user.idlePoints
        self.user.idlePoints      = 0
        self.userHasReceivedBonus = true

        next()
    end
end

--------------------------------------------------------------------------------

function UserManager:showStatus()

    local popup = viewManager.showPopup()

    popup.refresh = function()
        viewManager.refreshPlayButton()
        viewManager.closePopin()
        viewManager.closePopup(popup)
        popup = userManager:showStatus()
    end

    ----------------------------

    popup.congratz   = display.newImage( popup, I "title.status.png")
    popup.congratz.x = display.contentWidth*0.5
    popup.congratz.y = display.contentHeight*0.15

    popup.iconTicket   = display.newImage( popup, "assets/images/icons/info.big.png")
    popup.iconTicket.x = display.contentWidth*0.15
    popup.iconTicket.y = display.contentHeight*0.15

    popup.sep   = display.newImage( popup, "assets/images/icons/separateur.horizontal.png")
    popup.sep.x = display.contentWidth*0.5
    popup.sep.y = display.contentHeight*0.21

    ----------------------------

    popup.earnText = viewManager.newText({
        parent   = popup,
        text     = T "Remaining Tickets" .. ":",
        fontSize = 55,
        x        = display.contentWidth * 0.5,
        y        = display.contentHeight*0.26,
    })

    popup.availableTickets = viewManager.newText({
        parent   = popup,
        text     = self:remainingTickets() .. " / " .. self:totalAvailableTickets(),
        fontSize = 55,
        x        = display.contentWidth * 0.5,
        y        = display.contentHeight*0.34,
    })

    popup.availableTickets.anchorX = 1
    popup.availableTickets.anchorY = 0.55

    popup.iconTicket   = display.newImage( popup, "assets/images/icons/status/ticket.png")
    popup.iconTicket.x = display.contentWidth*0.6
    popup.iconTicket.y = display.contentHeight*0.34

    --------------------------

    popup.more   = display.newImage( popup, I "more.tickets.png")
    popup.more.x = display.contentWidth*0.5
    popup.more.y = display.contentHeight*0.47

    utils.onTouch(popup.more, function()
        shareManager:moreTickets(popup)
    end)

    --------------------------

    popup.sep   = display.newImage( popup, "assets/images/icons/separateur.horizontal.png")
    popup.sep.x = display.contentWidth*0.5
    popup.sep.y = display.contentHeight*0.58
    popup.sep:scale(0.9,1);

    ----------------------------

    popup.earnText = viewManager.newText({
        parent   = popup,
        text     = T "Instant Tickets" .. ":",
        fontSize = 55,
        x        = display.contentWidth * 0.5,
        y        = display.contentHeight*0.63,
    })

    popup.extraTickets = viewManager.newText({
        parent   = popup,
        text     = self.user.extraTickets,
        fontSize = 55,
        x        = display.contentWidth * 0.45,
        y        = display.contentHeight*0.71,
    })

    popup.extraTickets.anchorX = 1
    popup.extraTickets.anchorY = 0.6

    popup.iconITicket   = display.newImage( popup, "assets/images/icons/status/instant.ticket.png")
    popup.iconITicket.x  = display.contentWidth*0.57
    popup.iconITicket.y  = display.contentHeight*0.715

    --------------------------

    popup.more     = display.newImage( popup, I "more.instant.png")
    popup.more.x    = display.contentWidth*0.5
    popup.more.y    = display.contentHeight*0.84

    utils.onTouch(popup.more, function()
        shareManager:inviteForInstants(popup)
    end)

    --------------------------

    popup.close    = display.newImage( popup, "assets/images/hud/CroixClose.png")
    popup.close.x    = display.contentWidth*0.88
    popup.close.y    = display.contentHeight*0.09

    utils.onTouch(popup.close, function()
        viewManager.closePopin()
        viewManager.closePopup(popup)
    end)

    return popup
end


----------------------------------------

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

    local lastUpdatedPrizes = translate(lotteryManager.global.lastUpdatedPrizes)

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

    popup.playNow   = display.newImage( popup, I "timer.play.png")
    popup.playNow.x = display.contentWidth*0.5
    popup.playNow.y = display.contentHeight*0.48

    utils.onTouch(popup.playNow, function()

        if(self.user.extraTickets > 0) then
            display.remove(popup.multiLineText)
            display.remove(popup.minText)
            display.remove(popup.secText)
            display.remove(popup.pictoTimer)
            display.remove(popup.playNow)
            display.remove(popup.textor)
            display.remove(popup.increase)
            display.remove(popup.close)

            transition.to(popup.timerDisplay, {
                x = display.contentWidth*0.5,
                y = display.contentHeight*0.5,
                xScale = 2.5,
                yScale = 2.5
            })

            viewManager.decreaseTimer(function()
                viewManager.closePopup(popup)
                gameManager:startTicket()
            end)

        else
            shareManager:shareForInstants(popup)
        end

    end)

    ----------------------------------------------------

    popup.textor   = display.newImage( popup, I "timer.or.png")
    popup.textor.x = display.contentWidth*0.5
    popup.textor.y = display.contentHeight*0.59

    --------------------------

    popup.increase   = display.newImage( popup, I "timer.jackpot.png")
    popup.increase.x = display.contentWidth*0.5
    popup.increase.y = display.contentHeight*0.7

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