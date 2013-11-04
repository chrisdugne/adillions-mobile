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

	viewManager.initBack()
	viewManager.darkerBack()
	viewManager.initHeader()

	---------------------------------------------------------------

	hud.tuto1 			= display.newImage( hud, "assets/images/icons/ticket.png")
	hud.tuto1.x 		= display.contentWidth*0.5
	hud.tuto1.y 		= display.contentHeight*0.5

	hud.tuto2 			= display.newImage( hud, "assets/images/icons/players.png")
	hud.tuto2.x 		= display.contentWidth*1.5
	hud.tuto2.y 		= display.contentHeight*0.5

	hud.tuto3 			= display.newImage( hud, "assets/images/icons/winners.png")
	hud.tuto3.x 		= display.contentWidth*2.5
	hud.tuto3.y 		= display.contentHeight*0.5

	hud.arrow 			= display.newImage( hud, "assets/images/icons/winners.png")
	hud.arrow.x 		= display.contentWidth*0.5
	hud.arrow.y 		= display.contentHeight*0.9

	hud.replay 			= display.newImage( hud, "assets/images/icons/players.png")
	hud.replay.x 		= display.contentWidth*0.45
	hud.replay.y 		= display.contentHeight*0.9
	hud.replay.alpha = 0

	hud.ok 			= display.newImage( hud, "assets/images/icons/ticket.png")
	hud.ok.x 		= display.contentWidth*0.55
	hud.ok.y 		= display.contentHeight*0.9
	hud.ok.alpha	= 0
	
	---------------------------------------------------------------
	
	self.tutoNum = 1
	utils.onTouch(hud.arrow, function()
   	
   	self:nextTuto(self.tutoNum)

		if(self.tutoNum == 3) then
			hud.arrow.alpha 	= 0
			hud.replay.alpha 	= 1
			hud.ok.alpha 		= 1

		end
	end)
	
	---------------------------------------------------------------
   
   utils.onTouch(hud.replay, function()
   	hud.arrow.alpha 	= 1
		hud.replay.alpha 	= 0
		hud.ok.alpha 		= 0
		
		self:nextTuto(0)
   end)
   
	---------------------------------------------------------------
   
   utils.onTouch(hud.ok, function()
   
   	GLOBALS.savedData.requireTutorial = false
		utils.saveTable(GLOBALS.savedData, "savedData.json")
	
   	if(userManager.user.uid) then
   		router.openInfo()
   	else
   		router.openOutside()
   	end
   end)
	
	---------------------------------------------------------------

	self.view:insert(hud)

	---------------------------------------------------------------

end

------------------------------------------

function scene:nextTuto(currentTuto)
	if(hud.tuto1.transition) then transition.cancel(hud.tuto1.transition) end
	if(hud.tuto2.transition) then transition.cancel(hud.tuto2.transition) end
	if(hud.tuto3.transition) then transition.cancel(hud.tuto3.transition) end

	hud.tuto1.transition = transition.to(hud.tuto1, { time=300, x=display.contentWidth*0.5 - currentTuto*display.contentWidth })
	hud.tuto2.transition = transition.to(hud.tuto2, { time=300, x=display.contentWidth*1.5 - currentTuto*display.contentWidth })
	hud.tuto3.transition = transition.to(hud.tuto3, { time=300, x=display.contentWidth*2.5 - currentTuto*display.contentWidth })
	self.tutoNum = currentTuto + 1
end

------------------------------------------

function scene:openOptions()
	router.openOptions()	
end

function scene:openPodiums()
	router.openPodiums()	
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