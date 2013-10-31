-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local widget = require( "widget" )

local ICON_SIZE = 95
local SMALL_THEME_SCALE = 0.59

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

function initHeader()

	hud.headerRect = display.newImageRect( hud, "assets/images/header.png", display.contentWidth, HEADER_HEIGHT)  
	hud.headerRect.x = display.viewableContentWidth*0.5 
	hud.headerRect.y = HEADER_HEIGHT*0.5

	hud.logo = display.newImage( hud, "assets/images/logo.png")  
	hud.logo.x = display.contentWidth*0.5
	hud.logo.y = HEADER_HEIGHT*0.5
	
	refreshHeaderPoints()
	
end

-----------------------------------------------------------------------------------------

function initBoard()
	hud.board = widget.newScrollView
	{
		top = 0,
		left = 0,
		friction = 1.5,
		width = display.contentWidth,
		height = display.contentHeight - HEADER_HEIGHT - MENU_HEIGHT,
		bottomPadding = MENU_HEIGHT,
		hideBackground = true,
		id = "board",
		horizontalScrollDisabled = true,
		verticalScrollDisabled = false,
		hideScrollBar = true,
	}
end

-----------------------------------------------------------------------------------------

function refreshHeaderPoints()
	
	local points = userManager.user.currentPoints
	if(not points) then return end
	
	hud.points = display.newImage( hud, "assets/images/points/points.".. points ..".png")  
	hud.points.x = display.contentWidth*0.9
	hud.points.y = HEADER_HEIGHT*0.5
	
	hud.points:toFront()
	
	local title 	= ""
	local text		= ""

	utils.onTouch(hud.points, function()
		viewManager.showPopup(title, text, function() end)

		viewManager.newText({
			parent 			= hud.popup, 
			text	 			= userManager.user.currentPoints .. " pts",     
			x 					= display.contentWidth*0.54,
			y 					= display.contentHeight*0.25,
			fontSize 		= 60,
		})

		hud.iconPoints 			= display.newImage( hud.popup, "assets/images/points/points.".. userManager.user.currentPoints .. ".png")
		hud.iconPoints.x 			= display.contentWidth * 0.4
		hud.iconPoints.y 			= display.contentHeight*0.255

		--------------------------

		local nbTickets = (userManager.user.availableTickets + userManager.user.totalBonusTickets - userManager.user.playedBonusTickets)

		viewManager.newText({
			parent 			= hud.popup, 
			text 				= T "Tickets to play" .. " : ",         
			x 					= display.contentWidth * 0.5,
			y 					= display.contentHeight*0.35,
		})

		hud.iconTicket 			= display.newImage( hud.popup, "assets/images/icons/ticket.png")
		hud.iconTicket.x 			= display.contentWidth * 0.5 - 40
		hud.iconTicket.y 			= display.contentHeight*0.4

		viewManager.newText({
			parent 			= hud.popup, 
			text	 			= nbTickets,     
			x 					= display.contentWidth * 0.5 + 55,
			y 					= display.contentHeight*0.4,
			font				= NUM_FONT,
			fontSize 		= 40,
			referencePoint = display.CenterRightReferencePoint
		})

		--------------------------

		viewManager.newText({
			parent 			= hud.popup, 
			text 				= T "Extra Tickets" .. " : ",         
			x 					= display.contentWidth * 0.5,
			y 					= display.contentHeight*0.5,
		})

		hud.iconExtraTicket 			= display.newImage( hud.popup, "assets/images/icons/ticket.png")
		hud.iconExtraTicket.x 		= display.contentWidth * 0.5 - 40
		hud.iconExtraTicket.y 		= display.contentHeight*0.55

		viewManager.newText({
			parent 			= hud.popup, 
			text	 			= userManager.user.extraTickets,     
			x 					= display.contentWidth * 0.5 + 55,
			y 					= display.contentHeight*0.55,
			font				= NUM_FONT,
			fontSize 		= 40,
			referencePoint = display.CenterRightReferencePoint
		})

		--------------------------
		
		viewManager.drawButton(hud.popup, "Ok", display.contentWidth*0.5, display.contentHeight *0.7, function() utils.emptyGroup(hud.popup) end)

	end)

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

	hud.backGrey 		= drawBorder( hud.popup, 
		0, 0, 
		display.contentWidth+50, display.viewableContentHeight+50,
		50,50,50
	)  
	hud.backGrey.x 	= display.viewableContentWidth*0.5 
	hud.backGrey.y 	= display.viewableContentHeight*0.5
	hud.backGrey.alpha=0.85
	
	
	hud.popupRect 		= drawBorder( hud.popup, 
		display.contentWidth*0.1, display.contentHeight*15, 
		display.contentWidth*0.8, display.viewableContentHeight*0.7,
		250,250,250
	)  
	hud.popupRect.x 	= display.viewableContentWidth*0.5 
	hud.popupRect.y 	= display.viewableContentHeight*0.5
	
	viewManager.newText({
		parent 			= hud.popup, 
		text	 			= title,     
		x 					= display.contentWidth*0.16,
		y 					= display.contentHeight*0.2,
		fontSize 		= 40,
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
		
	hud.popup:toFront()
	transition.to(hud.popup, {time=250, alpha=1})
end

------------------------------------------------------------------

function addCloseButton()

	hud.popupClose = display.newImage( hud.popup, "assets/images/hud/ko.png")
  	hud.popupClose.x = display.contentWidth*0.83 
  	hud.popupClose.y = display.contentHeight*0.18
  	hud.popupClose:scale(0.4,0.4)
  	
	utils.onTouch(hud.popupClose, function()
		display.remove(hud.popupClose)
		transition.to(hud.popup, {time=250, alpha=0, onComplete=function()
   		utils.emptyGroup(hud.popup)
   		
   		if(action) then
   			action()
   		end
		end})
	end)	
	
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

function drawBorder(parent, x, y, width, height, r, g, b)

	-----------------------------------

	if(not width) then
		width = 250
	end

	if(not height) then
		height = 90
	end

	-----------------------------------
	
	if(not r) then r = 239 end
	if(not g) then g = 237 end
	if(not b) then b = 238 end
	
	local gray = r - 19
	
	-----------------------------------
	-- rounded buttons 1 color
	
	local border = display.newRoundedRect(parent, 0, 0, width, height, 17)
   border.x = x 
   border.y = y
   border.strokeWidth = 1
   border:setFillColor(r,g,b)
   border:setStrokeColor(gray)
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

function drawRemoteImage( url, parent, x, y, scale, alpha, next )

	if(not scale) then scale = 1 end
	if(not alpha) then alpha = 1 end
	
	local fileName = utils.imageName(url)
	local image = display.newImage( parent, fileName, system.TemporaryDirectory)
	
	if not image then
		local imageReceived = function(event) return insertImage(event.target, parent, x, y, scale, alpha, next) end
		display.loadRemoteImage( url, "GET", imageReceived, fileName, system.TemporaryDirectory )
	else
		insertImage(image, parent, x, y, scale, alpha, next)
	end
	
end	

function insertImage(image, parent, x, y, scale, alpha, next)
	
	image.x 			= x
	image.y	 		= y
	image.xScale 	= scale
	image.yScale 	= scale
	image.alpha 	= alpha

	parent:insert(image)
	
	if(next) then
		next()
	end
end

------------------------------------------------------------------

function buildMenu(tabSelected)

	local buttonWidth = display.contentWidth/5 - 1
	
	-- Create the tabBar's buttons
	local tabButtons = 
	{
		{
			width 				= buttonWidth, 
			height 				= ICON_SIZE,
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
			height 				= ICON_SIZE,
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
			height 				= ICON_SIZE,
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
			height 				= ICON_SIZE,
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
			height 				= ICON_SIZE,
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
		
		leftEdge 	= "assets/images/menus/empty.png"
		rightEdge 	= "assets/images/menus/empty.png"
		middle 		= "assets/images/menus/empty.png"

	-- Create a tabBar
	local tabBar = widget.newTabBar({
		left = 0,
		top = display.contentHeight - MENU_HEIGHT,
		width = display.contentWidth,
		height = MENU_HEIGHT,
		backgroundFile = "assets/images/menus/menu.bg.png",
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

	local ball = display.newImage(hud, "assets/images/balls/ball.small.white.png")
	ball.x = x
	ball.y = y
	
	ball.text = display.newText( {
		parent = hud,
		text = num,     
		x = x,
		y = y,
		font = NUM_FONT,   
		fontSize = 37,
	} )
	
	ball.text:setTextColor(0)
	ball.num = num
	ball.selected = false

	utils.onTouch(ball, function()
		if(lotteryManager:canAddToSelection()) then
			lotteryManager:addToSelection(ball.num)
		end
	end)
	
	hud.balls[num] = ball
end


function drawBallPicked(num)
	
	local x = hud.balls[num].x
	local y = hud.balls[num].y
	display.remove(hud.balls[num])
	
	local ball = display.newImage(hud, "assets/images/balls/ball.small.green.png")
	ball.x = x
	ball.y = y
	
	ball.text = display.newText( {
		parent = hud,
		text = num,     
		x = x,
		y = y,
		font = NUM_FONT,   
		fontSize = 33,
	} )
	
	ball.text:setTextColor(255)
	ball.num = num
	ball.selected = true

	utils.onTouch(ball, function()
		lotteryManager:removeFromSelection(ball.num)
	end)
	
	hud.balls[num] = ball
end

-----------------------------------------------------------------------------------------

function drawThemeToPick(num,x,y)

	local ball = {}
	ball.selected 	= false
	ball.num 		= num

	drawThemeIcon(num, hud, lotteryManager.nextLottery, x, y, 1, 1, function()
		local themeMask = display.newImage(hud, "assets/images/balls/ball.mask.png")
		themeMask.x = x
		themeMask.y = y

		utils.onTouch(themeMask, function()
			if(ball.selected) then
				lotteryManager:cancelAdditionalSelection()
			else
				lotteryManager:addToAdditionalSelection(ball)
			end
		end)
	end)

	viewManager.newText({
		parent 			= hud, 
		text	 			= lotteryManager.nextLottery.theme.icons[num].name,     
		x 					= x,
		y 					= y + 120,
		fontSize 		= 40
	})


end

function drawThemeIcon(num, parent, lottery, x, y, scale, alpha, next)
	drawRemoteImage(lottery.theme.icons[num].image, parent, x, y, scale, alpha, next)
end

-----------------------------------------------------------------------------------------

--- 
-- theme sur un ticket ou un result
function drawTheme(parent, lottery, num,x,y, alpha, requireCheck)

	if(not alpha) then alpha = 1 end

	drawThemeIcon(num, parent, lottery, x, y, SMALL_THEME_SCALE, alpha, function()
		local themeMask = display.newImage(parent, "assets/images/balls/ball.mask.png")
		themeMask.x = x
		themeMask.y = y
		themeMask.alpha = alpha
		themeMask:scale(SMALL_THEME_SCALE, SMALL_THEME_SCALE)
		parent:insert(themeMask)
		
		if(requireCheck) then
			local check = display.newImage(parent, "assets/images/icons/check.png")
      	check.x = x + 20
      	check.y = y - 30
      	parent:insert(check)
      end
	end)
	
end

-----------------------------------------------------------------------------------------

function drawBall(parent, num,x,y)

	local ball = display.newImage(hud, "assets/images/balls/ball.small.green.png")
	ball.x = x
	ball.y = y
	
	parent:insert(ball)
	
	ball.text = display.newText( {
		text = num,     
		x = x,
		y = y,
		font = NUM_FONT,   
		fontSize = 37,
	} )

	ball.text:setTextColor(255)
	parent:insert(ball.text)
	
	ball.num = num
	ball.alpha = 1
	
	return ball
end

-----------------------------------------------------------------------------------------

function drawSelectedBall(selected, x, y, action)

	local ball = display.newImage(hud.selection, "assets/images/balls/ball.big.green.png")
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
		font = NUM_FONT,   
		fontSize = 47,
	} )
	
	ball.text:setTextColor(255)
	
	return ball
end

-----------------------------------------------------------------------------------------

function drawSelectedAdditional(ball,x,y, action)
	
	if(ball) then
		drawThemeIcon(ball.num, hud.selection, lotteryManager.nextLottery, x, y, SMALL_THEME_SCALE, 1, function()
      	local themeMask = display.newImage(hud.selection, "assets/images/balls/ball.mask.png")
      	themeMask.x = x
      	themeMask.y = y
      	themeMask:scale(SMALL_THEME_SCALE, SMALL_THEME_SCALE)
      	
   		if(action) then
      		utils.onTouch(themeMask, action)
      	end
		end)
	end
	
end

-----------------------------------------------------------------------------------------

function drawSelection(parent, numbers)

	-------------------------------------
	-- display
	
	local nbSelected  = 0
	local xGap 			= display.contentWidth*0.14
	local y 				= display.contentHeight*0.22

	-------------------------------------

	for j = 1,#numbers-1 do
		drawBall(parent, numbers[j], xGap*j, y)
	end
	
	drawTheme(parent, lotteryManager.nextLottery, numbers[#numbers], xGap*#numbers, y)
	
end

-----------------------------------------------------------------------------------------

function drawTicket(parent, lottery, numbers, x, y)
	
	local xGap =  display.contentWidth *0.12

	for j = 1,#numbers-1 do
		
		local ball = drawBall(parent, numbers[j], x + xGap*j, y)
		
		local goodNumber = true
		
		if(lottery.result) then
   		if type(lottery.result) == "string" then lottery.result = json.decode(lottery.result) end
			
			goodNumber = false
			for w = 1, #lottery.result-1 do
				if(lottery.result[w] == numbers[j]) then
					goodNumber = true
				end
   		end
		end
		
		if(goodNumber) then
			ball.alpha = 1
			
			if(lottery.result) then
   			local check = display.newImage(parent, "assets/images/icons/check.png")
         	check.x = x + xGap*j + 20
         	check.y = y - 30
         	parent:insert(check)
         end
		else
			ball.alpha = 0.34
   	end
	end
	
	local alpha = 1	
	local themeWon = false
	
	if(lottery.result) then
		themeWon = lottery.result[#lottery.result] == numbers[#numbers]
		if(not themeWon) then
			alpha = 0.34
		end 
	end
	
	drawTheme(parent, lottery, numbers[#numbers], x + xGap*#numbers, y, alpha, themeWon)
	
end

-----------------------------------------------------------------------------------------