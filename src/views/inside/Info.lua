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

	self.top 				= HEADER_HEIGHT + display.contentHeight*0.11
	self.yGap 				= display.contentHeight*0.15

	self.column1 = display.contentWidth*0.3
	self.column2 = display.contentWidth*0.7

	------------------

	hud.bg 		= display.newImageRect(hud, "assets/images/hud/Infos_Bg.png", display.contentWidth, display.viewableContentHeight*0.8)
	hud.bg.x 	= display.contentWidth*0.5
	hud.bg.y 	= display.contentHeight*0.5

	------------------

	hud.options 			= display.newImage( hud, I "info.Options.png")  
	hud.options.x 			= self.column1
	hud.options.y			= self.top

	utils.onTouch(hud.options, function()
		router.openOptions()
	end)

	hud.tutorial 			= display.newImage( hud, I "info.Tutorial.png")  
	hud.tutorial.x 		= self.column2
	hud.tutorial.y			= self.top

	utils.onTouch(hud.tutorial, function()
		router.openTutorial()
	end)

	------------------
	
	hud.prize 				= display.newImage( hud, I "info.Prize.png")  
	hud.prize.x 			= self.column1
	hud.prize.y				= self.top + self.yGap

	utils.onTouch(hud.prize, function()
		analytics.event("Links", "prizes") 
		system.openURL( SERVER_URL .. "#/about/prizes" )
	end)

	hud.rewards 			= display.newImage( hud, I "info.Rewards.png")  
	hud.rewards.x 			= self.column2
	hud.rewards.y			= self.top + self.yGap

	utils.onTouch(hud.rewards, function()
		analytics.event("Links", "rewards") 
		system.openURL( SERVER_URL .. "#/about/rewards" )
	end)
	
	------------------
	
	hud.contact 			= display.newImage( hud, I "info.Contact.png")  
	hud.contact.x 			= self.column1
	hud.contact.y			= self.top + self.yGap * 2

	utils.onTouch(hud.contact, function()
		router.openContact()
	end)

	hud.faq 					= display.newImage( hud, I "info.Faq.png")  
	hud.faq.x 				= self.column2
	hud.faq.y				= self.top + self.yGap * 2

	utils.onTouch(hud.faq, function()
		analytics.event("Links", "faq") 
		system.openURL( SERVER_URL .. "#/about/faq" )
	end)

	------------------
	
	hud.terms 				= display.newImage( hud, I "info.Terms.png")  
	hud.terms.x 			= self.column1
	hud.terms.y				= self.top + self.yGap * 3

	utils.onTouch(hud.terms, function()
		analytics.event("Links", "terms") 
		system.openURL( SERVER_URL .. "#/about/terms" )
	end)

	hud.privacy 			= display.newImage( hud, I "info.Privacy.png")  
	hud.privacy.x 			= self.column2
	hud.privacy.y			= self.top + self.yGap * 3

	utils.onTouch(hud.privacy, function()
		analytics.event("Links", "privacy") 
		system.openURL( SERVER_URL .. "#/about/privacy" )
	end)

	------------------
	
	hud.write 				= display.newImage( hud, I "info.Write.png")  
	hud.write.x 			= display.contentWidth * 0.5
	hud.write.y				= self.top + self.yGap * 4
	
	utils.onTouch(hud.write, function()
		analytics.event("Links", "writeReview") 
		local options =
		{
			iOSAppId = "739060819",
			androidAppPackageName = "com.adillions.v1",
			supportedAndroidStores = { "google" },
		}
		native.showPopup("appStore", options) 
	end)
	
--	------------------
--	
--	hud.facebookIcon 			= display.newImage( hud.board, "assets/images/icons/facebook.png")  
--	hud.facebookIcon.x 		= display.contentWidth*0.5
--	hud.facebookIcon.y		= display.contentHeight*0.2
--	hud.board:insert(hud.facebookIcon)
--
--	utils.onTouch(hud.facebookIcon, function()
--		system.openURL( "https://www.facebook.com/pages/Adillions/379432705492888" )
--	end)
--
--	------------------
--
--	hud.twitterIcon 			= display.newImage( hud.board, "assets/images/icons/twitter.png")  
--	hud.twitterIcon.x 		= display.contentWidth*0.5
--	hud.twitterIcon.y		= display.contentHeight*0.3
--	hud.board:insert(hud.twitterIcon)
--
--	utils.onTouch(hud.twitterIcon, function()
--		system.openURL( "http://www.twitter.com/adillions" )
--	end)
	
	------------------
--	
--	viewManager.drawButton(hud.board, "_Reglement", display.contentWidth*0.5, display.contentHeight *0.4, function() system.openURL( "http://www.adillions.com" ) end)
--
--	------------------
--	
--	viewManager.drawButton(hud.board, "_FAQ", display.contentWidth*0.5, display.contentHeight *0.5, function() system.openURL( "http://www.adillions.com" ) end)
--
--	viewManager.drawButton(hud.board, "_Write a review", display.contentWidth*0.5, display.contentHeight *0.5, function()
--		local options =
--		{
--			iOSAppId = "739060819",
--			androidAppPackageName = "com.adillions.v1",
--			supportedAndroidStores = { "google" },
--		}
--		native.showPopup("appStore", options) 
--	end)
--
--	---------------------------------------------------------------------------------
--
--	viewManager.drawButton(hud.board, "_Options", display.contentWidth*0.5, display.contentHeight *0.6, function() router.openOptions() end)
--
--	---------------------------------------------------------------------------------
--
--	viewManager.drawButton(hud.board, "tuto", display.contentWidth*0.5, display.contentHeight *0.7, function() router.openTutorial() end)

	---------------------------------------------------------------------------------

	viewManager.setupView(5)
	self.view:insert(hud)
	
	viewManager.darkerBack()
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