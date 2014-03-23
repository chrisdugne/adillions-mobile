-----------------------------------------------------------------------------------------

UserManager = {} 

-----------------------------------------------------------------------------------------

function UserManager:new()  

    local object = {
        user                    = {},
        attemptFBPlayer         = 0,       -- attemptFBPlayer pour compter les getPlayerByFacebookId pour android reco apres retour app
        attemptFetchPlayer      = 0,

        userHasReceivedBonus    = false    -- while receiving BT and IT, set to true. One updatedPlayer after all bonus are received
    }

    setmetatable(object, { __index = UserManager })
    return object
end

-----------------------------------------------------------------------------------------

function UserManager:getGlobals(onGoodVersion, onBadVersion)
    print("getGlobals")
    utils.postWithJSON({}, 
    SERVER_URL .. "globals", 
    function(result)
    
        if(result.isError) then
            -- android....
            print("globals on error...")
            timer.performWithDelay(2000, function() userManager:getGlobals(onGoodVersion, onBadVersion) end)
            
            
        else
        
            local response = json.decode(result.response)
            
            lotteryManager.global               = response.global
            
            lotteryManager.global.appStatus     = json.decode(lotteryManager.global.appStatus)
            lotteryManager.global.tweet         = json.decode(lotteryManager.global.tweet)
            lotteryManager.global.tweetTheme    = json.decode(lotteryManager.global.tweetTheme)
            lotteryManager.global.fbPost        = json.decode(lotteryManager.global.fbPost)
            lotteryManager.global.fbSharePrize  = json.decode(lotteryManager.global.fbSharePrize)
            lotteryManager.global.sms           = json.decode(lotteryManager.global.sms)
            lotteryManager.global.email         = json.decode(lotteryManager.global.email)
            lotteryManager.global.text48h       = json.decode(lotteryManager.global.text48h)
            lotteryManager.global.text3min      = json.decode(lotteryManager.global.text3min)
    
            lotteryManager.global.minEuro       = json.decode(lotteryManager.global.minMoney).euro
            lotteryManager.global.minUSD        = json.decode(lotteryManager.global.minMoney).usd
    
            time.setServerTime(response.serverTime)
            TIMER                               = lotteryManager.global.lastUpdate or response.serverTime
            VERSION_REQUIRED                    = response.global.versionRequired
            bannerManager.banners               = json.decode(lotteryManager.global.banners)
    
            if(APP_VERSION >= VERSION_REQUIRED) then
                print("onGoodVersion")
                onGoodVersion()
            else
                print("onBadVersion")
                onBadVersion()
            end
            
        end
    end)
end

-----------------------------------------------------------------------------------------

function UserManager:refreshPlayer()
    gameManager:open()
end

-----------------------------------------------------------------------------------------

function UserManager:fetchPlayer()

    userManager.user.fanBonusTickets = 0
    userManager.user.charityBonusTickets = 0

    native.setActivityIndicator( true )
    print("fetchPlayer")
    self.attemptFetchPlayer = self.attemptFetchPlayer + 1 

    print("fetch : mobileVersion " .. APP_VERSION)

    utils.postWithJSON({
        mobileVersion   = APP_VERSION,
        country         = COUNTRY
    }, 
    SERVER_URL .. "player", 
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
                userManager:receivedPlayer(player, router.openHome)
            end
        end
    end
    )

end

-----------------------------------------------------------------------------------------

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
    SERVER_URL .. "playerFromFB", 
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

-----------------------------------------------------------------------------------------

function UserManager:loadMoreTickets(lastLotteryUID, onReceivedTickets)
    utils.postWithJSON({
            lastLotteryUID = lastLotteryUID
        }, 
        SERVER_URL .. "lotteryTickets", 
        function(result)
            onReceivedTickets(json.decode(result.response))
        end
    )
end

-----------------------------------------------------------------------------------------

