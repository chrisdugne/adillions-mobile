-----------------------------------------------------------------------------------------

ShareManager = {} 

-----------------------------------------------------------------------------------------

function ShareManager:new()  

    local object = {}

    setmetatable(object, { __index = ShareManager })
    return object
end

-----------------------------------------------------------------------------------------

function ShareManager:moreTickets()

    -----------------------------------

    viewManager.showPopin()
    analytics.event("Social", "popinMoreTickets")

    -----------------------------------

    hud.popin.title         = display.newImage( hud.popin, I "stock.title.png")  
    hud.popin.title.x       = - display.contentWidth * 0.485
    hud.popin.title.y       = hud.popin.headerMiddle
    hud.popin.title.anchorX = 0

    hud.popin.what          = display.newImage( hud.popin, I "what.png")  
    hud.popin.what.x        = hud.popin.title.x + hud.popin.title.contentWidth
    hud.popin.what.y        = hud.popin.headerMiddle
    hud.popin.what.anchorX  = 0

    -----------------------------------
    -- FB BUTTON
    -----------------------------------

    local actionFacebook    = nil
    local imageFacebook     = nil

    if(userManager.user.facebookId) then
        -- linked

        if(userManager.user.facebookFan) then
            -- fan | button v4
            imageFacebook   = I "stock.facebook.4.png"
            actionFacebook  = nil

        else
            if(GLOBALS.savedData.facebookAccessToken) then
                -- pas fan et connecte | button v3 : open FB page
                imageFacebook = I "stock.facebook.3.png"
                actionFacebook = function()
                    facebook.openFacebookPage()
                    viewManager.closePopin() 
                end

            else
                -- pas fan et pas connecte | button v2 : connect to enable button
                imageFacebook = I "stock.facebook.3.png"
                actionFacebook = function() 
                    facebook.connect(function()
                        viewManager.closePopin() 
                        facebook.openFacebookPage()
                    end) 
                end

            end

        end
    else
        -- button v1 : connect to link
        imageFacebook = I "stock.facebook.1.png"
        actionFacebook = function() 
            facebook.connect(function()
                viewManager.closePopin() 
                userManager:giftStock(FACEBOOK_CONNECTION_TICKETS)
                analytics.event("Social", "linkedFacebookFromMore") 
                self:moreTickets() 
            end) 
        end
    end

    -----------------------------------
    -- TWITTER BUTTON
    -----------------------------------

    local actionTwitter    = nil
    local imageTwitter     = nil

    if(userManager.user.twitterId) then
        -- linked

        if(userManager.user.twitterFan) then
            -- fan | button v4
            imageTwitter = I "stock.twitter.4.png"
            actionTwitter = nil

        else
            if(twitter.connected) then
                -- pas fan et connecte | button v3
                imageTwitter = I "stock.twitter.3.png"
                actionTwitter = function()
                    native.setActivityIndicator( true )  
                    viewManager.closePopin() 
                    twitter.follow(function()
                        native.setActivityIndicator( false )        
                        userManager.user.twitterFan = true
                        userManager:giftStock(TWITTER_FAN_TICKETS)
                        analytics.event("Social", "followTwitter") 
                    end) 
                end

            else
                -- pas fan et pas connecte | button v3 : connect + follow
                imageTwitter = I "stock.twitter.3.png"
                actionTwitter = function() 
                    twitter.connect(function()
                        viewManager.closePopin() 
                        twitter.follow(function()
                            native.setActivityIndicator( false )        
                            userManager.user.twitterFan = true
                            userManager:giftStock(TWITTER_FAN_TICKETS)
                            analytics.event("Social", "followTwitter") 
                        end) 
                    end) 
                end

            end

        end
    else
        -- button v1 : connect to link
        imageTwitter = I "stock.twitter.1.png"
        actionTwitter = function() 
            twitter.connect(function()
                viewManager.closePopin() 
                userManager:giftStock(TWITTER_CONNECTION_TICKETS)
                analytics.event("Social", "linkedTwitterFromMore") 
                self:moreTickets() 
            end) 
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

