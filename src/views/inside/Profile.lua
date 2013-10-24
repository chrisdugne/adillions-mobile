-----------------------------------------------------------------------------------------
--
-- AppHome.lua
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

-----------------------------------------------------------------------------------------

function scene:drawTextEntry(title, value, position, fontSize)

	viewManager.newText({
		parent 			= hud.board, 
		text 				= title,         
		x 					= self.column1,
		y 					= self.top + self.yGap*position,
		fontSize 		= fontSize or self.fontSize,
		referencePoint = display.CenterLeftReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= value,     
		x 					= self.column2,
		y 					= self.top + self.yGap*position,
		fontSize 		= fontSize or self.fontSize,
		font				= NUM_FONT,
		referencePoint = display.CenterRightReferencePoint
	})
	
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()

	viewManager.initBoard()

	------------------

	self.top 		= HEADER_HEIGHT + 70
	self.yGap 		= 60
	self.fontSize 	= 35

	self.column1 = display.contentWidth*0.1
	self.column2 = display.contentWidth*0.9 
	
	---------------------------------------------------------------
	-- Personal Details
	---------------------------------------------------------------
	
	local detailsTop 			= 0
	local detailsHeight 		= 3
	
	hud.board.logout = display.newImage( hud.board, "assets/images/hud/logout.png")  
	hud.board.logout:scale(0.23,0.23)
	hud.board.logout.x = display.contentWidth*0.93
	hud.board.logout.y = self.yGap * (detailsTop+1)
	hud.board:insert( hud.board.logout )	

	utils.onTouch(hud.board.logout, function()
		userManager:logout()
	end)	

	------------------

	self:drawTextEntry("_userName : ", userManager.user.userName, detailsTop+1)

	------------------
	
	self:drawTextEntry("_firstName : ", userManager.user.firstName, detailsTop+2)
	self:drawTextEntry("_lastName : ", userManager.user.lastName, detailsTop+3)
	self:drawTextEntry("_birthDate : ", utils.readableDate(utils.userManager.user.birthDate), detailsTop+4)
	self:drawTextEntry("_email : ", userManager.user.email, detailsTop+5)

	---------------------------------------------------------------
	-- Status
	---------------------------------------------------------------

	local statusTop 			= 7
	local statusHeight 		= 3

	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= "_totalPoints : ",         
		x 					= self.column1,
		y 					= self.top + self.yGap*statusTop,
		fontSize 		= self.fontSize,
		referencePoint = display.CenterLeftReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= userManager.user.totalPoints .. " pts",     
		x 					= self.column1,
		y 					= self.top + self.yGap*(statusTop+1),
		fontSize 		= self.fontSize,
		font				= NUM_FONT,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= "_currentPoints : ",         
		x 					= self.column2,
		y 					= self.top + self.yGap*statusTop,
		fontSize 		= self.fontSize,
		referencePoint = display.CenterRightReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= userManager.user.currentPoints .. " pts",     
		x 					= self.column2,
		y 					= self.top + self.yGap*(statusTop+1),
		fontSize 		= self.fontSize,
		font				= NUM_FONT,
		referencePoint = display.CenterRightReferencePoint
	})
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= "_bonus Tickets : ",         
		x 					= self.column2,
		y 					= self.top + self.yGap*(statusTop+2),
		fontSize 		= self.fontSize,
		referencePoint = display.CenterRightReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= "+ " .. userManager.user.totalBonusTickets,     
		x 					= self.column2,
		y 					= self.top + self.yGap*(statusTop+3),
		fontSize 		= self.fontSize,
		font				= NUM_FONT,
		referencePoint = display.CenterRightReferencePoint
	})

	--------------------------

	viewManager.newText({
		parent 			= hud.board, 
		text 				= "_charity time : ",         
		x 					= self.column1,
		y 					= self.top + self.yGap*(statusTop+2),
		fontSize 		= self.fontSize,
		referencePoint = display.CenterLeftReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= userManager.user.totalPoints .. " min sec",     
		x 					= self.column1,
		y 					= self.top + self.yGap*(statusTop+3),
		fontSize 		= self.fontSize,
		font				= NUM_FONT,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	---------------------------------------------------------------
	-- FACEBOOK
	---------------------------------------------------------------
	
	local facebookTop 		= 12.5
	local facebookHeight		= 2.5
	
	viewManager.drawBorder(hud.board, display.contentWidth*0.5, self.top + self.yGap*facebookTop, display.contentWidth*0.9, self.yGap * facebookHeight)
	
	
	if(userManager.user.facebookId) then
	   	
   	self:drawTextEntry("_Facebook : ", self:isFBConnection(), facebookTop-0.5 )
   	if(userManager.user.facebookFan) then
      	self:drawTextEntry("_FB fan : ", "_Yes!", facebookTop+0.5 )
      else
      	self:drawTextEntry("_Like us now and get " .. FACEBOOK_FAN_TICKETS .. " more tickets each lottery !", "", facebookTop+0.5 , 27 )
      end
   else
		hud.fbConnect = display.newImage(hud.board, "assets/images/icons/facebook.png", display.contentWidth*0.7, self.top + self.yGap*(facebookTop-0.5))
		hud.board:insert(hud.fbConnect)
		
		utils.onTouch(hud.fbConnect, function() 
			facebook.connect(function()
				router.resetScreen()
				self:refreshScene()
			end) 
		end)
	end
	
	hud.fbIcon = display.newImage(hud.board, "assets/images/icons/facebook.png", display.contentWidth*0.011, self.top + self.yGap*(facebookTop-1.6))
	hud.board:insert(hud.fbIcon)

	if(userManager.user.facebookId) then
   	display.loadRemoteImage( facebook.data.picture.data.url, "GET", function(event)
   		local picture = event.target	
   		hud.board:insert(picture)
   		picture.x = display.contentWidth*0.9
   		picture.y = self.top + self.yGap*(facebookTop-0.7)
   	end, 
   	"profilePicture", system.TemporaryDirectory)
	end

	---------------------------------------------------------------
	-- TWITTER
	---------------------------------------------------------------
	
	local twitterTop 		= 15.5
	local twitterHeight	= 2.5
	
	viewManager.drawBorder(hud.board, display.contentWidth*0.5, self.top + self.yGap*twitterTop, display.contentWidth*0.9, self.yGap * twitterHeight)

	hud.twitterIcon = display.newImage(hud.board, "assets/images/icons/facebook.png", display.contentWidth*0.011, self.top + self.yGap*(twitterTop-1.6))
	hud.board:insert(hud.twitterIcon)
	
	utils.tprint(userManager.user)
	
	if(userManager.user.twitterId) then
   	self:drawTextEntry("_Twitter : ", self:isTwitterConnection(), twitterTop-0.5 )
   else
		hud.twitterConnect = display.newImage(hud.board, "assets/images/icons/facebook.png", display.contentWidth*0.7, self.top + self.yGap*(twitterTop-0.5))
		hud.board:insert(hud.twitterConnect)
		
		utils.onTouch(hud.twitterConnect, function() 
			twitter.connect(function()
   			print("refresh profile")
				router.resetScreen()
				self:refreshScene()
			end) 
		end)
	end

	---------------------------------------------------------------------------------
	-- REFERRER
	---------------------------------------------------------------
	
	local referringTop 		= 18
	local referringHeight	= 1.5
	
	viewManager.drawBorder(hud.board, display.contentWidth*0.5, self.top + self.yGap*referringTop, display.contentWidth*0.9, self.yGap * referringHeight)
	self:drawTextEntry("_my referrerId : ", userManager.user.uid, referringTop )
	
	hud.shareIcon = display.newImage(hud.board, "assets/images/icons/friends.png")
	hud.shareIcon.x = display.contentWidth*0.89
	hud.shareIcon.y =  self.top + self.yGap*referringTop
	hud.board:insert(hud.shareIcon)
		
	utils.onTouch(hud.shareIcon, function()
		local title = "_Be an Adillions' Ambassador !"
		local text	= "_Earn free additional tickets by referring people to Adillions"
		viewManager.showPopup(title, text)

		viewManager.drawButton(hud.popup, "SMS", display.contentWidth*0.5, display.contentHeight*0.4, function()
			local options =
			{
				body = "_Join me on www.adillions.com !\n Please use my referrer code when you sign in : " .. userManager.user.uid
			}
			native.showPopup("sms", options)
		end)

		viewManager.drawButton(hud.popup, "email", display.contentWidth*0.5, display.contentHeight*0.5, function()
			local options =
			{
				body = "<html><body>_Join me on <a href='http://www.adillions.com'>Adillions</a> !<br/> Please use my referrer code when you sign in : " .. userManager.user.uid .. "</body></html>",
   			isBodyHtml = true,
   			subject = "Adillions",
			}
			native.showPopup("mail", options)
		end)

		if(userManager.user.facebookId) then
   		viewManager.drawButton(hud.popup, "Facebook", display.contentWidth*0.5, display.contentHeight*0.6, function()
   			facebook.postOnWall("_Join me on www.adillions.com !\n Please use my referrer code when you sign in : " .. userManager.user.uid, function()
	   			viewManager.showPopup("_Thank you !", "_Successfully posted on your wall")
   			end)
   		end)
   	else
   		viewManager.drawButton(hud.popup, "_Connect with Facebook", display.contentWidth*0.5, display.contentHeight*0.6, function()
      		facebook.connect(function()
   				router.resetScreen()
   				self:refreshScene()
   			end) 
   		end,
   		display.contentWidth*0.6)
   	end



		if(userManager.user.twitterId) then
   		viewManager.drawButton(hud.popup, "Twitter", display.contentWidth*0.5, display.contentHeight*0.7, function()
   			twitter.tweetMessage("_Join me on www.adillions.com !\n Please use my referrer code when you sign in : " .. userManager.user.uid, function()
					viewManager.showPopup("_Thank you !", "_Successfully tweeted")
				end)
			end)
		else
			viewManager.drawButton(hud.popup, "_Connect with Twitter", display.contentWidth*0.5, display.contentHeight*0.7, function()
				twitter.connect(function()
      			print("refresh profile")
   				router.resetScreen()
   				self:refreshScene()
   			end)
			end,
			display.contentWidth*0.6)
		end
	end)

	---------------------------------------------------------------------------------
	-- Options
	---------------------------------------------------------------

	local optionsTop 		= 21
	local optionsHeight	= 2.5

	local function beforeDrawSwitchListener( event )
		GLOBALS.options.notificationBeforeDraw = event.target.isOn
		utils.saveTable(GLOBALS.options, "options.json")
		
		utils.tprint(GLOBALS.options)
		
   	lotteryManager:refreshNotifications(lotteryManager.nextLottery.date)
	end
	
	local function afterDrawSwitchListener( event )
		GLOBALS.options.notificationAfterDraw = event.target.isOn
		utils.saveTable(GLOBALS.options, "options.json")

		utils.tprint(GLOBALS.options)
	
   	lotteryManager:refreshNotifications(lotteryManager.nextLottery.date)	
	end

	---------------------------------------------------------------
	
	viewManager.drawBorder(hud.board, display.contentWidth*0.5, self.top + self.yGap*optionsTop, display.contentWidth*0.9, self.yGap * optionsHeight)
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Notification 48h before the next draw",         
		x 					= self.column1,
		y 					= self.top + self.yGap*(optionsTop-0.5),
		fontSize 		= self.fontSize,
		referencePoint = display.CenterLeftReferencePoint
	})

	local beforeDrawSwitch = widget.newSwitch
	{
		left 							= display.contentWidth*0.8,
		top 							= self.top + self.yGap*(optionsTop-0.7),
		initialSwitchState	 	= GLOBALS.options.notificationBeforeDraw,
		onPress 						= beforeDrawSwitchListener,
		onRelease 					= beforeDrawSwitchListener,
	}

	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Notification for the results",         
		x 					= self.column1,
		y 					= self.top + self.yGap*(optionsTop+0.5),
		fontSize 		= self.fontSize,
		referencePoint = display.CenterLeftReferencePoint
	})


	local afterDrawSwitch = widget.newSwitch
	{
		left 							= display.contentWidth*0.8,
		top 							= self.top + self.yGap*(optionsTop+0.3),
		initialSwitchState	 	= GLOBALS.options.notificationAfterDraw,
		onPress 						= afterDrawSwitchListener,
		onRelease 					= afterDrawSwitchListener,
	}
	
	-----------------------------------------------

	hud.board:insert( beforeDrawSwitch )	
	hud.board:insert( afterDrawSwitch )	

	------------------

	hud:insert(hud.board)

	------------------
	--

	--   local likeButtonUrl = "http://www.facebook.com/plugins/like.php?href=https%3A%2F%2Fwww.facebook.com%2Fpages%2FAdillions%2F379432705492888&layout=button_count&action=like&send=false&appId=170148346520274"
	--	hud.likePageWebview = native.newWebView( 0, display.contentHeight - MENU_HEIGHT - display.contentHeight*0.05, display.contentWidth, display.contentHeight*0.05 )
	--	hud.likePageWebview:request( likeButtonUrl )
	--	hud.likePageWebview:addEventListener( "urlRequest", function(event) self:loginViewListener(event) end )

	------------------

	viewManager.setupView(4)
	self.view:insert(hud)
end

------------------------------------------

function scene:isFBConnection( event )
	local text = "_No"
	if(userManager.user.facebookId) then
		text = "_Yes !"
	end
	
	return text
end

------------------------------------------

function scene:isTwitterConnection( event )
	local text = "_No"
	if(userManager.user.twitterId) then
		text = "_Yes !"
	end
	
	return text
end

------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	self:refreshScene()
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene