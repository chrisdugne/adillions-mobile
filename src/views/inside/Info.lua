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
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()

    ------------------

    self.top                = HEADER_HEIGHT + display.contentHeight*0.11
    self.yGap               = display.contentHeight*0.15

    self.column1 = display.contentWidth*0.3
    self.column2 = display.contentWidth*0.7

    ------------------

    hud.bg 		= display.newImageRect(hud, "assets/images/hud/Infos_Bg.png", display.contentWidth, display.viewableContentHeight*0.8)
    hud.bg.x 	= display.contentWidth*0.5
    hud.bg.y 	= display.contentHeight*0.5

    ------------------

    hud.options 			= display.newImage( hud, I "info.Options.png")  
    hud.options.x 			= self.column1
    hud.options.y			= self.top

    utils.onTouch(hud.options, function()
        self:openOptions()
    end)

    hud.tutorial 			= display.newImage( hud, I "info.Tutorial.png")  
    hud.tutorial.x 		= self.column2
    hud.tutorial.y			= self.top

    utils.onTouch(hud.tutorial, function()
        router.openTutorial()
    end)

    ------------------

    hud.prize 				= display.newImage( hud, I "info.Prize.png")  
    hud.prize.x 			= self.column1
    hud.prize.y				= self.top + self.yGap

    utils.onTouch(hud.prize, function()
        analytics.event("Links", "prizes") 
        self:openPrizes()
    end)

    hud.rewards 			= display.newImage( hud, I "info.Rewards.png")  
    hud.rewards.x 			= self.column2
    hud.rewards.y			= self.top + self.yGap

    utils.onTouch(hud.rewards, function()
        analytics.event("Links", "rewards") 
        self:openRewards1()
    end)

    ------------------

    hud.contact 			= display.newImage( hud, I "info.Contact.png")  
    hud.contact.x 			= self.column1
    hud.contact.y			= self.top + self.yGap * 2

    utils.onTouch(hud.contact, function()
        self:openContact()
    end)

    hud.faq 			    = display.newImage( hud, I "info.Faq.png")  
    hud.faq.x 				= self.column2
    hud.faq.y				= self.top + self.yGap * 2

    utils.onTouch(hud.faq, function()
        analytics.event("Links", "faq") 
        system.openURL( SERVER_URL .. "#/about/faq" )
    end)

    ------------------

    hud.terms 				= display.newImage( hud, I "info.Terms.png")  
    hud.terms.x 			= self.column1
    hud.terms.y				= self.top + self.yGap * 3

    utils.onTouch(hud.terms, function()
        analytics.event("Links", "terms") 
        self:openTerms()
    end)

    hud.privacy 			= display.newImage( hud, I "info.Privacy.png")  
    hud.privacy.x 			= self.column2
    hud.privacy.y			= self.top + self.yGap * 3

    utils.onTouch(hud.privacy, function()
        analytics.event("Links", "privacy") 
        system.openURL( SERVER_URL .. "#/about/privacy" )
    end)

    ------------------

    hud.write 				= display.newImage( hud, I "info.Write.png")  
    hud.write.x 			= display.contentWidth * 0.5
    hud.write.y				= self.top + self.yGap * 4

    utils.onTouch(hud.write, function()
        analytics.event("Links", "writeReview") 
        local options =
        {
            iOSAppId = "739060819",
            androidAppPackageName = "com.adillions.v1",
            supportedAndroidStores = { "google" },
        }
        native.showPopup("appStore", options) 
    end)

    --	------------------
    --	
    --	hud.facebookIcon 			= display.newImage( hud.board, "assets/images/icons/facebook.png")  
    --	hud.facebookIcon.x 		= display.contentWidth*0.5
    --	hud.facebookIcon.y		= display.contentHeight*0.2
    --	hud.board:insert(hud.facebookIcon)
    --
    --	utils.onTouch(hud.facebookIcon, function()
    --		system.openURL( "https://www.facebook.com/pages/Adillions/379432705492888" )
    --	end)
    --
    --	------------------
    --
    --	hud.twitterIcon 			= display.newImage( hud.board, "assets/images/icons/twitter.png")  
    --	hud.twitterIcon.x 		= display.contentWidth*0.5
    --	hud.twitterIcon.y		= display.contentHeight*0.3
    --	hud.board:insert(hud.twitterIcon)
    --
    --	utils.onTouch(hud.twitterIcon, function()
    --		system.openURL( "http://www.twitter.com/adillions" )
    --	end)

    ------------------
    --	
    --	viewManager.drawButton(hud.board, "_Reglement", display.contentWidth*0.5, display.contentHeight *0.4, function() system.openURL( "http://www.adillions.com" ) end)
    --
    --	------------------
    --	
    --	viewManager.drawButton(hud.board, "_FAQ", display.contentWidth*0.5, display.contentHeight *0.5, function() system.openURL( "http://www.adillions.com" ) end)
    --
    --	viewManager.drawButton(hud.board, "_Write a review", display.contentWidth*0.5, display.contentHeight *0.5, function()
    --		local options =
    --		{
    --			iOSAppId = "739060819",
    --			androidAppPackageName = "com.adillions.v1",
    --			supportedAndroidStores = { "google" },
    --		}
    --		native.showPopup("appStore", options) 
    --	end)
    --
    --	---------------------------------------------------------------------------------
    --
    --	viewManager.drawButton(hud.board, "_Options", display.contentWidth*0.5, display.contentHeight *0.6, function() router.openOptions() end)
    --
    --	---------------------------------------------------------------------------------
    --
    --	viewManager.drawButton(hud.board, "tuto", display.contentWidth*0.5, display.contentHeight *0.7, function() router.openTutorial() end)

    ---------------------------------------------------------------------------------

    viewManager.setupView(5)
    self.view:insert(hud)

    viewManager.darkerBack()
