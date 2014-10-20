--------------------------------------------------------------------------------

ShareManager = {}

--------------------------------------------------------------------------------

function ShareManager:new()

    local object = {}

    setmetatable(object, { __index = ShareManager })
    return object
end

--------------------------------------------------------------------------------

function ShareManager:moreTickets(popup)

    -----------------------------------

    viewManager.showPopin()
    analytics.event("Social", "popinMoreTickets")

    -----------------------------------

    local close = function()
        viewManager.closePopin()
        viewManager.closePopup(popup)
    end

    -----------------------------------

    hud.popin.title         = display.newImage( hud.popin, I "stock.title.png")
    hud.popin.title.x       = - display.contentWidth * 0.485
    hud.popin.title.y       = hud.popin.headerMiddle
    hud.popin.title.anchorX = 0

    hud.popin.what          = display.newImage( hud.popin, I "what.png")
    hud.popin.what.x        = hud.popin.title.x + hud.popin.title.contentWidth
    hud.popin.what.y        = hud.popin.headerMiddle
    hud.popin.what.anchorX  = 0

    utils.onTouch(hud.popin.title, function()
        shareManager:openRewards1()
    end)

    utils.onTouch(hud.popin.what, function()
        shareManager:openRewards1()
    end)


    -----------------------------------
    -- FB BUTTON
    -----------------------------------

    local actionFacebook    = nil
    local imageFacebook     = nil

    if(userManager.user.networks.connectedToFacebook) then
        -- linked

        if(userManager.user.networks.isFan) then
            -- fan | button v4
            imageFacebook   = I "stock.facebook.4.png"
            actionFacebook  = nil

        else
            -- pas fan et connecte | button v3 : open FB page
            imageFacebook = I "stock.facebook.3.png"
            actionFacebook = function()
                self:openFacebookPage(popup)
                close()
            end
        end
    else
        -- button v1 : connect to link
        imageFacebook = I "stock.facebook.1.png"
        actionFacebook = function()
            local success = function()
                viewManager.closePopin()
                analytics.event("Social", "linkedFacebookFromMore")
                userManager:readPlayer(function()
                    local bonus = 0;
                    if(userManager.user.networks.connectedToFacebook) then
                        bonus = bonus + FACEBOOK_CONNECTION_TICKETS
                    end
                    if(userManager.user.networks.isFan) then
                        bonus = bonus + FACEBOOK_FAN_TICKETS
                    end
                    userManager:giftStock(bonus, function()
                        if(popup and popup.refresh) then
                            popup.refresh()
                        end
                        self:moreTickets(popup)
                    end)
                end)
            end
            signinManager:connect('facebook', success, close)
        end
    end

    -----------------------------------
    -- TWITTER BUTTON
    -----------------------------------

    local actionTwitter    = nil
    local imageTwitter     = nil

    if(userManager.user.networks.connectedToTwitter) then
        -- linked

        if(userManager.user.networks.isFollower) then
            -- follower | button v4
            imageTwitter = I "stock.twitter.4.png"
            actionTwitter = nil

        else
            -- pas follower et connecte | button v3
            imageTwitter = I "stock.twitter.3.png"
            actionTwitter = function()
                self:follow(popup)
            end
        end
    else
        -- button v1 : connect to link
        imageTwitter = I "stock.twitter.1.png"
        actionTwitter = function()
            local success = function()
                viewManager.closePopin()
                analytics.event("Social", "linkedTwitterFromMore")
                userManager:giftStock(TWITTER_CONNECTION_TICKETS, function()
                    if(popup and popup.refresh) then
                        popup.refresh()
                    end
                    self:moreTickets(popup)
                end)
            end
            signinManager:connect('twitter', success, close)
        end
    end

    -----------------------------------

    hud.popin.buttonFacebook   = display.newImage( hud.popin, imageFacebook)
    hud.popin.buttonFacebook.x = display.contentWidth * -0.2
    hud.popin.buttonFacebook.y = hud.popin.contentMiddle

    if(actionFacebook) then
        utils.onTouch(hud.popin.buttonFacebook, actionFacebook)
    end

    hud.popin.buttonTwitter   = display.newImage( hud.popin, imageTwitter)
    hud.popin.buttonTwitter.x = display.contentWidth * 0.2
    hud.popin.buttonTwitter.y = hud.popin.contentMiddle

    if(actionTwitter) then
        utils.onTouch(hud.popin.buttonTwitter, actionTwitter)
    end

end

--------------------------------------------------------------------------------

