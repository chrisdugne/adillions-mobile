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
    self:drawScene() 
end

-----------------------------------------------------------------------------------------

function scene:drawScene()

    viewManager.initBoard()

    ------------------

    local statusTop        = 3
    local stockTop         = 10.5
    local winningsTop      = 20
    local detailsTop       = 29
    local logoutTop        = 36

    ------------------

    self.top    = HEADER_HEIGHT + display.contentHeight*0.1
    self.yGap    = 60
    self.fontSizeLeft  = 37
    self.fontSizeRight  = 35

    self.column1 = display.contentWidth*0.07
    self.column2 = display.contentWidth*0.9 

    -- ---------------------------------------------------------------
    -- -- Top picture
    -- ---------------------------------------------------------------

    viewManager.drawBorder( hud.board, 
    display.contentWidth*0.65, self.top + display.contentHeight*0.02, 
    display.contentWidth*0.6, 180,
    250,250,250
    )  

    viewManager.newText({
        parent      = hud.board, 
        text        = userManager.user.userName,         
        x           = display.contentWidth*0.65,
        y           = self.top + display.contentHeight*0.02,
        width       = display.contentWidth * 0.5,
        align       = "center" ,
        fontSize    = 44,
        anchorX     = 0.5,
        anchorY     = 0.5,
    })


    if(GLOBALS.savedData.facebookAccessToken and facebook.data) then
        display.loadRemoteImage( facebook.data.picture.data.url, "GET", function(event)
            local picture = event.target 
            hud.board:insert(picture)
            picture.x = display.contentWidth*0.2
            picture.y = self.top + display.contentHeight*0.02
        end, 
        "profilePicture", system.TemporaryDirectory)
    else
        hud.dummyPicture   = display.newImage( hud.board, "assets/images/hud/dummy.profile.png")
        hud.dummyPicture.x   = display.contentWidth*0.2
        hud.dummyPicture.y   = self.top + display.contentHeight*0.02
        hud.board:insert(hud.dummyPicture)

    end

    -- ---------------------------------------------------------------
    -- -- Personal Details
    -- ---------------------------------------------------------------

    hud.lineDetails   = display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
    hud.lineDetails.x   = display.contentWidth*0.5
    hud.lineDetails.y   = self.top + self.yGap*(detailsTop+0.7)
    hud.board:insert(hud.lineDetails)

    hud.titleDetails   = display.newImage( hud.board, I "details.png")  

    hud.titleDetails.anchorX    = 0
    hud.titleDetails.anchorY    = 0.5
    hud.titleDetails.x   = display.contentWidth*0.05
    hud.titleDetails.y  = self.top + self.yGap*(detailsTop+0.7)
    hud.board:insert(hud.titleDetails)

    ------------------

    self:drawTextEntry(T "First name"  .. " : ", userManager.user.firstName, detailsTop+2)
    self:drawTextEntry(T "Last name"  .. " : ", userManager.user.lastName, detailsTop+3)
    self:drawTextEntry(T "Email"    .. " : ", userManager.user.email, detailsTop+4)
    self:drawTextEntry(T "Date of birth"   .. " : ", utils.readableDate(userManager.user.birthDate, false, true), detailsTop+5)
    self:drawTextEntry("_Sponsor code"  .. " : ", userManager.user.sponsorCode, detailsTop+6)

    ---------------------------------------------------------------
    -- Status
    ---------------------------------------------------------------

    hud.lineStatus    = display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
    hud.lineStatus.x   = display.contentWidth*0.5
    hud.lineStatus.y   = self.top + self.yGap*statusTop
    hud.board:insert(hud.lineStatus)

    hud.titleStatus    = display.newImage( hud.board, I "status.png")

    hud.titleStatus.anchorX     = 0
    hud.titleStatus.anchorY     = 0.5  
    hud.titleStatus.x           = display.contentWidth*0.05
    hud.titleStatus.y   = self.top + self.yGap*statusTop
    hud.board:insert(hud.titleStatus)

    --------------------------

    viewManager.newText({
        parent    = hud.board, 
        text            = "# Tickets" .. " : ",       
        x     = self.column1,
        y     = self.top + self.yGap*(statusTop+1),
        fontSize   = self.fontSizeLeft,
        anchorX   = 0,
        anchorY   = 0.5,
    })

    viewManager.newText({
        parent    = hud.board, 
        text    = userManager.user.totalPlayedTickets,     
        x     = self.column1 + display.contentWidth*0.05,
        y     = self.top + self.yGap*(statusTop+2),
        fontSize   = 40,
        font   = NUM_FONT,
        anchorX   = 0,
        anchorY   = 0.5,
    })

    --------------------------

    viewManager.newText({
        parent    = hud.board, 
        text    = "# Tickets" .. " : ",         
        x     = self.column2,
        y     = self.top + self.yGap*(statusTop+1),
        fontSize   = self.fontSizeLeft,
        anchorX   = 1,
        anchorY   = 0.5,
    })


    hud.iconTicket    = display.newImage( hud.board, "assets/images/icons/ticket.png")
    hud.iconTicket.x   = self.column2 - display.contentWidth*0.05
    hud.iconTicket.y   = self.top + self.yGap*(statusTop+2) - display.contentHeight*0.001
    hud.board:insert(hud.iconTicket)

    viewManager.newText({
        parent    = hud.board, 
        text    = START_AVAILABLE_TICKETS .. " + " .. (userManager.user.fanBonusTickets + userManager.user.charityBonusTickets + userManager.user.temporaryBonusTickets),     
        x     = self.column2 - display.contentWidth*0.11,
        y     = self.top + self.yGap*(statusTop+2),
        fontSize   = self.fontSizeRight,
        font   = NUM_FONT,
        fontSize   = 40,
        anchorX   = 1,
        anchorY   = 0.5,
    })

    --------------------------

    viewManager.newText({
        parent    = hud.board, 
        text    = T "Charity profile" .. " : ",            
        x     = display.contentWidth*0.5,
        y     = self.top + self.yGap*(statusTop+3.5),
        fontSize   = self.fontSizeLeft,
    })

    for i=1,5 do 
        hud.iconCharity   = display.newImage( hud.board, "assets/images/icons/CharitiesOFF.png")
        hud.iconCharity.x   = display.contentWidth*0.35 + i * display.contentWidth*0.05  
        hud.iconCharity.y   = self.top + self.yGap*(statusTop+4.5)
        hud.board:insert(hud.iconCharity)
    end

    local charityLevel = userManager:charityLevel()
    
    for i=1,charityLevel do 
        hud.iconCharity      = display.newImage( hud.board, "assets/images/icons/CharitiesON.png")
        hud.iconCharity.x   = display.contentWidth*0.35 + i * display.contentWidth*0.05 
        hud.iconCharity.y   = self.top + self.yGap*(statusTop+4.5)
        hud.board:insert(hud.iconCharity)
    end

    viewManager.newText({
        parent    = hud.board, 
        text    = T(CHARITY[charityLevel]),              
        x     = display.contentWidth*0.5,
        y     = self.top + self.yGap*(statusTop+5.5),
        fontSize   = self.fontSizeRight,
        fontSize   = 30,
    })

    ---------------------------------------------------------------
    -- Stock of tickets
    ---------------------------------------------------------------

    hud.lineStatus              = display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
    hud.lineStatus.x            = display.contentWidth*0.5
    hud.lineStatus.y            = self.top + self.yGap*stockTop
    hud.board:insert(hud.lineStatus)

    hud.titleStatus    = display.newImage( hud.board, I "profile.stock.png")

    hud.titleStatus.anchorX     = 0
    hud.titleStatus.anchorY     = 0.5  
    hud.titleStatus.x           = display.contentWidth*0.05
    hud.titleStatus.y           = self.top + self.yGap*stockTop
    hud.board:insert(hud.titleStatus)

    ---------------------------------------------------------------
    
    viewManager.newText({
        parent      = hud.board, 
        text        = "_available tickets" .. " : ",         
        x           = self.column1,
        y           = self.top + self.yGap*(stockTop+1),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })
    
    viewManager.newText({
        parent      = hud.board, 
        text        = START_AVAILABLE_TICKETS,         
        x           = self.column2,
        y           = self.top + self.yGap*(stockTop+1),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })

    ---------------------------------------------------------------
    
    viewManager.newText({
        parent      = hud.board, 
        text        = "_fan" .. " : ",         
        x           = self.column1,
        y           = self.top + self.yGap*(stockTop+2),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })
    
    viewManager.newText({
        parent      = hud.board, 
        text        = userManager.user.fanBonusTickets,         
        x           = self.column2,
        y           = self.top + self.yGap*(stockTop+2),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })

    ---------------------------------------------------------------
    
    viewManager.newText({
        parent      = hud.board, 
        text        = "_charity profile" .. " : ",         
        x           = self.column1,
        y           = self.top + self.yGap*(stockTop+3),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })
    
    viewManager.newText({
        parent      = hud.board, 
        text        = userManager.user.charityBonusTickets,         
        x           = self.column2,
        y           = self.top + self.yGap*(stockTop+3),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })

    ---------------------------------------------------------------
    
    viewManager.newText({
        parent      = hud.board, 
        text        = "_winnings/temporary" .. " : ",         
        x           = self.column1,
        y           = self.top + self.yGap*(stockTop+4),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })
    
    viewManager.newText({
        parent      = hud.board, 
        text        = userManager.user.temporaryBonusTickets,         
        x           = self.column2,
        y           = self.top + self.yGap*(stockTop+4),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })

    ---------------------------------------------------------------
    
    viewManager.newText({
        parent      = hud.board, 
        text        = "_total" .. " : ",         
        x           = self.column1,
        y           = self.top + self.yGap*(stockTop+5),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })
    
    viewManager.newText({
        parent      = hud.board, 
        text        = (START_AVAILABLE_TICKETS + userManager.user.temporaryBonusTickets + userManager.user.fanBonusTickets + userManager.user.charityBonusTickets),         
        x           = self.column2,
        y           = self.top + self.yGap*(stockTop+5),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })

    ---------------------------------------------------------------
    -- winnings
    ---------------------------------------------------------------

    hud.lineWinnings    = display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
    hud.lineWinnings.x    = display.contentWidth*0.5
    hud.lineWinnings.y    = self.top + self.yGap*winningsTop
    hud.board:insert(hud.lineWinnings)

    hud.titleWinnings    = display.newImage( hud.board, I "Gain.png")

    hud.titleWinnings.anchorX    = 0
    hud.titleWinnings.anchorY    = 0.5  

    hud.titleWinnings.x   = display.contentWidth*0.05
    hud.titleWinnings.y   = self.top + self.yGap*winningsTop
    hud.board:insert(hud.titleWinnings)

    --------------------------

    viewManager.newText({
        parent    = hud.board, 
        text     = T "Total winnings" .. " : ",         
        x      = self.column1,
        y      = self.top + self.yGap*(winningsTop+1),
        fontSize   = self.fontSizeLeft,
        anchorX    = 0,
        anchorY    = 0.5,
    })

    viewManager.newText({
        parent    = hud.board, 
        text     = utils.displayPrice(userManager.user.totalWinnings, COUNTRY) ,   
        x      = self.column1 + display.contentWidth*0.26, 
        y      = self.top + self.yGap*(winningsTop+2),
        fontSize   = 40,
        font    = NUM_FONT,
        anchorX    = 1,
        anchorY    = 0.5,
    })

    hud.iconMoney    = display.newImage( hud.board, "assets/images/icons/money.png")
    hud.iconMoney.x   = self.column1 + display.contentWidth*0.31
    hud.iconMoney.y   = self.top + self.yGap*(winningsTop+2) - display.contentHeight*0.004
    hud.board:insert(hud.iconMoney)

    --------------------------

    viewManager.newText({
        parent    = hud.board, 
        text     = T "Payed" .. " : ",         
        x      = self.column2,
        y      = self.top + self.yGap*(winningsTop+1),
        fontSize   = self.fontSizeLeft,
        anchorX    = 1,
        anchorY    = 0.5,
    })

    viewManager.newText({
        parent    = hud.board, 
        text     = utils.displayPrice(userManager.user.receivedWinnings, COUNTRY) ,     
        x      = self.column2 -  display.contentWidth*0.07,
        y      = self.top + self.yGap*(winningsTop+2),
        fontSize   = self.fontSizeRight,
        font    = NUM_FONT,
        fontSize   = 40,
        anchorX    = 1,
        anchorY    = 0.5,
    })

    hud.iconMoney    = display.newImage( hud.board, "assets/images/icons/PictogainPayed.png")
    hud.iconMoney.x   = self.column2 
    hud.iconMoney.y   = self.top + self.yGap*(winningsTop+2) - display.contentHeight*0.004
    hud.board:insert(hud.iconMoney)

    --------------------------

    viewManager.newText({
        parent    = hud.board, 
        text     = T "Balance" .. " : ",         
        x      = display.contentWidth*0.5,
        y      = self.top + self.yGap*(winningsTop+4),
        fontSize   = self.fontSizeLeft,
    })

    local balance = utils.displayPrice(userManager.user.balance, COUNTRY)
    if(userManager.user.pendingWinnings > 0) then
        balance = balance  .. " (" .. utils.displayPrice(userManager.user.pendingWinnings, COUNTRY) .. ")"
    end

    local totalWinningsText = viewManager.newText({
        parent    = hud.board, 
        text     = balance,   
        x      = display.contentWidth*0.5, 
        y      = self.top + self.yGap*(winningsTop+5),
        fontSize   = 40,
        font    = NUM_FONT,
        anchorX    = 1,
        anchorY    = 0.5,
    })

    hud.iconMoney    = display.newImage( hud.board, "assets/images/icons/PictoBalance.png")
    hud.iconMoney.x   = display.contentWidth*0.58
    hud.iconMoney.y   = self.top + self.yGap*(winningsTop+5) - display.contentHeight*0.004
    hud.board:insert(hud.iconMoney)

    --------------------------

    hud.cashout   = display.newImage( hud.board, I "cashout.button.png")  
    hud.cashout.x   = display.contentWidth*0.5
    hud.cashout.y  = self.top + self.yGap*(winningsTop+7.5)
    hud.board:insert(hud.cashout)

    utils.onTouch(hud.cashout, function() 
        self:openCashout()
    end)

    -----------------------------------------------

    hud.logoutLine    = display.newImage( hud.board, "assets/images/hud/Filet.png")  
    hud.logoutLine .x   = display.contentWidth*0.5
    hud.logoutLine .y   = self.top + self.yGap*(logoutTop)
    hud.board:insert(hud.logoutLine )

    hud.logoutCadenas    = display.newImage( hud.board, "assets/images/hud/Cadenas.png")  
    hud.logoutCadenas .x   = display.contentWidth*0.5
    hud.logoutCadenas .y   = self.top + self.yGap*(logoutTop)
    hud.board:insert(hud.logoutCadenas )

    hud.board.logout = display.newImage( hud.board, I "Logout.png")  
    hud.board.logout.x = display.contentWidth*0.5
    hud.board.logout.y =  self.top + self.yGap * (logoutTop+2)
    hud.board:insert( hud.board.logout ) 

    utils.onTouch(hud.board.logout, function()
        display.remove(hud.board.logout)
        userManager:logout()
    end) 

    ------------------

    hud:insert(hud.board)

    ------------------

    viewManager.setupView(1)
    self.view:insert(hud)