end

------------------------------------------

function scene:openPrizes()

    local top	 	= display.contentHeight * 0.35
    local yGap		= display.contentHeight * 0.082

    viewManager.showPopup()

    --------------------------

    viewManager.newText({
        parent = hud.popup, 
        text = T "Last updated : January 05th, 2014",
        x = display.contentWidth*0.9,
        y = display.contentHeight * 0.08,
        fontSize = 26,
        font		= FONT,
        anchorX 			= 1,
        anchorY 			= 1,
    })

    --------------------------

    hud.picto 			= display.newImage(hud.popup, "assets/images/icons/PrizeTitle.png")
    hud.picto.x 		= display.contentWidth*0.14
    hud.picto.y 		= display.contentHeight*0.15
    hud.picto:scale(0.7,0.7)

    hud.title 			= display.newImage(hud.popup, I "Prize.png")

    hud.title.anchorX 			= 0
    hud.title.anchorY 			= 0.5
    hud.title.x 		= display.contentWidth*0.22
    hud.title.y 		= display.contentHeight*0.15

    hud.sep 			= display.newImage(hud.popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x 		= display.contentWidth*0.5
    hud.sep.y 		= display.contentHeight*0.2

    --------------------------

    viewManager.newText({
        parent = hud.popup, 
        text = T "Match", 
        x = display.contentWidth*0.45,
        y = display.contentHeight * 0.24,
        fontSize = 32,
        font = NUM_FONT
    })

    viewManager.newText({
        parent = hud.popup, 
        text = T "n° + LB", 
        x = display.contentWidth*0.45,
        y = display.contentHeight * 0.27,
        fontSize = 32,
        font = NUM_FONT
    })

    viewManager.newText({
        parent = hud.popup, 
        text = T "Prize", 
        x = display.contentWidth * 0.8,
        y = display.contentHeight * 0.24,
        fontSize = 32,
        font = NUM_FONT
    })

    viewManager.newText({
        parent = hud.popup, 
        text = T "breakdown", 
        x = display.contentWidth * 0.8,
        y = display.contentHeight * 0.27,
        fontSize = 32,
        font = NUM_FONT
    })

    local matches 		= lotteryManager.nextDrawing.rangs.matches
    local percents 	= lotteryManager.nextDrawing.rangs.percents

    for i = 1, #matches do

        hud.iconRang 			= display.newImage( hud.popup, "assets/images/icons/rangs/R".. i .. ".png")
        hud.iconRang.x 		= display.contentWidth * 0.2
        hud.iconRang.y 		= top + yGap * (i-1)

        viewManager.newText({
            parent 			= hud.popup, 
            text	 			= matches[i],     
            x 					= display.contentWidth*0.45,
            y 					= top + yGap * (i-1) ,
            fontSize 		= 35,
        })

        viewManager.newText({
            parent 			= hud.popup, 
            text	 			= percents[i] .. '%',     
            x 					= display.contentWidth*0.75,
            y 					= top + yGap * (i-1) ,
            fontSize 		= 35,
        })

        hud.iconPieces 			= display.newImage( hud.popup, "assets/images/icons/PictoPrize.png")
        hud.iconPieces.x 			= display.contentWidth * 0.86
        hud.iconPieces.y 			= top + yGap * (i-1) - display.contentHeight*0.0005

    end

    --------------------------

    hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
    hud.popup.close.x 			= display.contentWidth*0.5
    hud.popup.close.y 			= display.contentHeight*0.88

    utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)