function ShareManager:inviteForInstants(popup)

    -----------------------------------

    viewManager.showPopin()
    analytics.event("Social", "popinInviteForInstants")

    -----------------------------------

    local close = function()
        viewManager.closePopin()
        if(popup) then
            viewManager.closePopup(popup)
        end
    end

    -----------------------------------

    hud.popin.title         = display.newImage( hud.popin, I "instant.invite.png")
    hud.popin.title.x       = - display.contentWidth * 0.485
    hud.popin.title.y       = hud.popin.headerMiddle
    hud.popin.title.anchorX = 0

    hud.popin.what          = display.newImage( hud.popin, I "what.png")
    hud.popin.what.x        = hud.popin.title.x + hud.popin.title.contentWidth
    hud.popin.what.y        = hud.popin.headerMiddle
    hud.popin.what.anchorX  = 0

    utils.onTouch(hud.popin.title, function()
        shareManager:openRewards2()
    end)

    utils.onTouch(hud.popin.what, function()
        shareManager:openRewards2()
    end)

    -----------------------------------
    -- FB BUTTON
    -----------------------------------

    local actionFacebook    = nil
    local imageFacebook     = nil
    local backToHome        = function() router.openHome() end

    if(userManager.user.networks.connectedToFacebook) then
        imageFacebook = I "invite.facebook.3.png"
        actionFacebook = function()
            close()
            shareManager:inviteFBFriends()
            analytics.event("Social", "openFacebookFriendList")
        end
    else
        -- button v1 : connect to link
        imageFacebook = I "invite.facebook.1.png"
        actionFacebook = function()
            local success = function()
                analytics.event("Social", "linkedFacebookFromInvite")
                viewManager.closePopin()
                userManager:giftStock(FACEBOOK_CONNECTION_TICKETS, function()
                    if(popup and popup.refresh) then
                        popup.refresh()
                    end
                    self:inviteForInstants(popup)
                end)
            end
            signinManager:connect('facebook', success, close)
        end

    end

    -----------------------------------

    hud.popin.buttonFacebook        = display.newImage( hud.popin, imageFacebook)
    hud.popin.buttonFacebook.x      = display.contentWidth * -0.325
    hud.popin.buttonFacebook.y      = hud.popin.contentMiddle
    utils.onTouch(hud.popin.buttonFacebook, actionFacebook)

    hud.popin.sms                   = display.newImage( hud.popin, I "invite.sms.png")
    hud.popin.sms.x                 = 0
    hud.popin.sms.y                 = hud.popin.contentMiddle
    utils.onTouch(hud.popin.sms, function() self:sms() end)

    hud.popin.email                 = display.newImage( hud.popin, I "invite.email.png")
    hud.popin.email.x               = display.contentWidth * 0.325
    hud.popin.email.y               = hud.popin.contentMiddle
    utils.onTouch(hud.popin.email, function() self:email() end)

    -----------------------------------

    viewManager.newText({
        parent   = hud.popin,
        text     = T "* Cf. sponsorship rules",
        x        = -display.contentWidth * 0.45,
        y        = hud.popin.bottom,
        anchorX  = 0,
        fontSize = 27
    })

end

--------------------------------------------------------------------------------

