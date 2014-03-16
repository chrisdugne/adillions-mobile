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

    ------------------

    self.top                = HEADER_HEIGHT + display.contentHeight*0.15
    self.yGap               = display.contentHeight*0.17

    self.column1 = display.contentWidth*0.3
    self.column2 = display.contentWidth*0.7

    ------------------

    hud.headerRect = display.newImageRect( hud, "assets/images/hud/game/header.game.png", display.contentWidth, HEADER_HEIGHT)  
    hud.headerRect.x = display.viewableContentWidth*0.5 
    hud.headerRect.y = HEADER_HEIGHT*0.5

    hud.logo = display.newImage( hud, "assets/images/hud/game/logo.game.png")  
    hud.logo.x = display.contentWidth*0.5
    hud.logo.y = HEADER_HEIGHT*0.5

    ------------------

    hud.subheaderBG   = display.newImage(hud, "assets/images/hud/info.bg.png")
    hud.subheaderBG.x  = display.contentWidth*0.5
    hud.subheaderBG.y  = display.contentHeight * 0.5

    ------------------

    hud.options    = display.newImage( hud, I "info.Options.png")  
    hud.options.x    = self.column1
    hud.options.y   = self.top

    utils.onTouch(hud.options, function()
        self:openOptions()
    end)

    hud.tutorial    = display.newImage( hud, I "info.Tutorial.png")  
    hud.tutorial.x       = self.column2
    hud.tutorial.y   = self.top

    utils.onTouch(hud.tutorial, function()
        router.openTutorial()
    end)

    ------------------

    hud.prize     = display.newImage( hud, I "info.Prize.png")  
    hud.prize.x    = self.column1
    hud.prize.y    = self.top + self.yGap

    utils.onTouch(hud.prize, function()
        analytics.event("Links", "prizes") 
        self:openPrizes()
    end)

    hud.rewards    = display.newImage( hud, I "info.Rewards.png")  
    hud.rewards.x    = self.column2
    hud.rewards.y   = self.top + self.yGap

    utils.onTouch(hud.rewards, function()
        analytics.event("Links", "rewards") 
        shareManager:openRewards1()
    end)

    ------------------

    hud.contact    = display.newImage( hud, I "info.Contact.png")  
    hud.contact.x    = self.column1
    hud.contact.y   = self.top + self.yGap * 2

    utils.onTouch(hud.contact, function()
        self:openContact()
    end)

    hud.faq        = display.newImage( hud, I "info.Faq.png")  
    hud.faq.x     = self.column2
    hud.faq.y    = self.top + self.yGap * 2

    utils.onTouch(hud.faq, function()
        analytics.event("Links", "faq")
        
        viewManager.openWeb(SERVER_URL .. "mfaq", function(event)
            print(event.url)
        end) 
    end)

    ------------------

    hud.terms     = display.newImage( hud, I "info.Terms.png")  
    hud.terms.x    = self.column1
    hud.terms.y    = self.top + self.yGap * 3

    utils.onTouch(hud.terms, function()
        analytics.event("Links", "terms")
        self:openTerms()
    end)

    ------------------

    hud.privacy    = display.newImage( hud, I "info.Privacy.png")  
    hud.privacy.x    = self.column2
    hud.privacy.y   = self.top + self.yGap * 3

    utils.onTouch(hud.privacy, function()
        analytics.event("Links", "privacy") 
        viewManager.openWeb(SERVER_URL .. "#/about/privacy", function(event)
            print(event.url)
        end) 
    end)

    ------------------
--
--    hud.write     = display.newImage( hud, I "info.Write.png")  
--    hud.write.x    = display.contentWidth * 0.5
--    hud.write.y    = self.top + self.yGap * 4
--
--    utils.onTouch(hud.write, function()
--        analytics.event("Links", "writeReview") 
--        local options =
--        {
--            iOSAppId = "739060819",
--            androidAppPackageName = "com.adillions.v1",
--            supportedAndroidStores = { "google" },
--        }
--        native.showPopup("appStore", options) 
--    end)

    ---------------------------------------------------------------------------------

    viewManager.setupCustomView(5)
    self.view:insert(hud)
end

------------------------------------------

