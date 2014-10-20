--------------------------------------------------------------------------------

AppManager = {}

--------------------------------------------------------------------------------

function AppManager:new()
    local object = {}
    setmetatable(object, { __index = AppManager })
    return object
end

--------------------------------------------------------------------------------

function AppManager:start()

    APP_NAME = "Adillions"

    ----------------------------------------------------------------------------

    -- LOCAL = true
    -- VERBOSE = true

    ----------------------------------------------------------------------------
    -- Dev overiddes

    -- DEV_BEARER = 'b5a8d743-9317-4f37-9537-0787fa245f19'
    -- DEV_LANG = "fr" -- "en"
    -- DEV_COUNTRY = "FR" -- "US"

    ----------------------------------------------------------------------------

    if(LOCAL) then
        SETTINGS_ID            = 'local'
        LOCAL_IP               = "192.168.0.7"
        -- LOCAL_IP               = "10.17.100.223"
    else
        -- SETTINGS_ID            = 'dev'
        -- SETTINGS_ID            = 'stage-1.5'
        SETTINGS_ID            = 'prod-1.5'
        MOBILE_SETTINGS_URL    = "http://www.adillions.com/api/mobile/settings/"
    end

    ----------------------------------------------------------------------------

    print("---------------------- "
        .. APP_NAME
        .. " " .. SETTINGS_ID
        .. " ----------------")

    ----------------------------------------------------------------------------

    appManager:setup()
    appManager:deviceSetup()

    router.openLoading()
    appManager:checkInternetConnection()

end

--------------------------------------------------------------------------------

function AppManager:setup()

    print("application setup...")

    ----------------------------------------------------------------------------
    ---- App globals

    GLOBALS = {
        savedData = utils.loadUserData("savedData.json"),
        options   = utils.loadUserData("options.json")
    }

    ----------------------------------------------------------------------------

    FACEBOOK_PAGE_ID = "379432705492888"
    FACEBOOK_PAGE    = "https://www.facebook.com/adillions"
    TWITTER_ID       = "1922939570"

    ----------------------------------------------------------------------------

    ANALYTICS_VERSION     = 1
    ANALYTICS_TRACKING_ID = "UA-45586817-2"
    ANALYTICS_PROFILE_ID  = "78871292"

    ----------------------------------------------------------------------------

    IOS         = system.getInfo( "platformName" )  == "iPhone OS"
    ANDROID     = system.getInfo( "platformName" )  == "Android"
    SIMULATOR   = system.getInfo( "environment" )   == "simulator"

    ----------------------------------------------------------------------------
    --- lottery tickets status

    BLOCKED = 1; -- set as winning ticket, notification/popup read, w84 cashout
    PENDING = 2; -- cashout requested
    PAYED   = 3; -- to set manually when paiement is done
    GIFT    = 4; --  gift to charity

    BONUS_1 = 11; -- rang 7
    BONUS_2 = 12; -- rang 8
    BONUS_3 = 13; -- rang 9
    BONUS_4 = 14; -- rang 10

    ----------------------------------------------------------------------------

    NB_INSTANTS_PER_TWEET           = 1
    NB_INSTANTS_PER_POST            = 1
    NB_INSTANTS_PER_THEME_LIKED     = 1
    NB_SDONSDLN_PER_TWEET           = 2

    NB_SDONSDLN_PER_POST            = 2

    NB_SDONSDLN_PER_THEME_LIKED     = 2

    NB_SDONSDLN_PER_TWEET           = 2

    NB_SDONSDLN_PER_POST            = 2

    NB_INSTANTS_PER_THEME_LIKED     = 1

    FACEBOOK_CONNECTION_TICKETS     = 1
    TWITTER_CONNECTION_TICKETS      = 1

    FACEBOOK_FAN_TICKETS            = 3
    TWITTER_FAN_TICKETS             = 3

    ----------------------------------------------------------------------------

    HEADER_HEIGHT = display.contentHeight * 0.095
    MENU_HEIGHT   = 124
    TICKET_HEIGHT = 100

    ----------------------------------------------------------------------------

    translations = require("assets.Translations")

    if ANDROID then
        FONT   = "GillSans"
        NUM_FONT = "HelveticaBold"
    else
        FONT   = "Gill Sans"
        NUM_FONT = "Helvetica-Bold"
    end

    ----------------------------------------------------------------------------

    if(ANDROID) then
        LANG = userDefinedLanguage or system.getPreference("locale", "language")
    else
        LANG = userDefinedLanguage or system.getPreference("ui", "language")
    end

    -- LANG not supported : default en
    if(LANG ~= "en" and LANG ~= "fr") then LANG = "en" end

    -- dev overiddes
    if(DEV_LANG) then LANG = DEV_LANG end

    ----------------------------------------------------------------------------

    COUNTRY = system.getPreference( "locale", "country" ) or "US"

    -- dev overiddes
    if(DEV_COUNTRY) then COUNTRY = DEV_COUNTRY end

    ----------------------------------------------------------------------------

    aspectRatio = display.pixelHeight / display.pixelWidth

    ----------------------------------------------------------------------------

    abs         = math.abs
    random      = math.random

    ----------------------------------------------------------------------------
    --- Display Container

    hud = display.newGroup()