end


------------------------------------------

function scene:openTerms()

    local top	 	= display.contentHeight * 0.35
    local yGap		= display.contentHeight*0.082

    viewManager.showPopup()

    --------------------------

    hud.picto 			= display.newImage(hud.popup, "assets/images/icons/PictoTerms.png")
    hud.picto.x 		= display.contentWidth*0.14
    hud.picto.y 		= display.contentHeight*0.1

    hud.title 			= display.newImage(hud.popup, I "terms.png")

    hud.title.anchorX 			= 0
    hud.title.anchorY 			= 0.5
    hud.title.x 		= display.contentWidth*0.22
    hud.title.y 		= display.contentHeight*0.1

    hud.sep 			= display.newImage(hud.popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x 		= display.contentWidth*0.5
    hud.sep.y 		= display.contentHeight*0.15

    --------------------------

    hud.textImportant = display.newText(
    hud.popup, 
    "Important", 
    0, 0, display.contentWidth*0.8, display.contentHeight*0.25, NUM_FONT, 35 )

    hud.textImportant.x = display.contentWidth*0.5
    hud.textImportant.y = display.contentHeight*0.29
    hud.textImportant:setFillColor(0)

    hud.text = display.newText(
    hud.popup, 
    T "Adillions - a simplified joint-stock company (S.A.S.), registered at the Paris RCS (France) under No. 797 736 261, organizes free games without any purchase obligation, for an indefinite period.", 
    0, 0, display.contentWidth*0.8, display.contentHeight*0.25, FONT, 35 )

    hud.text.x = display.contentWidth*0.5
    hud.text.y = display.contentHeight*0.33
    hud.text:setFillColor(0)

    local company = "Apple Inc. "
    if(ANDROID) then company = "Google Inc " end

    hud.text2 = display.newText(
    hud.popup, 
    company .. (T "is not an organizer, a co-organizer or a partner of Adillions. ") .. company .. (T "is not involved in any way in the organization of the Adillions lottery and does not sponsor it."), 
    0, 0, display.contentWidth*0.8, display.contentHeight*0.25, FONT, 35 )

    hud.text2.x = display.contentWidth*0.5
    hud.text2.y = display.contentHeight*0.53
    hud.text2:setFillColor(0)

    --------------------------

    hud.popup.keyrules 			= display.newImage( hud.popup, I "key.rules.png")
    hud.popup.keyrules.x 		= display.contentWidth*0.5
    hud.popup.keyrules.y 		= display.contentHeight*0.65

    utils.onTouch(hud.popup.keyrules, function() 
        system.openURL( SERVER_URL .. "#/about/keyrules" )
    end)

    --------------------------

    hud.popup.read 		= display.newImage( hud.popup, I "read.terms.png")
    hud.popup.read.x 		= display.contentWidth*0.5
    hud.popup.read.y 		= display.contentHeight*0.78

    utils.onTouch(hud.popup.read, function() 
        router.openTerms()
    end)

    --------------------------

    hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
    hud.popup.close.x 			= display.contentWidth*0.5
    hud.popup.close.y 			= display.contentHeight*0.9

    utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)
