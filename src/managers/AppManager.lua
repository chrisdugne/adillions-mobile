--------------------------------------------------------------------------------

AppManager = {}

--------------------------------------------------------------------------------

function AppManager:new()

    local object = {
    }

    setmetatable(object, { __index = AppManager })
    return object
end

--------------------------------------------------------------------------------

function AppManager:start()

    APP_NAME = "Adillions"

    ----------------------------------------------------------------------------
    PROD = true

    if(PROD) then
        APP_VERSION             = 1.5
        FACEBOOK_APP_ID        = "170148346520274"
        FACEBOOK_API_SECRET    = "887e8f7abb9b1cb9238a097e06585ae2"
        FACEBOOK_APP_NAMESPACE = "adillions"
        MOBILE_SETTINGS_URL    = "http://adillions-dev.herokuapp.com/api/mobile/settings/"
    else
        LOCAL_IP               = "192.168.0.10"
        -- LOCAL_IP               = "10.17.100.223"
        APP_VERSION            = 999
        FACEBOOK_APP_ID        = "534196239997712"
        FACEBOOK_API_SECRET    = "46383d827867d50ef5d87b66c81f1a8e"
        FACEBOOK_APP_NAMESPACE = "adillions-dev"
        MOBILE_SETTINGS_URL    = "http://" .. LOCAL_IP .. ":1337/api/mobile/settings/"
    end

    print("---------------------- "
        .. APP_NAME
        .. " " .. APP_VERSION
        .. " ----------------")

    ----------------------------------------------------------------------------

    appManager.setup()
    appManager:deviceSetup()
    appManager:checkInternetConnection()

end

--------------------------------------------------------------------------------

function AppManager:setup()

    print("application setup...")

    ------------------------------------------------------------------------------
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

    BLOCKED = 1; -- set as winning ticket, notification/popup read, cashout blocked (<10)
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

    FACEBOOK_CONNECTION_TICKETS     = 1
    TWITTER_CONNECTION_TICKETS      = 1

    FACEBOOK_FAN_TICKETS            = 3
    TWITTER_FAN_TICKETS             = 3

    ----------------------------------------------------------------------------

    HEADER_HEIGHT = display.contentHeight * 0.095
    MENU_HEIGHT   = 124
    TICKET_HEIGHT = 100

    ------------------------------------------------------------------------------

    translations = require("assets.Translations")

    if ANDROID then
        FONT   = "GillSans"
        NUM_FONT = "HelveticaBold"
    else
        FONT   = "Gill Sans"
        NUM_FONT = "Helvetica-Bold"
    end

    ------------------------------------------------------------------------------

    if(ANDROID) then
        LANG =  userDefinedLanguage or system.getPreference("locale", "language")
    else
        LANG =  userDefinedLanguage or system.getPreference("ui", "language")
    end

    -- LANG not supported : default en
    if(LANG ~= "en" and LANG ~= "fr") then LANG = "en" end

    ------------------------------------------------------------------------------

    COUNTRY = system.getPreference( "locale", "country" ) or "US"

    ------------------------------------------------------------------------------

    aspectRatio = display.pixelHeight / display.pixelWidth

    ------------------------------------------------------------------------------

    abs         = math.abs
    random      = math.random

    ------------------------------------------------------------------------------
    --- Display Container

    hud = display.newGroup()

end

--------------------------------------------------------------------------------

function AppManager:deviceSetup()
    print("device setup...")
    -------
    --- NOTIFICATIONS
    --- pas d'ecoute des notifs In-APP : pas besoin.
    --local function notificationListener( event )
    --
    --   print("------------------ notificationListener")
    -- utils.tprint(event)
    -- if ( event.type == "remote" ) then
    --  native.showPopup("Notification", "remote", { "Ok" })
    --
    -- elseif ( event.type == "local" ) then
    --  native.showPopup("Notification", "local", { "Ok" })
    --
    -- elseif ( event.type == "remoteRegistration" ) then
    --  native.showPopup("Notification", "remoteRegistration", { "Ok" })
    --
    -- end
    --
    --   native.setProperty( "applicationIconBadgeNumber", 0 ) -- iOS badges (+n on icon)
    --end
    --
    --Runtime:addEventListener( "notification", notificationListener )


    ------------------------------------------------------------------------------

    -- create a function to handle all of the system events
    local onSystem = function( event )
        if event.type == "applicationSuspend" then

        elseif event.type == "applicationStart" then
            native.setProperty( "applicationIconBadgeNumber", 0 ) -- iOS badges (+n on icon)
            twitter.reconnect()

        elseif event.type == "applicationResume" then

            print("----->  ON RESUME", vungle.vungleON, facebook.facebookON, twitter.twitterON, router.view)
            if( not vungle.vungleON
            and not facebook.facebookON
            and not twitter.twitterON
            and not (router.view == router.NO_INTERNET)
            and not (router.view == router.LOADING)
            and not (router.view == router.OUTSIDE)
            and not (router.view == router.LOGIN)
            and not (router.view == router.SIGNIN)
            and not (router.view == router.SIGNINFB)
            ) then
                print("RESET PLAYER")
                native.setProperty( "applicationIconBadgeNumber", 0 ) -- iOS badges (+n on icon)
                gameManager:open()
                twitter.reconnect()
            end
        end
    end

    -- setup a system event listener
    Runtime:addEventListener( "system", onSystem )


    ------------------------------------------------------------------------------
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
                        storyboard.gotoScene( lastScene, { effect="crossFade", time=500 } )
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

    ---------------------------------------------------------------------------------

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

    if(PROD) then
        print("retrieving settings...("..MOBILE_SETTINGS_URL .. APP_VERSION..")")
        utils.get(MOBILE_SETTINGS_URL .. APP_VERSION, function(res)
            local settings = json.decode(res.response)
            utils.tprint(settings)

            API_URL  = settings.api.play
            WEB_URL  = settings.api.play
            NODE_URL = settings.api.node

            appManager.onSettingsReady()

        end)
    else
        -- DEV : local servers ONLY
        print("DEV settings : local servers")

        API_URL  = "http://" .. LOCAL_IP .. ":9000/"
        WEB_URL  = "http://" .. LOCAL_IP .. ":9000/"
        NODE_URL = "http://" .. LOCAL_IP .. ":1337"

        appManager.onSettingsReady()

    end
end

--------------------------------------------------------------------------------

function AppManager:onSettingsReady()

    if(PROD) then
        print("     -------->  PROD")
    else
        print("     -------->  DEV")
        LANG = "fr"
        COUNTRY = "FR"
    end

    print("     api:      " .. API_URL)
    print("     node:     " .. NODE_URL)
    print("     webviews: " .. WEB_URL)
    print("     fb-app:   " .. FACEBOOK_APP_NAMESPACE)
    print("     lang:     " .. LANG)
    print("     country:  " .. COUNTRY)

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

return AppManager
