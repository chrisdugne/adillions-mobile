-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

APP_NAME 			= "Adillions"
APP_VERSION 		= "1.0"

-----------------------------------------------------------------------------------------

DEV					= 1
PROD					= 1

-----------------------------------------------------------------------------------------

AUTH_TOKEN			= ""
FACEBOOK_PAGE_ID 	= "379432705492888"

if(PROD) then
	print("prod")
   FACEBOOK_APP_ID 			= "170148346520274"
   FACEBOOK_API_SECRET 		= "887e8f7abb9b1cb9238a097e06585ae2"
   SERVER_URL 					= "http://adillions.herokuapp.com/"
else
	print("dev")
	FACEBOOK_APP_ID 			= "534196239997712"
	FACEBOOK_API_SECRET 		= "46383d827867d50ef5d87b66c81f1a8e"
	SERVER_URL 					= "http://192.168.0.9:9000/"
end

-----------------------------------------------------------------------------------------

FACEBOOK_APP_NAMESPACE 	= "adillions"
SERVER_OG_URL 				= "http://adillions.herokuapp.com/"

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
   FONT = "Helvetica_Light-Normal"
else
	FONT = "Helvetica_Light-Normal"
end

-----------------------------------------------------------------------------------------
--- Corona's libraries
json 					= require "json"
storyboard 			= require "storyboard"

---- Additional libs
xml 					= require "src.libs.Xml"
utils 				= require "src.libs.Utils"
facebook 			= require "src.libs.Facebook" 

---- Game libs

-----------------------------------------------------------------------------------------

aspectRatio = display.pixelHeight / display.pixelWidth

-----------------------------------------------------------------------------------------

abs 		= math.abs
random 	= math.random

-----------------------------------------------------------------------------------------
-- Translations

local translations = require("assets.Translations")
local LANG =  userDefinedLanguage or system.getPreference("ui", "language")

function T(enText)
	return translations[enText][LANG] or enText
end

-----------------------------------------------------------------------------------------
---- Server access Managers

---- App Tools
router 			= require "src.tools.Router"
viewManager		= require "src.tools.ViewManager"

UserManager		= require "src.managers.UserManager"
LotteryManager	= require "src.managers.LotteryManager"

-----------------------------------------------------------------------------------------

userManager 		= UserManager:new()
lotteryManager 	= LotteryManager:new()

-----------------------------------------------------------------------------------------

hud = display.newGroup()

-----------------------------------------------------------------------------------------
---- App globals

GLOBALS = {
	savedData 		= utils.loadUserData("savedData.json"),
}


-----------------------------------------------------------------------------------------

if(not GLOBALS.savedData) then
	utils.initGameData()
   router.openOutside()
else
	native.setActivityIndicator( true )
	
	if(GLOBALS.savedData.user.facebookId) then
   	facebook.getMe(function()
   		native.setActivityIndicator( false )
         router.openOutside()
   	end)
	
	elseif(GLOBALS.savedData.user.uid) then
		userManager:fetchPlayer()
   
   else
   	native.setActivityIndicator( false )
      router.openOutside()
	end
		
end

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