end

------------------------------------------------------------------------------

function scene:openOptions()

    local top	 	= display.contentHeight * 0.15
    local yGap		= display.contentHeight*0.15

    viewManager.showPopup()

    --------------------------

    local optionsTop 		= 1

    local fontSizeLeft 	= 27
    local fontSizeRight 	= 29

    --------------------------

    hud.picto 			= display.newImage(hud.popup, "assets/images/icons/PictoOptions.png")
    hud.picto.x 		= display.contentWidth*0.14
    hud.picto.y 		= display.contentHeight*0.15

    hud.title 			= display.newImage(hud.popup, I "Options.png")

    hud.title.anchorX 			= 0
    hud.title.anchorY 			= 0.5
    hud.title.x 		= display.contentWidth*0.22
    hud.title.y 		= display.contentHeight*0.15

    hud.sep 			= display.newImage(hud.popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x 		= display.contentWidth*0.5
    hud.sep.y 		= display.contentHeight*0.2

    ---------------------------------------------------------------------------------
    -- Options
    ---------------------------------------------------------------

    local function beforeDrawSwitchListener( event )
        GLOBALS.options.notificationBeforeDraw = event.target.isOn
        utils.saveTable(GLOBALS.options, "options.json")

        lotteryManager:refreshNotifications(lotteryManager.nextLottery.date)
    end

    local function afterDrawSwitchListener( event )
        GLOBALS.options.notificationAfterDraw = event.target.isOn
        utils.saveTable(GLOBALS.options, "options.json")

        lotteryManager:refreshNotifications(lotteryManager.nextLottery.date)	
    end

    ---------------------------------------------------------------

    viewManager.newText({
        parent 			= hud.popup, 
        text 				= T "Notification 48h before the next draw",         
        x 					= display.contentWidth*0.11,
        y 					= top + yGap*(optionsTop),
        fontSize 		= fontSizeLeft,
        anchorX 			= 0,
        anchorY 			= 0.5,
    })

    local beforeDrawSwitch = widget.newSwitch
    {
        left 							= display.contentWidth*0.75,
        top 							= top + yGap*(optionsTop-0.05),
        initialSwitchState	 	= GLOBALS.options.notificationBeforeDraw,
        onPress 						= beforeDrawSwitchListener,
        onRelease 					= beforeDrawSwitchListener,
    }

    beforeDrawSwitch:scale(2,2)	

    viewManager.newText({
        parent 			= hud.popup, 
        text 				= T "Notification for the results",         
        x 					= display.contentWidth*0.11,
        y 					= top + yGap*(optionsTop+0.5),
        fontSize 		= fontSizeLeft,
        anchorX 			= 0,
        anchorY 			= 0.5,
    })


    local afterDrawSwitch = widget.newSwitch
    {
        left 							= display.contentWidth*0.75,
        top 							= top + yGap*(optionsTop+0.45),
        initialSwitchState	 	= GLOBALS.options.notificationAfterDraw,
        onPress 						= afterDrawSwitchListener,
        onRelease 					= afterDrawSwitchListener,
    }

    afterDrawSwitch:scale(2,2)	

    hud.popup:insert( beforeDrawSwitch )	
    hud.popup:insert( afterDrawSwitch )	

    --------------------------

    hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
    hud.popup.close.x 			= display.contentWidth*0.5
    hud.popup.close.y 			= display.contentHeight*0.85

    utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)

end

------------------------------------------------------------------------------

