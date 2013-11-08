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

function scene:refreshScene()
	self:drawScene() 
end

-----------------------------------------------------------------------------------------

function scene:drawScene()

	viewManager.initBoard()

	------------------

	local statusTop 			= 0
	local detailsTop 			= 7.5
	local socialTop 			= 15
	local sponsorTop 			= 28
	local logoutTop 			= 39
		
	------------------

	self.top 				= HEADER_HEIGHT + 70
	self.yGap 				= 60
	self.fontSizeLeft 	= 27
	self.fontSizeRight 	= 29

	self.column1 = display.contentWidth*0.1
	self.column2 = display.contentWidth*0.9 
	
	---------------------------------------------------------------
	-- Personal Details
	---------------------------------------------------------------
	
	hud.lineDetails 			= display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
	hud.lineDetails.x 		= display.contentWidth*0.5
	hud.lineDetails.y 		= self.top + self.yGap*detailsTop
	hud.board:insert(hud.lineDetails)

	hud.titleDetails 			= display.newImage( hud.board, I "details.png")  
	hud.titleDetails:setReferencePoint(display.CenterLeftReferencePoint);
	hud.titleDetails.x 		= display.contentWidth*0.05
	hud.titleDetails.y		= self.top + self.yGap*detailsTop
	hud.board:insert(hud.titleDetails)

	------------------

	self:drawTextEntry(T "User name" .. " : ", userManager.user.userName, detailsTop+1.5, 27, 27)

	------------------
	
	self:drawTextEntry(T "First name" 	.. " : ", userManager.user.firstName, detailsTop+2.5)
	self:drawTextEntry(T "Last name" 	.. " : ", userManager.user.lastName, detailsTop+3.5)
	self:drawTextEntry(T "Email" 			.. " : ", userManager.user.email, detailsTop+4.5)
	self:drawTextEntry(T "Birthday" 		.. " : ", utils.readableDate(utils.userManager.user.birthDate), detailsTop+5.5)

	---------------------------------------------------------------
	-- Status
	---------------------------------------------------------------
	
	hud.lineStatus 			= display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
	hud.lineStatus.x 			= display.contentWidth*0.5
	hud.lineStatus.y 			= self.top + self.yGap*statusTop
	hud.board:insert(hud.lineStatus)

	hud.titleStatus 			= display.newImage( hud.board, I "status.png")  
	hud.titleStatus:setReferencePoint(display.CenterLeftReferencePoint);
	hud.titleStatus.x 		= display.contentWidth*0.05
	hud.titleStatus.y			= self.top + self.yGap*statusTop
	hud.board:insert(hud.titleStatus)
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Total points" .. " : ",         
		x 					= self.column1,
		y 					= self.top + self.yGap*(statusTop+1),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterLeftReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= userManager.user.totalPoints .. " Pts",     
		x 					= self.column1,
		y 					= self.top + self.yGap*(statusTop+2),
		fontSize 		= 40,
		font				= NUM_FONT,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Total gains" .. " : ",         
		x 					= self.column2,
		y 					= self.top + self.yGap*(statusTop+1),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterRightReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= "US$ " .. userManager.user.totalGains ,     
		x 					= self.column2 - 50,
		y 					= self.top + self.yGap*(statusTop+2),
		fontSize 		= self.fontSizeRight,
		font				= NUM_FONT,
		fontSize 		= 40,
		referencePoint = display.CenterRightReferencePoint
	})
	
	hud.iconMoney 			= display.newImage( hud.board, "assets/images/icons/money.png")
	hud.iconMoney.x 		= self.column2 
	hud.iconMoney.y 		= self.top + self.yGap*(statusTop+2)
	hud.board:insert(hud.iconMoney)
	
	--------------------------
	
	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Bonus tickets" .. " : ",         
		x 					= self.column2,
		y 					= self.top + self.yGap*(statusTop+3.5),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterRightReferencePoint
	})


	hud.iconTicket 			= display.newImage( hud.board, "assets/images/icons/ticket.png")
	hud.iconTicket.x 			= self.column2 - 30
	hud.iconTicket.y 			= self.top + self.yGap*(statusTop+4.5)
	hud.board:insert(hud.iconTicket)
	
	viewManager.newText({
		parent 			= hud.board, 
		text	 			= "+ " .. userManager.user.totalBonusTickets,     
		x 					= self.column2,
		y 					= self.top + self.yGap*(statusTop+5.5),
		fontSize 		= self.fontSizeRight,
		font				= NUM_FONT,
		fontSize 		= 40,
		referencePoint = display.CenterRightReferencePoint
	})

	--------------------------

	viewManager.newText({
		parent 			= hud.board, 
		text 				= T "Charity" .. " : ",         
		x 					= self.column1,
		y 					= self.top + self.yGap*(statusTop+3.5),
		fontSize 		= self.fontSizeLeft,
		referencePoint = display.CenterLeftReferencePoint
	})


	hud.iconTicket 			= display.newImage( hud.board, "assets/images/icons/charity.png")
	hud.iconTicket.x 			= self.column1 + 30
	hud.iconTicket.y 			= self.top + self.yGap*(statusTop+4.5)
	hud.board:insert(hud.iconTicket)
	
	local charity = {"Starter"}
	
	viewManager.newText({
		parent 			= hud.board, 
		text	 			= T(charity[1]),     
		x 					= self.column1,
		y 					= self.top + self.yGap*(statusTop+5.7),
		fontSize 		= self.fontSizeRight,
		font				= NUM_FONT,
		fontSize 		= 30,
		referencePoint = display.CenterLeftReferencePoint
	})
	
	
	---------------------------------------------------------------
	-- SOCIALS
	---------------------------------------------------------------
	
	hud.lineSocials 				= display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
	hud.lineSocials.x 			= display.contentWidth*0.5
	hud.lineSocials.y 			= self.top + self.yGap*socialTop
	hud.board:insert(hud.lineSocials)

	hud.titleSocials 				= display.newImage( hud.board, I "socials.png")  
	hud.titleSocials:setReferencePoint(display.CenterLeftReferencePoint);
	hud.titleSocials.x 			= display.contentWidth*0.05
	hud.titleSocials.y			= self.top + self.yGap*socialTop
	hud.board:insert(hud.titleSocials)
	
	---------------------------------------------------------------
	-- FACEBOOK
	---------------------------------------------------------------
	
	local facebookLinkedState 		= "off"
	local facebookConnectedState 	= "off"
	local facebookFanState 			= "off"

	local facebookLinkedTitle 		= T "Account not linked"
	local facebookConnectedTitle 	= T "Not connected"
	local facebookFanTitle 			= T "Not fan yet"

   hud.facebookConnect 		= display.newImage( hud.board, I "facebook.connect.button.png")  
   hud.facebookConnect.x 	= display.contentWidth*0.5
   hud.facebookConnect.y	= self.top + self.yGap*(socialTop+2.5)
   hud.board:insert(hud.facebookConnect)
	
	if(userManager.user.facebookId) then
		facebookConnectedTitle 	= T "Connected"
		facebookLinkedTitle 		= T "Account linked"
		facebookConnectedState 	= "on"
		facebookLinkedState 		= "on"
	
   else
   
		utils.onTouch(hud.facebookConnect, function() 
			facebook.connect(function()
				router.resetScreen()
				self:refreshScene()
			end) 
		end)
		
	end
	
	if(userManager.user.facebookFan) then
		facebookFanTitle = T "Thank you for being a fan !"
		facebookFanState = "on"

	else
		if(userManager.user.facebookId) then
         hud.facebookLike 		= display.newImage( hud.board, I "like.button.png")  
         hud.facebookLike.x 	= display.contentWidth*0.3
         hud.facebookLike.y	= self.top + self.yGap*(socialTop+5.2)
         hud.board:insert(hud.facebookLike)

   		utils.onTouch(hud.facebookLike, function()
   			-- todo : listener pour trouver qd revenir ?
   			local url = "https://www.facebook.com/pages/Adillions/379432705492888"
				native.showWebPopup(0, 0, display.contentWidth, display.contentHeight, url) 
   		end)
		end
	end
	
	self:drawConnection(facebookLinkedTitle, 		facebookLinkedState, 			socialTop+4.3)
	self:drawConnection(facebookConnectedTitle, 	facebookConnectedState, 		socialTop+5)
	self:drawConnection(facebookFanTitle, 			facebookFanState, 				socialTop+5.7)

	------------------------------
	-- more to display :

