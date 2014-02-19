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
                end

            else
                -- pas fan et pas connecte | button v2 : connect to enable button
                imageFacebook = I "stock.facebook.3.png"
                actionFacebook = function() 
                    facebook.connect(function()
                        router.resetScreen()
                        self:refreshScene()
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
                router.resetScreen()
                self:refreshScene()
            end) 
        end
    end

    -----------------------------------
    -- TWITTER BUTTON
    -----------------------------------

    local actionTwitter    = nil
    local imageTwitter     = nil
    
    if(userManager.user.twitter) then
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
                    twitter.follow(function()
                        native.setActivityIndicator( false )        
                        userManager.user.twitterFan = true
                        router.resetScreen()
                        self:refreshScene()
                    end) 
                end

            else
                -- pas fan et pas connecte | button v2 : connect to enable button
                imageTwitter = I "stock.twitter.2.png"
                actionTwitter = function() 
                    twitter.connect(function()
                        router.resetScreen()
                        self:refreshScene()
                    end) 
                end
                
            end

        end
    else
        -- button v1 : connect to link
        imageTwitter = I "stock.twitter.1.png"
        actionTwitter = function() 
            twitter.connect(function()
                router.resetScreen()
                self:refreshScene()
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
                router.openInviteFriends(backToHome)
                analytics.event("Social", "openFacebookFriendList") 
            end
        else
           actionFacebook = function() 
                facebook.connect(function()
                    router.openInviteFriends(backToHome)
                    analytics.event("Social", "openFacebookFriendListAfterConnection") 
                end) 
            end
        end

    else
        -- button v1 : connect to link
        imageFacebook = I "invite.facebook.1.png"
        actionFacebook = function() 
            facebook.connect(function()
                router.resetScreen()
                self:refreshScene()
            end) 
        end
        
    end
    
    -----------------------------------

    hud.popin.buttonFacebook         = display.newImage( hud.popin, imageFacebook)  
    hud.popin.buttonFacebook.x       = display.contentWidth * -0.35
    hud.popin.buttonFacebook.y       = hud.popin.contentMiddle
    utils.onTouch(hud.popin.buttonFacebook, actionFacebook)

    hud.popin.sms                   = display.newImage( hud.popin, I "invite.sms.png")  
    hud.popin.sms.x                 = 0
    hud.popin.sms.y                 = hud.popin.contentMiddle
    utils.onTouch(hud.popin.sms, function() self:sms() end)

    hud.popin.email                 = display.newImage( hud.popin, I "invite.email.png")  
    hud.popin.email.x               = display.contentWidth * 0.35
    hud.popin.email.y               = hud.popin.contentMiddle
    utils.onTouch(hud.popin.email, function() self:email() end)

    ----------------------------------------------------------------------------------------------------



end

-----------------------------------------------------------------------------------------

function ShareManager:shareForInstants()

    -----------------------------------

    viewManager.showPopin()
    analytics.event("Social", "popinShareForInstants")

    hud.popin.title         = display.newImage( hud.popin, I "stock.title.png")  
    hud.popin.title.x       = - display.contentWidth * 0.485
    hud.popin.title.y       = hud.popin.headerMiddle
    hud.popin.title.anchorX = 0

    hud.popin.what          = display.newImage( hud.popin, I "what.png")  
    hud.popin.what.x        = hud.popin.title.x + hud.popin.title.contentWidth
    hud.popin.what.y        = hud.popin.headerMiddle
    hud.popin.what.anchorX  = 0

    hud.popin.email         = display.newImage( hud.popin, I "stock.facebook.1.png")  
    hud.popin.email.x       = display.contentWidth * -0.2
    hud.popin.email.y       = hud.popin.contentMiddle

    hud.popin.email         = display.newImage( hud.popin, I "stock.twitter.4.png")  
    hud.popin.email.x       = display.contentWidth * 0.2
    hud.popin.email.y       = hud.popin.contentMiddle

    ----------------------------------------------------------------------------------------------------

end

-----------------------------------------------------------------------------------------

--- DEPRECATED
function ShareManager:share()

    -----------------------------------

    local popup = viewManager.showPopup()
    analytics.event("Social", "popupShare") 

    ----------------------------------------------------------------------------------------------------

    popup.shareIcon 				= display.newImage( popup, "assets/images/icons/PictoShare.png")  
    popup.shareIcon.x 			= display.contentWidth*0.5
    popup.shareIcon.y			= display.contentHeight*0.22

    popup.shareText 				= display.newImage( popup, I "popup.Txt3.png")  
    popup.shareText.x 			= display.contentWidth*0.5
    popup.shareText.y			= display.contentHeight*0.32


    popup.multiLineText = display.newText({
        parent	= popup,
        text 		= T "Earn Instant Tickets and increase the jackpot",  
        width 	= display.contentWidth*0.6,  
        height 	= display.contentHeight*0.25,  
        x 			= display.contentWidth*0.5,
        y 			= display.contentHeight*0.55,
        font 		= FONT, 
        fontSize = 34,
        align 	= "center",
    })

    popup.multiLineText:setFillColor(0)

    -----------------------------------
    -- Facebook
    -----------------------------------


    if(GLOBALS.savedData.facebookAccessToken) then
        popup.facebookShare 		= display.newImage( popup, I "popup.facebook.share.png")  
        popup.facebookShare.x 		= display.contentWidth*0.5
        popup.facebookShare.y		= display.contentHeight*0.63

        utils.onTouch(popup.facebookShare, function() 
            self:shareOnWall()
            analytics.event("Social", "facebookShare") 
        end)

    else
        popup.facebookConnect 		= display.newImage( popup, I "popup.facebook.connect.png")  
        popup.facebookConnect.x 	= display.contentWidth*0.5
        popup.facebookConnect.y	= display.contentHeight*0.63

        utils.onTouch(popup.facebookConnect, function() 
            facebook.connect(function()
                self:shareOnWall()
                analytics.event("Social", "facebookShareAfterConnection") 
            end) 
        end)

    end

    -----------------------------------
    -- Twitter
    -----------------------------------

    if(twitter.connected) then
        popup.twitterShare 			= display.newImage( popup, I "popup.twitter.share.png")  
        popup.twitterShare.x 		= display.contentWidth*0.5
        popup.twitterShare.y		= display.contentHeight*0.77	

        utils.onTouch(popup.twitterShare, function() 
            self:tweetShare()
            analytics.event("Social", "twitterShare") 
        end)

    else
        popup.twitterConnect 		= display.newImage( popup, I "popup.twitter.connect.png")  
        popup.twitterConnect.x 	= display.contentWidth*0.5
        popup.twitterConnect.y		= display.contentHeight*0.77

        utils.onTouch(popup.twitterConnect, function() 
            twitter.connect(function()
                analytics.event("Social", "twitterShareAfterConnection") 
                self:tweetShare()
            end) 
        end)

    end

    ----------------------------------------------------------------------------------------------------

    popup.close 				= display.newImage( popup, "assets/images/hud/CroixClose.png")
    popup.close.x 			= display.contentWidth*0.89
    popup.close.y 			= display.contentHeight*0.085

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)


