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

function GameManager:start()
   router.openTutorial()
end

function GameManager:start3()

   router.openTutorial()
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
	utils.initGameData()
	utils.initOptions()
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