-- play now ! share ==> instants
function ShareManager:shareForInstants(popup)

    -----------------------------------

    viewManager.showPopin()
    analytics.event("Social", "popinShareForInstants")

    -----------------------------------

    local close = function()
        viewManager.refreshPlayButton()
        viewManager.closePopin()
        if(popup) then
            viewManager.closePopup(popup)
        end
    end

    -----------------------------------

    hud.popin.title         = display.newImage( hud.popin, I "instant.playnow.png")
    hud.popin.title.x       = - display.contentWidth * 0.485
    hud.popin.title.y       = hud.popin.headerMiddle + display.contentHeight * 0.005
    hud.popin.title.anchorX = 0

    hud.popin.what         = display.newImage( hud.popin, I "what.png")
    hud.popin.what.x       = hud.popin.title.x + hud.popin.title.contentWidth
    hud.popin.what.y       = hud.popin.headerMiddle
    hud.popin.what.anchorX = 0

    utils.onTouch(hud.popin.what, function()
        shareManager:openRewards2()
    end)

    utils.onTouch(hud.popin.title, function()
        shareManager:openRewards2()
    end)

    -------------------------------------------------------------------------------------------
    -- FB BUTTON
    -----------------------------------

    print("----- facebook")
    local actionFacebook    = nil
    local imageFacebook     = nil

    if(userManager.user.networks.connectedToFacebook) then
        -- linked

        print("LINKED")

        -- NOTE : pour back to OG theme changer ce if
        --        if(userManager.user.themeLiked) then
        if(userManager.user.postThemeOnFacebook) then
            print("postThemeOnFacebook")

            local fbPost = translate(lotteryManager.globals.fbPost)

            if(userManager.user.postOnFacebook) then

                print("postOnFacebook")
                -- theme liked + has post | button v5
                imageFacebook   = I "share.facebook.5.png"
                actionFacebook  = function()
                    self:write('facebook', fbPost, close, close)
                    analytics.event("Social", "facebookShareWithoutReward")
                end

            else
                local success = function()
                    if(not userManager.user.postOnFacebook) then
                        userManager.user.postOnFacebook = true
                        userManager:giftInstants(NB_INSTANTS_PER_POST, close)
                    else
                        close()
                    end
                end

                imageFacebook = I "share.facebook.4.png"
                actionFacebook = function()
                    self:write('facebook', fbPost, success, close)
                    analytics.event("Social", "facebookShare")
                end
            end

        else
            -- theme not posted
            print("! postThemeOnFacebook")

            local fbPostTheme = translate(lotteryManager.globals.fbPostTheme)

            -- theme not liked et connecte | button v3 : like theme
            imageFacebook = I "share.facebook.3.png"
            actionFacebook = function()
                local success = function()
                    if(not userManager.user.postThemeOnFacebook) then
                        userManager.user.postThemeOnFacebook = true
                        userManager:giftInstants(NB_INSTANTS_PER_POST, close)
                    else
                        close()
                    end
                end
                self:write('facebook', fbPostTheme, success, close)
                analytics.event("Social", "facebookShareTheme")
            end

        end

    else
        print(" !  linked")
        -- not linked button v1 : connect to link
        imageFacebook = I "share.facebook.1.png"
        actionFacebook = function()
            local success = function()
                viewManager.closePopin()
                analytics.event("Social", "linkedFacebookFromShare")
                userManager:giftStock(FACEBOOK_CONNECTION_TICKETS, function()
                    if(popup and popup.refresh) then
                        popup.refresh()
                    end
                    self:shareForInstants(popup)
                end)
            end
            signinManager:connect('facebook', success, close)
        end
    end

    -------------------------------------------------------------------------------------------
    -- TWITTER BUTTON
    -----------------------------------

    print("----- twitter")

    local imageTwitter     = nil
    local actionTwitter    = nil

    if(userManager.user.networks.connectedToTwitter) then
        print("connectedToTwitter")

        if(userManager.user.tweetTheme) then
            print("tweetTheme")

            if(userManager.user.tweet) then

                print("tweet")
                -- theme tweeted + tweet | button v5
                imageTwitter = I "share.twitter.5.png"
                actionTwitter  = function()
                    local text = translate(lotteryManager.globals.tweet)
                    viewManager.closePopin()
                    self:write('twitter', text, close, close)
                    analytics.event("Social", "tweetWithoutReward")
                end
            else
                -- pas encore tweet et connecte | button v4 : tweet
                imageTwitter = I "share.twitter.4.png"
                actionTwitter = function()
                    local success = function()
                        if(not userManager.user.tweet) then
                            userManager.user.tweet = true
                            userManager:giftInstants(NB_INSTANTS_PER_TWEET, close)
                        else
                            close()
                        end
                    end

                    local text = translate(lotteryManager.globals.tweet)
                    self:write('twitter', text, success, close)
                    analytics.event("Social", "tweet")
                end
            end

        else
            -- theme not tweeted et connecte | button v3 : tweet theme
            imageTwitter = I "share.twitter.3.png"
            actionTwitter = function()
                local success = function()
                    if(not userManager.user.tweetTheme) then
                        userManager.user.tweetTheme = true
                        userManager:giftInstants(NB_INSTANTS_PER_TWEET, close)
                    else
                        close()
                    end
                end

                local text = translate(lotteryManager.globals.tweetTheme)
                self:write('twitter', text, success, close)
                analytics.event("Social", "tweetTheme")
            end
        end

    else
        print("! connectedToTwitter")
        -- not connectedToTwitter button v1 : connect to link
        imageTwitter = I "share.twitter.1.png"
        actionTwitter = function()
            local success = function()
                viewManager.closePopin()
                analytics.event("Social", "linkedTwitterFromShare")
                userManager:readPlayer(function()
                    local bonus = 0;
                    if(userManager.user.networks.connectedToTwitter) then
                        bonus = bonus + TWITTER_CONNECTION_TICKETS
                    end
                    if(userManager.user.networks.isFollower) then
                        bonus = bonus + TWITTER_FAN_TICKETS
                    end
                    userManager:giftStock(bonus, function()
                        if(popup and popup.refresh) then
                            popup.refresh()
                        end
                        self:shareForInstants(popup)
                    end)
                end)
            end
            signinManager:connect('twitter', success, close)
        end
    end

    -----------------------------------

    hud.popin.buttonFacebook         = display.newImage( hud.popin, imageFacebook)
    hud.popin.buttonFacebook.x       = display.contentWidth * -0.2
    hud.popin.buttonFacebook.y       = hud.popin.contentMiddle
    utils.onTouch(hud.popin.buttonFacebook, actionFacebook)

    hud.popin.buttonTwitter         = display.newImage( hud.popin, imageTwitter)
    hud.popin.buttonTwitter.x       = display.contentWidth * 0.2
    hud.popin.buttonTwitter.y       = hud.popin.contentMiddle
    utils.onTouch(hud.popin.buttonTwitter, actionTwitter)


