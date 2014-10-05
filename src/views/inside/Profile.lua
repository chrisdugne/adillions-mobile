--------------------------------------------------------------------------------
--
-- Profile.lua
--
--------------------------------------------------------------------------------

local scene = storyboard.newScene()

--------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--   unless storyboard.removeScene() is called.
--
--------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

--------------------------------------------------------------------------------

function scene:refreshScene()
    self:drawScene()
end

--------------------------------------------------------------------------------

function scene:drawScene()

    viewManager.initBoard()

    ------------------

    local charityTop       = 4
    local ambassadorTop    = 10
    local stockTop         = 18.5
    local winningsTop      = 33
    local detailsTop       = 43
    local logoutTop        = 56.5

    ------------------

    self.top                = HEADER_HEIGHT + display.contentHeight*0.1
    self.yGap               = 60
    self.fontSizeLeft       = 37
    self.fontSizeRight      = 35

    self.column1 = display.contentWidth*0.1
    self.column2 = display.contentWidth*0.9

    ----------------------------------------------------------------------------
    -- Top picture
    ----------------------------------------------------------------------------

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
        print(facebook.data.picture.data.url)
        viewManager.drawRemoteImage(
            facebook.data.picture.data.url,
            hud.board,
            display.contentWidth*0.2,
            self.top + display.contentHeight*0.02,
            0.5,
            0.5,
            1,
            1,
            function(image)
                print("received profile photo")
            end,
            "profilePicture_"
        )
    else
        hud.dummyPicture        = display.newImage( hud.board, "assets/images/hud/dummy.profile.png")
        hud.dummyPicture.x      = display.contentWidth*0.2
        hud.dummyPicture.y      = self.top + display.contentHeight*0.02
        hud.board:insert(hud.dummyPicture)
    end

    ----------------------------------------------------------------------------
    -- Charity Level
    ----------------------------------------------------------------------------

    viewManager.drawBorder( hud.board,
        display.contentWidth*0.5, self.top + self.yGap * ( charityTop - 0.8),
        display.contentWidth*0.9, self.yGap* (ambassadorTop - charityTop - 0.6),
        250,250,250, 0.5, 0
    )

    hud.titleStatus    = display.newImage( hud.board, I "profile.charity.png")

    hud.titleStatus.anchorX     = 0
    hud.titleStatus.anchorY     = 0.5
    hud.titleStatus.x           = self.column1 - display.contentWidth * 0.03
    hud.titleStatus.y           = self.top + self.yGap*charityTop
    hud.board:insert(hud.titleStatus)

    hud.what                = display.newImage( hud.board, "assets/images/hud/profile/profile.what.png")
    hud.what.x              = display.contentWidth * 0.9
    hud.what.y              = hud.titleStatus.y
    hud.board:insert(hud.what)

    utils.onTouch(hud.what, function()
        shareManager:openCharityRewards()
    end)

    --------------------------

    viewManager.newText({
        parent      = hud.board,
        text        = "Total Tickets" .. " : ",
        x           = self.column1,
        y           = self.top + self.yGap*(charityTop+1.5),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5
    })

    local textTotal = viewManager.newText({
        parent      = hud.board,
        text        = userManager.user.playedTickets,
        x           = self.column1 + display.contentWidth*0.1,
        y           = self.top + self.yGap*(charityTop+2.8),
        fontSize    = 40,
        font        = NUM_FONT,
        anchorX     = 1,
        anchorY     = 0.5
    })

    hud.ticketIcon         = display.newImage( hud.board, "assets/images/hud/profile/profile.ticket.png")
    hud.ticketIcon.x       = textTotal.x + display.contentWidth*0.1
    hud.ticketIcon.y       = textTotal.y
    hud.ticketIcon.anchorX = 1
    hud.board:insert(hud.ticketIcon)

    hud.arrow               = display.newImage( hud.board, "assets/images/hud/profile/profile.status.arrow.png")
    hud.arrow.x             = display.contentWidth*0.45
    hud.arrow.y             = textTotal.y
    hud.board:insert(hud.arrow)

    --------------------------

    local charityLevel = userManager:charityLevel()

    viewManager.newText({
        parent      = hud.board,
        text        = T "Charity profile" .. " : ",
        x           = self.column2,
        y           = self.top + self.yGap*(charityTop+1.5),
        fontSize    = self.fontSizeLeft,
        anchorX     = 1
    })

    hud.iconCharity         = display.newImage( hud.board, I "profile.charity.".. charityLevel ..".png")
    hud.iconCharity.anchorX = 0.91
    hud.iconCharity.x       = self.column2
    hud.iconCharity.x       = self.column2
    hud.iconCharity.y       = self.top + self.yGap*(charityTop+3.1),
    hud.board:insert(hud.iconCharity)


    ----------------------------------------------------------------------------
    -- Ambassador Level
    ----------------------------------------------------------------------------

    viewManager.drawBorder( hud.board,
        display.contentWidth*0.5, self.top + self.yGap * ( ambassadorTop - 0.8),
        display.contentWidth*0.9, self.yGap* (stockTop - ambassadorTop - 0.6),
        250,250,250, 0.5, 0
    )

    hud.titleStatus    = display.newImage( hud.board, I "profile.ambassador.png")

    hud.titleStatus.anchorX = 0
    hud.titleStatus.anchorY = 0.5
    hud.titleStatus.x       = self.column1 - display.contentWidth * 0.03
    hud.titleStatus.y       = self.top + self.yGap*ambassadorTop
    hud.board:insert(hud.titleStatus)

    hud.what                = display.newImage( hud.board, "assets/images/hud/profile/profile.what.png")
    hud.what.x              = display.contentWidth * 0.9
    hud.what.y              = hud.titleStatus.y
    hud.board:insert(hud.what)

    utils.onTouch(hud.what, function()
        shareManager:openAmbassadorRewards()
    end)

    --------------------------

    viewManager.newText({
        parent      = hud.board,
        text        = "Total Sponsorees" .. " : ",
        x           = self.column1,
        y           = self.top + self.yGap*(ambassadorTop+1.5),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5
    })

    local textTotal = viewManager.newText({
        parent      = hud.board,
        text        = userManager.user.godChildren,
        x           = self.column1 + display.contentWidth*0.1,
        y           = self.top + self.yGap*(ambassadorTop+2.8),
        fontSize    = 40,
        font        = NUM_FONT,
        anchorX     = 1,
        anchorY     = 0.5
    })

    hud.ticketIcon         = display.newImage( hud.board, "assets/images/hud/profile/profile.ambassador.sponsoree.png")
    hud.ticketIcon.x       = textTotal.x + display.contentWidth*0.1
    hud.ticketIcon.y       = textTotal.y
    hud.ticketIcon.anchorX = 0.5
    hud.board:insert(hud.ticketIcon)

    hud.arrow               = display.newImage( hud.board, "assets/images/hud/profile/profile.status.arrow.png")
    hud.arrow.x             = display.contentWidth*0.45
    hud.arrow.y             = textTotal.y
    hud.board:insert(hud.arrow)

    --------------------------

    local ambassadorLevel = userManager:ambassadorLevel()

    viewManager.newText({
        parent      = hud.board,
        text        = T "Ambass. Profile" .. " : ",
        x           = self.column2,
        y           = self.top + self.yGap*(ambassadorTop+1.5),
        fontSize    = self.fontSizeLeft,
        anchorX     = 1
    })

    hud.iconAmbassador         = display.newImage( hud.board, I "profile.ambassador.".. ambassadorLevel ..".png")
    hud.iconAmbassador.anchorX = 0.91
    hud.iconAmbassador.x       = self.column2
    hud.iconAmbassador.x       = self.column2
    hud.iconAmbassador.y       = self.top + self.yGap*(ambassadorTop+3.1),
    hud.board:insert(hud.iconAmbassador)

    --------------------------

    hud.invite         = display.newImage( hud.board, I "profile.ambassador.invite.png")
    hud.invite.x       = display.contentWidth*0.5
    hud.invite.y       = self.top + self.yGap*(ambassadorTop+5.5)
    hud.board:insert(hud.invite)

    utils.onTouch(hud.invite, function()
        shareManager:inviteForInstants()
    end)

    ----------------------------------------------------------------------------
    -- Stock of tickets
    ----------------------------------------------------------------------------

    viewManager.drawBorder( hud.board,
        display.contentWidth*0.5, self.top + self.yGap * ( stockTop - 0.8 ),
        display.contentWidth*0.9, self.yGap* (winningsTop - stockTop - 0.6),
        250,250,250, 0.5, 0
    )

    hud.titleStatus    = display.newImage( hud.board, I "profile.stock.png")

    hud.titleStatus.anchorX     = 0
    hud.titleStatus.anchorY     = 0.5
    hud.titleStatus.x           = self.column1 - display.contentWidth * 0.03
    hud.titleStatus.y           = self.top + self.yGap*stockTop
    hud.board:insert(hud.titleStatus)

    ----------------------------------------------------------------------------

    viewManager.newText({
        parent      = hud.board,
        text        = T "Initial stock" .. " : ",
        x           = self.column1,
        y           = self.top + self.yGap*(stockTop+1.5),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })

    local value = viewManager.newText({
        parent      = hud.board,
        text        = lotteryManager.nextLottery.startTickets,
        x           = self.column2 - display.contentWidth * 0.07,
        y           = self.top + self.yGap*(stockTop+1.5),
        fontSize    = self.fontSizeLeft,
        anchorX     = 1,
        anchorY     = 0.5,
    })

    hud.ticketIcon          = display.newImage( hud.board, "assets/images/hud/profile/profile.ticket.png")
    hud.ticketIcon.x        = self.column2 - display.contentWidth * 0.04
    hud.ticketIcon.y        = self.top + self.yGap*(stockTop+1.5)
    hud.ticketIcon.anchorX  = 0
    hud.ticketIcon.anchorY  = 0.4
    hud.board:insert(hud.ticketIcon)

    ----------------------------------------------------------------------------

    local text = viewManager.newText({
        parent      = hud.board,
        text        = "+ " .. T "Social networks",
        x           = self.column1,
        y           = self.top + self.yGap*(stockTop+3),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })

    hud.fanIcon         = display.newImage( hud.board, "assets/images/hud/profile/profile.bonus.networks.png")
    hud.fanIcon.x       = text.x + text.contentWidth + display.contentWidth * 0.04
    hud.fanIcon.y       = self.top + self.yGap*(stockTop+3)
    hud.fanIcon.anchorX = 0
    hud.board:insert(hud.fanIcon)

    local value = viewManager.newText({
        parent      = hud.board,
        text        = userManager.user.fanBonusTickets,
        x           = self.column2 - display.contentWidth * 0.07,
        y           = self.top + self.yGap*(stockTop+3),
        fontSize    = self.fontSizeLeft,
        anchorX     = 1,
        anchorY     = 0.5,
    })

    hud.ticketIcon          = display.newImage( hud.board, "assets/images/hud/profile/profile.bonus.ticket.png")
    hud.ticketIcon.x        = self.column2 - display.contentWidth * 0.04
    hud.ticketIcon.y        = self.top + self.yGap*(stockTop+3)
    hud.ticketIcon.anchorX  = 0
    hud.ticketIcon.anchorY  = 0.4
    hud.board:insert(hud.ticketIcon)

    ----------------------------------------------------------------------------

    local text = viewManager.newText({
        parent      = hud.board,
        text        = "+ " .. T "Charity profile",
        x           = self.column1,
        y           = self.top + self.yGap*(stockTop+4.5),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })

    hud.charityIcon         = display.newImage( hud.board, "assets/images/hud/profile/profile.bonus.charity.png")
    hud.charityIcon.x       = text.x + text.contentWidth + display.contentWidth * 0.04
    hud.charityIcon.y       = self.top + self.yGap*(stockTop+4.5)
    hud.charityIcon.anchorX = 0
    hud.board:insert(hud.charityIcon)

    local value = viewManager.newText({
        parent      = hud.board,
        text        = userManager.user.charityBonusTickets,
        x           = self.column2 - display.contentWidth * 0.07,
        y           = self.top + self.yGap*(stockTop+4.5),
        fontSize    = self.fontSizeLeft,
        anchorX     = 1,
        anchorY     = 0.5
    })

    hud.ticketIcon          = display.newImage( hud.board, "assets/images/hud/profile/profile.bonus.ticket.png")
    hud.ticketIcon.x        = self.column2 - display.contentWidth * 0.04
    hud.ticketIcon.y        = self.top + self.yGap*(stockTop+4.5)
    hud.ticketIcon.anchorX  = 0
    hud.ticketIcon.anchorY  = 0.4
    hud.board:insert(hud.ticketIcon)

    ----------------------------------------------------------------------------

    local text = viewManager.newText({
        parent      = hud.board,
        text        = "+ " .. T "Ambass. Profile",
        x           = self.column1,
        y           = self.top + self.yGap*(stockTop+6),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5
    })

    hud.ambassadorIcon         = display.newImage( hud.board, "assets/images/hud/profile/profile.stock.ambassador.png")
    hud.ambassadorIcon.x       = text.x + text.contentWidth + display.contentWidth * 0.04
    hud.ambassadorIcon.y       = self.top + self.yGap*(stockTop+6)
    hud.ambassadorIcon.anchorX = 0
    hud.board:insert(hud.ambassadorIcon)

    local text = viewManager.newText({
        parent      = hud.board,
        text        = userManager.user.ambassadorBonusTickets,
        x           = self.column2 - display.contentWidth * 0.07,
        y           = self.top + self.yGap*(stockTop+6),
        fontSize    = self.fontSizeLeft,
        anchorX     = 1,
        anchorY     = 0.5,
    })

    hud.ticketIcon          = display.newImage( hud.board, "assets/images/hud/profile/profile.bonus.ticket.png")
    hud.ticketIcon.x        = self.column2 - display.contentWidth * 0.04
    hud.ticketIcon.y        = self.top + self.yGap*(stockTop+6)
    hud.ticketIcon.anchorX  = 0
    hud.ticketIcon.anchorY  = 0.4
    hud.board:insert(hud.ticketIcon)

    ----------------------------------------------------------------------------

    local text = viewManager.newText({
        parent      = hud.board,
        text        = "+ " .. T "Winning Tickets",
        x           = self.column1,
        y           = self.top + self.yGap*(stockTop+7.5),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5
    })

    hud.winningsIcon         = display.newImage( hud.board, "assets/images/hud/profile/profile.stock.winnings.png")
    hud.winningsIcon.x       = text.x + text.contentWidth + display.contentWidth * 0.04
    hud.winningsIcon.y       = self.top + self.yGap*(stockTop+7.5)
    hud.winningsIcon.anchorX = 0
    hud.board:insert(hud.winningsIcon)

    local text = viewManager.newText({
        parent      = hud.board,
        text        = userManager.user.temporaryBonusTickets,
        x           = self.column2 - display.contentWidth * 0.07,
        y           = self.top + self.yGap*(stockTop+7.5),
        fontSize    = self.fontSizeLeft,
        anchorX     = 1,
        anchorY     = 0.5,
    })

    hud.ticketIcon          = display.newImage( hud.board, "assets/images/hud/profile/profile.bonus.ticket.png")
    hud.ticketIcon.x        = self.column2 - display.contentWidth * 0.04
    hud.ticketIcon.y        = self.top + self.yGap*(stockTop+7.5)
    hud.ticketIcon.anchorX  = 0
    hud.ticketIcon.anchorY  = 0.4
    hud.board:insert(hud.ticketIcon)

    ----------------------------------------------------------------------------

    viewManager.newText({
        parent      = hud.board,
        text        = "= " .. T "Available Tickets" .. " : ",
        x           = self.column1,
        y           = self.top + self.yGap*(stockTop+9),
        fontSize    = self.fontSizeLeft,
        anchorX     = 0,
        anchorY     = 0.5,
    })

    local text = viewManager.newText({
        parent      = hud.board,
        text        = userManager:totalAvailableTickets(),
        x           = self.column2 - display.contentWidth * 0.07,
        y           = self.top + self.yGap*(stockTop+9),
        fontSize    = self.fontSizeLeft,
        anchorX     = 1,
        anchorY     = 0.5,
    })

    hud.ticketIcon          = display.newImage( hud.board, "assets/images/hud/profile/profile.ticket.png")
    hud.ticketIcon.x        = self.column2 - display.contentWidth * 0.04
    hud.ticketIcon.y        = self.top + self.yGap*(stockTop+9)
    hud.ticketIcon.anchorX  = 0
    hud.ticketIcon.anchorY  = 0.4
    hud.board:insert(hud.ticketIcon)

    --------------------------

    hud.moreTickets         = display.newImage( hud.board, I "profile.stock.more.png")
    hud.moreTickets.x       = display.contentWidth*0.5
    hud.moreTickets.y       = self.top + self.yGap*(stockTop+11.5)
    hud.board:insert(hud.moreTickets)

    utils.onTouch(hud.moreTickets, function()
        shareManager:moreTickets()
    end)

    ----------------------------------------------------------------------------
    -- winnings
    ----------------------------------------------------------------------------

    viewManager.drawBorder( hud.board,
        display.contentWidth*0.5, self.top + self.yGap * ( winningsTop - 0.8 ),
        display.contentWidth*0.9, self.yGap* (detailsTop - winningsTop - 0.6),
        250,250,250, 0.5, 0
    )

    hud.titleWinnings    = display.newImage( hud.board, I "profile.winnings.png")

    hud.titleWinnings.anchorX    = 0
    hud.titleWinnings.anchorY    = 0.5

    hud.titleWinnings.x   = self.column1 - display.contentWidth * 0.03
    hud.titleWinnings.y   = self.top + self.yGap*winningsTop
    hud.board:insert(hud.titleWinnings)

    --------------------------

    viewManager.newText({
        parent    = hud.board,
        text     = T "Total winnings" .. " : ",
        x      = self.column1,
        y      = self.top + self.yGap*(winningsTop+1.5),
        fontSize   = self.fontSizeLeft,
        anchorX    = 0,
        anchorY    = 0.5,
    })

    viewManager.newText({
        parent    = hud.board,
        text     = utils.displayPrice(userManager.user.totalWinnings, COUNTRY) ,
        x      = self.column1 + display.contentWidth*0.26,
        y      = self.top + self.yGap*(winningsTop+2.5),
        fontSize   = 40,
        font    = NUM_FONT,
        anchorX    = 1,
        anchorY    = 0.5,
    })

    hud.iconMoney    = display.newImage( hud.board, "assets/images/icons/money.png")
    hud.iconMoney.x   = self.column1 + display.contentWidth*0.31
    hud.iconMoney.y   = self.top + self.yGap*(winningsTop+2.5) - display.contentHeight*0.004
    hud.board:insert(hud.iconMoney)

    --------------------------

    viewManager.newText({
        parent    = hud.board,
        text     = T "Payed" .. " : ",
        x      = self.column2,
        y      = self.top + self.yGap*(winningsTop+1.5),
        fontSize   = self.fontSizeLeft,
        anchorX    = 1,
        anchorY    = 0.5,
    })

    viewManager.newText({
        parent    = hud.board,
        text     = utils.displayPrice(userManager.user.receivedWinnings, COUNTRY) ,
        x      = self.column2 -  display.contentWidth*0.07,
        y      = self.top + self.yGap*(winningsTop+2.5),
        fontSize   = self.fontSizeRight,
        font    = NUM_FONT,
        fontSize   = 40,
        anchorX    = 1,
        anchorY    = 0.5,
    })

    hud.iconMoney    = display.newImage( hud.board, "assets/images/icons/PictogainPayed.png")
    hud.iconMoney.x   = self.column2
    hud.iconMoney.y   = self.top + self.yGap*(winningsTop+2.5) - display.contentHeight*0.004
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
        parent      = hud.board,
        text        = balance,
        x           = display.contentWidth*0.5,
        y           = self.top + self.yGap*(winningsTop+5),
        fontSize    = 40,
        font        = NUM_FONT,
        anchorX     = 1,
        anchorY     = 0.5
    })

    hud.iconMoney       = display.newImage( hud.board, "assets/images/icons/PictoBalance.png")
    hud.iconMoney.x     = display.contentWidth*0.58
    hud.iconMoney.y     = self.top + self.yGap*(winningsTop+5) - display.contentHeight*0.004
    hud.board:insert(hud.iconMoney)

    --------------------------

    hud.cashout         = display.newImage( hud.board, I "profile.payment.png")
    hud.cashout.x       = display.contentWidth*0.5
    hud.cashout.y       = self.top + self.yGap*(winningsTop+7.2)
    hud.board:insert(hud.cashout)

    utils.onTouch(hud.cashout, function()
        self:openCashout()
    end)


    ----------------------------------------------------------------------------
    -- Personal Details
    ----------------------------------------------------------------------------

    viewManager.drawBorder( hud.board,
        display.contentWidth*0.5, self.top + self.yGap * ( detailsTop - 0.8 ),
        display.contentWidth*0.9, self.yGap* (logoutTop - detailsTop - 0.6),
        250,250,250, 0.5, 0
    )

    hud.titleDetails   = display.newImage( hud.board, I "profile.personal.png")

    hud.titleDetails.anchorX    = 0
    hud.titleDetails.anchorY    = 0.5
    hud.titleDetails.x      = self.column1 - display.contentWidth*0.03
    hud.titleDetails.y      = self.top + self.yGap*(detailsTop)
    hud.board:insert(hud.titleDetails)

    ------------------

    self:drawTextEntry(T "First name"           .. " : ", userManager.user.firstName or '-', detailsTop+1.5)
    self:drawTextEntry(T "Last name"            .. " : ", userManager.user.lastName or '-', detailsTop+2.7)
    self:drawTextEntry(T "Email"                .. " : ", userManager.user.email or '-', detailsTop+3.9)
    self:drawTextEntry(T "Date of birth"        .. " : ", utils.readableDate(userManager.user.birthDate, false, true), detailsTop+5.1)
    self:drawTextEntry(T "Sponsorship code"     .. " : ", userManager.user.sponsorCode or '-', detailsTop+6.3)

    ------------------

    hud.fb                = display.newImage( hud.board, "assets/images/hud/profile/facebook.details.png")
    hud.fb.anchorX        = 0
    hud.fb.anchorY        = 0.4
    hud.fb.x              = self.column1
    hud.fb.y              = self.top + self.yGap*(detailsTop+7.5)
    hud.board:insert(hud.fb)

    local textFB = viewManager.newText({
        parent      = hud.board,
        text        = "Facebook :",
        x           = hud.fb.x + hud.fb.contentWidth + display.contentWidth * 0.02,
        y           = self.top + self.yGap*(detailsTop+7.5),
        fontSize    = self.fontSizeLeft,
        font        = FONT,
        anchorX     = 0,
        anchorY     = 0.5
    })

    local valueFB = "-"
    if(userManager.user.facebookId) then
        valueFB = userManager.user.userName
    end

    viewManager.newText({
        parent      = hud.board,
        text        = valueFB,
        x           = self.column2,
        y           = self.top + self.yGap*(detailsTop+7.5),
        fontSize    = self.fontSizeRight,
        font        = NUM_FONT,
        anchorX     = 1,
        anchorY     = 0.5
    })

    ------------------

    hud.tw                = display.newImage( hud.board, "assets/images/hud/profile/twitter.details.png")
    hud.tw.anchorX        = 0
    hud.tw.anchorY        = 0.4
    hud.tw.x              = self.column1
    hud.tw.y              = self.top + self.yGap*(detailsTop+8.7)
    hud.board:insert(hud.tw)

    local textTW = viewManager.newText({
        parent      = hud.board,
        text        = "Twitter :",
        x           = hud.tw.x + hud.tw.contentWidth + display.contentWidth * 0.02,
        y           = self.top + self.yGap*(detailsTop+8.7),
        fontSize    = self.fontSizeLeft,
        font        = FONT,
        anchorX     = 0,
        anchorY     = 0.5
    })

    local valueTW = "-"
    if(userManager.user.twitterId) then
        valueTW = userManager.user.twitterName
    end

    viewManager.newText({
        parent      = hud.board,
        text        = valueTW,
        x           = self.column2,
        y           = self.top + self.yGap*(detailsTop+8.7),
        fontSize    = self.fontSizeRight,
        font        = NUM_FONT,
        anchorX     = 1,
        anchorY     = 0.5
    })

    --------------------------

    hud.complete         = display.newImage( hud.board, I "profile.complete.png")
    hud.complete.x       = display.contentWidth*0.5
    hud.complete.y       = self.top + self.yGap*(detailsTop+10.5)
    hud.board:insert(hud.complete)

    utils.onTouch(hud.complete, function()
        shareManager:moreTickets()
    end)

    -----------------------------------------------
    -- Logout button
    -----------------------------------------------

    hud.logoutLine    = display.newImage( hud.board, "assets/images/hud/Filet.png")
    hud.logoutLine .x = display.contentWidth*0.5
    hud.logoutLine .y = self.top + self.yGap*(logoutTop)
    hud.board:insert(hud.logoutLine )

    hud.logoutCadenas    = display.newImage( hud.board, "assets/images/hud/Cadenas.png")
    hud.logoutCadenas .x = display.contentWidth*0.5
    hud.logoutCadenas .y = self.top + self.yGap*(logoutTop)
    hud.board:insert(hud.logoutCadenas )

    hud.board.logout   = display.newImage( hud.board, I "Logout.png")
    hud.board.logout.x = display.contentWidth*0.5
    hud.board.logout.y = self.top + self.yGap * (logoutTop+2)
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