end

--------------------------------------------------------------------------------

function AppManager:deviceSetup()

    print("device setup...")

    ----------------------------------------------------------------------------
    -- prepare notifications for this session
    -- these notifications can be removed as long as the app is ON

    self.deviceNotifications = {}

    ----------------------------------------------------------------------------

    -- create a function to handle all of the system events
    local onSystem = function( event )
        if event.type == "applicationSuspend" then

        elseif event.type == "applicationStart" then
             -- iOS badges (+n on icon)
            native.setProperty( "applicationIconBadgeNumber", 0 )

        elseif event.type == "applicationResume" then

            print("----->  ON RESUME", vungle.vungleON, router.view)
            if( not vungle.vungleON
            and not (router.view == router.NO_INTERNET)
            and not (router.view == router.LOADING)
            and not (router.view == router.OUTSIDE)
            and not (router.view == router.LOGIN)
            and not (router.view == router.SIGNIN)
            and not (router.view == router.SIGNINFB)
            ) then
                print("RESET PLAYER")
                 -- iOS badges (+n on icon)
                native.setProperty( "applicationIconBadgeNumber", 0 )
                gameManager:open()
            end
        end
    end

    -- setup a system event listener
    Runtime:addEventListener( "system", onSystem )

    ----------------------------------------------------------------------------
    --- iOS Status Bar
    display.setStatusBar( display.HiddenStatusBar )

    ------------------------------------------
    --- ANDROID BACK BUTTON

    local function onKeyEvent( event )

        local phase = event.phase
        local keyName = event.keyName
        print( event.phase, event.keyName )

        if ( "back" == keyName and phase == "up" ) then
            if ( storyboard.currentScene == "splash" ) then
                native.requestExit()
            else
                if ( storyboard.isOverlay ) then
                    storyboard.hideOverlay()
                else
                    local lastScene = storyboard.returnTo
                    print( "previous scene", lastScene )
                    if ( lastScene ) then
                        storyboard.gotoScene( lastScene, {
                            effect="crossFade",
                            time=500
                        })
                    else
                        native.requestExit()
                    end
                end
            end
        end

        if ( keyName == "volumeUp" and phase == "down" ) then
            local masterVolume = audio.getVolume()
            print( "volume:", masterVolume )
            if ( masterVolume < 1.0 ) then
                masterVolume = masterVolume + 0.1
                audio.setVolume( masterVolume )
            end
        elseif ( keyName == "volumeDown" and phase == "down" ) then
            local masterVolume = audio.getVolume()
            print( "volume:", masterVolume )
            if ( masterVolume > 0.0 ) then
                masterVolume = masterVolume - 0.1
                audio.setVolume( masterVolume )
            end
        end

        return true  --SEE NOTE BELOW
    end

    --add the key callback
    Runtime:addEventListener( "key", onKeyEvent )

    ----------------------------------------------------------------------------

    local function myUnhandledErrorListener( event )

        local iHandledTheError = true

        if iHandledTheError then
            print( "Handling the unhandled error", event.errorMessage )
        else
            print( "Not handling the unhandled error", event.errorMessage )
        end

        return iHandledTheError
    end

    Runtime:addEventListener("unhandledError", myUnhandledErrorListener)

    ----------------------------------------------------------------------------

    --
    --
    --local fonts = native.getFontNames()
    --
    --count = 0
    --
    ---- Count the number of total fonts
    --for i,fontname in ipairs(fonts) do
    --    count = count+1
    --end
    --
    --print( "\rFont count = " .. count )
    --
    --local name = "pt"     -- part of the Font name we are looking for
    --
    --name = string.lower( name )
    --
    ---- Display each font in the terminal console
    --for i, fontname in ipairs(fonts) do
    --
    --        print( "fontname = " .. tostring( fontname ) )
    --end