function UserManager:checkExistPlayerByFacebookId(proceedWithMerge, connectionSuccessful, beforeForceLogin)

    native.setActivityIndicator( true )
    print("checkExistPlayerByFacebookId")

    utils.postWithJSON({
        facebookData = facebook.data,
    }, 
    SERVER_URL .. "isMeFBPlayer", 
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

-----------------------------------------------------------------------------------------

function UserManager:receivedPlayer(player, next)

    if(next == router.openHome) then
        sponsorpayTools:init(player.uid)
        viewManager.message(T "Welcome" .. " " .. player.userName .. " !")
    end

    self:updatedPlayer(player, next)
end

-----------------------------------------------------------------------------------------

function UserManager:updatedPlayer(player, next)

    self.user = player

    print("------------------------ updatedPlayer ")

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

    lotteryManager:sumPrices()

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
    
    print("###")
    print(" hasTweetTheme : ", self.user.hasTweetTheme )
    self:refreshBonusTickets(next)
end

-----------------------------------------------------------------------------------------

function UserManager:refreshBonusTickets(next)
    
    print("-------------------------- refreshBonusTickets ")
    self.user.fanBonusTickets       = 0
    self.user.charityBonusTickets   = 0

    self:setCharityBonus()    
    self:checkFanStatus(function()
        if(next) then
            next()
        end
        facebook.checkThemeLiked()
    end)
    
end

-----------------------------------------------------------------------------------------

function UserManager:checkExistingUser(connectionSuccessful, beforeForceLogin)
    self:checkExistPlayerByFacebookId(function()
        self:showConfirmMerge(connectionSuccessful)
    end, connectionSuccessful, beforeForceLogin)
end

-----------------------------------------------------------------------------------------

function UserManager:setCharityBonus()

    local charityLevel = self:charityLevel()

    if(charityLevel == BENEFACTOR) then
        self.user.charityBonusTickets = self.user.charityBonusTickets + 5

    elseif(charityLevel == DONOR) then
        self.user.charityBonusTickets = self.user.charityBonusTickets + 2

    elseif(charityLevel == JUNIOR_DONOR) then
        self.user.charityBonusTickets = self.user.charityBonusTickets + 1

    end

end

-----------------------------------------------------------------------------------------

function UserManager:charityLevel()

    if(self.user.totalPlayedTickets         >= 500) then
        return BENEFACTOR

    elseif(self.user.totalPlayedTickets     >= 200) then
        return DONOR

    elseif(self.user.totalPlayedTickets     >= 100) then
        return JUNIOR_DONOR

    elseif(self.user.totalPlayedTickets     >= 50) then
        return CONTRIBUTOR

    else
        return SCOUT

    end

end

-----------------------------------------------------------------------------------------
-- popup affichee uniquement si facebookId libre pour adillions
-- (sinon on a logout puis login le user FB existant)
-- si confirm : on pose link facebookId, 
function UserManager:showConfirmMerge(next)

    -----------------

    local popup = viewManager.showPopup()

    popup.shareIcon    = display.newImage( popup, "assets/images/icons/PictoInfo.png")  
    popup.shareIcon.x    = display.contentWidth*0.5
    popup.shareIcon.y   = display.contentHeight*0.22

    popup.shareIcon    = display.newImage( popup, I "watchout.png")  
    popup.shareIcon.x    = display.contentWidth*0.5
    popup.shareIcon.y   = display.contentHeight*0.31

    -----------------

    local message = ""
    if(LANG == "fr") then
        message = "Vous allez connecter le compte Facebook " .. facebook.data.name .. " avec le compte Adillions de " .. self.user.firstName
    else
        message = "You are about to connect " .. facebook.data.name .. " Facebook profile with " .. self.user.firstName .. "'s Adillions account"
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

    popup.multiLineText:setFillColor(0)

    -----------------

    popup.confirm    = display.newImage( popup, I "confirm.png")
    popup.confirm.x   = display.contentWidth*0.5
    popup.confirm.y   = display.contentHeight*0.65

    utils.onTouch(popup.confirm, function() 
        viewManager.closePopup(popup)
        userManager:mergePlayerWithFacebook(next)
    end)

    -----------------

    popup.close    = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x    = display.contentWidth*0.5
    popup.close.y    = display.contentHeight*0.83

    utils.onTouch(popup.close, function()
        viewManager.closePopup(popup)
    end)


end


-----------------------------------------------------------------------------------------
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

-----------------------------------------------------------------------------------------

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

            print("statusChanged ? " )
            print(statusChanged)

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
                    if(next) then
                        next()
                    end
                end
                            
            end

            ---------------------------------------------------------
        end)
    end)

