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
		utils.vardump(result)
		self.nextLottery = json.decode(result.response)
		self.nextLottery.theme = json.decode(self.nextLottery.theme)
		
		utils.vardump(self.nextLottery)
		
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
	return "_Tirage du " .. os.date("%d/%m/%Y", lottery.date/1000)
end

-----------------------------------------------------------------------------------------

function LotteryManager:isGameAvailable()
	return userManager.user.availableTickets + userManager.user.totalBonusTickets - userManager.user.playedBonusTickets  > 0
end

-----------------------------------------------------------------------------------------

function LotteryManager:addToSelection(num)
	self.currentSelection[#self.currentSelection+1] = num
	self:refreshNumberSelectionDisplay()
	
	hud.balls[num].alpha = 1
	hud.balls[num].text:setTextColor(255)
	hud.balls[num].selected = true
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

	hud.balls[num].alpha = 0.3
	hud.balls[num].text:setTextColor(0)
	hud.balls[num].selected = false
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
	local marginLeft 	=  -display.contentWidth *0.014
	local xGap 			=  display.contentWidth *0.11
	local y 				= 	hud.gridPanel.contentHeight + HEADER_HEIGHT/2
	
	-------------------------------------
	
	viewManager.drawBorder(hud.selection, display.contentWidth*0.4, y, display.contentWidth*0.78, TICKET_HEIGHT)
	
	-------------------------------------
	-- numbers
	
	for i = 1,self.nextLottery.maxPicks do
		local num = self.currentSelection[i]
		if(self.currentSelection[i]) then
			viewManager.drawSelectedBall(num, marginLeft + xGap*i, y, function()
				self:removeFromSelection(num)
			end)
			nbSelected = nbSelected + 1 
		end
	end

	-------------------------------------
	-- ok button

	if(#self.currentSelection == self.nextLottery.maxPicks) then
		viewManager.drawButton(hud.selection, "_ok !", display.contentWidth*0.89, y, function()
			
			sponsorpayTools.afterVideoSeen = router.openSelectAdditionalNumber
			vungle.afterVideoSeen = router.openSelectAdditionalNumber
			
			sponsorpayTools:requestOffers()
		end,
		110)

		-------------------------------------
		-- text pick more

--	else
--		viewManager.newText({
--			parent = hud.selection, 
--			text = "_PICK " .. (self.nextLottery.maxPicks - #self.currentSelection) .. " more numbers",  
--			x = display.contentWidth*0.3,
--			y = display.contentHeight*0.71,
--			fontSize = 30,
--		})

	end
	--	
	--	if(nbSelected == LotteryManager.nextLottery.maxPicks+1) then
	--   	viewManager.drawSelectedBall("_OK !", display.contentWidth*0.9, display.contentHeight*0.7, function()
	--   		self:validateSelection()
	--   	end)
	--   end
end

-----------------------------------------------------------------------------------------

function LotteryManager:refreshThemeSelectionDisplay()

	-------------------------------------
	-- erase
	
	utils.emptyGroup(hud.selection)

	-------------------------------------
	-- display
	
	local nbSelected  = 0
	local marginLeft 	=  -display.contentWidth *0.014
	local xGap 			=  display.contentWidth *0.11
	
	-------------------------------------
	-- numbers
	
	for i = 1,self.nextLottery.maxPicks do
		local num = self.currentSelection[i]
		viewManager.drawSelectedBall(num, marginLeft + xGap*i, display.contentHeight*0.7)
		if(self.currentSelection[i]) then nbSelected = nbSelected + 1 end
	end

	-------------------------------------
	-- additional theme

	viewManager.drawSelectedAdditional(self.currentAdditionalBall, marginLeft + xGap*(self.nextLottery.maxPicks+1) + 20, display.contentHeight*0.7, function()
		self:cancelAdditionalSelection()
	end)
	
	if(self.currentAdditionalBall) then nbSelected = nbSelected + 1 end

	-------------------------------------
	-- ok button
	
	if(nbSelected == self.nextLottery.maxPicks+1) then
	
		viewManager.drawButton(hud.selection, "_ok !", display.contentWidth*0.5, display.contentHeight*0.8, function()
   		self:validateSelection()
		end,
		110)
	
   end
end

-----------------------------------------------------------------------------------------

function LotteryManager:validateSelection()
	self.currentSelection[self.nextLottery.maxPicks+1] = self.currentAdditionalBall.num
	userManager:storeLotteryTicket(self.currentSelection)
end

-----------------------------------------------------------------------------------------

return LotteryManager