-----------------------------------------------------------------------------------------

function ShareManager:inviteForInstants()

    -----------------------------------

    viewManager.showPopin()
    analytics.event("Social", "popinInviteForInstants")

    -----------------------------------

    hud.popin.title         = display.newImage( hud.popin, I "instant.title.png")  
    hud.popin.title.x       = - display.contentWidth * 0.485
    hud.popin.title.y       = hud.popin.headerMiddle
    hud.popin.title.anchorX = 0

    hud.popin.what          = display.newImage( hud.popin, I "what.png")  
    hud.popin.what.x        = hud.popin.title.x + hud.popin.title.contentWidth
    hud.popin.what.y        = hud.popin.headerMiddle
    hud.popin.what.anchorX  = 0

    -----------------------------------
    -- FB BUTTON
    -----------------------------------

    local actionFacebook    = nil
    local imageFacebook     = nil
    local backToHome        = function() router.openHome() end

    if(userManager.user.facebookId) then

        -- linked
        if(GLOBALS.savedData.facebookAccessToken) then
            imageFacebook = I "invite.facebook.3.png"
            actionFacebook = function() 
                viewManager.closePopin() 
                router.openInviteFriends(backToHome)
                analytics.event("Social", "openFacebookFriendList") 
            end
        else
            actionFacebook = function() 
                facebook.connect(function()
                    viewManager.closePopin() 
                    router.openInviteFriends(backToHome)
                    analytics.event("Social", "openFacebookFriendList") 
                end) 
            end
        end

    else
        -- button v1 : connect to link
        imageFacebook = I "invite.facebook.1.png"
        actionFacebook = function() 
            facebook.connect(function()
                viewManager.closePopin() 
                userManager:giftStock(FACEBOOK_CONNECTION_TICKETS)
                analytics.event("Social", "linkedFacebookFromInvite") 
                self:inviteForInstants() 
            end) 
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

end

-----------------------------------------------------------------------------------------

