-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local widget = require( "widget" )

local ICON_SIZE = 100

-----------------------------------------------------------------------------------------

function setupView(selectedTab)
	initBack()
	initHeader()
	buildMenu(selectedTab)
end
	
-----------------------------------------------------------------------------------------

function initBack()
	hud.back = display.newImageRect( hud, "assets/images/blur.jpg", display.contentWidth, display.contentHeight)  
	hud.back.x = display.viewableContentWidth*0.5 
	hud.back.y = display.viewableContentHeight*0.5
	hud.back:toBack()
end
	
-----------------------------------------------------------------------------------------

function initHeader()

   hud.headerRect = display.newRect(hud, 0, 0, display.contentWidth, HEADER_HEIGHT)
   hud.headerRect.alpha = 0.7
--   hud.headerRect:setFillColor(0,100,0)
   hud.headerRect:setFillColor(0)
   
	hud.logo = display.newImage( hud, "assets/images/logo.png")  
	hud.logo:scale(0.5,0.5)
	hud.logo.x = hud.logo.contentWidth*0.6
	hud.logo.y = HEADER_HEIGHT*0.5

	hud.headerTitle = display.newText( {
		parent = hud,
		text = "Adillions",     
		x = display.contentWidth*0.3,
		y = HEADER_HEIGHT * 0.5,
		font = FONT,   
		fontSize = 60,
	} )

   hud.headerRect2 = display.newRect(hud, 0, HEADER_HEIGHT, display.contentWidth, HEADER_HEIGHT)
   hud.headerRect2.alpha = 0.2
   hud.headerRect2:setFillColor(0,150,0)

	hud.headerTitle2 = display.newText( {
		parent = hud,
		text = "Action",     
		x = display.contentWidth*0.5,
		y = HEADER_HEIGHT * 1.5,
		font = FONT,   
		fontSize = 35,
	} )
end

------------------------------------------------------------------