--------------------------------------------------------------------------------

function scene:openFacebookPage()
    viewManager.openWeb(FACEBOOK_PAGE)
end

--------------------------------------------------------------------------------

function scene:drawTextEntry(title, value, position, fontSizeLeft, fontSizeRight)

    viewManager.newText({
        parent   = hud.board,
        text     = title,
        x        = self.column1,
        y        = self.top + self.yGap*position,
        fontSize = fontSizeLeft or self.fontSizeLeft,
        anchorX  = 0,
        anchorY  = 0.5,
    })

    viewManager.newText({
        parent   = hud.board,
        text     = value,
        x        = self.column2,
        y        = self.top + self.yGap*position,
        fontSize = fontSizeRight or self.fontSizeRight,
        font     = NUM_FONT,
        anchorX  = 1,
        anchorY  = 0.5,
    })

end

--------------------------------------------------------------------------------

function scene:drawConnection(title, state, position)

    viewManager.newText({
        parent   = hud.board,
        text     = title,
        x        = display.contentWidth*0.75,
        y        = self.top + self.yGap*position,
        fontSize = 21,
        anchorX  = 1,
        anchorY  = 0.5,
    })

    local light  = display.newImage(hud.board, "assets/images/hud/".. state ..".png")
    light.x    = display.contentWidth*0.8
    light.y    = self.top + self.yGap*position + 3
    hud.board:insert(light)

