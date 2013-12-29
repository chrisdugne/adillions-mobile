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

	GLOBALS.savedData.facebookAccessToken 	= nil
	GLOBALS.savedData.twitterAccessToken 	= nil
	
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
	self:initGameData()
	self:initOptions()
	
	self:openFirstTerms()
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

function GameManager:openFirstTerms()
	
	local top	 	= display.contentHeight * 0.35
	local yGap		= display.contentHeight*0.082

	viewManager.showPopup(function() end)

	--------------------------
	
	hud.picto 			= display.newImage(hud.popup, "assets/images/icons/PictoInfo.png")
	hud.picto.x 		= display.contentWidth*0.14
	hud.picto.y 		= display.contentHeight*0.1

	hud.title 			= display.newImage(hud.popup, I "important.png")
	hud.title:setReferencePoint(display.CenterLeftReferencePoint);
	hud.title.x 		= display.contentWidth*0.22
	hud.title.y 		= display.contentHeight*0.1

	hud.sep 			= display.newImage(hud.popup, "assets/images/icons/separateur.horizontal.png")
	hud.sep.x 		= display.contentWidth*0.5
	hud.sep.y 		= display.contentHeight*0.15

	--------------------------

	hud.text = display.newText(
		hud.popup, 
		T "Adillions - a simplified joint-stock company (S.A.S.), registered at the Paris RCS (France) under No. 797 736 261, organizes free games without any purchase obligation, for an indefinite period.", 
		0, 0, display.contentWidth*0.8, display.contentHeight*0.25, FONT, 35 )
		
	hud.text.x = display.contentWidth*0.5
	hud.text.y = display.contentHeight*0.34
	hud.text:setTextColor(0)

	local company = "Apple Inc. "
	if(ANDROID) then company = "Google Inc " end

	hud.text2 = display.newText(
		hud.popup, 
		company .. T "is not organizer, co-organizer or partner of Adillions. This company is not involved in any way in the organization of the Adillions lottery and does not sponsor it.", 
		0, 0, display.contentWidth*0.8, display.contentHeight*0.25, FONT, 35 )
		
	hud.text2.x = display.contentWidth*0.5
	hud.text2.y = display.contentHeight*0.62
	hud.text2:setTextColor(0)
	
	--------------------------

	hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
	hud.popup.close.x 			= display.contentWidth*0.5
	hud.popup.close.y 			= display.contentHeight*0.9

	utils.onTouch(hud.popup.close, function() 
		viewManager.closePopup() 
   	router.openTutorial()
   end)
end

-----------------------------------------------------------------------------------------

return GameManager