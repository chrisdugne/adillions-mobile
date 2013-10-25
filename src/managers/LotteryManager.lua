-----------------------------------------------------------------------------------------

LotteryManager = {}	

-----------------------------------------------------------------------------------------

function LotteryManager:new()  

	local object = {
		nextLottery = {},
		currentSelection = {}
	}

	setmetatable(object, { __index = LotteryManager })
	return object
end

-----------------------------------------------------------------------------------------

function LotteryManager:refreshNextLottery(draw)
	utils.postWithJSON(
	{}, 
	SERVER_URL .. "nextLottery" .. "?nocache=" .. system.getTimer(), 
	function(result)
	
		self.nextLottery = json.decode(result.response)
		self.nextLottery.theme = json.decode(self.nextLottery.theme)
		
		userManager:checkUserCurrentLottery()
		draw()
	end)
end

function LotteryManager:getFinishedLotteries(next)
	utils.postWithJSON(
	{}, 
	SERVER_URL .. "finishedLotteries", 
	function(result)
		self.finishedLotteries = json.decode(result.response)
		utils.tprint(self.finishedLotteries)
		next()
	end)
end

-----------------------------------------------------------------------------------------

function LotteryManager:price(lottery)
	return math.min(lottery.maxPrice, math.max(lottery.minPrice, lottery.nbTickets/1000 * lottery.cpm))  .. "  $"
end

function LotteryManager:date(lottery)
	return utils.timestampToReadableDate(lottery.date, true)
end

-----------------------------------------------------------------------------------------

function LotteryManager:refreshNotifications(lotteryDateMillis)

	system.cancelNotification()
	
	if(GLOBALS.options.notificationBeforeDraw) then
		
		local notificationTimeSeconds = os.date( "!*t", lotteryDateMillis/1000 - 48 * 60 * 60 )
		local previousCount = native.getProperty( "applicationIconBadgeNumber" ) or 0 

		local options = {
			alert = T "Next draw in 48h !",
			badge = previousCount + 1,
		}

		system.scheduleNotification( notificationTimeSeconds, options )
	end

	if(GLOBALS.options.notificationAfterDraw) then
		
		local notificationTimeSeconds = os.date( "!*t", lotteryDateMillis/1000 + 3 * 60)
		local previousCount = native.getProperty( "applicationIconBadgeNumber" ) or 0 

		local options = {
			alert = T "This week's results are published !",
			badge = previousCount + 1,
		}

		system.scheduleNotification( notificationTimeSeconds, options )
	end
end

-----------------------------------------------------------------------------------------

function LotteryManager:isGameAvailable()
	return userManager.user.availableTickets + userManager.user.totalBonusTickets - userManager.user.playedBonusTickets  > 0
end

-----------------------------------------------------------------------------------------