end

--------------------------------------------------------------------------------

function scene:openCashout()

    -----------------------------------

    local popup = viewManager.showPopup()
    analytics.event("Gaming", "opencashout")

    ----------------------------------------------------------------------------

    popup.infoBG                    = display.newImage(popup, "assets/images/hud/info.bg.png")
    popup.infoBG.x                  = display.contentWidth*0.5
    popup.infoBG.y                  = display.contentHeight * 0.5

    popup.shareIcon                 = display.newImage( popup, "assets/images/icons/PictoInfo.png")
    popup.shareIcon.x               = display.contentWidth*0.5
    popup.shareIcon.y               = display.contentHeight*0.2

    popup.TxtInformation            = display.newImage( popup, I "TxtInformation.png")
    popup.TxtInformation.x          = display.contentWidth*0.5
    popup.TxtInformation.y          = display.contentHeight*0.28

    ----------------------------------------------------------------------------

    local value = ""
    if(utils.isEuroCountry(COUNTRY)) then
        value = lotteryManager.globals.minEuro .. "€"
    else
        value = "US$" .. lotteryManager.globals.minUSD
    end

    popup.multiLineText = display.newText({
        parent      = popup,
        text        = T "You can cash out when your winnings have reached a minimum total balance of " .. value,
        width       = display.contentWidth      * 0.82,
        height      = display.contentHeight     * 0.25,
        x           = display.contentWidth      * 0.5,
        y           = display.contentHeight     * 0.52,
        font        = FONT,
        fontSize    = 45,
        align       = "center",
    })

    popup.multiLineText:setFillColor(0)

    ----------------------------------------------------------------------------

    local min = lotteryManager.globals.minEuro
    if(not utils.isEuroCountry(COUNTRY)) then
        min = lotteryManager.globals.minUSD
    end

    if(userManager.user.balance >= min) then
        hud.cashoutEnabled          = display.newImage( popup, I "cashout.on.png")
        hud.cashoutEnabled.x        = display.contentWidth*0.5
        hud.cashoutEnabled.y        = display.contentHeight*0.7
        utils.onTouch(hud.cashoutEnabled, function()
            viewManager.closePopup(popup)
            self.openConfirmCashout()
        end)

    else
        hud.cashoutDisabled         = display.newImage( popup, I "cashout.off.png")
        hud.cashoutDisabled.x       = display.contentWidth*0.5
        hud.cashoutDisabled.y       = display.contentHeight*0.7

    end

    ----------------------------------------------------------------------------

    popup.close         = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x       = display.contentWidth*0.5
    popup.close.y       = display.contentHeight*0.86

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