end

-----------------------------------------------------------------------------------------

function scene:openFacebookPage()
    native.showWebPopup(0, 0, display.contentWidth, display.contentHeight, FACEBOOK_PAGE) 
end

-----------------------------------------------------------------------------------------

function scene:drawTextEntry(title, value, position, fontSizeLeft, fontSizeRight)

    viewManager.newText({
        parent    = hud.board, 
        text    = title,         
        x     = self.column1,
        y     = self.top + self.yGap*position,
        fontSize   = fontSizeLeft or self.fontSizeLeft,
        anchorX   = 0,
        anchorY   = 0.5,
    })

    viewManager.newText({
        parent    = hud.board, 
        text     = value,     
        x      = self.column2,
        y      = self.top + self.yGap*position,
        fontSize   = fontSizeRight or self.fontSizeRight,
        font    = NUM_FONT,
        anchorX    = 1,
        anchorY    = 0.5,
    })

end

-----------------------------------------------------------------------------------------

function scene:drawConnection(title, state, position)

    viewManager.newText({
        parent    = hud.board, 
        text     = title,         
        x      = display.contentWidth*0.75,
        y      = self.top + self.yGap*position,
        fontSize   = 21,
        anchorX    = 1,
        anchorY    = 0.5,
    })

    local light  = display.newImage(hud.board, "assets/images/hud/".. state ..".png")
    light.x    = display.contentWidth*0.8
    light.y    = self.top + self.yGap*position + 3
    hud.board:insert(light)