end

-----------------------------------------------------------------------------------------

--- DEPRECATED
function ShareManager:invite(next)

    ----------------------------------------------------------------------------------------------------

    local popup = viewManager.showPopup()
    analytics.event("Social", "popupInvite") 

    ----------------------------------------------------------------------------------------------------

    popup.inviteIcon 			= display.newImage( popup, "assets/images/icons/PictoInvite.png")  
    popup.inviteIcon.x 			= display.contentWidth*0.5
    popup.inviteIcon.y			= display.contentHeight*0.22

    popup.inviteText 			= display.newImage( popup, I "popup.Txt2.png")  
    popup.inviteText.x 			= display.contentWidth*0.5
    popup.inviteText.y			= display.contentHeight*0.32

    popup.multiLineText = display.newText({
        parent	= popup,
        text 	= T "Earn Instant Tickets and increase the jackpot",  
        width 	= display.contentWidth*0.6,  
        height 	= display.contentHeight*0.25,  
        x 		= display.contentWidth*0.5,
        y 		= display.contentHeight*0.5,
        font 	= FONT, 
        fontSize= 34,
        align 	= "center",
    })

    popup.multiLineText:setFillColor(0)

    ----------------------------------------------------------------------------------------------------

    popup.sms 	= display.newImage( popup, I "popup.Btsms.png")  
    popup.sms.x = display.contentWidth*0.5
    popup.sms.y	= display.contentHeight*0.52

    utils.onTouch(popup.sms, function() self:sms() end) 

    ----------------------------------------------------------------------------------------------------

    popup.email 	= display.newImage( popup, I "popup.Btemail.png")  
    popup.email.x 	= display.contentWidth*0.5
    popup.email.y	= display.contentHeight*0.66

    utils.onTouch(popup.email, function() self:email() end) 

    ----------------------------------------------------------------------------------------------------

    if(GLOBALS.savedData.facebookAccessToken) then
        popup.facebookShare 		= display.newImage( popup, I "popup.facebook.invite.png")  
        popup.facebookShare.x 		= display.contentWidth*0.5
        popup.facebookShare.y		= display.contentHeight*0.8

        utils.onTouch(popup.facebookShare, function() 
            router.openInviteFriends(next)
            analytics.event("Social", "openFacebookFriendList") 
        end)

    else
        popup.facebookConnect 		= display.newImage( popup, I "popup.facebook.connect.png")  
        popup.facebookConnect.x 	= display.contentWidth*0.5
        popup.facebookConnect.y	= display.contentHeight*0.8

        utils.onTouch(popup.facebookConnect, function() 
            facebook.connect(function()
                router.openInviteFriends(next)
                analytics.event("Social", "openFacebookFriendListAfterConnection") 
            end) 
        end)

    end

    ----------------------------------------------------------------------------------------------------

    popup.close 			= display.newImage( popup, "assets/images/hud/CroixClose.png")
    popup.close.x 			= display.contentWidth*0.89
    popup.close.y 			= display.contentHeight*0.085

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

