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

function scene:drawTextEntry(title, value, position)

	viewManager.newText({
		parent 			= hud.board, 
		text 				= title,         
		x 					= self.column1,
		y 					= self.top + self.yGap*position,
		fontSize 		= self.fontSize,
		referencePoint = display.CenterLeftReferencePoint
	})

	viewManager.newText({
		parent 			= hud.board, 
		text	 			= value,     
		x 					= self.column2,
		y 					= self.top + self.yGap*position,
		fontSize 		= self.fontSize,
		referencePoint = display.CenterLeftReferencePoint
	})
	
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()

	viewManager.initBoard()

	------------------

	self.top 		= HEADER_HEIGHT + 70
	self.yGap 		= 60
	self.fontSize 	= 35

	self.column1 = display.contentWidth*0.08
	self.column2 = display.contentWidth*0.4 
	
	------------------
	
	viewManager.drawBorder(hud.board, display.contentWidth*0.5, self.top, display.contentWidth*0.9, self.yGap * 1.5)
	self:drawTextEntry("_userName : ", userManager.user.userName, 0)
	
	viewManager.drawBorder(hud.board, display.contentWidth*0.5, self.top + self.yGap*3, display.contentWidth*0.9, self.yGap * 3.5)
	self:drawTextEntry("_firstName : ", userManager.user.firstName, 2)
	self:drawTextEntry("_lastName : ", userManager.user.lastName, 3)
	self:drawTextEntry("_birthDate : ", userManager.user.birthDate, 4)

	viewManager.drawBorder(hud.board, display.contentWidth*0.5, self.top + self.yGap*6.5, display.contentWidth*0.9, self.yGap * 2.5)
	self:drawTextEntry("_currentPoints : ", userManager.user.currentPoints, 6)
	self:drawTextEntry("_totalPoints : ", userManager.user.totalPoints, 7)

	------------------
	
	viewManager.drawBorder(hud.board, display.contentWidth*0.5, self.top + self.yGap*9.5, display.contentWidth*0.9, self.yGap * 2.5)
	self:drawTextEntry("_FB connection : ", self:isFBConnection(), 9 )
	
	if(userManager.user.facebookId) then
   	if(userManager.user.facebookFan) then
      	self:drawTextEntry("_FB fan : ", "_Yes!", 10 )
      else
      	self:drawTextEntry("Like now us and get " .. FACEBOOK_FAN_TICKETS .. " more tickets each lottery !", "", 10 )
      	hud.likeIcon = display.newImage(hud.board, "assets/images/icons/like.png", display.contentWidth*0.72, self.top + self.yGap*8.5)
      	utils.onTouch(hud.likeIcon, function()
      		facebook.like()
      	end)
   	end
	end
	
	hud.fbIcon = display.newImage(hud.board, "assets/images/icons/facebook.png", display.contentWidth*0.011, self.top + self.yGap*7.9)
	
	if(userManager.user.facebookId) then
   	display.loadRemoteImage( facebook.data.picture.data.url, "GET", function(event)
   		local picture = event.target	
   		hud.board:insert(picture)
   		picture.x = display.contentWidth*0.9
   		picture.y = self.top + self.yGap*8.8
   	end, 
   	"profilePicture", system.TemporaryDirectory)
	end

	------------------
	
	viewManager.drawBorder(hud.board, display.contentWidth*0.5, self.top + self.yGap*12, display.contentWidth*0.9, self.yGap * 1.5)
	self:drawTextEntry("_my referrerId : ", userManager.user.uid, 12 )
	
	hud.shareIcon = display.newImage(hud.board, "assets/images/icons/friends.png")
	hud.shareIcon.x = display.contentWidth*0.89
	hud.shareIcon.y =  self.top + self.yGap*12
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
   	end

		if(userManager.user.twitterId) then
   		viewManager.drawButton(hud.popup, "Twitter", display.contentWidth*0.5, display.contentHeight*0.7, function()
   			facebook.postOnWall("teitwee")
   		end)
   	end
	end)
	
	------------------

	hud:insert(hud.board)
   	
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