function ShareManager:shareForInstants()

    print("----- shareForInstants")
    -----------------------------------

    viewManager.showPopin()
    analytics.event("Social", "popinShareForInstants")

    -----------------------------------

    hud.popin.title         = display.newImage( hud.popin, I "instant.title.png")  
    hud.popin.title.x       = - display.contentWidth * 0.485
    hud.popin.title.y       = hud.popin.headerMiddle
    hud.popin.title.anchorX = 0

    hud.popin.what          = display.newImage( hud.popin, I "what.png")  
    hud.popin.what.x        = hud.popin.title.x + hud.popin.title.contentWidth
    hud.popin.what.y        = hud.popin.headerMiddle
    hud.popin.what.anchorX  = 0

    ----------------------------------------------------------------------------------------------------
    -- FB BUTTON
    -----------------------------------

    print("----- facebook")
    local actionFacebook    = nil
    local imageFacebook     = nil

    if(userManager.user.facebookId) then
        -- linked

        print("LINKED")

        if(userManager.user.themeLiked) then
            print("themeLiked")

            if(userManager.user.hasPostOnFacebook) then

                print("hasPostOnFacebook")
                -- theme liked + hasPost | button v5
                imageFacebook   = I "share.facebook.5.png"
                actionFacebook  = function()
                    self:shareOnWall()
                    analytics.event("Social", "facebookShareWithoutReward")
                    viewManager.closePopin() 
                end

            else

                print(" ! hasPostOnFacebook")
                if(GLOBALS.savedData.facebookAccessToken) then

                    -- pas encore post et connecte | button v4 : postOnWall
                    imageFacebook = I "share.facebook.4.png"
                    actionFacebook = function()
                        self:shareOnWall()
                        analytics.event("Social", "facebookShare") 
                        viewManager.closePopin() 
                    end

                else
                    -- pas encore post et pas connecte | button v4 : connexion + postOnWall
                    imageFacebook = I "share.facebook.4.png"
                    actionFacebook = function() 
                        facebook.connect(function()
                            viewManager.closePopin() 
                            self:shareOnWall() 
                            analytics.event("Social", "facebookShare") 
                        end) 
                    end

                end

            end

        else
            -- theme not liked
            print(" ! theme liked")

            if(GLOBALS.savedData.facebookAccessToken) then

                -- theme not liked et connecte | button v3 : like theme
                imageFacebook = I "share.facebook.3.png"
                actionFacebook = function()
                    facebook.likeTheme()
                    analytics.event("Social", "facebookLikeTheme") 
                    viewManager.closePopin() 
                end

            else
                -- theme not liked  et pas connecte | button v3 : connexion + like theme
                imageFacebook = I "share.facebook.3.png"
                actionFacebook = function() 
                    facebook.connect(function()
                        facebook.likeTheme() 
                        analytics.event("Social", "facebookLikeTheme") 
                        viewManager.closePopin() 
                    end) 
                end

            end


        end

    else
        print(" !  linked")
        -- not linked button v1 : connect to link
        imageFacebook = I "share.facebook.1.png"
        actionFacebook = function() 
            facebook.connect(function()
                viewManager.closePopin() 
                userManager:giftStock(FACEBOOK_CONNECTION_TICKETS)
                analytics.event("Social", "linkedFacebookFromShare") 
                self:shareForInstants() 
            end) 
        end
    end

    ----------------------------------------------------------------------------------------------------
    -- TWITTER BUTTON
    -----------------------------------

    print("TWITTER")

    local imageTwitter     = nil
    local actionTwitter    = nil

    if(userManager.user.twitterId) then
        -- linked
        print("linked")

        if(userManager.user.hasTweetTheme) then
            print("hasTweetTheme")

            if(userManager.user.hasTweet) then

                print("hasTweet")
                -- theme tweeted + tweet | button v5
                imageTwitter = I "share.twitter.5.png"
                actionTwitter  = function()
                    viewManager.closePopin() 
                    self:tweet()
                    analytics.event("Social", "tweetWithoutReward") 
                end
            else

                print("! hasTweet")
                if(twitter.connected) then

                    -- pas encore tweet et connecte | button v4 : tweet
                    imageTwitter = I "share.twitter.4.png"
                    actionTwitter = function()
                        viewManager.closePopin() 
                        self:tweet()
                        analytics.event("Social", "tweet") 
                    end

                else
                    -- pas encore tweet et pas connecte | button v4 : connexion + tweet
                    imageTwitter = I "share.twitter.4.png"
                    actionTwitter = function() 
                        twitter.connect(function()
                            viewManager.closePopin() 
                            self:tweet() 
                            analytics.event("Social", "tweet") 
                        end) 
                    end

                end

            end

        else
            -- theme not tweeted   

                print("! hasTweetTheme")
            if(twitter.connected) then

                -- theme not tweeted et connecte | button v3 : tweet theme
                imageTwitter = I "share.twitter.3.png"
                actionTwitter = function()
                    viewManager.closePopin() 
                    self:tweetTheme()
                    analytics.event("Social", "tweetTheme") 
                end

            else
                -- theme not tweeted  et pas connecte | button v3 : connexion + tweet theme
                imageTwitter = I "share.twitter.3.png"
                actionTwitter = function() 
                    twitter.connect(function()
                        viewManager.closePopin() 
                        self:tweetTheme()
                        analytics.event("Social", "tweetTheme") 
                    end) 
                end

            end

        end

    else
        print("! linked")
        -- not linked button v1 : connect to link
        imageTwitter = I "share.twitter.1.png"
        actionTwitter = function() 
            twitter.connect(function()
                viewManager.closePopin() 
                userManager:giftStock(FACEBOOK_CONNECTION_TICKETS)
                analytics.event("Social", "linkedTwitterFromShare")
                self:shareForInstants() 
            end) 
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

-----------------------------------------------------------------------------------------

function ShareManager:sharePrize()

end

-----------------------------------------------------------------------------------------

