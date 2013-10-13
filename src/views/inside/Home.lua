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

	------------------
	
	hud.friendsIcon = display.newImage(hud, "assets/images/icons/friends.png")
	hud.friendsIcon.x = display.contentWidth*0.12
	hud.friendsIcon.y = HEADER_HEIGHT * 1.7

	------------------
	
	hud.friendsText = viewManager.newText({
		parent = hud, 
		text = " _Invite your friends !",    
		x = display.contentWidth*0.5,
		y = HEADER_HEIGHT * 1.7,
		fontSize = 55,
	})

	hud.friendsText:setReferencePoint(display.CenterReferencePoint);

	------------------

	hud.arrowIcon = display.newImage(hud, "assets/images/icons/right.arrow.png")
	hud.arrowIcon.x = display.contentWidth*0.9
	hud.arrowIcon.y = HEADER_HEIGHT * 1.7	

	utils.onTouch(hud.arrowIcon, function()
		router.openInviteFriends()
	end)
	
	------------------
	
	lotteryManager:refreshNextLottery(function() self:drawNextLottery() end)
	
	------------------

--	if(userManager.user.facebookId) then
--   	display.loadRemoteImage( facebook.data.picture.data.url, "GET", function(event)	hud:insert(event.target) end, "profilePicture", system.TemporaryDirectory)
--	end

	------------------

	viewManager.setupView(1)
	self.view:insert(hud)
end

------------------------------------------

function scene:drawNextLottery( event )

		local y = HEADER_HEIGHT * 3.7
		local top = HEADER_HEIGHT * 3
		
		hud.lotteryPanel = display.newImageRect( hud, "assets/images/menus/panel.simple.png", display.contentWidth, HEADER_HEIGHT*2.5)  
		hud.lotteryPanel.x = display.contentWidth*0.5
		hud.lotteryPanel.y = y
		
---		
--		viewManager.drawBorder(hud, display.contentWidth*0.5, y, display.contentWidth*0.95, 350)
--	
----		------------------------------------------------
--
		viewManager.newText({
			parent = hud, 
			text = lotteryManager:date(lotteryManager.nextLottery), 
			x = display.contentWidth*0.05,
   		y = top,
			fontSize = 33,
			referencePoint = display.CenterLeftReferencePoint
		})

		-------------------------------
		
		local price = lotteryManager:price(lotteryManager.nextLottery)
		
		viewManager.newText({
			parent = hud, 
   		text = price,     
			x = display.contentWidth*0.95,
   		y = top,
			fontSize = 83,
			referencePoint = display.CenterRightReferencePoint
		})

		-------------------------------
		
		viewManager.newText({
			parent = hud, 
			text = lotteryManager.nextLottery.nbPlayers .. "    _Players", 
			x = display.contentWidth*0.05,
   		y = top + 70,
			fontSize = 33,
			referencePoint = display.CenterLeftReferencePoint
		})
		
		-------------------------------
	
		viewManager.drawButton(hud, "_Jouer !", display.contentWidth*0.5, top + 250, router.openFillLotteryTicket)
		
		-------------------------------
   	-- theme
   	
		viewManager.newText({
			parent = hud, 
			text = "_THIS WEEK'S THEME",    
   		x = display.contentWidth*0.25,
   		y = display.contentHeight * 0.67,
   		fontSize = 32,
		})
		
   	------------------
   	
		viewManager.drawRemoteImage("http://www.uralys.com/adillions/themes/theme1/eyes.png", hud, display.contentWidth*0.5, display.contentHeight * 0.75)
	   	
   	------------------
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