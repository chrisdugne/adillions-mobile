-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

APP_NAME 			= "Adillions"
APP_VERSION 		= "1.0"

-----------------------------------------------------------------------------------------

SERVER_URL 			= "http://192.168.0.7:9000/"
AUTH_TOKEN			= ""

-----------------------------------------------------------------------------------------

IOS 					= system.getInfo( "platformName" )  == "iPhone OS"
ANDROID 				= system.getInfo( "platformName" )  == "Android"
SIMULATOR 			= system.getInfo( "environment" )  	== "simulator"

-----------------------------------------------------------------------------------------

DEV					= 1

-----------------------------------------------------------------------------------------

HEADER_HEIGHT		= 120
MENU_HEIGHT			= 170

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
LotteryManager		= require "src.managers.LotteryManager"

-----------------------------------------------------------------------------------------

userManager = UserManager:new()
lotteryManager = LotteryManager:new()

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
	facebook.getMe(function()
   	if(GLOBALS.savedData.user.uid) then
   		userManager:fetchPlayer()
   	else
         router.openOutside()
   	end
	end)
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