end

-----------------------------------------------------------------------------------------

function ShareManager:noMoreTickets()

    ----------------------------------------------------------------------------------------------------

    local popup = viewManager.showPopup()

    ----------------------------------------------------------------------------------------------------

    popup.icon 			= display.newImage( popup, "assets/images/icons/PictomaxTicket.png")
    popup.icon.x 		= display.contentWidth*0.5
    popup.icon.y 		= display.contentHeight*0.2

    popup.icon 			= display.newImage( popup, I "Sorry.png")
    popup.icon.x 		= display.contentWidth*0.5
    popup.icon.y 		= display.contentHeight*0.3

    ----------------------------------------------------------------------------------------------------

    viewManager.newText({
        parent 			= popup, 
        text	 			= T "You have reached the maximum number of Tickets for this draw",     
        x 					= display.contentWidth * 0.5,
        y 					= display.contentHeight*0.4,
        width				= display.contentWidth * 0.75,
        fontSize			= 37,
    })

    viewManager.newText({
        parent 			= popup, 
        text	 			= T "Increase your stock of Tickets",     
        x 					= display.contentWidth * 0.5,
        y 					= display.contentHeight*0.5,
        fontSize			= 37,
    })

    --------------------------

    popup.more 				= display.newImage( popup, I "more.tickets.png")
    popup.more.x 				= display.contentWidth*0.5
    popup.more.y 				= display.contentHeight*0.65

    utils.onTouch(popup.more, function() 
        viewManager.closePopup(popup) 
    end)

    --------------------------

    popup.close 				= display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x 			= display.contentWidth*0.5
    popup.close.y 			= display.contentHeight*0.83

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

    local text = T "I have just played a free lottery ticket on Adillions. You too, try your luck now !" .. "\n www.adillions.com" 

    facebook.postOnWall(text, function()

        print("---> postOnWall next")
        viewManager.closePopup(popup)
        viewManager.message(T "Thank you" .. " !  " .. T "Successfully posted on your wall !")
        if(not userManager.user.hasPostOnFacebook) then
            viewManager.showPoints(NB_POINTS_PER_POST)
            userManager.user.currentPoints = userManager.user.currentPoints + NB_POINTS_PER_POST
            userManager.user.hasPostOnFacebook = true
            userManager:updatePlayer()
        end 
    end)
end

-----------------------------------------------------------------------------------------

function ShareManager:tweetShare()

    local text = T "I have just played a free lottery ticket on Adillions. You too, try your luck now !" .. "\n www.adillions.com"

    twitter.tweetMessage(text, function()

        viewManager.closePopup(popup)
        viewManager.message(T "Thank you" .. " !  " .. T "Successfully tweeted")
        if(not userManager.user.hasTweet) then
            viewManager.showPoints(NB_POINTS_PER_TWEET)
            userManager.user.currentPoints = userManager.user.currentPoints + NB_POINTS_PER_TWEET
            userManager.user.hasTweet = true
            userManager:updatePlayer()
        end 
    end)
end

-----------------------------------------------------------------------------------------

return ShareManager