end

--------------------------------------------------------------------------------

function scene: openConfirmCashout()

    -----------------------------------

    local popup = viewManager.showPopup()
    analytics.event("Gaming", "openConfirmCashout")

    ----------------------------------------------------------------------------

    popup.infoBG                    = display.newImage(popup, "assets/images/hud/info.bg.png")
    popup.infoBG.x                  = display.contentWidth*0.5
    popup.infoBG.y                  = display.contentHeight * 0.5

    popup.shareIcon                 = display.newImage( popup, "assets/images/icons/notification/prizes.popup.png")
    popup.shareIcon.x               = display.contentWidth*0.5
    popup.shareIcon.y               = display.contentHeight*0.15

    popup.congratz                  = display.newImage( popup, I "TxtCongratulations.png")
    popup.congratz.x                = display.contentWidth*0.5
    popup.congratz.y                = display.contentHeight*0.25

    ----------------------------------------------------------------------------

    popup.multiLineText = display.newText({
        parent      = popup,
        text        = T "You will receive your winnings within 4 to 8 weeks \n \n  We will contact you by email in the coming days to proceed with the payment",
        width       = display.contentWidth*0.6,
        height      = display.contentHeight*0.25,
        x           = display.contentWidth*0.5,
        y           = display.contentHeight*0.45,
        font        = FONT,
        fontSize    = 42,
        align       = "center"
    })

    popup.multiLineText:setFillColor(0)

    ----------------------------------------------------------------------------

    hud.confirm     = display.newImage( popup, I "confirm.png")
    hud.confirm.x   = display.contentWidth*0.5
    hud.confirm.y   = display.contentHeight*0.7

    local refresh = function() scene:refreshScene() end

    utils.onTouch(hud.confirm, function()
        analytics.event("Gaming", "cashout")
        native.setActivityIndicator( true )
        userManager:cashout(function()
            print("--> cashout success")
            native.setActivityIndicator( false )
            viewManager.message(T "Congratulations !")
            viewManager.closePopup(popup)
            userManager.user.pendingWinnings = userManager.user.pendingWinnings + userManager.user.balance
            userManager.user.balance = 0

            print("--> refreshing screen")
            router.resetScreen()
            refresh()
        end)
    end)

    ------------------------------------------

    popup.close     = display.newImage( popup, I "popup.Bt_close.png")
    popup.close.x    = display.contentWidth*0.5
    popup.close.y    = display.contentHeight*0.86

    utils.onTouch(popup.close, function() viewManager.closePopup(popup) end)

end

--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------

return scene