end

-----------------------------------------------------------------------------------------

function scene:openCashout()

    -----------------------------------

    local popup = viewManager.showPopup()
    analytics.event("Gaming", "opencashout") 

    ----------------------------------------------------------------------------------------------------

    popup.shareIcon     = display.newImage( popup, "assets/images/icons/PictoInfo.png")  
    popup.shareIcon.x    = display.contentWidth*0.5
    popup.shareIcon.y   = display.contentHeight*0.15

    popup.TxtInformation   = display.newImage( popup, I "TxtInformation.png")  
    popup.TxtInformation.x  = display.contentWidth*0.5
    popup.TxtInformation.y  = display.contentHeight*0.23

    ----------------------------------------------------------------------------------------------------

    local value = ""
    if(utils.isEuroCountry(COUNTRY)) then
        value = "10€"
    else
        value = "US$15"
    end

    popup.multiLineText = display.newText({
        parent = popup,
        text   = T "You can cash out when your winnings \n have reached a minimum total \n balance of " .. value,  
        width  = display.contentWidth*0.72,  
        height  = display.contentHeight*0.25,  
        x    = display.contentWidth*0.5,
        y    = display.contentHeight*0.45,
        font   = FONT, 
        fontSize = 40,
        align  = "center",
    })

    popup.multiLineText:setFillColor(0)

    ----------------------------------------------------------------------------------------------------

    local min = 10
    if(not utils.isEuroCountry(COUNTRY)) then
        min = 15
    end

    if(userManager.user.balance >= min) then
        hud.cashoutEnabled     = display.newImage( popup, I "cashout.on.png")  
        hud.cashoutEnabled.x    = display.contentWidth*0.5
        hud.cashoutEnabled.y    = display.contentHeight*0.65
        utils.onTouch(hud.cashoutEnabled, function() self.openConfirmCashout() end)
    else
        hud.cashoutDisabled     = display.newImage( popup, I "cashout.off.png")  
        hud.cashoutDisabled.x    = display.contentWidth*0.5
        hud.cashoutDisabled.y   = display.contentHeight*0.65
    end

    -- if(userManager.user.balance > 0) then
    --    hud.giveToCharity     = display.newImage( popup, I "donate.on.png")  
    --    hud.giveToCharity.x     = display.contentWidth*0.5
    --      hud.giveToCharity.y    = display.contentHeight*0.73
    --    utils.onTouch(hud.giveToCharity, function() self.openGiveToCharity() end)
    --   else
    --  hud.giftDisabled      = display.newImage( popup, I "donate.off.png")  
    --  hud.giftDisabled.x     = display.contentWidth*0.5
    --      hud.giftDisabled.y    = display.contentHeight*0.73
    -- end


    ----------------------------------------------------------------------------------------------------

    popup.close     = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x    = display.contentWidth*0.5
    popup.close.y    = display.contentHeight*0.86

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