--      	self:drawTextEntry("_Like us now and get " .. FACEBOOK_FAN_TICKETS .. " more tickets each lottery !", "", facebookTop+0.5 , 27 )

--	if(userManager.user.facebookId) then
--   	display.loadRemoteImage( facebook.data.picture.data.url, "GET", function(event)
--   		local picture = event.target	
--   		hud.board:insert(picture)
--   		picture.x = display.contentWidth*0.9
--   		picture.y = self.top + self.yGap*(facebookTop-0.7)
--   	end, 
--   	"profilePicture", system.TemporaryDirectory)
--	end

	---------------------------------------------------------------
	-- TWITTER
	---------------------------------------------------------------
	
	local twitterLinkedState 		= "off"
	local twitterConnectedState 	= "off"
	local twitterFanState 			= "off"

	local twitterLinkedTitle 		= T "Account not linked"
	local twitterConnectedTitle 	= T "Not connected"
	local twitterFanTitle 			= T "Not fan yet"

   hud.twitterConnect 				= display.newImage( hud.board, I "twitter.connect.button.png")  
   hud.twitterConnect.x 			= display.contentWidth*0.5
   hud.twitterConnect.y				= self.top + self.yGap*(socialTop+8)
   hud.board:insert(hud.twitterConnect)
		
	if(twitter.connected) then
		twitterConnectedTitle = T "Connected"
		twitterConnectedState = "on"
		
   else
      
		utils.onTouch(hud.twitterConnect, function() 
			twitter.connect(function()
				router.resetScreen()
				self:refreshScene()
			end) 
		end)
			
	end
	
	if(userManager.user.twitterId) then
		twitterLinkedTitle = T "Account linked"
		twitterLinkedState = "on"
	end

	if(userManager.user.twitterFan) then
		twitterFanTitle = T "Thank you for being a fan !"
		twitterFanState = "on"
	else
		if(twitter.connected) then
         hud.twitterFollow 		= display.newImage( hud.board, I "follow.button.png")  
         hud.twitterFollow.x 	= display.contentWidth*0.35
         hud.twitterFollow.y	= self.top + self.yGap*(socialTop+10.7)
         hud.board:insert(hud.twitterFollow)
         
   		utils.onTouch(hud.twitterFollow, function()
   		
				native.setActivityIndicator( true )	 
   			twitter.follow(function()
					native.setActivityIndicator( false )		
   				userManager.user.twitterFan = true
   				router.resetScreen()
   				self:refreshScene()
   			end) 
   		end)
		end
	end
	

	self:drawConnection(twitterLinkedTitle, 		twitterLinkedState, 			socialTop+9.8)
	self:drawConnection(twitterConnectedTitle, 	twitterConnectedState, 		socialTop+10.5)
	self:drawConnection(twitterFanTitle, 			twitterFanState, 				socialTop+11.2)
	

	---------------------------------------------------------------------------------
	-- REFERRER
	---------------------------------------------------------------
	
	hud.lineSponsor 				= display.newImage( hud.board, "assets/images/icons/separateur.horizontal.png")
	hud.lineSponsor.x 			= display.contentWidth*0.5
	hud.lineSponsor.y 			= self.top + self.yGap*sponsorTop
	hud.board:insert(hud.lineSponsor)

	hud.titleSponsor 				= display.newImage( hud.board, I "sponsor.png")  
	hud.titleSponsor:setReferencePoint(display.CenterLeftReferencePoint);
	hud.titleSponsor.x 			= display.contentWidth*0.05
	hud.titleSponsor.y			= self.top + self.yGap*sponsorTop
	hud.board:insert(hud.titleSponsor)
	
	-----------------------------------------------------------------
	
	viewManager.drawBorder(hud.board, 
		display.contentWidth*0.76, self.top + self.yGap*(sponsorTop+2.4), 
		display.contentWidth*0.4, 120,
		250,250,250
	)
	
	viewManager.newText({
		parent 			= hud.board, 
		text	 			= userManager.user.sponsorCode,     
		x 					= display.contentWidth*0.76,
		y 					= self.top + self.yGap*(sponsorTop+2.4),
		fontSize 		= 45,
		font				= NUM_FONT,
	})
	
	
	hud.sponsorButton 		= display.newImage(hud.board, I "sponsor.button.png")
	hud.sponsorButton.x 		= display.contentWidth*0.3
	hud.sponsorButton.y 		=  self.top + self.yGap*(sponsorTop+2.4)
	hud.board:insert(hud.sponsorButton)
		
	utils.onTouch(hud.sponsorButton, function()
		shareManager:invite()
	end)
	
	-----------------------------------------------
	
	hud.board.logout = display.newImage( hud.board, "assets/images/hud/logout.png")  
	hud.board.logout:scale(0.43,0.43)
	hud.board.logout.x = display.contentWidth*0.5
	hud.board.logout.y = self.yGap * (logoutTop)
	hud.board:insert( hud.board.logout )	

	utils.onTouch(hud.board.logout, function()
		userManager:logout()
	end)	
	
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

-----------------------------------------------------------------------------------------

function scene:drawTextEntry(title, value, position, fontSizeLeft, fontSizeRight)

	viewManager.newText({
		parent 			= hud.board, 
		text 				= title,         
		x 					= self.column1,
		y 					= self.top + self.yGap*position,
		fontSize 		= fontSizeLeft or self.fontSizeLeft,
		referencePoint = display.CenterLeftReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= value,     
		x 					= self.column2,
		y 					= self.top + self.yGap*position,
		fontSize 		= fontSizeRight or self.fontSizeRight,
		font				= NUM_FONT,
		referencePoint = display.CenterRightReferencePoint
	})
	
end

-----------------------------------------------------------------------------------------

function scene:drawConnection(title, state, position)

	viewManager.newText({
		parent 			= hud.board, 
		text 				= title,         
		x 					= display.contentWidth*0.75,
		y 					= self.top + self.yGap*position,
		fontSize 		= 21,
		referencePoint = display.CenterRightReferencePoint
	})
	
	local light 	= display.newImage(hud.board, "assets/images/hud/".. state ..".png")
	light.x 			= display.contentWidth*0.8
	light.y 			= self.top + self.yGap*position + 3
	hud.board:insert(light)

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