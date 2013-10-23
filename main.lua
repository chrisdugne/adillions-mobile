-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

APP_NAME 			= "Adillions"
APP_VERSION 		= "1.9.3"

-----------------------------------------------------------------------------------------

DEV					= 1
PROD					= 1

-----------------------------------------------------------------------------------------

FACEBOOK_PAGE_ID 	= "379432705492888"

-----------------------------------------------------------------------------------------

if(PROD) then
	print("prod")
   FACEBOOK_APP_ID 			= "170148346520274"
   FACEBOOK_API_SECRET 		= "887e8f7abb9b1cb9238a097e06585ae2"
   SERVER_URL 					= "http://www.adillions.com/"
else
	print("dev")
	FACEBOOK_APP_ID 			= "534196239997712"
	FACEBOOK_API_SECRET 		= "46383d827867d50ef5d87b66c81f1a8e"
	SERVER_URL 					= "http://192.168.0.9:9000/"
end

if(DEV) then
	print(SERVER_URL)
end

-----------------------------------------------------------------------------------------

FACEBOOK_APP_NAMESPACE 	= "adillions"
SERVER_OG_URL 				= "http://www.adillions.com/"

-----------------------------------------------------------------------------------------

IOS 					= system.getInfo( "platformName" )  == "iPhone OS"
ANDROID 				= system.getInfo( "platformName" )  == "Android"
SIMULATOR 			= system.getInfo( "environment" )  	== "simulator"

-----------------------------------------------------------------------------------------

HEADER_HEIGHT		= display.contentHeight * 0.125
MENU_HEIGHT			= 170
TICKET_HEIGHT		= 100

-----------------------------------------------------------------------------------------

POINTS_TO_EARN_A_TICKET		= 8
NB_POINTS_PER_TICKET			= 1
START_AVAILABLE_TICKETS		= 10

FACEBOOK_FAN_TICKETS			= 4
TWITTER_FAN_TICKETS			= 4

-----------------------------------------------------------------------------------------

if ANDROID then
   FONT = "GillSans"
else
	FONT = "GillSans"
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

---- Game libs

-----------------------------------------------------------------------------------------

aspectRatio = display.pixelHeight / display.pixelWidth

-----------------------------------------------------------------------------------------

abs 		= math.abs
random 	= math.random

-----------------------------------------------------------------------------------------
-- Translations

translations = require("assets.Translations")
LANG =  userDefinedLanguage or system.getPreference("ui", "language")

function T(enText)
	return translations[enText][LANG] or enText
end

-----------------------------------------------------------------------------------------
---- App Tools
router 			= require "src.tools.Router"
viewManager		= require "src.tools.ViewManager"

UserManager		= require "src.managers.UserManager"
LotteryManager	= require "src.managers.LotteryManager"

-----------------------------------------------------------------------------------------
---- Server access Managers

userManager 		= UserManager:new()
lotteryManager 	= LotteryManager:new()

-----------------------------------------------------------------------------------------
--- Display

hud = display.newGroup()
viewManager.initGlobalBack()

-----------------------------------------------------------------------------------------
--- Vungle

vungle:init()

-----------------------------------------------------------------------------------------
---- App globals

GLOBALS = {
	savedData 		= utils.loadUserData("savedData.json"),
	options 			= utils.loadUserData("options.json"),
}

-----------------------------------------------------------------------------------------

if(not GLOBALS.savedData) then
	utils.initGameData()
	utils.initOptions()
   router.openOutside()
else
	native.setActivityIndicator( true )
	
	if(GLOBALS.savedData.user.facebookId) then
   	facebook.getMe(function()
   		native.setActivityIndicator( false )
			print("start : getMe : fail : outside")		 
         router.openOutside()
   	end)
	
	elseif(GLOBALS.savedData.user.uid) then
		userManager:fetchPlayer()
   
   else
   	native.setActivityIndicator( false )
		print("start : no user data : outside")		 
      router.openOutside()
	end

end

-----------------------------------------------------------------------------------------
--- NOTIFICATIONS

local function notificationListener( event )

   print("------------------ notificationListener")
	utils.tprint(event)
	if ( event.type == "remote" ) then
		native.showPopup("Notification", "remote", { "Ok" })

	elseif ( event.type == "local" ) then
		native.showPopup("Notification", "local", { "Ok" })

	elseif ( event.type == "remoteRegistration" ) then 
		native.showPopup("Notification", "remoteRegistration", { "Ok" })

	end
   
   native.setProperty( "applicationIconBadgeNumber", 0 ) -- iOS badges (+n on icon)
end

Runtime:addEventListener( "notification", notificationListener )

-----------------------------------------------------------------------------------------

-- create a function to handle all of the system events
local onSystem = function( event )
    if event.type == "applicationSuspend" then
    
    elseif event.type == "applicationStart" or event.type == "applicationResume" then
      native.setProperty( "applicationIconBadgeNumber", 0 ) -- iOS badges (+n on icon)
    
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
--      	native.setKeyboardFocus( nil )
-- 		nothing
      end
   end

   return true  --SEE NOTE BELOW
end

--add the key callback
Runtime:addEventListener( "key", onKeyEvent )