end

-----------------------------------------------------------------------------------------

function UserManager:giveToCharity(next)
    viewManager.closePopup(popup)

    print("giveToCharity")
    if(next)then  print("next ready") end
    utils.postWithJSON({}, 
    SERVER_URL .. "giveToCharity", 
    function(result)
        userManager:updatePlayer(next)
    end
    )

end

function UserManager:cashout(next)
    viewManager.closePopup(popup)

    utils.postWithJSON({
        country = COUNTRY
    }, 
    SERVER_URL .. "cashout", 
    function(result)
        userManager:updatePlayer(next)
    end
    )

end

-----------------------------------------------------------------------------------------
-- en arrivant on check si on passe sur une nouvelle lotterie
-- ce check est donc fait avant le concertIdlePoints
-- donc les tickets convertis de idlepoints sont bien rajoutés aux nouveaux availableTickets

function UserManager:checkUserCurrentLottery()

    if(self.user.currentLotteryUID ~= lotteryManager.nextLottery.uid) then

        ----------------------------------------

        self.user.currentLotteryUID   = lotteryManager.nextLottery.uid
        self.user.availableTickets    = START_AVAILABLE_TICKETS 
        self.user.playedBonusTickets   = 0

        self.user.hasTweet     = false
        self.user.hasPostOnFacebook   = false
        self.user.hasTweetAnInvite   = false
        self.user.hasInvitedOnFacebook  = false

        self:updatePlayer()

        ----------------------------------------

    end

    --------------------------------------------------------------------------------------

    lotteryManager:refreshNotifications(lotteryManager.nextLottery.date)
end

-----------------------------------------------------------------------------------------

