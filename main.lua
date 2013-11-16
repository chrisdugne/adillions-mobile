-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

APP_NAME 			= "Adillions"
APP_VERSION 		= "1.17.1"

-----------------------------------------------------------------------------------------

--DEV					= 1
PROD					= 1

-----------------------------------------------------------------------------------------

FACEBOOK_PAGE_ID 	= "379432705492888"
TWITTER_ID 			= "1922939570"

-----------------------------------------------------------------------------------------

ANALYTICS_VERSION 		= 1
ANALYTICS_TRACKING_ID 	= "UA-45586817-2"
ANALYTICS_PROFILE_ID 	= "78871292"

-----------------------------------------------------------------------------------------

if(PROD) then
	print("prod")
   FACEBOOK_APP_ID 			= "170148346520274"
   FACEBOOK_API_SECRET 		= "887e8f7abb9b1cb9238a097e06585ae2"
   FACEBOOK_APP_NAMESPACE 	= "adillions"
   SERVER_URL 					= "http://www.watchtocash.com/"
   SERVER_OG_URL 				= "http://www.watchtocash.com/"
--   SERVER_URL 					= "http://www.adillions.com/"
--   SERVER_OG_URL 				= "http://www.adillions.com/"
else
	print("dev")
	FACEBOOK_APP_ID 			= "534196239997712"
	FACEBOOK_API_SECRET 		= "46383d827867d50ef5d87b66c81f1a8e"
   FACEBOOK_APP_NAMESPACE 	= "adillions-dev"
	SERVER_URL 					= "http://192.168.0.9:9000/"
   SERVER_OG_URL 				= "http://192.168.0.9:9000/"
end

if(DEV) then
	print(SERVER_URL)
end

-----------------------------------------------------------------------------------------

IOS 					= system.getInfo( "platformName" )  == "iPhone OS"
ANDROID 				= system.getInfo( "platformName" )  == "Android"
SIMULATOR 			= system.getInfo( "environment" )  	== "simulator"

-----------------------------------------------------------------------------------------

HEADER_HEIGHT		= display.contentHeight * 0.095
MENU_HEIGHT			= 124
TICKET_HEIGHT		= 100

-----------------------------------------------------------------------------------------

START_AVAILABLE_TICKETS			= 10
POINTS_TO_EARN_A_TICKET			= 8
NB_POINTS_PER_TICKET				= 1
NB_POINTS_PER_TWEET				= 2
NB_POINTS_PER_POST				= 2
NB_POINTS_PER_LIKE				= 2
NB_POINTS_PER_THEME_LIKED		= 2

FACEBOOK_FAN_TICKETS				= 2
TWITTER_FAN_TICKETS				= 2
FACEBOOK_CONNECTION_TICKETS	= 2
TWITTER_CONNECTION_TICKETS		= 2

-----------------------------------------------------------------------------------------
--- lottery tickets status

BLOCKED 	= 1;
PENDING 	= 2;
PAYED 	= 3;
GIFT 		= 4;

-----------------------------------------------------------------------------------------

translations = require("assets.Translations")

if ANDROID then
   FONT 		= "GillSans"
   NUM_FONT = "HelveticaBold"
else
	FONT 		= "Gill Sans"
   NUM_FONT = "Helvetica-Bold"
end

if(ANDROID) then
	LANG =  userDefinedLanguage or system.getPreference("locale", "language")
else
	LANG =  userDefinedLanguage or system.getPreference("ui", "language")
end

COUNTRY = system.getPreference( "locale", "country" ) or "US"
	
if(DEV) then
	LANG = "fr"
	COUNTRY = "FR"
end

-----------------------------------------------------------------------------------------
--- Corona's libraries
json 					= require "json"
storyboard 			= require "storyboard"
widget		 		= require "widget"
coronaFacebook		= require "facebook"
sponsorpay 			= require "plugin.sponsorpay"
ads 					= require "ads"

---- Additional libs
xml 					= require "src.libs.Xml"
utils 				= require "src.libs.Utils"
facebook 			= require "src.libs.Facebook" 
vungle 				= require "src.libs.Vungle" 
sponsorpayTools 	= require "src.libs.SponsorpayTools" 
twitter 				= require "src.libs.Twitter" 
analytics 			= require "src.libs.google.Analytics"

-----------------------------------------------------------------------------------------

aspectRatio = display.pixelHeight / display.pixelWidth

-----------------------------------------------------------------------------------------

abs 		= math.abs
random 	= math.random

-----------------------------------------------------------------------------------------
-- Translations

function T(enText)
	return translations[enText][LANG] or enText
end

function I(asset)
	return "assets/images/bylang/"..LANG.."/"..asset
end

-----------------------------------------------------------------------------------------
---- App Tools
router 			= require "src.tools.Router"
viewManager		= require "src.tools.ViewManager"

GameManager		= require "src.managers.GameManager"
UserManager		= require "src.managers.UserManager"
LotteryManager	= require "src.managers.LotteryManager"
VideoManager	= require "src.managers.VideoManager"
ShareManager	= require "src.managers.ShareManager"

-----------------------------------------------------------------------------------------
---- Server access Managers

gameManager 		= GameManager:new()
userManager 		= UserManager:new()
lotteryManager 	= LotteryManager:new()
videoManager 		= VideoManager:new()
shareManager 		= ShareManager:new()

-----------------------------------------------------------------------------------------
--- Display Container

hud = display.newGroup()

-----------------------------------------------------------------------------------------
---- App globals

GLOBALS = {
	savedData 		= utils.loadUserData("savedData.json"),
	options 			= utils.loadUserData("options.json"),
}

-----------------------------------------------------------------------------------------

gameManager:start()

-----------------------------------------------------------------------------------------
--- NOTIFICATIONS
--- pas d'ecoute des notifs In-APP : pas besoin.
--local function notificationListener( event )
--
--   print("------------------ notificationListener")
--	utils.tprint(event)
--	if ( event.type == "remote" ) then
--		native.showPopup("Notification", "remote", { "Ok" })
--
--	elseif ( event.type == "local" ) then
--		native.showPopup("Notification", "local", { "Ok" })
--
--	elseif ( event.type == "remoteRegistration" ) then 
--		native.showPopup("Notification", "remoteRegistration", { "Ok" })
--
--	end
--   
--   native.setProperty( "applicationIconBadgeNumber", 0 ) -- iOS badges (+n on icon)
--end
--
--Runtime:addEventListener( "notification", notificationListener )

-----------------------------------------------------------------------------------------

-- create a function to handle all of the system events
local onSystem = function( event )
    if event.type == "applicationSuspend" then
    
    elseif event.type == "applicationStart" or event.type == "applicationResume" then
      native.setProperty( "applicationIconBadgeNumber", 0 ) -- iOS badges (+n on icon)
--      
--      facebook.isFacebookFan(function() 
--      end)
      
   	twitter.reconnect()
    
    end
end

-- setup a system event listener
Runtime:addEventListener( "system", onSystem )

-----------------------------------------------------------------------------------------
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