function scene:openPrizes()

    local top   = display.contentHeight * 0.35
    local yGap  = display.contentHeight * 0.082

    local popup = viewManager.showPopup()

    --------------------------

    viewManager.newText({
        parent = popup, 
        text = T "Last updated : January 05th, 2014",
        x = display.contentWidth*0.9,
        y = display.contentHeight * 0.08,
        fontSize = 26,
        font  = FONT,
        anchorX    = 1,
        anchorY    = 1,
    })

    --------------------------

    hud.picto    = display.newImage(popup, "assets/images/icons/PrizeTitle.png")
    hud.picto.x   = display.contentWidth*0.14
    hud.picto.y   = display.contentHeight*0.15
    hud.picto:scale(0.7,0.7)

    hud.title    = display.newImage(popup, I "Prize.png")

    hud.title.anchorX    = 0
    hud.title.anchorY    = 0.5
    hud.title.x   = display.contentWidth*0.22
    hud.title.y   = display.contentHeight*0.15

    hud.sep    = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x   = display.contentWidth*0.5
    hud.sep.y   = display.contentHeight*0.2

    --------------------------

    viewManager.newText({
        parent = popup, 
        text = T "Match", 
        x = display.contentWidth*0.45,
        y = display.contentHeight * 0.255,
        fontSize = 32,
        font = NUM_FONT
    })

    viewManager.newText({
        parent = popup, 
        text = T "Prize", 
        x = display.contentWidth * 0.8,
        y = display.contentHeight * 0.24,
        fontSize = 32,
        font = NUM_FONT
    })

    viewManager.newText({
        parent = popup, 
        text = T "breakdown", 
        x = display.contentWidth * 0.8,
        y = display.contentHeight * 0.27,
        fontSize = 32,
        font = NUM_FONT
    })

    local matches   = lotteryManager.nextDrawing.rangs.matches[LANG]
    local percents  = lotteryManager.nextDrawing.rangs.percents

    for i = 1, #matches do

        hud.iconRang    = display.newImage( popup, "assets/images/icons/rangs/R".. i .. ".png")
        hud.iconRang.x   = display.contentWidth * 0.2
        hud.iconRang.y   = top + yGap * (i-1)

        viewManager.newText({
            parent      = popup, 
            text        = matches[i],     
            x           = display.contentWidth*0.45,
            y           = top + yGap * (i-1) ,
            fontSize    = 35,
        })

        viewManager.newText({
            parent    = popup, 
            text     = percents[i] .. '%',     
            x      = display.contentWidth*0.75,
            y      = top + yGap * (i-1) ,
            fontSize   = 35,
        })

        hud.iconPieces    = display.newImage( popup, "assets/images/icons/PictoPrize.png")
        hud.iconPieces.x    = display.contentWidth * 0.86
        hud.iconPieces.y    = top + yGap * (i-1) - display.contentHeight*0.0005

    end

    --------------------------

    popup.close     = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x    = display.contentWidth*0.5
    popup.close.y    = display.contentHeight*0.88

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

end


------------------------------------------