function drawButton(text, x, y, action)

	local button = display.newImage(hud, "assets/images/hud/button.png")
	button.x = x
	button.y = y
	
	button.loginText = display.newText( {
		parent = hud,
		text = text,     
		x = x,
		y = y - display.contentHeight*0.01,
		font = FONT,   
		fontSize = 45,
	} )

	utils.onTouch(button, action)

	hud.buttons[#hud.buttons] = button 

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

	-- Create the tabBar's buttons
	local tabButtons = 
	{
		{
			width = ICON_SIZE, 
			height = ICON_SIZE,
			defaultFile = "assets/demos/tabIcon.png",
			overFile = "assets/demos/tabIcon-down.png",
			label = "_Home",
			labelColor =
			{
				default = { 0, 0, 0 },
				over = { 255, 255, 255 },
			},
			font = FONT,
			size = 17,
			onPress = function( event )
				if(tabSelected ~= 1) then 
					router.openHome() 
				end 
			end,
			selected = tabSelected == 1
		},
		{
			width = ICON_SIZE, 
			height = ICON_SIZE,
			defaultFile = "assets/demos/tabIcon.png",
			overFile = "assets/demos/tabIcon-down.png",
			label = "_My tickets",
			labelColor =
			{
				default = { 0, 0, 0 },
				over = { 255, 255, 255 },
			},
			font = FONT,
			size = 17,
			onPress = function( event )
				if(tabSelected ~= 2) then 
					router.openMyTickets() 
				end 
			end,
			selected =  tabSelected == 2
		},
		{
			width = ICON_SIZE, 
			height = ICON_SIZE,
			defaultFile = "assets/demos/tabIcon.png",
			overFile = "assets/demos/tabIcon-down.png",
			label = "_Results",
			labelColor =
			{
				default = { 0, 0, 0 },
				over = { 255, 255, 255 },
			},
			font = FONT,
			size = 17,
			onPress = function( event )
				if(tabSelected ~= 3) then 
					router.openResults() 
				end 
			end,
			selected =  tabSelected == 3
		},
		{
			width = ICON_SIZE, 
			height = ICON_SIZE,
			defaultFile = "assets/demos/tabIcon.png",
			overFile = "assets/demos/tabIcon-down.png",
			label = "_Profile",
			labelColor =
			{
				default = { 0, 0, 0 },
				over = { 255, 255, 255 },
			},
			font = FONT,
			size = 17,
			onPress = function( event )
				if(tabSelected ~= 4) then 
					router.openProfile() 
				end 
			end,
			selected =  tabSelected == 4
		},
		{
			width = ICON_SIZE, 
			height = ICON_SIZE,
			defaultFile = "assets/demos/tabIcon.png",
			overFile = "assets/demos/tabIcon-down.png",
			label = "_Info",
			labelColor =
			{
				default = { 0, 0, 0 },
				over = { 255, 255, 255 },
			},
			font = FONT,
			size = 17,
			onPress = function( event )
				if(tabSelected ~= 5) then 
					router.openInfo() 
				end 
			end,
			selected = tabSelected == 5
		},
	}

	local leftEdge 	= "assets/demos/tabBar_tabSelectedLeftEdge.png"
	local rightEdge 	= "assets/demos/tabBar_tabSelectedRightEdge.png"
	local middle 		= "assets/demos/tabBar_tabSelectedMiddle.png"
	
	if(tabSelected == 0) then
		leftEdge 	= "assets/demos/tabBar_noSelection.png"
		rightEdge 	= "assets/demos/tabBar_noSelection.png"
		middle 		= "assets/demos/tabBar_noSelection.png"
	end

	-- Create a tabBar
	local tabBar = widget.newTabBar({
		left = 0,
		top = display.contentHeight - MENU_HEIGHT,
		width = display.contentWidth,
		height = MENU_HEIGHT,
		backgroundFile = "assets/demos/woodbg.png",
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

--	local ball = display.newCircle(hud, x,y, 45)
	
	local i = random(1,4)

	local ball = display.newImage(hud, "assets/images/game/balls3/ball"..i..".png")
	ball:scale(0.4,0.4)
	ball.x = x
	ball.y = y
	
	ball.text = display.newText( {
		parent = hud,
		text = num,     
		x = x+12,
		y = y-24,
		font = FONT,   
		fontSize = 23,
	} )
	
	ball.text.rotation = -16
	
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

	local ball = display.newCircle(hud, x,y, 65)
	ball.alpha = 0.3
	ball.selected = false
	ball.num = num
	
	drawThemeIcon(num, hud, x, y)
	
	utils.onTouch(ball, function()
		if(ball.selected) then
			lotteryManager:cancelAdditionalSelection()
		else
			lotteryManager:addToAdditionalSelection(ball)
		end
	end)
end

function drawThemeIcon(num, parent, x, y, scale)
	drawRemoteImage(lotteryManager.nextLottery.theme[num],parent, x, y, scale)
end

-----------------------------------------------------------------------------------------

function drawTheme(parent, num,x,y)

	local ball = display.newCircle(x,y, 45)
	ball.num = num
	parent:insert(ball)
	
	drawThemeIcon(num, parent, x, y, 0.7)
end

-----------------------------------------------------------------------------------------

function drawBall(parent, num,x,y)

--	local ball = display.newCircle(x,y, 45)

	local ball = display.newImage(hud, "assets/images/game/balls3/ball1.png")
	ball:scale(0.4,0.4)
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

	parent:insert(ball.text)
	
	ball.text:setTextColor(0)
	ball.num = num
	ball.alpha = 1
end

-----------------------------------------------------------------------------------------

function drawSelectedBall(selected, x, y, action)

	local ball = display.newCircle(hud.selection, x,y, 45)
	
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
	
	ball.text:setTextColor(0)
	
	return ball
end

-----------------------------------------------------------------------------------------

function drawSelectedAdditional(ball,x,y, action)
	
	if(not ball) then
		drawSelectedBall(nil,x,y)
	else
   	local ballInSelection = display.newCircle(hud.selection, x,y, 45)
		drawThemeIcon(ball.num, hud.selection, x, y, 0.7)
		
		if(action) then
   		utils.onTouch(ballInSelection, action)
   	end
	end
	
end
