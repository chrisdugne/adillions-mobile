--------------------------------------------------------------------------------

GameManager = {}

--------------------------------------------------------------------------------

function GameManager:new()

    local object = {
    }

    setmetatable(object, { __index = GameManager })
    return object
end

--------------------------------------------------------------------------------

function GameManager:start()

    analytics.init(
        ANALYTICS_VERSION,
        ANALYTICS_TRACKING_ID,
        ANALYTICS_PROFILE_ID,
        APP_NAME,
        APP_VERSION
    )

    viewManager.initGlobalBack()
    vungle:init()

    if(not GLOBALS.savedData) then
        self:firstStart()
    else
        self:open()
    end

end

--------------------------------------------------------------------------------

function GameManager:open()

    router.openLoading()

    local onGoodVersion = function()
        if(GLOBALS.savedData.user.facebookId) then
            gameManager:tryAutoOpenFacebookAccount()
        else
            print("tryAutoOpenFacebookAccount")
            gameManager:tryAutoOpenAdillionsAccount()
        end
    end

    local onBadVersion = function() gameManager:showBadVersion() end

    userManager:getGlobals(onGoodVersion, onBadVersion)

end

--------------------------------------------------------------------------------

function GameManager:firstStart()
    router.openLoading()
    self:initGameData()
    self:initOptions()
    router.openTutorial()
end

--------------------------------------------------------------------------------

function GameManager:initGameData(tutorialSeen)

    GLOBALS.savedData = {
        requireTutorial = not tutorialSeen,
        user            = {}
    }

    GLOBALS.savedData.facebookAccessToken  = nil
    GLOBALS.savedData.twitterAccessToken  = nil

    utils.saveTable(GLOBALS.savedData, "savedData.json")
end


function GameManager:initOptions()

    GLOBALS.options = {
        notificationBeforeDraw  = true,
        notificationAfterDraw  = true,
    }

    utils.saveTable(GLOBALS.options, "options.json")
end

--------------------------------------------------------------------------------

function GameManager:tryAutoOpenFacebookAccount()
    native.setActivityIndicator( true )
    facebook.getMe(function()
        native.setActivityIndicator( false )
        print("start : getMe : fail : try adillions account")
        self:tryAutoOpenAdillionsAccount()
    end)
end

function GameManager:tryAutoOpenAdillionsAccount()

    GLOBALS.savedData.facebookAccessToken  = nil
    GLOBALS.savedData.twitterAccessToken  = nil
    utils.saveTable(GLOBALS.savedData, "savedData.json")

    if(GLOBALS.savedData.user.uid) then
        userManager:fetchPlayer()

    else
        print("start : no user data : outside")
        router.openOutside()
    end
end

--------------------------------------------------------------------------------

function GameManager:showBadVersion()

        local popup = viewManager.showPopup(display.contentWidth*0.95, true)

        ----------------------------------------

        popup.bg        = display.newImage( popup, "assets/images/hud/home/BG_adillions.png")
        popup.bg.x      = display.contentWidth*0.5
        popup.bg.y      = display.contentHeight*0.5


        popup.congratz    = display.newImage( popup, I "wrongversion.title.png")
        popup.congratz.x   = display.contentWidth*0.5
        popup.congratz.y  = display.contentHeight*0.3

        ----------------------------------------

        popup.earnText = viewManager.newText({
            parent      = popup,
            text        = T "Please download the latest version of Adillions" .. "(v" .. VERSION_REQUIRED .. ") !",
            fontSize    = 55,
            width       = display.contentWidth * 0.8,
            x           = display.contentWidth * 0.5,
            y           = display.contentHeight * 0.47
        })

        popup.earnText = viewManager.newText({
            parent      = popup,
            text        = T "Thank you",
            fontSize    = 55,
            width       = display.contentWidth * 0.5,
            x           = display.contentWidth * 0.5,
            y           = display.contentHeight * 0.65
        })

        --------------------------

end

--------------------------------------------------------------------------------

function GameManager:play()
    if(userManager:hasTicketsToPlay()) then
        if(userManager:checkTicketTiming()) then
            videoManager:play(router.openFillLotteryTicket, true)
        end
    else
        shareManager:noMoreTickets()
    end
end

--------------------------------------------------------------------------------

return GameManager

--------------------------------------------------------------------------------