end

-----------------------------------------------------------------------------------------

function scene:openGiveToCharity()

    -----------------------------------

    local popup = viewManager.showPopup()
    analytics.event("Gaming", "openGiveToCharity") 

    ----------------------------------------------------------------------------------------------------

    popup.shareIcon     = display.newImage( popup, "assets/images/icons/PictoCoeur.png")  
    popup.shareIcon.x    = display.contentWidth*0.5
    popup.shareIcon.y   = display.contentHeight*0.15

    popup.thanks      = display.newImage( popup, I "thanks.png")  
    popup.thanks.x     = display.contentWidth*0.5
    popup.thanks.y    = display.contentHeight*0.23

    ----------------------------------------------------------------------------------------------------
    --
    --   local multiLineText = display.newMultiLineText  
    --     {
    --           text = T "Your winnings will be donated to Adillions Solidarity \n and Sustainable Development Fund \n \n \n Soon users will be able to \n directly choose their own charity …",
    --           width = display.contentWidth*0.8,  
    --           left = display.contentWidth*0.5,
    --           font = FONT, 
    --           fontSize = 40,
    --           align = "center"
    --     }
    -- 
    -- multiLineText.anchorX = 0.5
    -- multiLineText.anchorY = 0
    -- multiLineText.x = display.contentWidth*0.5
    -- multiLineText.y = display.contentHeight*0.3
    -- popup:insert(multiLineText)         

    ----------------------------------------------------------------------------------------------------

    hud.giveToCharity     = display.newImage( popup, I "confirm.png")  
    hud.giveToCharity.x     = display.contentWidth*0.5
    hud.giveToCharity.y    = display.contentHeight*0.7

    local refresh = function() scene:refreshScene() end

    utils.onTouch(hud.giveToCharity, function() 
        analytics.event("Gaming", "giveToCharity") 
        userManager:giveToCharity(function()
            router.resetScreen()
            refresh()
            viewManager.message(T "Thank you" .. "!")
        end) 
    end)

    ----------------------------------------------------------------------------------------------------

    popup.close     = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x    = display.contentWidth*0.5
    popup.close.y    = display.contentHeight*0.86

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

