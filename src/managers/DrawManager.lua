-----------------------------------------------------------------------------------------

DrawManager = {}	

-----------------------------------------------------------------------------------------

function DrawManager:new()  

	local object = {
		nextDraw = {},
		currentSelection = {}
	}

	setmetatable(object, { __index = DrawManager })
	return object
end

-----------------------------------------------------------------------------------------

function DrawManager:getNextDraw()
	utils.postWithJSON(
	{}, 
	SERVER_URL .. "nextDraw", 
	function(result)
		drawManager.nextDraw = json.decode(result.response)
		drawManager.nextDraw.theme = json.decode(drawManager.nextDraw.theme)
	end)
end

-----------------------------------------------------------------------------------------

function DrawManager:addToSelection(num)
	self.currentSelection[#self.currentSelection+1] = num
	self:refreshSelectionOkButton()
end

function DrawManager:removeFromSelection(num)
	local indexToDelete
	for k,n in pairs(self.currentSelection) do
		if(num == n) then
			indexToDelete = k
		end 
	end
	table.remove(self.currentSelection, indexToDelete)
	self:refreshSelectionOkButton()
end

function DrawManager:canAddToSelection()
	return #self.currentSelection < self.nextDraw.maxPicks
end

function DrawManager:refreshSelectionOkButton()
	utils.emptyGroup(hud.selection)
	
	if(#self.currentSelection == drawManager.nextDraw.maxPicks) then 
   	viewManager.drawSelectedBall("_ok", display.contentWidth*0.8, display.contentHeight*0.75, function()
   		table.sort(self.currentSelection)
   		router.openSelectAdditionalNumber()
   	end)
   else
      local text = display.newText( {
   		parent = hud.selection,
   		text = "_PICK " .. (drawManager.nextDraw.maxPicks - #self.currentSelection) .. " more numbers",     
   		x = display.contentWidth*0.7,
   		y = display.contentHeight*0.75,
   		font = FONT,   
   		fontSize = 40,
   	} )
	end
end

-----------------------------------------------------------------------------------------

function DrawManager:addToAdditionalSelection(ball)
	if(self.currentAdditionalBall) then
		self.currentAdditionalBall.selected = false
		self.currentAdditionalBall.alpha = 0.3
	end
	
	self.currentAdditionalBall = ball
	self.currentAdditionalBall.selected = true
	self.currentAdditionalBall.alpha = 1
	self:refreshSelectionDisplay()
end

function DrawManager:cancelAdditionalSelection()
	self.currentAdditionalBall.selected = false
	self.currentAdditionalBall.alpha = 0.3
	self.currentAdditionalBall = nil
	self:refreshSelectionDisplay()
end

-----------------------------------------------------------------------------------------

function DrawManager:startSelection()
	self.currentSelection = {}
	self.currentAdditionalBall = nil
	self:refreshSelectionOkButton()
end

-----------------------------------------------------------------------------------------

function DrawManager:refreshSelectionDisplay()

	-------------------------------------
	-- erase
	
	utils.emptyGroup(hud.selection)

	-------------------------------------
	-- display
	
	local nbSelected  = 0
	local marginLeft 	=  -display.contentWidth *0.02
	local xGap 			=  display.contentWidth *0.12
	
	-------------------------------------
	-- numbers
	
	for i = 1,drawManager.nextDraw.maxPicks do
		local num = self.currentSelection[i]
		viewManager.drawSelectedBall(num, marginLeft + xGap*i, display.contentHeight*0.7)
		if(self.currentSelection[i]) then nbSelected = nbSelected + 1 end
	end

	-------------------------------------
	-- additional theme

	viewManager.drawSelectedAdditional(self.currentAdditionalBall, marginLeft + xGap*(drawManager.nextDraw.maxPicks+1), display.contentHeight*0.7, function()
		self:cancelAdditionalSelection()
	end)
	
	if(self.currentAdditionalBall) then nbSelected = nbSelected + 1 end

	-------------------------------------
	-- ok button
	
	if(nbSelected == drawManager.nextDraw.maxPicks+1) then
   	viewManager.drawSelectedBall("_OK !", display.contentWidth*0.9, display.contentHeight*0.7, function()
   		self:validateSelection()
   	end)
   end
end

-----------------------------------------------------------------------------------------

function DrawManager:validateSelection()
	self.currentSelection[drawManager.nextDraw.maxPicks+1] = self.currentAdditionalBall.num
	userManager:storeDrawTicket(self.currentSelection)
end

-----------------------------------------------------------------------------------------

return DrawManager