function scene:openContact()

    local top	 	= display.contentHeight * 0.3
    local yGap		= display.contentHeight*0.082

    viewManager.showPopup()

    --------------------------

    hud.picto 			= display.newImage(hud.popup, "assets/images/icons/PictoContact.png")
    hud.picto.x 		= display.contentWidth*0.14
    hud.picto.y 		= display.contentHeight*0.15

    hud.title 			= display.newImage(hud.popup, I "Contact.png")

    hud.title.anchorX 			= 0
    hud.title.anchorY 			= 0.5
    hud.title.x 		= display.contentWidth*0.22
    hud.title.y 		= display.contentHeight*0.15

    hud.sep 			= display.newImage(hud.popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x 		= display.contentWidth*0.5
    hud.sep.y 		= display.contentHeight*0.2

    --------------------------

    viewManager.newText({
        parent = hud.popup, 
        text = T "By email", 
        x = display.contentWidth*0.1,
        y = display.contentHeight * 0.27,
        fontSize = 40,
        font = NUM_FONT,
        anchorX 			= 0,
        anchorY 			= 0.5,
    })

    --------------------------

    viewManager.newText({
        parent = hud.popup, 
        text = T "General information" .. " :", 
        x = display.contentWidth*0.1,
        y = display.contentHeight * 0.31,
        fontSize = 26,
        anchorX 			= 0,
        anchorY 			= 0.5,
    })

    viewManager.newText({
        parent = hud.popup, 
        text = "contact@adillions.com", 
        x = display.contentWidth*0.9,
        y = display.contentHeight * 0.31,
        fontSize = 26,
        font		= NUM_FONT,
        anchorX 			= 1,
        anchorY 			= 0.5,
    })

    viewManager.newText({
        parent = hud.popup, 
        text = T "For technical issues" .. " :", 
        x = display.contentWidth*0.1,
        y = display.contentHeight * 0.36,
        fontSize = 26,
        anchorX 			= 0,
        anchorY 			= 0.5,
    })

    viewManager.newText({
        parent = hud.popup, 
        text = "support@adillions.com", 
        x = display.contentWidth*0.9,
        y = display.contentHeight * 0.36,
        fontSize = 26,
        font		= NUM_FONT,
        anchorX 			= 1,
        anchorY 			= 0.5,
    })

    viewManager.newText({
        parent = hud.popup, 
        text = T "For payments" .. " :", 
        x = display.contentWidth*0.1,
        y = display.contentHeight * 0.41,
        fontSize = 26,
        anchorX 			= 0,
        anchorY 			= 0.5,
    })

    viewManager.newText({
        parent = hud.popup, 
        text = "winners@adillions.com", 
        x = display.contentWidth*0.9,
        y = display.contentHeight * 0.41,
        fontSize = 26,
        font		= NUM_FONT,
        anchorX 			= 1,
        anchorY 			= 0.5,
    })

    viewManager.newText({
        parent = hud.popup, 
        text = T "For advertisers" .. " :", 
        x = display.contentWidth*0.1,
        y = display.contentHeight * 0.46,
        fontSize = 26,
        anchorX 			= 0,
        anchorY 			= 0.5,
    })

    viewManager.newText({
        parent = hud.popup, 
        text = "advertisers@adillions.com", 
        x = display.contentWidth*0.9,
        y = display.contentHeight * 0.46,
        fontSize = 26,
        font		= NUM_FONT,
        anchorX 			= 1,
        anchorY 			= 0.5,
    })

    --------------------------

    viewManager.newText({
        parent = hud.popup, 
        text = T "On the web", 
        x = display.contentWidth*0.1,
        y = display.contentHeight * 0.6,
        fontSize = 40,
        font = NUM_FONT,
        anchorX 			= 0,
        anchorY 			= 0.5,
    })

    --------------------------

    viewManager.newText({
        parent = hud.popup, 
        text = "www.adillions.com", 
        x = display.contentWidth*0.5,
        y = display.contentHeight * 0.65,
        fontSize = 56,
        font		= NUM_FONT,
    })

    --------------------------

    hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
    hud.popup.close.x 			= display.contentWidth*0.5
    hud.popup.close.y 			= display.contentHeight*0.85

    utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)

end

------------------------------------------