function ShareManager:noMoreTickets()

    ----------------------------------------------------------------------------------------------------

    local popup = viewManager.showPopup()

    ----------------------------------------------------------------------------------------------------

    popup.icon    = display.newImage( popup, "assets/images/icons/PictomaxTicket.png")
    popup.icon.x   = display.contentWidth*0.5
    popup.icon.y   = display.contentHeight*0.2

    popup.icon    = display.newImage( popup, I "Sorry.png")
    popup.icon.x   = display.contentWidth*0.5
    popup.icon.y   = display.contentHeight*0.3

    ----------------------------------------------------------------------------------------------------

    viewManager.newText({
        parent    = popup, 
        text    = T "You have reached the maximum number of Tickets for this draw",     
        x     = display.contentWidth * 0.5,
        y     = display.contentHeight*0.4,
        width   = display.contentWidth * 0.75,
        fontSize  = 37,
    })

    viewManager.newText({
        parent    = popup, 
        text    = T "Increase your stock of Tickets",     
        x     = display.contentWidth * 0.5,
        y     = display.contentHeight*0.5,
        fontSize  = 37,
    })

    --------------------------

    popup.more    = display.newImage( popup, I "more.tickets.png")
    popup.more.x   = display.contentWidth*0.5
    popup.more.y   = display.contentHeight*0.65

    utils.onTouch(popup.more, function() 
        self:moreTickets() 
    end)

    --------------------------

    popup.close   = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x   = display.contentWidth*0.5
    popup.close.y   = display.contentHeight*0.83

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

    ----------------------------------------------------------------------------------------------------
end

-----------------------------------------------------------------------------------------

function ShareManager:sms()
    analytics.event("Social", "askSMS") 

    local body = T "Join me on Adillions and get a chance to win the jackpot !" 
    body = body .. "\n\n" 
    body = body .. T "MORE PLAYERS = A BIGGER JACKPOT"
    body = body .. "\n\n" 
    body = body .. T "Free and fun - Sign up now using my sponsorship code : " 
    body = body .. userManager.user.sponsorCode
    body = body .. "\n\n" 
    body = body .. T "Available on the App Store, Google Play, Facebook and on www.adillions.com"
    body = body .. "\n\n" 
    body = body .. T "Adillions is a free-to-play lottery game with real cash prizes funded by advertising" 

    local options = {
        body = body
    }

    native.showPopup("sms", options)
end

-----------------------------------------------------------------------------------------

function ShareManager:email()
    analytics.event("Social", "askEmail")

    local body = "<html><body>" 
    body = body .. T "Join me on Adillions and get a chance to win the jackpot !"
    body = body .. "<br/><br/>" 
    body = body .. T "MORE PLAYERS = A BIGGER JACKPOT"
    body = body .. "<br/><br/>" 
    body = body .. T "Free and fun - Sign up now using my sponsorship code : " 
    body = body .. userManager.user.sponsorCode
    body = body .. "<br/><br/>" 
    body = body .. T "Available on the App Store, Google Play, Facebook and on www.adillions.com"
    body = body .. "<br/><br/>" 
    body = body .. T "Adillions is a free-to-play lottery game with real cash prizes funded by advertising" 
    body = body .. "</body></html>" 

    local options =
    {
        body = body,
        isBodyHtml = true,
        subject = "Adillions",
    }

    native.showPopup("mail", options)
end

-----------------------------------------------------------------------------------------

function ShareManager:shareOnWall()

    local text = translate(lotteryManager.global.fbPost) 

    facebook.postOnWall(text, function()

        viewManager.closePopup(popup)
        viewManager.message(T "Thank you" .. " !  " .. T "Successfully posted on your wall !")

        if(not userManager.user.hasPostOnFacebook) then
            userManager.user.hasPostOnFacebook = true
            userManager:giftInstants(NB_INSTANTS_PER_POST)
        end

    end)
end

-----------------------------------------------------------------------------------------

function ShareManager:tweetTheme()

    local text = translate(lotteryManager.global.tweetTheme)

    print(userManager.user.hasTweetTheme)
    twitter.tweetMessage(text, function()

        viewManager.closePopup(popup)
        viewManager.message(T "Thank you" .. " !  " .. T "Successfully tweeted")

        print("tweet ok")
        print(userManager.user.hasTweetTheme)

        if(not userManager.user.hasTweetTheme) then
            userManager.user.hasTweetTheme = true
            userManager:giftInstants(NB_INSTANTS_PER_TWEET)
        end

    end)
