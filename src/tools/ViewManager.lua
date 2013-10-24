-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local widget = require( "widget" )

local ICON_SIZE = 122

-----------------------------------------------------------------------------------------

function setupView(selectedTab)
	initBack()
	initHeader()
	buildMenu(selectedTab)
end
	
-----------------------------------------------------------------------------------------

-- globalBack not to have a black screen while changing views
function initGlobalBack()
--	local globalBack = display.newImageRect( "assets/images/bg.jpg", display.contentWidth, display.contentHeight)  
--	globalBack.x = display.viewableContentWidth*0.5 
--	globalBack.y = display.viewableContentHeight*0.5
--	globalBack:toBack()

--	display.setDefault( "background", 227, 225, 226 )
end
	
-----------------------------------------------------------------------------------------

function initBack()
	display.setDefault( "background", 237, 235, 236 )
end
	
function darkerBack()
	display.setDefault( "background", 227, 225, 226 )
end
	
-----------------------------------------------------------------------------------------

function initBoard()
	hud.board = widget.newScrollView
	{
		top = 0,
		left = 0,
		width = display.contentWidth,
		height = display.contentHeight - HEADER_HEIGHT - MENU_HEIGHT,
		bottomPadding = HEADER_HEIGHT,
		hideBackground = true,
		id = "onBottom",
		horizontalScrollDisabled = true,
		verticalScrollDisabled = false,
		hideScrollBar = true,
	}
end


-----------------------------------------------------------------------------------------

function initHeader()

	hud.headerRect = display.newImageRect( hud, "assets/images/menus/00_Header_Background.png", display.contentWidth, HEADER_HEIGHT)  
	hud.headerRect.x = display.viewableContentWidth*0.5 
	hud.headerRect.y = HEADER_HEIGHT*0.5

	hud.logo = display.newImage( hud, "assets/images/00_Header_Logo.png")  
	hud.logo.x = display.contentWidth*0.5
	hud.logo.y = HEADER_HEIGHT*0.5
	
	refreshHeaderPoints()
	
end

-----------------------------------------------------------------------------------------

function refreshHeaderPoints()
	
	local points = userManager.user.currentPoints
	if(not points) then return end
	
	hud.points = display.newImage( hud, "assets/images/game/points/points.".. points ..".png")  
	hud.points.x = display.contentWidth*0.9
	hud.points.y = HEADER_HEIGHT*0.5
	
	hud.points:toFront()

end

-----------------------------------------------------------------------------------------

function showPoints(nbPoints)
	local text = viewManager.newText({
		parent 			= hud, 
		text	 			= "+ " .. nbPoints,     
		x 					= display.contentWidth*0.97,
		y 					= display.contentHeight*0.05,
		fontSize 		= 65
	})

	transition.to(text, { time=1500, alpha=0, x=display.contentWidth*0.84 })
end

-----------------------------------------------------------------------------------------

function showPopup(title, text, action)

	utils.emptyGroup(hud.popup)
	hud.popup = display.newGroup()
	hud.popup.alpha = 0

	hud.popupRect = display.newImageRect( hud.popup, "assets/images/menus/panel.popup.png", display.contentWidth*0.8, display.viewableContentHeight*0.7)  
	hud.popupRect.x = display.viewableContentWidth*0.5 
	hud.popupRect.y = display.viewableContentHeight*0.5
	
	viewManager.newText({
		parent 			= hud.popup, 
		text	 			= title,     
		x 					= display.contentWidth*0.12,
		y 					= display.contentHeight*0.2,
		fontSize 		= 35,
		referencePoint = display.CenterLeftReferencePoint
	})

	viewManager.newText({
		parent 			= hud.popup, 
		text	 			= text,     
		x 					= display.contentWidth*0.13,
		y 					= display.contentHeight*0.3,
		fontSize 		= 30,
		width				= display.contentWidth*0.7,
		referencePoint = display.CenterLeftReferencePoint
	})
		
	hud.popupClose = display.newImage( hud.popup, "assets/images/hud/ko.png")
  	hud.popupClose.x = display.contentWidth*0.8 
  	hud.popupClose.y = display.contentHeight*0.2
  	hud.popupClose:scale(0.3,0.3)
  	
	utils.onTouch(hud.popupClose, function()
		display.remove(hud.popupClose)
		transition.to(hud.popup, {time=250, alpha=0, onComplete=function()
   		utils.emptyGroup(hud.popup)
   		
   		if(action) then
   			action()
   		end
		end})
	end)	
	
	hud.popup:toFront()
	transition.to(hud.popup, {time=250, alpha=1})
end
	
------------------------------------------------------------------

function newText(options)

	local finalOptions = {}
	finalOptions.text 		= options.text
	finalOptions.font 		= options.font or FONT
	finalOptions.fontSize 	= options.fontSize or 48

	if(options.width) then
		finalOptions.width	= options.width
	end

	if(options.height) then
		finalOptions.height	= options.height
	end

	local text = display.newText( finalOptions )

	text:setTextColor(0)
	text:setReferencePoint(options.referencePoint or display.CenterReferencePoint);
	text.x = options.x
	text.y = options.y

	if(options.parent) then
		options.parent:insert(text)
	end

	
	return text