end

--------------------------------------------------------------------------------

function ShareManager:noMoreTickets()

    -------------------------------------------------------------------------------------------

    local popup = viewManager.showPopup()

    -------------------------------------------------------------------------------------------

    popup.icon   = display.newImage( popup, "assets/images/hud/home/maxticket.png")
    popup.icon.x = display.contentWidth*0.5
    popup.icon.y = display.contentHeight*0.18

    popup.icon   = display.newImage( popup, I "Sorry.png")
    popup.icon.x = display.contentWidth*0.5
    popup.icon.y = display.contentHeight*0.29

    popup.bg   = display.newImage( popup, "assets/images/hud/home/maxticket.bg.png")
    popup.bg.x = display.contentWidth*0.5
    popup.bg.y = display.contentHeight*0.5

    -------------------------------------------------------------------------------------------

    viewManager.newText({
        parent   = popup,
        text     = T "You have reached the maximum number of Tickets for this draw",
        x        = display.contentWidth * 0.5,
        y        = display.contentHeight*0.4,
        width    = display.contentWidth * 0.75,
        fontSize = 45,
    })

    --------------------------

    popup.more   = display.newImage( popup, I "more.tickets.png")
    popup.more.x = display.contentWidth*0.5
    popup.more.y = display.contentHeight*0.55

    utils.onTouch(popup.more, function()
        self:moreTickets(popup)
    end)

    --------------------------

    popup.textor   = display.newImage( popup, I "timer.or.png")
    popup.textor.x = display.contentWidth*0.5
    popup.textor.y = display.contentHeight*0.63

    --------------------------

    popup.increase   = display.newImage( popup, I "timer.jackpot.png")
    popup.increase.x = display.contentWidth*0.5
    popup.increase.y = display.contentHeight*0.72

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
    popup.close.y = display.contentHeight*0.87

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

    -------------------------------------------------------------------------------------------
end

--------------------------------------------------------------------------------

function ShareManager:sms()
    analytics.event("Social", "askSMS")
    native.showPopup("sms", {
        body = translate(lotteryManager.globals.sms)
    })
end

--------------------------------------------------------------------------------

function ShareManager:email()
    analytics.event("Social", "askEmail")

    local body = translate(lotteryManager.globals.email):gsub("___", userManager.user.sponsorcode)
    local options = {
        body       = body,
        isBodyHtml = true,
        subject    = "Adillions",
    }

    native.showPopup("mail", options)
end

--------------------------------------------------------------------------------

function ShareManager:write(network, text, success, close)
    native.setActivityIndicator( true )

    utils.post( SAILS_URL .. '/api/'.. network ..'/', {text = text}, function(event)
        native.setActivityIndicator( false )
        viewManager.closePopup(popup)
        local successful = json.decode(event.response)

        if(successful) then
            viewManager.message(T "Thank you" .. " !  ")
            success()
        else
            viewManager.message(T "Try again")
            close()
        end

    end)
end

--------------------------------------------------------------------------------

--- follower = twitter.following @Adillions
function ShareManager:follow(popup)
    native.setActivityIndicator( true )
    utils.post( SAILS_URL .. '/api/twitter/follow', {}, function(event)
        local successful = json.decode(event.response)

        userManager:readPlayer(function()
            native.setActivityIndicator( false )
            analytics.event("Social", "followTwitter")

            self:moreTickets(popup)

            userManager:giftStock(TWITTER_FAN_TICKETS, function()
                if(popup and popup.refresh) then
                    popup.refresh()
                end
            end)
        end)
    end)
end

--------------------------------------------------------------------------------
---
--  "share" : {
--    "twitter": {
--        "en": "wqer",
--        "fr": "er",
--        "reward": {
--            "type": "BT/IT",
--            "num": 1
--        }
--    },
--    "facebook": {
--        "en": "wqer",
--        "fr": "er",
--        "reward": {
--            "type": "BT/IT",
--            "num": 1
--        }
--    }
--}
--