end

-----------------------------------------------------------------------------------------

function ShareManager:tweet()

    local text = translate(lotteryManager.global.tweet)

    twitter.tweetMessage(text, function()

        viewManager.closePopup(popup)
        viewManager.message(T "Thank you" .. " !  " .. T "Successfully tweeted")

        if(not userManager.user.hasTweet) then
            userManager.user.hasTweet = true
            userManager:giftInstants(NB_INSTANTS_PER_TWEET)
        end 

    end)
end

-----------------------------------------------------------------------------------------

function ShareManager:openRewards1()

    local top   = display.contentHeight * 0.3
    local yGap  = display.contentHeight*0.082

    local popup = viewManager.showPopup()

    --------------------------


    hud.title    = display.newImage(popup, I "rewards.stock.title.png")
    hud.title.anchorX  = 0
    hud.title.anchorY  = 0.5
    hud.title.x   = display.contentWidth*0.1
    hud.title.y   = display.contentHeight*0.15

    --------------------------

    hud.sep    = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x        = display.contentWidth*0.5
    hud.sep.y       = display.contentHeight*0.2

    --------------------------

    hud.next = viewManager.newText({
        parent          = popup,
        text            = T "Increase your stock of Tickets", 
        fontSize        = 35,  
        x               = display.contentWidth * 0.1,
        y               = display.contentHeight*0.23,
        anchorX         = 0,
    })

    --------------------------

    for i = 1,6 do
        hud.line    = display.newImage(popup, I "rewards.stock".. i ..".png")
        hud.line.x    = display.contentWidth*0.5
        hud.line.y    = display.contentHeight*0.215 + display.contentHeight*0.09 *i
    end

    --------------------------

    hud.next = viewManager.newText({
        parent          = popup,
        text            = T "*Only for the next drawing", 
        fontSize        = 29,  
        x               = display.contentWidth * 0.1,
        y               = display.contentHeight*0.82,
        anchorX         = 0,
    })

    --------------------------

    hud.sep   = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x   = display.contentWidth*0.5
    hud.sep.y   = display.contentHeight*0.84

    hud.next = viewManager.newText({
        parent    = popup,
        text    = T "NEXT" .. "  >", 
        fontSize  = 49,  
        x     = display.contentWidth * 0.5,
        y     = display.contentHeight*0.895,
    })

    utils.setGreen(hud.next)

    utils.onTouch(hud.next, function()
        viewManager.closePopup(popup) 
        self:openRewards2() 
    end)

    ---------------------------------------------------------------

    hud.close    = display.newImage( popup, "assets/images/hud/CroixClose.png")
    hud.close.x   = display.contentWidth*0.89
    hud.close.y   = display.contentHeight*0.085

    utils.onTouch(hud.close, function() viewManager.closePopup(popup) end)

end

------------------------------------------