function scene:openTerms()

    local top   = display.contentHeight * 0.35
    local yGap  = display.contentHeight*0.082

    local popup = viewManager.showPopup()

    --------------------------

    hud.picto    = display.newImage(popup, "assets/images/icons/PictoTerms.png")
    hud.picto.x   = display.contentWidth*0.14
    hud.picto.y   = display.contentHeight*0.1

    hud.title    = display.newImage(popup, I "terms.png")

    hud.title.anchorX    = 0
    hud.title.anchorY    = 0.5
    hud.title.x   = display.contentWidth*0.22
    hud.title.y   = display.contentHeight*0.1

    hud.sep    = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x   = display.contentWidth*0.5
    hud.sep.y   = display.contentHeight*0.15

    --------------------------

    hud.textImportant = display.newText(
    popup, 
    "Important", 
    0, 0, display.contentWidth*0.8, display.contentHeight*0.25, NUM_FONT, 35 )

    hud.textImportant.x = display.contentWidth*0.5
    hud.textImportant.y = display.contentHeight*0.29
    hud.textImportant:setFillColor(0)

    hud.text = display.newText(
    popup, 
    T "Adillions - a simplified joint-stock company (S.A.S.), registered at the Paris RCS (France) under No. 797 736 261, organizes free games without any purchase obligation, for an indefinite period.", 
    0, 0, display.contentWidth*0.8, display.contentHeight*0.25, FONT, 35 )

    hud.text.x = display.contentWidth*0.5
    hud.text.y = display.contentHeight*0.33
    hud.text:setFillColor(0)

    local company = "Apple Inc. "
    if(ANDROID) then company = "Google Inc " end

    hud.text2 = display.newText(
    popup, 
    company .. (T "is not an organizer, a co-organizer or a partner of Adillions. ") .. company .. (T "is not involved in any way in the organization of the Adillions lottery and does not sponsor it."), 
    0, 0, display.contentWidth*0.8, display.contentHeight*0.25, FONT, 35 )

    hud.text2.x = display.contentWidth*0.5
    hud.text2.y = display.contentHeight*0.53
    hud.text2:setFillColor(0)

    --------------------------

    popup.keyrules    = display.newImage( popup, I "key.rules.png")
    popup.keyrules.x   = display.contentWidth*0.5
    popup.keyrules.y   = display.contentHeight*0.65

    utils.onTouch(popup.keyrules, function() 
        viewManager.openWeb(SERVER_URL .. "#/about/keyrules", function(event)
            print(event.url)
        end) 
    end)

    --------------------------

    popup.read   = display.newImage( popup, I "read.terms.png")
    popup.read.x   = display.contentWidth*0.5
    popup.read.y   = display.contentHeight*0.78

    utils.onTouch(popup.read, function() 
    
        local terms = ""
        if(COUNTRY == "FR") then
            terms = "mtermsFR"
        else
            terms = "mtermsEN"
        end

        viewManager.openWeb( SERVER_URL .. terms, function(event)
            print(event.url)
        end) 
    end)

    --------------------------

    popup.close     = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x    = display.contentWidth*0.5
    popup.close.y    = display.contentHeight*0.9

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)
end

------------------------------------------------------------------------------

function scene:openOptions()

    local top   = display.contentHeight * 0.1
    local yGap  = display.contentHeight*0.2

    local popup = viewManager.showPopup()

    --------------------------

    local optionsTop   = 1

    local fontSizeLeft  = 38
    local fontSizeRight  = 29

    --------------------------

    hud.picto    = display.newImage(popup, "assets/images/icons/PictoOptions.png")
    hud.picto.x   = display.contentWidth*0.14
    hud.picto.y   = display.contentHeight*0.15

    hud.title    = display.newImage(popup, I "Options.png")

    hud.title.anchorX    = 0
    hud.title.anchorY    = 0.5
    hud.title.x   = display.contentWidth*0.22
    hud.title.y   = display.contentHeight*0.15

    hud.sep    = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x   = display.contentWidth*0.5
    hud.sep.y   = display.contentHeight*0.2

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
        parent    = popup, 
        text     = T "Notification 48h before the next draw",         
        x      = display.contentWidth*0.11,
        y      = top + yGap*(optionsTop),
        fontSize   = fontSizeLeft,
        width       = display.contentWidth * 0.5,
        anchorX    = 0,
        anchorY    = 0.4,
    })

    local beforeDrawSwitch = widget.newSwitch
    {
        left        = display.contentWidth*0.75,
        top        = top + yGap*(optionsTop-0.05),
        initialSwitchState   = GLOBALS.options.notificationBeforeDraw,
        onPress       = beforeDrawSwitchListener,
        onRelease      = beforeDrawSwitchListener,
    }

    beforeDrawSwitch:scale(2.5,2.5) 

    viewManager.newText({
        parent    = popup, 
        text     = T "Notification for the results",         
        x      = display.contentWidth*0.11,
        y      = top + yGap*(optionsTop+0.5),
        fontSize   = fontSizeLeft,
        anchorX    = 0,
        anchorY    = 0.5,
    })


    local afterDrawSwitch = widget.newSwitch
    {
        left        = display.contentWidth*0.75,
        top        = top + yGap*(optionsTop+0.45),
        initialSwitchState   = GLOBALS.options.notificationAfterDraw,
        onPress       = afterDrawSwitchListener,
        onRelease      = afterDrawSwitchListener,
    }

    afterDrawSwitch:scale(2.5,2.5) 

    popup:insert( beforeDrawSwitch ) 
    popup:insert( afterDrawSwitch ) 

    --------------------------

    popup.close     = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x    = display.contentWidth*0.5
    popup.close.y    = display.contentHeight*0.85

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