function ShareManager:simplePost(share)
    local text = translate(share.facebook)
    self:write('facebook', text, function()end, function()end)
end

--------------------------------------------------------------------------------

function ShareManager:shareWinningsOnWall(prize, popup)

    local text = translate(lotteryManager.globals.fbSharePrize):gsub("___", prize)

    -------

    local close = function()
        viewManager.closePopup(popup)
    end

    -------

    local share = function()
        analytics.event("Social", "shareWinnings")
        self:write('facebook', text, close, close)
    end

    -------

    if(userManager.user.networks.connectedToFacebook) then
        share()
    else
        signinManager:connect('facebook', share, close)
    end

end

--------------------------------------------------------------------------------

function ShareManager:openRewards1()

    local top   = display.contentHeight * 0.3
    local yGap  = display.contentHeight*0.082

    local popup = viewManager.showPopup()

    --------------------------


    hud.title         = display.newImage(popup, I "rewards.stock.title.png")
    hud.title.anchorX = 0
    hud.title.anchorY = 0.5
    hud.title.x       = display.contentWidth*0.1
    hud.title.y       = display.contentHeight*0.15

    --------------------------

    hud.sep   = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x = display.contentWidth*0.5
    hud.sep.y = display.contentHeight*0.2

    --------------------------

    hud.next = viewManager.newText({
        parent   = popup,
        text     = T "Increase your stock of Tickets",
        fontSize = 35,
        x        = display.contentWidth * 0.1,
        y        = display.contentHeight*0.23,
        anchorX  = 0,
    })

    --------------------------

    for i = 1,6 do
        hud.line   = display.newImage(popup, I "rewards.stock".. i ..".png")
        hud.line.x = display.contentWidth*0.5
        hud.line.y = display.contentHeight*0.215 + display.contentHeight*0.09 *i
    end

    --------------------------

    hud.next = viewManager.newText({
        parent   = popup,
        text     = T "*Only for the next drawing",
        fontSize = 29,
        x        = display.contentWidth * 0.1,
        y        = display.contentHeight*0.82,
        anchorX  = 0,
    })

    --------------------------

    hud.sep   = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x   = display.contentWidth*0.5
    hud.sep.y   = display.contentHeight*0.84

    hud.next = viewManager.newText({
        parent   = popup,
        text     = T "NEXT" .. "  >",
        fontSize = 49,
        x        = display.contentWidth * 0.5,
        y        = display.contentHeight*0.895,
    })

    utils.setGreen(hud.next)

    utils.onTouch(hud.next, function()
        viewManager.closePopup(popup)
        self:openRewards2()
    end)

    ---------------------------------------------------------------

    hud.close   = display.newImage( popup, "assets/images/hud/CroixClose.png")
    hud.close.x = display.contentWidth*0.89
    hud.close.y = display.contentHeight*0.085

    utils.onTouch(hud.close, function() viewManager.closePopup(popup) end)

end

------------------------------------------

function ShareManager:openRewards2()

    local top  = display.contentHeight * 0.3
    local yGap = display.contentHeight*0.082

    local popup = viewManager.showPopup()

    --------------------------

    hud.title         = display.newImage(popup, I "rewards.instant.title.png")
    hud.title.anchorX = 0
    hud.title.anchorY = 0.5
    hud.title.x       = display.contentWidth*0.1
    hud.title.y       = display.contentHeight*0.15

    --------------------------

    hud.sep   = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x = display.contentWidth*0.5
    hud.sep.y = display.contentHeight*0.2

    --------------------------

    hud.next = viewManager.newText({
        parent   = popup,
        text     = T "Play right now thanks to Timers",
        fontSize = 34,
        x        = display.contentWidth * 0.1,
        y        = display.contentHeight*0.23,
        anchorX  = 0,
    })

    --------------------------

    for i = 1,4 do
        hud.line   = display.newImage(popup, I "rewards.instant".. i ..".png")
        hud.line.x = display.contentWidth*0.5
        hud.line.y = display.contentHeight*0.205 + display.contentHeight*0.125 *i
    end

    --------------------------

    hud.sep   = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x = display.contentWidth*0.5
    hud.sep.y = display.contentHeight*0.84

    --------------------------

    hud.next = viewManager.newText({
        parent   = popup,
        text     = "<  " .. T "PREVIOUS",
        fontSize = 49,
        x        = display.contentWidth * 0.5,
        y        = display.contentHeight*0.895,
        anchorX  = 1,
    })

    utils.setGreen(hud.next)

    utils.onTouch(hud.next, function()
        viewManager.closePopup(popup)
        self:openRewards1()
    end)

    --------------------------

    hud.next = viewManager.newText({
        parent   = popup,
        text     = T "*For the sponsor and the sponsored user (2 draws min.)",
        fontSize = 29,
        x        = display.contentWidth * 0.1,
        y        = display.contentHeight*0.785,
        anchorX  = 0,
    })

    hud.next = viewManager.newText({
        parent   = popup,
        text     = T "**Per post (max. 4 Timers per draw)",
        fontSize = 29,
        x        = display.contentWidth * 0.1,
        y        = display.contentHeight*0.81,
        anchorX  = 0,
    })

    --------------------------

    hud.next = viewManager.newText({
        parent   = popup,
        text     = T "NEXT" .. "  >",
        fontSize = 49,
        x        = display.contentWidth * 0.6,
        y        = display.contentHeight*0.895,
        anchorX  = 0,
    })

    utils.setGreen(hud.next)

    utils.onTouch(hud.next, function()
        viewManager.closePopup(popup)
        self:openCharityRewards()
    end)

    ---------------------------------------------------------------

    hud.close   = display.newImage( popup, "assets/images/hud/CroixClose.png")
    hud.close.x = display.contentWidth*0.89
    hud.close.y = display.contentHeight*0.085

    utils.onTouch(hud.close, function() viewManager.closePopup(popup) end)

