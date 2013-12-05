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

	hud.logo = display.newImage( hud, "assets/images/logo.beta.png")  
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
	
		viewManager.showPopup(function() end)
   	analytics.event("Gaming", "popupPoints") 

		--------------------------

		local plural = ""
		if(userManager.user.currentPoints and (userManager.user.currentPoints > 1)) then
			plural = "s"
		end

		viewManager.newText({
			parent 			= hud.popup, 
			text	 			= userManager.user.currentPoints .. " pt" .. plural,     
			x 					= display.contentWidth*0.54,
			y 					= display.contentHeight*0.2,
			fontSize 		= 60,
		})

		hud.iconPoints 			= display.newImage( hud.popup, "assets/images/points/points.".. userManager.user.currentPoints .. ".png")
		hud.iconPoints.x 			= display.contentWidth * 0.4
		hud.iconPoints.y 			= display.contentHeight*0.205

		--------------------------

		local instantTickets = T "Instant Ticket"
		if(userManager.user.extraTickets > 1) then
			instantTickets = T "Instant Tickets"
		end

		viewManager.newText({
			parent 			= hud.popup, 
			text 				= instantTickets .. " : ",         
			x 					= display.contentWidth * 0.5,
			y 					= display.contentHeight*0.35,
		})

		hud.iconExtraTicket 			= display.newImage( hud.popup, "assets/images/icons/Picto_InstantTicket.png")
		hud.iconExtraTicket.x 		= display.contentWidth * 0.5 - 40
		hud.iconExtraTicket.y 		= display.contentHeight*0.42

		viewManager.newText({
			parent 			= hud.popup, 
			text	 			= userManager.user.extraTickets,     
			x 					= display.contentWidth * 0.5 + 55,
			y 					= display.contentHeight*0.42,
			font				= NUM_FONT,
			fontSize 		= 40,
			referencePoint = display.CenterRightReferencePoint
		})
		
		--------------------------
		
   	hud.popup.separator 			= display.newImage(hud.popup, "assets/images/icons/separateur.horizontal.png")
   	hud.popup.separator.x 		= display.contentWidth*0.5
   	hud.popup.separator.y 		= display.contentHeight*0.52
		
		--------------------------

		local nbTickets = (userManager.user.availableTickets + userManager.user.totalBonusTickets - userManager.user.playedBonusTickets)

		local remainingTickets = T "Remaining ticket"
		if(nbTickets > 1) then
			remainingTickets = T "Remaining tickets"
		end

		viewManager.newText({
			parent 			= hud.popup, 
			text 				= remainingTickets .. " : ",         
			x 					= display.contentWidth * 0.5,
			y 					= display.contentHeight*0.6,
		})

		hud.iconTicket 			= display.newImage( hud.popup, "assets/images/hud/InstantTicket_Picto1.png")
		hud.iconTicket.x 			= display.contentWidth * 0.44
		hud.iconTicket.y 			= display.contentHeight*0.67

		viewManager.newText({
			parent 			= hud.popup, 
			text	 			= nbTickets,     
			x 					= display.contentWidth * 0.5 + 55,
			y 					= display.contentHeight*0.67,
			font				= NUM_FONT,
			fontSize 		= 40,
			referencePoint = display.CenterRightReferencePoint
		})

		--------------------------

		hud.popup.close 				= display.newImage( hud.popup, I "popup.Bt_close.png")
		hud.popup.close.x 			= display.contentWidth*0.5
		hud.popup.close.y 			= display.contentHeight*0.84

		utils.onTouch(hud.popup.close, function() viewManager.closePopup() end)

	end)

end

-----------------------------------------------------------------------------------------

function showPoints(nbPoints)
--	local text = viewManager.newText({
--		parent 			= hud, 
--		text	 			= "+ " .. nbPoints,     
--		x 					= display.contentWidth*0.97,
--		y 					= display.contentHeight*0.05,
--		fontSize 		= 65
--	})
--
--	transition.to(text, { time=1500, alpha=0, x=display.contentWidth*0.84 })

	local plural = ""
	if(nbPoints > 1) then plural = 's' end
	message("+ " .. nbPoints .. " pt" .. plural)
end

-----------------------------------------------------------------------------------------

function message(message)

	if(hud.messager) then
		transition.to(hud.messager, { time=300, alpha=0 } )
	end
	
	hud.messager = display.newGroup()
	hud.messager.y = -200

	hud.messager.popupRect 		= drawBorder( hud.messager, 
		0, HEADER_HEIGHT, 
		display.contentWidth+100, HEADER_HEIGHT*0.6,
		240,240,240
	)  
	hud.messager.popupRect.x = display.contentWidth*0.5
	hud.messager.popupRect.alpha = 0.95
	
	hud.messager.text = viewManager.newText({
		parent 			= hud.messager, 
		text	 			= message,     
		x 					= display.contentWidth*0.5,
		y 					= HEADER_HEIGHT - 12,
		fontSize 		= 35
	})

	hud.messager.text:setTextColor(5)
	
	transition.to(hud.messager, { time=500, y=-HEADER_HEIGHT/2 - 5, onComplete=function()
		timer.performWithDelay(2000, function()
			transition.to(hud.messager, { time=500, y=-200} )
		end)
	end })
end

-----------------------------------------------------------------------------------------