function scene:openRewards1()

    local top	 	= display.contentHeight * 0.3
    local yGap		= display.contentHeight*0.082

    viewManager.showPopup()

    --------------------------

    hud.picto 			= display.newImage(hud.popup, "assets/images/icons/Picto_BonusTicket.png")
    hud.picto.x 		= display.contentWidth*0.14
    hud.picto.y 		= display.contentHeight*0.15

    hud.title 			= display.newImage(hud.popup, I "moretickets.png")

    hud.title.anchorX 			= 0
    hud.title.anchorY 			= 0.5
    hud.title.x 		= display.contentWidth*0.22
    hud.title.y 		= display.contentHeight*0.15

    hud.sep 			= display.newImage(hud.popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x 		= display.contentWidth*0.5
    hud.sep.y 		= display.contentHeight*0.2

    --------------------------

    --	hud.text = display.newText(
    --		hud.popup, 
    --		T "Increase your number of available Tickets for the next draws", 
    --		0, 0, display.contentWidth*0.8, display.contentHeight*0.25, FONT, 36 )
    --		
    --	hud.text.x = display.contentWidth*0.5
    --	hud.text.y = display.contentHeight*0.34
    --	hud.text:setFillColor(0)

    --------------------------

    hud.fb1 				= display.newImage(hud.popup, "assets/images/rewards/CharityLine.png")

    hud.fb1.anchorX 	= 0.5
    hud.fb1.anchorY 	= 0.5
    hud.fb1.x 			= display.contentWidth*0.5
    hud.fb1.y 			= display.contentHeight*0.3

    --------------------------

    hud.fb1 			= display.newImage(hud.popup, "assets/images/rewards/InstantLine.png")

    hud.fb1.anchorX 			= 0.5
    hud.fb1.anchorY 			= 0.5
    hud.fb1.x 		= display.contentWidth*0.5
    hud.fb1.y 		= display.contentHeight*0.45

    --------------------------

    hud.fb1 			= display.newImage(hud.popup, "assets/images/rewards/MoreLine.png")

    hud.fb1.anchorX 			= 0.5
    hud.fb1.anchorY 			= 0.5
    hud.fb1.x 		= display.contentWidth*0.5
    hud.fb1.y 		= display.contentHeight*0.6

    --------------------------

    hud.sep 			= display.newImage(hud.popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x 		= display.contentWidth*0.5
    hud.sep.y 		= display.contentHeight*0.83

    hud.next = viewManager.newText({
        parent 			= hud.popup,
        text 				= T "NEXT" .. "  >", 
        fontSize			= 49,  
        x 					= display.contentWidth * 0.5,
        y 					= display.contentHeight*0.895,
    })

    utils.setGreen(hud.next)

    utils.onTouch(hud.next, function() self:openRewards2() end)

    ---------------------------------------------------------------

    hud.close 				= display.newImage( hud.popup, "assets/images/hud/CroixClose.png")
    hud.close.x 			= display.contentWidth*0.89
    hud.close.y 			= display.contentHeight*0.085

    utils.onTouch(hud.close, function() viewManager.closePopup() end)

end

------------------------------------------

function scene:openRewards2()

    local top	 	= display.contentHeight * 0.3
    local yGap		= display.contentHeight*0.082

    viewManager.showPopup()

    --------------------------

    hud.picto 			= display.newImage(hud.popup, "assets/images/icons/Picto_InstantTicket.png")
    hud.picto.x 		= display.contentWidth*0.14
    hud.picto.y 		= display.contentHeight*0.15

    hud.title 			= display.newImage(hud.popup, I "instant.ticket.png")
    hud.title.anchorX 			= 0
    hud.title.anchorY 			= 0.5
    hud.title.x 		= display.contentWidth*0.22
    hud.title.y 		= display.contentHeight*0.15

    hud.sep 			= display.newImage(hud.popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x 		= display.contentWidth*0.5
    hud.sep.y 		= display.contentHeight*0.2

    --------------------------

    hud.text = display.newText(
    hud.popup, 
    T "Get Instant Tickets (ad-free Tickets) by earning points",
    0, 0, display.contentWidth*0.8, display.contentHeight*0.25, FONT, 36 )

    hud.text.x = display.contentWidth*0.5
    hud.text.y = display.contentHeight*0.34
    hud.text:setFillColor(0)

    -------------------

    hud.ticket 			= display.newImage(hud.popup, "assets/images/hud/InstantTicket_Picto1.png")
    hud.ticket.x 		= display.contentWidth*0.2
    hud.ticket.y 		= display.contentHeight*0.35

    hud.sep 				= display.newImageRect(hud.popup, "assets/images/icons/separateur.horizontal.png", display.contentWidth*0.1, display.contentHeight*0.0015)
    hud.sep.x 			= display.contentWidth*0.34
    hud.sep.y 			= display.contentHeight*0.35

    hud.ticketValue 	= display.newImage(hud.popup, "assets/images/hud/InstantTicket_Rond1.png")
    hud.ticketValue.x = display.contentWidth*0.5
    hud.ticketValue.y = display.contentHeight*0.35

    hud.sep 				= display.newImageRect(hud.popup, "assets/images/icons/separateur.horizontal.png", display.contentWidth*0.09, display.contentHeight*0.0015)
    hud.sep.x 			= display.contentWidth*0.62
    hud.sep.y 			= display.contentHeight*0.35

    --
    --	hud.popup.multiLineText = display.newText({
    --		parent	= hud.popup,
    --		text 		= T "+ 1pt / Ticket",   
    --		width 	= display.contentWidth*0.6,  
    --		height 	= display.contentHeight*0.25,  
    --		x 			= display.contentWidth*0.9,
    --		y 			= display.contentHeight*0.3,
    --		font 		= FONT, 
    --		fontSize = 38,
    --		align 	= "right",
    --	})
    --	
    --	hud.popup.multiLineText:setFillColor(0)

    -------------------

    hud.picto 			= display.newImage(hud.popup, "assets/images/hud/InstantTicket_Picto2.png")
    hud.picto.x 		= display.contentWidth*0.2
    hud.picto.y 		= display.contentHeight*0.45

    hud.sep 				= display.newImageRect(hud.popup, "assets/images/icons/separateur.horizontal.png", display.contentWidth*0.1, display.contentHeight*0.0015)
    hud.sep.x 			= display.contentWidth*0.34
    hud.sep.y 			= display.contentHeight*0.45

    hud.ticketValue 	= display.newImage(hud.popup, "assets/images/hud/InstantTicket_Rond1.png")
    hud.ticketValue.x = display.contentWidth*0.5
    hud.ticketValue.y = display.contentHeight*0.45

    hud.sep 				= display.newImageRect(hud.popup, "assets/images/icons/separateur.horizontal.png", display.contentWidth*0.04, display.contentHeight*0.0015)
    hud.sep.x 			= display.contentWidth*0.6
    hud.sep.y 			= display.contentHeight*0.45
    --	
    --	local multiLineText = display.newMultiLineText  
    --	{
    --		text = T "+ 1pt for the sponsor and the sponsored user", 
    --		width = display.contentWidth*0.25,  
    --		left = display.contentWidth*0.5,
    --		font = FONT, 
    --		fontSize = 25,
    --		align = "right",
    --		spaceY = display.contentWidth*0.009
    --	}
    --
    --	
    --   multiLineText.anchorX 			= 1
    --   multiLineText.anchorY 			= 0.5
    --	multiLineText.x = display.contentWidth*0.9
    --	multiLineText.y = display.contentHeight*0.45
    --	hud.popup:insert(multiLineText)         
    --	
    -------------------

    hud.picto 			= display.newImage(hud.popup, "assets/images/hud/InstantTicket_Picto3.png")
    hud.picto.x 		= display.contentWidth*0.2
    hud.picto.y 		= display.contentHeight*0.55

    hud.sep 				= display.newImageRect(hud.popup, "assets/images/icons/separateur.horizontal.png", display.contentWidth*0.1, display.contentHeight*0.0015)
    hud.sep.x 			= display.contentWidth*0.34
    hud.sep.y 			= display.contentHeight*0.55

    hud.ticketValue 	= display.newImage(hud.popup, "assets/images/hud/InstantTicket_Rond2.png")
    hud.ticketValue.x = display.contentWidth*0.5
    hud.ticketValue.y = display.contentHeight*0.55

    hud.sep 				= display.newImageRect(hud.popup, "assets/images/icons/separateur.horizontal.png", display.contentWidth*0.07, display.contentHeight*0.0015)
    hud.sep.x 			= display.contentWidth*0.61
    hud.sep.y 			= display.contentHeight*0.55

    --	local multiLineText = display.newMultiLineText  
    --	{
    --		text = T "+2 pts / post (max 4 pts per draw)", 
    --		width = display.contentWidth*0.25,  
    --		left = display.contentWidth*0.5,
    --		font = FONT, 
    --		fontSize = 25,
    --		align = "right",
    --		spaceY = display.contentWidth*0.009
    --	}
    --
    --
    --   multiLineText.anchorX 			= 1
    --   multiLineText.anchorY 			= 0.5
    --	multiLineText.x = display.contentWidth*0.9
    --	multiLineText.y = display.contentHeight*0.55
    --	hud.popup:insert(multiLineText)         

    -------------------

    hud.picto 			= display.newImage(hud.popup, "assets/images/hud/InstantTicket_Picto4.png")
    hud.picto.x 		= display.contentWidth*0.2
    hud.picto.y 		= display.contentHeight*0.65

    hud.sep 				= display.newImageRect(hud.popup, "assets/images/icons/separateur.horizontal.png", display.contentWidth*0.1, display.contentHeight*0.0015)
    hud.sep.x 			= display.contentWidth*0.34
    hud.sep.y 			= display.contentHeight*0.65

    hud.ticketValue 	= display.newImage(hud.popup, "assets/images/hud/InstantTicket_Rond2.png")
    hud.ticketValue.x = display.contentWidth*0.5
    hud.ticketValue.y = display.contentHeight*0.65

    hud.sep 				= display.newImageRect(hud.popup, "assets/images/icons/separateur.horizontal.png", display.contentWidth*0.17, display.contentHeight*0.0015)
    hud.sep.x 			= display.contentWidth*0.66
    hud.sep.y 			= display.contentHeight*0.65

    --	local multiLineText = display.newMultiLineText  
    --	{
    --		text = T "+2 pts", 
    --		width = display.contentWidth*0.25,  
    --		left = display.contentWidth*0.5,
    --		font = FONT, 
    --		fontSize = 25,
    --		align = "right"
    --	}
    --
    --   multiLineText.anchorX 			= 1
    --   multiLineText.anchorY 			= 0.5
    --	multiLineText.x = display.contentWidth*0.9
    --	multiLineText.y = display.contentHeight*0.65
    --	hud.popup:insert(multiLineText)         

    --------------------------

    hud.picto 			= display.newImage(hud.popup, "assets/images/hud/InstantTicket_RondALL.png")
    hud.picto.x 		= display.contentWidth*0.3
    hud.picto.y 		= display.contentHeight*0.75

    hud.equals = viewManager.newText({
        parent 			= hud.popup,
        text 				= "= 1", 
        fontSize			= 70,  
        x 					= display.contentWidth * 0.5,
        y 					= display.contentHeight*0.75,
    })

    utils.setGreen(hud.equals)

    hud.picto 			= display.newImage(hud.popup, "assets/images/hud/InstantTicket_Picto5.png")
    hud.picto.x 		= display.contentWidth*0.7
    hud.picto.y 		= display.contentHeight*0.75

    --------------------------

    hud.sep 			= display.newImage(hud.popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x 		= display.contentWidth*0.5
    hud.sep.y 		= display.contentHeight*0.83

    hud.next = viewManager.newText({
        parent 			= hud.popup,
        text 				= "<  " .. T "PREVIOUS", 
        fontSize			= 49,  
        x 					= display.contentWidth * 0.3,
        y 					= display.contentHeight*0.895,
    })

    utils.setGreen(hud.next)

    utils.onTouch(hud.next, function() self:openRewards1() end)

    hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
    hud.popup.close.x 			= display.contentWidth*0.75
    hud.popup.close.y 			= display.contentHeight*0.895

    utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)

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