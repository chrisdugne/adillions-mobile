-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local widget = require( "widget" )

-----------------------------------------------------------------------------------------

function initBack()
	hud.back = display.newImageRect( hud, "assets/images/blur.jpg", display.contentWidth, display.contentHeight)  
	hud.back.x = display.viewableContentWidth/2  
	hud.back.y = display.viewableContentHeight/2
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

function buildMenu(tabSelected)

	-- Create the tabBar's buttons
	local tabButtons = 
	{
		{
			width = 64, 
			height = 64,
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
			width = 64, 
			height = 64,
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
			width = 64, 
			height = 64,
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
			width = 64, 
			height = 64,
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
			width = 64, 
			height = 64,
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

	-- Create a tabBar
	local tabBar = widget.newTabBar({
		left = 0,
		top = display.contentHeight - 170,
		width = display.contentWidth,
		height = 170,
		backgroundFile = "assets/demos/woodbg.png",
		tabSelectedLeftFile = "assets/demos/tabBar_tabSelectedLeftEdge.png",
		tabSelectedRightFile = "assets/demos/tabBar_tabSelectedRightEdge.png",
		tabSelectedMiddleFile = "assets/demos/tabBar_tabSelectedMiddle.png",
		tabSelectedFrameWidth = 20,
		tabSelectedFrameHeight = 170,
		buttons = tabButtons,
	})

	hud:insert( tabBar )
end

-----------------------------------------------------------------------------------------

function drawBall(num,x,y)

	local ball = display.newCircle(hud, x,y, 45)
	
	ball.num = display.newText( {
		parent = hud,
		text = num,     
		x = x,
		y = y,
		font = FONT,   
		fontSize = 40,
	} )
	
	ball.num:setTextColor(0)
	ball.alpha = 0.3
	ball.selected = false

	utils.onTouch(ball, function()
   	ball.selected = not ball.selected
		
		if(ball.selected) then
      	ball.alpha = 1
		else
      	ball.alpha = 0.3
		end
		
	end)
end

-----------------------------------------------------------------------------------------

function drawThemeSelection(num,x,y)

	local ball = display.newCircle(hud, x,y, 65)
	
	ball.image = display.newImage(hud,"assets/demos/tabIcon-down.png")
	ball.image.x = x
	ball.image.y = y
	
	ball.alpha = 0.3
	ball.selected = false

	utils.onTouch(ball, function()
   	ball.selected = not ball.selected
		
		if(ball.selected) then
      	ball.alpha = 1
		else
      	ball.alpha = 0.3
		end
		
	end)
end