end

--------------------------------------------------------------------------------

function AppManager:checkInternetConnection(test)

    print("checking internet connection")
    if(utils.networkConnection()) then
        appManager.getMobileSettings()
    else
        if(not test) then
            router.openNoInternet()
        end
    end
end

--------------------------------------------------------------------------------

function AppManager:getMobileSettings()

    if(not LOCAL) then
        print("--> settings...("..MOBILE_SETTINGS_URL .. SETTINGS_ID ..")")
        utils.get(MOBILE_SETTINGS_URL .. SETTINGS_ID, function(res)
            local settings = json.decode(res.response)
            utils.tprint(settings)

            APP_VERSION     = tonumber(settings.version)
            OLD_API_URL     = settings.api.play
            SAILS_URL       = settings.api.node
            FACEBOOK_APP_ID = settings.facebookAppId

            appManager.onSettingsReady()

        end)
    else
        -- DEV : local servers ONLY
        print("DEV settings : local servers + FB adillions-localhost")
        APP_VERSION = 999

        OLD_API_URL  = "http://api.adillions.com/"
        SAILS_URL = "http://" .. LOCAL_IP .. ":1337"

        FACEBOOK_APP_ID = "293489340852840"

        appManager.onSettingsReady()

    end
end

--------------------------------------------------------------------------------

function AppManager:onSettingsReady()

    print("     version:  " .. APP_VERSION)
    print("     api:      " .. SAILS_URL)
    print("     old api:  " .. OLD_API_URL)
    print("     lang:     " .. LANG)
    print("     country:  " .. COUNTRY)
    print("     fbApp:    " .. FACEBOOK_APP_ID)

    gameManager:start()

end


--------------------------------------------------------------------------------
-- Translations

function T(enText)
    if(not translations[enText]) then
        print('Missing Translation : ' .. enText)
        return '&&&&&'
    end

    return translations[enText][LANG] or enText
end

function I(asset)
    return "assets/images/bylang/"..LANG.."/"..asset
end

function translate(texts)
    return texts[LANG]
end

--------------------------------------------------------------------------------

function AppManager:deviceNotification(text, secondsFromNow, id)

    print('----> deviceNotification : [' .. id .. '] --> ' .. text .. ' (' .. secondsFromNow .. ')')

    local options = {
        alert = text,
        badge = 1,
    }

    if(self.deviceNotifications[id]) then
        print('cancelling device notification : ', self.deviceNotifications[id])
        system.cancelNotification( self.deviceNotifications[id] )
    end

    print('scheduling : ', id, secondsFromNow)
    self.deviceNotifications[id] = system.scheduleNotification(
        secondsFromNow,
        options
    )
    print('scheduled : ', self.deviceNotifications[id])

end

--------------------------------------------------------------------------------

return AppManager