end

-----------------------------------------------------------------------------------------

function scene:openConfirmCashout()

    -----------------------------------

    local popup = viewManager.showPopup()
    analytics.event("Gaming", "openConfirmCashout") 

    ----------------------------------------------------------------------------------------------------

    popup.shareIcon     = display.newImage( popup, "assets/images/icons/notification/prizes.popup.png")  
    popup.shareIcon.x    = display.contentWidth*0.5
    popup.shareIcon.y   = display.contentHeight*0.15

    popup.congratz     = display.newImage( popup, I "TxtCongratulations.png")  
    popup.congratz.x    = display.contentWidth*0.5
    popup.congratz.y    = display.contentHeight*0.25

    ----------------------------------------------------------------------------------------------------

    popup.multiLineText = display.newText({
        parent = popup,
        text   = T "You will receive your winnings within 4 to 8 weeks \n \n  We will contact you by email in the coming days to proceed with the payment",  
        width  = display.contentWidth*0.6,  
        height  = display.contentHeight*0.25,  
        x    = display.contentWidth*0.5,
        y    = display.contentHeight*0.45,
        font   = FONT, 
        fontSize = 38,
        align  = "center",
    })

    popup.multiLineText:setFillColor(0)

    ----------------------------------------------------------------------------------------------------

    hud.confirm       = display.newImage( popup, I "confirm.png")  
    hud.confirm.x       = display.contentWidth*0.5
    hud.confirm.y      = display.contentHeight*0.7

    local refresh = function() scene:refreshScene() end

    utils.onTouch(hud.confirm, function() 
        analytics.event("Gaming", "cashout")
        native.setActivityIndicator( true ) 
        userManager:cashout(function()
            native.setActivityIndicator( false ) 
            router.resetScreen()
            refresh()
            viewManager.message(T "Congratulations !")
        end) 
    end)

    ----------------------------------------------------------------------------------------------------

    popup.close     = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x    = display.contentWidth*0.5
    popup.close.y    = display.contentHeight*0.86

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