end

------------------------------------------------------------------

function drawBorder(parent, x, y, width, height)

	if(not width) then
		width = 250
	end

	if(not height) then
		height = 90
	end
	
	-----------------------------------
	-- rounded buttons 1 color
	
	local border = display.newRoundedRect(parent, 0, 0, width, height, 17)
   border.x = x 
   border.y = y
   border.strokeWidth = 1
   border:setFillColor(239,237,238)
   border:setStrokeColor(220)
   parent:insert(border)
   
   return border
end

------------------------------------------------------------------

function drawButton(parent, text, x, y, action, width, height)

	-----------------------------------

	local button = drawBorder(parent, x, y, width, height)

	-----------------------------------
	
	button.text = display.newText( {
		parent = parent,
		text = text,     
		x = x,
		y = y-6,
		font = FONT,   
		fontSize = 45,
	} )

	button.text:setTextColor(0,0,0)
	utils.onTouch(button, action)

--	hud.buttons[#hud.buttons] = button 
	parent:insert(button)
	parent:insert(button.text)

	return button
end

------------------------------------------------------------------

function drawRemoteImage( url, parent, x, y, scale )

	if(not scale) then scale = 1 end
	
	local fileName = utils.imageName(url)
	local image = display.newImage( parent, fileName, system.TemporaryDirectory)
	
	if not image then
		local imageReceived = function(event) return insertImage(event.target, parent, x, y, scale)  end
		display.loadRemoteImage( url, "GET", imageReceived, fileName, system.TemporaryDirectory )
	else
		insertImage(image, parent, x, y, scale)
	end
	
end	

function insertImage(image, parent, x, y, scale)
	image.x = x
	image.y = y
	image.xScale = scale
	image.yScale = scale

	parent:insert(image)
end

------------------------------------------------------------------

function buildMenu(tabSelected)

	local buttonWidth = display.contentWidth/5 - 1
	print (buttonWidth)
	
	-- Create the tabBar's buttons
	local tabButtons = 
	{
		{
			width 				= buttonWidth, 
			height 				= MENU_HEIGHT,
			defaultFile 		= I "OFF1.png",
			overFile 			= I "ON1.png",
			onPress = function( event )
				if(tabSelected ~= 1) then 
					router.openHome() 
				end 
			end,
			selected = tabSelected == 1
		},
		{
			width 				= buttonWidth, 
			height 				= MENU_HEIGHT,
			defaultFile 		= I "OFF2.png",
			overFile 			= I "ON2.png",
			onPress = function( event )
				if(tabSelected ~= 2) then 
					router.openMyTickets() 
				end 
			end,
			selected =  tabSelected == 2
		},
		{
			width 				= buttonWidth, 
			height 				= MENU_HEIGHT,
			defaultFile 		= I "OFF3.png",
			overFile 			= I "ON3.png",
			onPress = function( event )
				if(tabSelected ~= 3) then 
					router.openResults() 
				end 
			end,
			selected =  tabSelected == 3
		},
		{
			width 				= buttonWidth, 
			height 				= MENU_HEIGHT,
			defaultFile 		= I "OFF4.png",
			overFile 			= I "ON4.png",
			onPress = function( event )
				if(tabSelected ~= 4) then 
					router.openProfile() 
				end 
			end,
			selected =  tabSelected == 4
		},
		{
			width 				= buttonWidth, 
			height 				= MENU_HEIGHT,
			defaultFile 		= I "OFF5.png",
			overFile 			= I "ON5.png",
			onPress = function( event )
				if(tabSelected ~= 5) then 
					router.openInfo() 
				end 
			end,
			selected = tabSelected == 5
		},
	}

--	local leftEdge 	= "assets/images/menus/tabBar_tabSelectedLeftEdge.png"
--	local rightEdge 	= "assets/images/menus/tabBar_tabSelectedRightEdge.png"
--	local middle 		= "assets/images/menus/tabBar_tabSelectedMiddle.png"
--	
--	if(tabSelected == 0) then
--		leftEdge 	= "assets/images/menus/tabBar_noSelection.png"
--		rightEdge 	= "assets/images/menus/tabBar_noSelection.png"
--		middle 		= "assets/images/menus/tabBar_noSelection.png"
--	end
		
		leftEdge 	= "assets/images/menus/tabBar_noSelection.png"
		rightEdge 	= "assets/images/menus/tabBar_noSelection.png"
		middle 		= "assets/images/menus/tabBar_noSelection.png"

	-- Create a tabBar
	local tabBar = widget.newTabBar({
		left = 0,
		top = display.contentHeight - MENU_HEIGHT,
		width = display.contentWidth,
		height = MENU_HEIGHT,
--		backgroundFile = "assets/images/menus/woodbg.png",
		backgroundFile = "assets/images/menus/woodbg.white.jpg",
		tabSelectedLeftFile = leftEdge,
		tabSelectedRightFile = rightEdge,
		tabSelectedMiddleFile = middle,
		tabSelectedFrameWidth = 20,
		tabSelectedFrameHeight = MENU_HEIGHT,
		buttons = tabButtons,
	})

	if(tabSelected == 0) then
   	tabBar:setSelected( 0, false )
   end
    
	hud:insert( tabBar )
	
end

-----------------------------------------------------------------------------------------

function drawBallToPick(num,x,y)

	local i = random(1,4)

	local ball = display.newImage(hud, "assets/images/game/ball.png")
	ball:scale(0.23, 0.23)
	ball.x = x
	ball.y = y
	
	ball.text = display.newText( {
		parent = hud,
		text = num,     
		x = x,
		y = y,
		font = FONT,   
		fontSize = 44,
	} )
	
	ball.text:setTextColor(0)
	ball.num = num
	ball.alpha = 0.3
	ball.selected = false

	utils.onTouch(ball, function()
		if(ball.selected) then
			lotteryManager:removeFromSelection(ball.num)
		else
   		if(lotteryManager:canAddToSelection()) then
   			lotteryManager:addToSelection(ball.num)
   		end
		end
		
	end)
	
	hud.balls[num] = ball
end

-----------------------------------------------------------------------------------------

function drawThemeToPick(num,x,y)

	local ball = display.newImage(hud, "assets/images/game/ball.png")
	ball:scale(0.2,0.2)
	ball.x = x
	ball.y = y

	ball.alpha 		= 0.3
	ball.selected 	= false
	ball.num 		= num
	
	drawThemeIcon(num, hud, x, y)
	
	viewManager.newText({
		parent 			= hud, 
		text	 			= lotteryManager.nextLottery.theme.icons[num].name,     
		x 					= x,
		y 					= y + display.contentHeight*0.05,
		fontSize 		= 30
	})
	
	utils.onTouch(ball, function()
		if(ball.selected) then
			lotteryManager:cancelAdditionalSelection()
		else
			lotteryManager:addToAdditionalSelection(ball)
		end
	end)
end

function drawThemeIcon(num, parent, x, y, scale)
	drawRemoteImage(lotteryManager.nextLottery.theme.icons[num].image, parent, x, y, scale)
end

-----------------------------------------------------------------------------------------

function drawTheme(parent, num,x,y, scale)
	
	if(not scale) then scale = 0.2 end

	local ball = display.newImage(hud, "assets/images/game/ball.png")
	ball:scale(scale,scale)
	ball.x = x
	ball.y = y
	ball.num = num
	parent:insert(ball)
	
	drawThemeIcon(num, parent, x, y, 0.7)
end

-----------------------------------------------------------------------------------------

function drawBall(parent, num,x,y)

	local ball = display.newImage(hud, "assets/images/game/ball.png")
	ball:scale(0.2,0.2)
	ball.x = x
	ball.y = y
	
	parent:insert(ball)
	
	ball.text = display.newText( {
		text = num,     
		x = x,
		y = y,
		font = FONT,   
		fontSize = 40,
	} )

	ball.text:setTextColor(255)
	parent:insert(ball.text)
	
	ball.num = num
	ball.alpha = 1
end

-----------------------------------------------------------------------------------------

function drawSelectedBall(selected, x, y, action)

	local ball = display.newImage(hud.selection, "assets/images/game/ball.png")
	ball:scale(0.2,0.2)
	ball.x = x
	ball.y = y
	
	if(not selected) then
		selected = ""
		ball.alpha = 0.3
	else
		if(action) then
   		utils.onTouch(ball, action)
   	end
	end
	
	ball.text = display.newText( {
		parent = hud.selection,
		text = selected,     
		x = x,
		y = y,
		font = FONT,   
		fontSize = 40,
	} )
	
	ball.text:setTextColor(255)
	
	return ball
end

-----------------------------------------------------------------------------------------

function drawSelectedAdditional(ball,x,y, action)
	
	if(not ball) then
		drawSelectedBall(nil,x,y)
	else
   	local ballInSelection = display.newImage(hud.selection, "assets/images/game/ball.png")
   	ballInSelection:scale(0.2,0.2)
   	ballInSelection.x = x
   	ballInSelection.y = y
   	
		drawThemeIcon(ball.num, hud.selection, x, y, 0.7)
		
		if(action) then
   		utils.onTouch(ballInSelection, action)
   	end
	end
	
end

-----------------------------------------------------------------------------------------

function drawTicket(parent, numbers, x, y)

	local xGap =  display.contentWidth *0.1
--	local center =  display.contentWidth*0.5
	
	viewManager.drawBorder(parent, x+(#numbers+1)/2*display.contentWidth*0.1, y, #numbers * display.contentWidth*0.105, TICKET_HEIGHT)
   	
	for j = 1,#numbers-1 do
		drawBall(parent, numbers[j], x + xGap*j, y)
	end
	
	drawTheme(parent, numbers[#numbers], x + xGap*#numbers, y)
	
end

-----------------------------------------------------------------------------------------