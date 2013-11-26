-----------------------------------------------------------------------------------------

GameManager = {}	

-----------------------------------------------------------------------------------------

function GameManager:new()  

	local object = {
	}

	setmetatable(object, { __index = GameManager })
	return object
end

-----------------------------------------------------------------------------------------

function GameManager:initGameData()

	GLOBALS.savedData = {
		requireTutorial 	= true,
		user 					= {}
	}

	utils.saveTable(GLOBALS.savedData, "savedData.json")
end


function GameManager:initOptions()

	GLOBALS.options = {
		notificationBeforeDraw 	= true,
		notificationAfterDraw 	= true,
	}

	utils.saveTable(GLOBALS.options, "options.json")
end

-----------------------------------------------------------------------------------------

function GameManager:start()

	analytics.init(ANALYTICS_VERSION, ANALYTICS_TRACKING_ID, ANALYTICS_PROFILE_ID, APP_NAME, APP_VERSION)
	viewManager.initGlobalBack()
	vungle:init()

	if(not GLOBALS.savedData) then
		self:firstStart()
	else
		if(GLOBALS.savedData.user.facebookId) then
			self:tryAutoOpenFacebookAccount()
		else
      	
			self:tryAutoOpenAdillionsAccount()
		end

	end
end

-----------------------------------------------------------------------------------------

function GameManager:firstStart()
	self.initGameData()
	self.initOptions()
   router.openTutorial()
end

function GameManager:tryAutoOpenFacebookAccount()
	native.setActivityIndicator( true )
	facebook.getMe(function()
   	native.setActivityIndicator( false )
		print("start : getMe : fail : try adillions account")		 
		self:tryAutoOpenAdillionsAccount()
	end)
end

function GameManager:tryAutoOpenAdillionsAccount()
	
	GLOBALS.savedData.facebookAccessToken 	= nil
	GLOBALS.savedData.twitterAccessToken 	= nil
	utils.saveTable(GLOBALS.savedData, "savedData.json")
	
	if(GLOBALS.savedData.user.uid) then
   	native.setActivityIndicator( true )
		userManager:fetchPlayer()
   
   else
		print("start : no user data : outside")		 
      router.openOutside()
   end
end


-----------------------------------------------------------------------------------------

return GameManager