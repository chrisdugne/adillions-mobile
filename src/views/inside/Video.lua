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
	
	displayVideo()
	self.view:insert(hud)
	
end

------------------------------------------

function exitVideo()
	hud.video:removeSelf()
	hud.video = nil
	
	router.openHome()
end

function displayVideo()

	------------------------------	

	hud.exitButton = display.newImage(hud, "assets/images/hud/ko.png")
	hud.exitButton:setReferencePoint( display.TopRightReferencePoint )
	hud.exitButton:rotate(-90)
	hud.exitButton:scale(0.4,0.4)
	hud.exitButton.x = 20
	hud.exitButton.y = 20
	hud.exitButton.alpha = 0

	utils.onTouch(hud.exitButton, exitVideo)
	transition.to(hud.exitButton, {time = 3000, alpha = 1})
	
	------------------------------	

	hud.video = native.newVideo( 0, 0, display.contentHeight, display.contentWidth*0.8 )
	hud.video:rotate(-90)
	hud.video.x = display.contentWidth*0.5
	hud.video.y = display.contentHeight*0.5

   local function videoListener( event )
       print( "Event phase: " .. event.phase )
   
		if event.errorCode then
			native.showAlert( "Error!", event.errorMessage, { "OK" } )
		end
	end

	hud.video:load( "http://video-js.zencoder.com/oceans-clip.mp4", media.RemoteSource )
	hud.video:play()

end

	---------------------------------------------------------------------------------------
	--	
	--	Recup de video + download + display dans une webView	
	--	

--	local call = "http://serve.vdopia.com/adserver/html5/adFetch/?ak=1f17f9cf4bcc60ae0b2314f820cb7bbc&adFormat=preappvideo&sleepAfter=0&version=1.0&requester=uralys&output=xhtml"
--
--	local function networkListener( event )
--		if ( event.isError ) then
--			print( "Network error!")
--		else
--			local html = event.response
--			local start = string.find(html,"<html>")
--			local ends = string.find(html,"</html>") + 6
--
--			html = html:sub(start, ends)
--
--			utils.saveFile(html, "test.html")
--			
--	   	local webView = native.newWebView( display.contentWidth*0.1, display.contentHeight*0.1, display.contentWidth*0.8, display.contentHeight*0.8, webListener )
--   		webView:request( "test.html", system.DocumentsDirectory )
--   		webView:addEventListener( "urlRequest", webListener )
--   		
--   		
--         local testText = display.newText( {
--         	text = "YO2",     
--         	x = display.contentWidth*0.5,
--         	y = 350,
--         	font = FONT,   
--         	fontSize = 85,
--         } )
--         
--		end
--	end
--   
--   network.request( call, "GET", networkListener )

--
--
--function webListener( event )
--    if event.url then
--        print( "You are visiting: " .. event.url )
--    end
--
--    if event.type then
--        print( "The event.type is " .. event.type ) -- print the type of request
--    end
--
--    if event.errorCode then
--        native.showAlert( "Error!", event.errorMessage, { "OK" } )
--    end
--end

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