function UserManager:storeLotteryTicket(numbers)

    local extraTicket = self.user.extraTickets > 0

    utils.postWithJSON({
        numbers = numbers,
        extraTicket = extraTicket
    }, 
    SERVER_URL .. "storeLotteryTicket", 
    function(result)
        local player = json.decode(result.response)
        if(player) then 
            lotteryManager.wasExtraTicket = extraTicket
            userManager:receivedPlayer(player, function()
            end)
        else 
            userManager:logout()
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
        
    lotteryManager:showLastTicket() 
end

-----------------------------------------------------------------------------------------

function UserManager:updatePlayer(next)

    print("------------- updatePlayer ")
    self.user.lotteryTickets = nil -- just remove all that long json useless for updates (BUG 2014-02-03). it'll be back at server callback. 
    self.user.lang = LANG
    self.userBackup = {}

    -- themeLiked is only client side, and fetched at startup
    self.userBackup.themeLiked = self.user.themeLiked 
    
    print(" hasTweetTheme : ", self.user.hasTweetTheme )

    utils.postWithJSON({
        user = self.user,
    }, 
    SERVER_URL .. "updatePlayer", 
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

-----------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------

function UserManager:updateFanStatus(next, notifyFBBonus, notifyTWBonus)

    print("--- updateFanStatus")
    print("facebookFan : " .. tostring(self.user.facebookFan))
    print("twitterFan : " .. tostring(self.user.twitterFan))

    native.setActivityIndicator( true ) 

    utils.postWithJSON({
        facebookFan  = self.user.facebookFan,
        twitterFan   = self.user.twitterFan,
    }, 
    SERVER_URL .. "updateFanStatus", 
    function(result)
        print("--- updateFanStatus false")
        native.setActivityIndicator( false )
        
        if(notifyFBBonus or self.requireFacebookConnectionTickets) then
            
            local bonus = 0
            if(notifyFBBonus) then bonus = bonus + FACEBOOK_FAN_TICKETS end 
            if(self.requireFacebookConnectionTickets) then bonus = bonus + FACEBOOK_CONNECTION_TICKETS end
            self.requireFacebookConnectionTickets = false
            
            userManager:giftStock(bonus, function()
                if(next) then
                    next()
                end
            end)
            
        elseif(notifyTWBonus) then
            local bonus = 0
            if(notifyFBBonus) then bonus = bonus + TWITTER_FAN_TICKETS end 
            if(self.requireTwitterConnectionTickets) then bonus = bonus + TWITTER_CONNECTION_TICKETS end
            self.requireTwitterConnectionTickets = false
            userManager:giftStock(bonus, function()
                if(next) then
                    next()
                end
            end)
        
        elseif(next) then
            next()
        end

    end)
end

-----------------------------------------------------------------------------------------

function UserManager:twitterConnection(twitterId, twitterName, next)

    GLOBALS.savedData.user.twitterId      = twitterId
    GLOBALS.savedData.user.twitterName      = twitterName

    utils.saveTable(GLOBALS.savedData, "savedData.json")

    self.user.twitterId   = twitterId
    self.user.twitterName  = twitterName

    self:updatePlayer(next)
end

-----------------------------------------------------------------------------------------

function UserManager:mergePlayerWithFacebook(next)

    GLOBALS.savedData.user.facebookId   = facebook.data.id
    GLOBALS.savedData.user.facebookName   = facebook.data.name

    utils.saveTable(GLOBALS.savedData, "savedData.json")

    self.user.facebookId  = facebook.data.id
    self.user.facebookName  = facebook.data.name

    self:updatePlayer(next)
end

-----------------------------------------------------------------------------------------

function UserManager:hasTicketsToPlay()
    return self:remainingTickets()  > 0
end

function UserManager:remainingTickets()
    return self.user.availableTickets + self.user.temporaryBonusTickets + self.user.fanBonusTickets + self.user.charityBonusTickets - self.user.playedBonusTickets
end

-----------------------------------------------------------------------------------------

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

    if(tonumber(spentMillis) >= (lotteryManager.nextLottery.ticketTimer * 60 * 1000) or self.user.extraTickets > 0) then
        return true
    else
        ----------------------------------------------------------------------------------------------------

        local popup = viewManager.showPopup()
        
        ----------------------------------------------------------------------------------------------------

        popup.icon    = display.newImage( popup, "assets/images/icons/timer.png")
        popup.icon.x    = display.contentWidth*0.5
        popup.icon.y    = display.contentHeight*0.18

        popup.icon    = display.newImage( popup, I "Sorry.png")
        popup.icon.x    = display.contentWidth*0.5
        popup.icon.y    = display.contentHeight*0.29

        popup.bg    = display.newImage( popup, "assets/images/hud/home/timer.bg.png")
        popup.bg.x    = display.contentWidth*0.5
        popup.bg.y    = display.contentHeight*0.5

        ----------------------------------------------------------------------------------------------------

        popup.multiLineText = display.newText({
            parent = popup,
            text   = T "You can fill out a new Ticket in :",  
            width  = display.contentWidth*0.85,  
            height  = display.contentHeight*0.25,  
            x    = display.contentWidth*0.5,
            y    = display.contentHeight*0.46,
            font   = FONT, 
            fontSize = 47,
            align  = "center",
        })

        popup.multiLineText:setFillColor(0)

        popup.pictoTimer     = display.newImage( popup, "assets/images/icons/Tuto_2_picto2.png")  
        popup.pictoTimer.x   = display.contentWidth*0.37
        popup.pictoTimer.y   = display.contentHeight*0.455

        popup.timerDisplay = viewManager.newText({
            parent = popup, 
            text = '',     
            x = display.contentWidth*0.57,
            y = display.contentHeight*0.44,
            fontSize = 53,
            font = NUM_FONT
        })

        viewManager.refreshPopupTimer(popup, lastTime)

        -------------------------------

        local timerLegendY   = display.contentHeight*0.475
        local timerLegendSize  = 22

        viewManager.newText({
            parent = popup, 
            text = T "MIN", 
            x = display.contentWidth*0.5,
            y = timerLegendY,
            fontSize = timerLegendSize,
        })

        viewManager.newText({
            parent = popup, 
            text = T "SEC", 
            x = display.contentWidth*0.638,
            y = timerLegendY,
            fontSize = timerLegendSize,
        })

        ----------------------------------------------------

        popup.textor          = display.newImage( popup, I "timer.or.png")
        popup.textor.x        = display.contentWidth*0.5
        popup.textor.y        = display.contentHeight*0.56

        --------------------------

        popup.more     = display.newImage( popup, I "timer.play.png")
        popup.more.x     = display.contentWidth*0.5
        popup.more.y     = display.contentHeight*0.7

        utils.onTouch(popup.more, function() 
            shareManager:shareForInstants(popup)
        end)

        --------------------------

        popup.close     = display.newImage( popup, I "popup.Bt_close.png")
        popup.close.x    = display.contentWidth*0.5
        popup.close.y    = display.contentHeight*0.89

        utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

        return false
    end

end

-----------------------------------------------------------------------------------------

function UserManager:logout()
    coronaFacebook.logout()
    twitter.logout()
    gameManager.initGameData() 
    router.openOutside()
end
--
--function UserManager:logoutViewListener( event )
--
-- if event.url then
--
--  print("self.logout")
--  print(event.url)
--
--  if event.url == SERVER_URL .. "backToMobile" then
--   self:closeWebView()     
--   print("logoutViewListener backToMobile : outside") 
--   router.openOutside()
--   
--   
--   print("--- logout false") 
--   native.setActivityIndicator( false )
--  end
-- end
--
--end
--
--
--function UserManager:closeWebView()
-- self.webView:removeEventListener( "urlRequest", function(event) self:logoutViewListener(event) end )
-- self.webView:removeSelf()
-- self.webView = nil
--end



-----------------------------------------------------------------------------------------
-- NOTIFICATIONS
-----------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------

function UserManager:giftInstants(nbInstants, next)
    self.user.idlePoints = self.user.idlePoints + nbInstants

    self:notifyInstants(function()
        self:updatePlayer()
        if(next) then
            next()
        end
    end)
end

-----------------------------------------------------------------------------------------

function UserManager:giftStock(nbStock, next)
    self.user.notifications.stocks = nbStock
    self:notifyStocks(function()
        if(next) then
            next()
        end
    end)
end

-----------------------------------------------------------------------------------------

function UserManager:notifyInstants(next)

    if(self.user.notifications.instants + self.user.idlePoints > 0) then

        ----------------------------------------

        local popup = viewManager.showPopup(display.contentWidth*0.95, true)

        ----------------------------------------

        popup.bg        = display.newImage( popup, "assets/images/icons/notification/BG_Instant.png")
        popup.bg.x      = display.contentWidth*0.5
        popup.bg.y      = display.contentHeight*0.5

        ----------------------------------------

        popup.congratz    = display.newImage( popup, I "popup.Txt1.png")  
        popup.congratz.x   = display.contentWidth*0.5
        popup.congratz.y  = display.contentHeight*0.35

        popup.earnText = viewManager.newText({
            parent    = popup,
            text    = T "You have won" .. " :", 
            fontSize  = 55,  
            x     = display.contentWidth * 0.5,
            y     = display.contentHeight*0.42,
        })

        popup.prizeText = viewManager.newText({
            parent    = popup,
            text    = self.user.notifications.instants + self.user.idlePoints, 
            fontSize  = 75,
            anchorX   = 1,
            anchorY   = 0.5,
            x     = display.contentWidth * 0.44,
            y     = display.contentHeight*0.52,
        })

        popup.iconTicket  = display.newImage( popup, "assets/images/icons/notification/instants.popup.png")
        popup.iconTicket.x  = display.contentWidth*0.57
        popup.iconTicket.y  = display.contentHeight*0.53

        --------------------------

        popup.close    = display.newImage( popup, "assets/images/hud/CroixClose.png")
        popup.close.x    = display.contentWidth*0.89
        popup.close.y    = display.contentHeight*0.55 - display.contentWidth*0.95/2

        utils.onTouch(popup.close, function()
            viewManager.closePopup(popup)
        end)

        popup.play   = display.newImage( popup, I "play.png")
        popup.play.x   = display.contentWidth*0.5
        popup.play.y   = display.contentHeight*0.7

        utils.onTouch(popup.play, function() 
            viewManager.closePopup(popup) 
            gameManager:play() 
        end)

        ----------------------------------------

        self.user.extraTickets      = self.user.extraTickets + self.user.idlePoints
        self.user.idlePoints        = 0
        self.userHasReceivedBonus   = true

        next()        
    end
end

-----------------------------------------------------------------------------------------

function UserManager:showStatus()

    local popup = viewManager.showPopup()

    popup.refresh = function() 
        viewManager.refreshPlayButton()
        viewManager.closePopin()
        viewManager.closePopup(popup)
        userManager:showStatus() 
    end
    
    ----------------------------

    popup.congratz    = display.newImage( popup, I "title.status.png")  
    popup.congratz.x   = display.contentWidth*0.5
    popup.congratz.y  = display.contentHeight*0.15

    popup.iconTicket   = display.newImage( popup, "assets/images/icons/info.big.png")
    popup.iconTicket.x   = display.contentWidth*0.15
    popup.iconTicket.y   = display.contentHeight*0.15

    popup.sep     = display.newImage( popup, "assets/images/icons/separateur.horizontal.png")
    popup.sep.x    = display.contentWidth*0.5
    popup.sep.y    = display.contentHeight*0.21

    ----------------------------

    popup.earnText = viewManager.newText({
        parent    = popup,
        text    = T "Remaining Tickets" .. ":", 
        fontSize  = 55,  
        x     = display.contentWidth * 0.5,
        y     = display.contentHeight*0.26,
    })

    popup.availableTickets = viewManager.newText({
        parent    = popup,
        text    = (self:remainingTickets()) .. " / " .. (START_AVAILABLE_TICKETS + self.user.temporaryBonusTickets + self.user.fanBonusTickets + self.user.charityBonusTickets), 
        fontSize  = 55,  
        x     = display.contentWidth * 0.5,
        y     = display.contentHeight*0.34,
    })

    popup.availableTickets.anchorX = 1
    popup.availableTickets.anchorY = 0.55

    popup.iconTicket   = display.newImage( popup, "assets/images/icons/status/ticket.png")
    popup.iconTicket.x   = display.contentWidth*0.6
    popup.iconTicket.y   = display.contentHeight*0.34

    --------------------------

    popup.more     = display.newImage( popup, I "more.tickets.png")
    popup.more.x    = display.contentWidth*0.5
    popup.more.y    = display.contentHeight*0.47

    utils.onTouch(popup.more, function() 
        shareManager:moreTickets(popup) 
    end)

    --------------------------

    popup.sep      = display.newImage( popup, "assets/images/icons/separateur.horizontal.png")
    popup.sep.x     = display.contentWidth*0.5
    popup.sep.y     = display.contentHeight*0.58
    popup.sep:scale(0.9,1);

    ----------------------------

    popup.earnText = viewManager.newText({
        parent    = popup,
        text    = T "Instant Tickets" .. ":", 
        fontSize  = 55,  
        x     = display.contentWidth * 0.5,
        y     = display.contentHeight*0.63,
    })

    popup.extraTickets = viewManager.newText({
        parent    = popup,
        text    = self.user.extraTickets, 
        fontSize  = 55,  
        x     = display.contentWidth * 0.45,
        y     = display.contentHeight*0.71,
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

end

-----------------------------------------------------------------------------------------

return UserManager