function closePopup(now, action)
	
	if(hud.popup) then
   	display.remove(hud.popup.close)
   	transition.cancel(hud.popup)
   	
   	if(not now) then
      	transition.to(hud.popup, {time=250, alpha=0, onComplete=function()
      		utils.emptyGroup(hud.popup)
      		if(action) then
      			action()
      		end
      	end})
      
      else
   		utils.emptyGroup(hud.popup)
   		if(action) then
   			action()
   		end
      end
      
   end
   
end

function showPopup(action)

	closePopup(true)
	hud.popup = display.newGroup()

	hud.backGrey 		= drawBorder( hud.popup, 
		0, 0, 
		display.contentWidth+50, display.viewableContentHeight+50,
		50,50,50
	)  
	hud.backGrey.x 	= display.viewableContentWidth*0.5 
	hud.backGrey.y 	= display.viewableContentHeight*0.5
	hud.backGrey.alpha= 0.85
	
	hud.popupRect = display.newImageRect( hud.popup, "assets/images/hud/Popup_BG.png", display.contentWidth*0.95, display.contentHeight*0.95)
  	hud.popupRect.x = display.contentWidth*0.5 
  	hud.popupRect.y = display.contentHeight*0.5
	
	hud.popup:toFront()
	
	utils.onTouch(hud.backGrey, function()end)
	utils.onTouch(hud.popupRect, function()end)
end

------------------------------------------------------------------

function refreshHomeTimer()
	
	if(hud.timer) then timer.cancel(hud.timer) end

	local days,hours,min,sec = utils.getDaysHoursMinSec(math.round((lotteryManager.nextDrawing.date/1000 - os.time())))
	
	if(days < 10) then days = "0"..days end 
	if(hours < 10) then hours = "0"..hours end 
	if(min < 10) then min = "0"..min end 
	if(sec < 10) then sec = "0"..sec end 
	
	hud.timerDisplay.text = days .. " : " .. hours .. " : " .. min .. " : " .. sec
	hud.timer = timer.performWithDelay(1000, function ()
		refreshHomeTimer()
	end)
end

------------------------------------------------------------------

function refreshPopupTimer(lastTime)
	
	if(hud.popup.timer) then timer.cancel(hud.popup.timer) end
	if(not hud.popup.timerDisplay) then return end

	local now = os.time() * 1000
	local hoursSpent, minSpent, secSpent, msSpent = utils.getHoursMinSecMillis(now - lastTime)
	
--	local h = 1 - tonumber(hoursSpent)
	local m = 59 - tonumber(minSpent)
	local s = 59 - tonumber(secSpent)
	
--	if(h < 10) then h = "0"..h end 
	if(m < 10) then m = "0"..m end 
	if(s < 10) then s = "0"..s end 
	
--	hud.popup.timerDisplay.text = h .. " : " .. m .. " : " .. s
	hud.popup.timerDisplay.text = m .. " : " .. s
	hud.popup.timer = timer.performWithDelay(1000, function ()
		refreshPopupTimer(lastTime)
	end)
end

------------------------------------------------------------------

function animatePrice(nextMillis)
	
	if(not nextMillis) then nextMillis = 3 end
	
	timer.performWithDelay(nextMillis, function()
   	local lotteryPriceDollars = lotteryManager:priceDollars(lotteryManager.nextDrawing)
   	local priceToReach = utils.countryPrice(lotteryPriceDollars, COUNTRY, lotteryManager.nextDrawing.rateUSDtoEUR)
   	
   	local ratio = (20 * priceToReach)/(priceToReach - hud.priceCurrentDisplay)
   	local toAdd = math.floor(priceToReach/ratio)
   	if(toAdd == 0) then toAdd = 1 end
   	
		hud.priceCurrentDisplay = math.round(hud.priceCurrentDisplay + toAdd)
		
		if(hud.priceCurrentDisplay >= priceToReach) then
			hud.priceCurrentDisplay = math.round(priceToReach)	
		else
			nextMillis = 1000/(priceToReach - hud.priceCurrentDisplay)
   		animatePrice(nextMillis)
   	end
		
		hud.priceDisplay.text = utils.displayPrice(hud.priceCurrentDisplay, COUNTRY)
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
function drawTheme(parent, lottery, num,x,y, alpha, requireCheck, bigBall)

	if(not alpha) then alpha = 1 end

	local scale = SMALL_THEME_SCALE
	if(bigBall) then 
		scale = 0.78
	end

	drawThemeIcon(num, parent, lottery, x, y, scale, alpha, function()
		local themeMask = display.newImage(parent, "assets/images/balls/ball.mask.png")
		themeMask.x = x
		themeMask.y = y
		themeMask.alpha = alpha
		themeMask:scale(scale, scale)
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

function drawBall(parent, num,x,y, bigBall)
	
	local size = "small"
	local fontSize = 37
	if(bigBall) then 
		size = "big"
		fontSize = 45 
	end
	
	local ball = display.newImage(hud, "assets/images/balls/ball.".. size..".green.png")
	ball.x = x
	ball.y = y
	
	parent:insert(ball)
	
	ball.text = display.newText( {
		text = num,     
		x = x,
		y = y,
		font = NUM_FONT,   
		fontSize = fontSize,
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
	local y 				= display.contentHeight*0.31

	-------------------------------------

	for j = 1,#numbers-1 do
		drawBall(parent, numbers[j], xGap*j, y, true)
	end
	
	drawTheme(parent, lotteryManager.nextLottery, numbers[#numbers], xGap*#numbers, y, 1, false, true)
	
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