function ShareManager:openRewards2()

    local top  = display.contentHeight * 0.3
    local yGap = display.contentHeight*0.082

    local popup = viewManager.showPopup()

    --------------------------

    hud.title           = display.newImage(popup, I "rewards.instant.title.png")
    hud.title.anchorX  = 0
    hud.title.anchorY  = 0.5
    hud.title.x   = display.contentWidth*0.1
    hud.title.y   = display.contentHeight*0.15

    --------------------------

    hud.sep       = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x       = display.contentWidth*0.5
    hud.sep.y       = display.contentHeight*0.2

    --------------------------

    hud.next = viewManager.newText({
        parent          = popup,
        text            = T "Play right now thanks to Instant Tickets", 
        fontSize        = 34,  
        x               = display.contentWidth * 0.1,
        y               = display.contentHeight*0.23,
        anchorX         = 0,
    })

    --------------------------

    for i = 1,5 do
        hud.line        = display.newImage(popup, I "rewards.instant".. i ..".png")
        hud.line.x      = display.contentWidth*0.5
        hud.line.y      = display.contentHeight*0.205 + display.contentHeight*0.1 *i
    end

    --------------------------

    hud.sep       = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x       = display.contentWidth*0.5
    hud.sep.y       = display.contentHeight*0.84

    --------------------------

    hud.next = viewManager.newText({
        parent    = popup,
        text    = "<  " .. T "PREVIOUS", 
        fontSize  = 49,  
        x     = display.contentWidth * 0.5,
        y     = display.contentHeight*0.895,
        anchorX         = 1,
    })

    utils.setGreen(hud.next)

    utils.onTouch(hud.next, function() 
        viewManager.closePopup(popup) 
        self:openRewards1() 
    end)

    --------------------------

    hud.next = viewManager.newText({
        parent          = popup,
        text            = T "*For the sponsor and the sponsored user (2 draws min.)", 
        fontSize        = 29,  
        x               = display.contentWidth * 0.1,
        y               = display.contentHeight*0.785,
        anchorX         = 0,
    })

    hud.next = viewManager.newText({
        parent          = popup,
        text            = T "** Per post (max. 4 Instants per draw)", 
        fontSize        = 29,  
        x               = display.contentWidth * 0.1,
        y               = display.contentHeight*0.81,
        anchorX         = 0,
    })

    --------------------------

    hud.next = viewManager.newText({
        parent          = popup,
        text            = T "NEXT" .. "  >", 
        fontSize        = 49,  
        x               = display.contentWidth * 0.6,
        y               = display.contentHeight*0.895,
        anchorX         = 0,
    })

    utils.setGreen(hud.next)

    utils.onTouch(hud.next, function()
        viewManager.closePopup(popup) 
        self:openRewards3() 
    end)

    ---------------------------------------------------------------

    hud.close           = display.newImage( popup, "assets/images/hud/CroixClose.png")
    hud.close.x         = display.contentWidth*0.89
    hud.close.y         = display.contentHeight*0.085

    utils.onTouch(hud.close, function() viewManager.closePopup(popup) end)

end


------------------------------------------

function ShareManager:openRewards3()

    local top  = display.contentHeight * 0.3
    local yGap = display.contentHeight*0.082

    local popup = viewManager.showPopup()

    --------------------------

    hud.title           = display.newImage(popup, I "rewards.charity.title.png")
    hud.title.anchorX  = 0
    hud.title.anchorY  = 0.5
    hud.title.x   = display.contentWidth*0.1
    hud.title.y   = display.contentHeight*0.15

    --------------------------

    hud.sep       = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x       = display.contentWidth*0.5
    hud.sep.y       = display.contentHeight*0.2

    --------------------------

    hud.next = viewManager.newText({
        parent          = popup,
        text            = T "The more you play Adillions, the more you contribute to charities", 
        fontSize        = 35,  
        x               = display.contentWidth  * 0.1,
        y               = display.contentHeight * 0.24,
        width           = display.contentWidth  * 0.8,
        heigth          = display.contentHeight * 0.02,
        anchorX         = 0,
        align           = "left"
    })

    --------------------------

    for i = 1,5 do
        hud.line        = display.newImage(popup, I "rewards.charity".. i ..".png")
        hud.line.x      = display.contentWidth*0.5
        hud.line.y      = display.contentHeight*0.22 + display.contentHeight*0.11 *i
    end

    --------------------------

    hud.sep       = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x       = display.contentWidth*0.5
    hud.sep.y       = display.contentHeight*0.84

    hud.next = viewManager.newText({
        parent    = popup,
        text    = "<  " .. T "PREVIOUS", 
        fontSize  = 49,  
        x               = display.contentWidth * 0.5,
        y               = display.contentHeight*0.895,
        anchorX         = 1,
    })

    utils.setGreen(hud.next)

    utils.onTouch(hud.next, function() 
        viewManager.closePopup(popup) 
        self:openRewards2() 
    end)

    popup.close   = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x   = display.contentWidth*0.75
    popup.close.y   = display.contentHeight*0.895

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

end

-----------------------------------------------------------------------------------------

return ShareManager