end


--------------------------------------------------------------------------------

function ShareManager:openCharityRewards()

    local top  = display.contentHeight * 0.3
    local yGap = display.contentHeight*0.082

    local popup = viewManager.showPopup()

    --------------------------

    hud.title         = display.newImage(popup, I "rewards.charity.title.png")
    hud.title.anchorX = 0
    hud.title.anchorY = 0.5
    hud.title.x       = display.contentWidth*0.1
    hud.title.y       = display.contentHeight*0.15

    --------------------------

    hud.sep   = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x = display.contentWidth*0.5
    hud.sep.y = display.contentHeight*0.2

    --------------------------

    hud.next = viewManager.newText({
        parent   = popup,
        text     = T "The more you play Adillions, the more you contribute to charities",
        fontSize = 35,
        x        = display.contentWidth  * 0.1,
        y        = display.contentHeight * 0.24,
        width    = display.contentWidth  * 0.8,
        heigth   = display.contentHeight * 0.02,
        anchorX  = 0,
        align    = "left"
    })

    --------------------------

    local line = function ( i )

        local lineY = display.contentHeight*0.3 + display.contentHeight*0.05 *i

        viewManager.newText({
            parent   = popup,
            text     = CHARITY_LEVELS[i].reach,
            fontSize = 32,
            x        = display.contentWidth * 0.1,
            y        = lineY,
            anchorX  = 0,
        })

        local ticket   = display.newImage(popup, "assets/images/hud/rewards/rewards.ticket.png")
        ticket.x       = display.contentWidth*0.26
        ticket.anchorX = 1
        ticket.y       = lineY

        viewManager.newText({
            parent   = popup,
            text     = '= ' .. CHARITY_LEVELS[i].level .. 'x',
            fontSize = 32,
            x        = display.contentWidth * 0.31,
            y        = lineY,
            anchorX  = 0,
        })

        local charity   = display.newImage(popup, "assets/images/hud/rewards/rewards.charity.png")
        charity.x       = display.contentWidth*0.45
        charity.anchorX = 1
        charity.y       = lineY

        viewManager.newText({
            parent   = popup,
            text     = CHARITY_LEVELS[i].names[LANG],
            fontSize = 32,
            x        = display.contentWidth * 0.47,
            y        = lineY,
            anchorX  = 0,
        })

        viewManager.newText({
            parent   = popup,
            text     = '= ' .. CHARITY_LEVELS[i].bonus,
            fontSize = 32,
            x        = display.contentWidth * 0.77,
            y        = lineY,
            anchorX  = 0,
        })

        local reward   = display.newImage(popup, "assets/images/hud/rewards/rewards.bonusticket.png")
        reward.x       = display.contentWidth*0.95
        reward.anchorX = 1
        reward.y       = lineY

    end

    for i = 1, #CHARITY_LEVELS do
        line(i)
    end

    --------------------------

    hud.sep   = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x = display.contentWidth*0.5
    hud.sep.y = display.contentHeight*0.84

    hud.next = viewManager.newText({
        parent   = popup,
        text     = "<  " .. T "PREVIOUS",
        fontSize = 49,
        x        = display.contentWidth * 0.5,
        y        = display.contentHeight*0.895,
        anchorX  = 1,
    })

    utils.setGreen(hud.next)

    utils.onTouch(hud.next, function()
        viewManager.closePopup(popup)
        self:openRewards2()
    end)

    --------------------------

    hud.next = viewManager.newText({
        parent   = popup,
        text     = T "NEXT" .. "  >",
        fontSize = 49,
        x        = display.contentWidth * 0.6,
        y        = display.contentHeight*0.895,
        anchorX  = 0,
    })

    utils.setGreen(hud.next)

    utils.onTouch(hud.next, function()
        viewManager.closePopup(popup)
        self:openAmbassadorRewards()
    end)

    ---------------------------------------------------------------

    hud.close   = display.newImage( popup, "assets/images/hud/CroixClose.png")
    hud.close.x = display.contentWidth*0.89
    hud.close.y = display.contentHeight*0.085

    utils.onTouch(hud.close, function() viewManager.closePopup(popup) end)