end

------------------------------------------------------------------------------

function scene:openContact()

    local top   = display.contentHeight * 0.3
    local yGap  = display.contentHeight*0.082

    local popup = viewManager.showPopup()

    --------------------------

    hud.picto    = display.newImage(popup, "assets/images/icons/PictoContact.png")
    hud.picto.x   = display.contentWidth*0.14
    hud.picto.y   = display.contentHeight*0.15

    hud.title    = display.newImage(popup, I "Contact.png")

    hud.title.anchorX    = 0
    hud.title.anchorY    = 0.5
    hud.title.x   = display.contentWidth*0.22
    hud.title.y   = display.contentHeight*0.15

    hud.sep    = display.newImage(popup, "assets/images/icons/separateur.horizontal.png")
    hud.sep.x   = display.contentWidth*0.5
    hud.sep.y   = display.contentHeight*0.2

    --------------------------

    viewManager.newText({
        parent = popup, 
        text = T "By email", 
        x = display.contentWidth*0.1,
        y = display.contentHeight * 0.27,
        fontSize = 40,
        font = NUM_FONT,
        anchorX    = 0,
        anchorY    = 0.5,
    })

    --------------------------

    viewManager.newText({
        parent = popup, 
        text = T "General information" .. " :", 
        x = display.contentWidth*0.1,
        y = display.contentHeight * 0.31,
        fontSize = 26,
        anchorX    = 0,
        anchorY    = 0.5,
    })

    viewManager.newText({
        parent = popup, 
        text = "contact@adillions.com", 
        x = display.contentWidth*0.9,
        y = display.contentHeight * 0.31,
        fontSize = 26,
        font  = NUM_FONT,
        anchorX    = 1,
        anchorY    = 0.5,
    })

    viewManager.newText({
        parent = popup, 
        text = T "For technical issues" .. " :", 
        x = display.contentWidth*0.1,
        y = display.contentHeight * 0.36,
        fontSize = 26,
        anchorX    = 0,
        anchorY    = 0.5,
    })

    viewManager.newText({
        parent = popup, 
        text = "support@adillions.com", 
        x = display.contentWidth*0.9,
        y = display.contentHeight * 0.36,
        fontSize = 26,
        font  = NUM_FONT,
        anchorX    = 1,
        anchorY    = 0.5,
    })

    viewManager.newText({
        parent = popup, 
        text = T "For payments" .. " :", 
        x = display.contentWidth*0.1,
        y = display.contentHeight * 0.41,
        fontSize = 26,
        anchorX    = 0,
        anchorY    = 0.5,
    })

    viewManager.newText({
        parent = popup, 
        text = "winners@adillions.com", 
        x = display.contentWidth*0.9,
        y = display.contentHeight * 0.41,
        fontSize = 26,
        font  = NUM_FONT,
        anchorX    = 1,
        anchorY    = 0.5,
    })

    viewManager.newText({
        parent = popup, 
        text = T "For advertisers" .. " :", 
        x = display.contentWidth*0.1,
        y = display.contentHeight * 0.46,
        fontSize = 26,
        anchorX    = 0,
        anchorY    = 0.5,
    })

    viewManager.newText({
        parent = popup, 
        text = "advertisers@adillions.com", 
        x = display.contentWidth*0.9,
        y = display.contentHeight * 0.46,
        fontSize = 26,
        font  = NUM_FONT,
        anchorX    = 1,
        anchorY    = 0.5,
    })

    --------------------------

    viewManager.newText({
        parent = popup, 
        text = T "On the web", 
        x = display.contentWidth*0.1,
        y = display.contentHeight * 0.6,
        fontSize = 40,
        font = NUM_FONT,
        anchorX    = 0,
        anchorY    = 0.5,
    })

    --------------------------

    viewManager.newText({
        parent = popup, 
        text = "www.adillions.com", 
        x = display.contentWidth*0.5,
        y = display.contentHeight * 0.65,
        fontSize = 56,
        font  = NUM_FONT,
    })

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