function LotteryManager:addToSelection(num)
	self.currentSelection[#self.currentSelection+1] = num
	self:refreshNumberSelectionDisplay()

	viewManager.drawBallPicked(num)
end

function LotteryManager:removeFromSelection(num)
	local indexToDelete
	for k,n in pairs(self.currentSelection) do
		if(num == n) then
			indexToDelete = k
		end 
	end
	table.remove(self.currentSelection, indexToDelete)
	self:refreshNumberSelectionDisplay()

	local x = hud.balls[num].x
	local y = hud.balls[num].y
	display.remove(hud.balls[num])

	viewManager.drawBallToPick(num,x,y)
	
end

function LotteryManager:canAddToSelection()
	return #self.currentSelection < self.nextLottery.maxPicks
end

-----------------------------------------------------------------------------------------

function LotteryManager:addToAdditionalSelection(ball)
	if(self.currentAdditionalBall) then
		self.currentAdditionalBall.selected = false
		self.currentAdditionalBall.alpha = 0.3
	end
	
	self.currentAdditionalBall = ball
	self.currentAdditionalBall.selected = true
	self.currentAdditionalBall.alpha = 1
	self:refreshThemeSelectionDisplay()
end

function LotteryManager:cancelAdditionalSelection()
	self.currentAdditionalBall.selected = false
	self.currentAdditionalBall.alpha = 0.3
	self.currentAdditionalBall = nil
	self:refreshThemeSelectionDisplay()
end

-----------------------------------------------------------------------------------------

function LotteryManager:startSelection()
	self.currentSelection = {}
	self.currentAdditionalBall = nil
	self:refreshNumberSelectionDisplay()
end

-----------------------------------------------------------------------------------------

function LotteryManager:refreshNumberSelectionDisplay()

	-------------------------------------
	-- erase
	
	utils.emptyGroup(hud.selection)
	table.sort(self.currentSelection)
	
	-------------------------------------
	-- display
	
	local nbSelected  = 0
	local marginLeft 	=  hud.selector.x - 360
	local xGap 			=  120
	local top 			= 	hud.selector.y
	
	-------------------------------------
	-- numbers
	
	for i = 1,self.nextLottery.maxPicks do
		local num = self.currentSelection[i]
		if(self.currentSelection[i]) then

			local x = marginLeft + i*xGap

			viewManager.drawSelectedBall(num, x, top, function()
				self:removeFromSelection(num)
			end)

			nbSelected = nbSelected + 1 
		end
	end

	-------------------------------------
	-- ok button

	if(#self.currentSelection == self.nextLottery.maxPicks) then
   	hud.validate = display.newImage( hud.selection, I "ValidateON.png")  
   	hud.validate.x = display.contentWidth*0.5
   	hud.validate.y = display.contentHeight*0.85
   	
   	utils.onTouch(hud.validate, function()
			videoManager:play(router.openSelectAdditionalNumber)
   	end)
   	
   	hud.selector.alpha = 0.3
	else
   	hud.validate = display.newImage( hud.selection, I "ValidateOFF.png")  
   	hud.validate.x = display.contentWidth*0.5
   	hud.validate.y = display.contentHeight*0.85

   	hud.selector.alpha = 1
	end
	
end

-----------------------------------------------------------------------------------------

function LotteryManager:refreshThemeSelectionDisplay()

	-------------------------------------
	-- erase
	
	utils.emptyGroup(hud.selection)

	-------------------------------------
	-- display
	
	local nbSelected  = 0
	local marginLeft 	=  hud.selector.x - 360
	local xGap 			=  100
	local top 			= 	hud.selector.y
	
	-------------------------------------
	-- numbers
	
	for i = 1,self.nextLottery.maxPicks do
		
		local num = self.currentSelection[i]
		local x = marginLeft + i*xGap
		
		viewManager.drawBall(hud, num, marginLeft + xGap*i, display.contentHeight*0.7)
		if(self.currentSelection[i]) then nbSelected = nbSelected + 1 end
		
	end

	-------------------------------------
	-- additional theme

	viewManager.drawSelectedAdditional(self.currentAdditionalBall, marginLeft + xGap*(self.nextLottery.maxPicks+1), display.contentHeight*0.7, function()
		self:cancelAdditionalSelection()
	end)
	
	if(self.currentAdditionalBall) then nbSelected = nbSelected + 1 end

	-------------------------------------
	-- ok button

	if(nbSelected == self.nextLottery.maxPicks+1) then
   	hud.validate = display.newImage( hud.selection, I "ValidateON.png")  
   	hud.validate.x = display.contentWidth*0.5
   	hud.validate.y = display.contentHeight*0.85
   	
   	utils.onTouch(hud.validate, function()
			self:validateSelection()
   	end)
   	
	else
   	hud.validate = display.newImage( hud.selection, I "ValidateOFF.png")  
   	hud.validate.x = display.contentWidth*0.5
   	hud.validate.y = display.contentHeight*0.85
	end
	
end

-----------------------------------------------------------------------------------------

function LotteryManager:validateSelection()
	self.currentSelection[self.nextLottery.maxPicks+1] = self.currentAdditionalBall.num
	userManager:storeLotteryTicket(self.currentSelection)
end

-----------------------------------------------------------------------------------------

return LotteryManager