end

--------------------------------------------------------------------------------

function ShareManager:openAmbassadorRewards()

    local top  = display.contentHeight * 0.3
    local yGap = display.contentHeight*0.082

    local popup = viewManager.showPopup()

    --------------------------

    hud.title         = display.newImage(popup, I "rewards.ambassador.title.png")
    hud.title.anchorX = 0
    hud.title.anchorY = 0.5
    hud.title.x       = display.contentWidth*0.05
    hud.title.y       = display.contentHeight*0.15

    --------------------------

    hud.sep   = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x = display.contentWidth*0.5
    hud.sep.y = display.contentHeight*0.2

    --------------------------

    hud.next = viewManager.newText({
        parent   = popup,
        text     = T "The more you invite friends, the more likely you are to win the Jackpot",
        fontSize = 35,
        x        = display.contentWidth  * 0.1,
        y        = display.contentHeight * 0.24,
        width    = display.contentWidth  * 0.8,
        heigth   = display.contentHeight * 0.02,
        anchorX  = 0,
        align    = "left"
    })

    --------------------------

    local line = function ( i )

        local lineY = display.contentHeight*0.3 + display.contentHeight*0.05 *i

        viewManager.newText({
            parent   = popup,
            text     = AMBASSADOR_LEVELS[i].reach,
            fontSize = 32,
            x        = display.contentWidth * 0.1,
            y        = lineY,
            anchorX  = 0,
        })

        local ambassador   = display.newImage(popup, "assets/images/hud/rewards/rewards.sponsoree.png")
        ambassador.x       = display.contentWidth*0.26
        ambassador.anchorX = 1
        ambassador.y       = lineY

        viewManager.newText({
            parent   = popup,
            text     = '= ' .. AMBASSADOR_LEVELS[i].level .. 'x',
            fontSize = 32,
            x        = display.contentWidth * 0.31,
            y        = lineY,
            anchorX  = 0,
        })

        local badge   = display.newImage(popup, "assets/images/hud/rewards/rewards.ambassador.png")
        badge.x       = display.contentWidth*0.45
        badge.anchorX = 1
        badge.y       = lineY

        viewManager.newText({
            parent   = popup,
            text     = AMBASSADOR_LEVELS[i].names[LANG],
            fontSize = 32,
            x        = display.contentWidth * 0.47,
            y        = lineY,
            anchorX  = 0,
        })

        viewManager.newText({
            parent   = popup,
            text     = '= ' .. AMBASSADOR_LEVELS[i].bonus,
            fontSize = 32,
            x        = display.contentWidth * 0.77,
            y        = lineY,
            anchorX  = 0,
        })

        local reward   = display.newImage(popup, "assets/images/hud/rewards/rewards.bonusticket.png")
        reward.x       = display.contentWidth*0.95
        reward.anchorX = 1
        reward.y       = lineY

    end

    for i = 1, #AMBASSADOR_LEVELS do
        line(i)
    end

    --------------------------

    hud.sep         = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x       = display.contentWidth*0.5
    hud.sep.y       = display.contentHeight*0.84

    hud.next = viewManager.newText({
        parent   = popup,
        text     = "<  " .. T "PREVIOUS",
        fontSize = 49,
        x        = display.contentWidth * 0.5,
        y        = display.contentHeight*0.895,
        anchorX  = 1,
    })

    utils.setGreen(hud.next)

    utils.onTouch(hud.next, function()
        viewManager.closePopup(popup)
        self:openCharityRewards()
    end)

    popup.close   = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x   = display.contentWidth*0.75
    popup.close.y   = display.contentHeight*0.895

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

    ---------------------------------------------------------------

    hud.close           = display.newImage( popup, "assets/images/hud/CroixClose.png")
    hud.close.x         = display.contentWidth*0.89
    hud.close.y         = display.contentHeight*0.085

    utils.onTouch(hud.close, function() viewManager.closePopup(popup) end)
end

--------------------------------------------------------------------------------

function ShareManager:openFacebookPage(popup)
    viewManager.openWeb(FACEBOOK_PAGE, function(event)
        print(event.url)
    end, function()

        -- lock to prevent webview to ask for callback many times
        if(self.checkingFBLike) then return end
        self.checkingFBLike = true

        native.setActivityIndicator( true )
        timer.performWithDelay(5000, function()
            userManager:readPlayer(function()

                native.setActivityIndicator( false )
                self.checkingFBLike = false

                if(userManager.user.networks.isFan) then
                    if(popup and popup.refresh) then
                        popup.refresh()
                    end
                else
                    viewManager.message(T "You haven't liked our page :-(")
                end

                self:moreTickets(popup)

            end)
        end)
    end)
end

--------------------------------------------------------------------------------

function ShareManager:inviteFBFriends()
    local title         = utils.urlEncode(T "Try your luck on Adillions !")
    local message       = utils.urlEncode(T "It's a free, fun and responsible game")
    local accessToken   = userManager:passport('facebook').tokens.accessToken

    local redirect_uri  = utils.urlEncode(SAILS_URL.."/backToMobile")
    local url           = "https://www.facebook.com/dialog/apprequests?app_id=".. FACEBOOK_APP_ID ..
                            "&message="         .. message ..
                            "&title="           .. title ..
                            "&data="            .. userManager.user.sponsorcode ..
                            "&redirect_uri="    .. redirect_uri

    self.listener       = function(event) self:inviteListener(event) end
    self.closeWebView   = viewManager.openWeb(url, self.listener)

end

------------------------------------------

function ShareManager:inviteListener( event )

    if event.url then
        print (event.url)

        if string.startsWith(event.url, SAILS_URL .. "/backToMobile?request=")
            or string.startsWith(event.url, "https://m.facebook.com/home.php") then
            self:closeWebView()

        elseif string.startsWith(event.url, SAILS_URL .. "/backToMobile") then

            self:closeWebView()
            local params = utils.getUrlParams(event.url);

            if(params.request) then
                print("-----> request " .. params.request )
                viewManager.message("Invitations sent !")
            end

        end

    end

end

--------------------------------------------------------------------------------

function ShareManager:prefixMessage(i)
    if(i == 0) then
        return T "Hey !"
    elseif(i == 1) then
        return T "Super !"
    elseif(i == 2) then
        return T "Great !"
    elseif(i == 3) then
        return T "Awesome !"
    elseif(i == 4) then
        return T "Fantatisc !"
    elseif(i == 5) then
        return T "Marvelous !"
    end
end

--------------------------------------------------------------------------------

function ShareManager:simpleShare()

    if(not GLOBALS.savedData.lastSimpleTweet) then
        GLOBALS.savedData.lastSimpleTweet = 1
        utils.saveTable(GLOBALS.savedData, "savedData.json")
    end

    if(not GLOBALS.savedData.lastSimplePost) then
        GLOBALS.savedData.lastSimplePost = 1
        utils.saveTable(GLOBALS.savedData, "savedData.json")
    end

    -----------------

    local canTweet = userManager.user.networks.connectedToTwitter
    local canPost  = userManager.user.networks.connectedToFacebook


    if(userManager.user.networks.connectedToTwitter) then
        GLOBALS.savedData.lastSimpleTweet = (GLOBALS.savedData.lastSimpleTweet + 1)%6
        utils.saveTable(GLOBALS.savedData, "savedData.json")
        local prefix = self:prefixMessage(GLOBALS.savedData.lastSimpleTweet)
        local text = prefix .. ' ' .. translate(lotteryManager.globals.tweetShare)
        self:write('twitter', text, function()end, function()end)
    end

    -----------------

    if(userManager.user.networks.connectedToFacebook) then
        GLOBALS.savedData.lastSimplePost = (GLOBALS.savedData.lastSimplePost + 1)%6
        utils.saveTable(GLOBALS.savedData, "savedData.json")
        local prefix = self:prefixMessage(GLOBALS.savedData.lastSimplePost)
        local text = prefix .. ' ' .. translate(lotteryManager.globals.tweetShare):gsub("#", "")
        self:write('facebook', text, function()end, function()end)
    end

    -----------------

    if(not canPost and not canTweet) then
        local options = {
            message  = translate(lotteryManager.globals.tweetShare),
            url      = "http://adillions.com",
            image    = {
                baseDir     = system.ResourceDirectory ,
                filename    = "assets/images/bylang/"..LANG.."/tweet.share.jpg"
            }
        }

        native.showPopup( "social", options )
    end

end

------------------------------------------

return ShareManager