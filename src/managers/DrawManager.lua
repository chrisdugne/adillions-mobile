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
	end)
end

-----------------------------------------------------------------------------------------

function DrawManager:startSelection()
	self.currentSelection = {}
end

function DrawManager:addToSelection(num)
	self.currentSelection[#self.currentSelection+1] = num
end

function DrawManager:removeFromSelection(num)
	local indexToDelete
	for k,n in pairs(self.currentSelection) do
		if(num == n) then
			indexToDelete = k
		end 
	end
	table.remove(self.currentSelection, indexToDelete)
end

function DrawManager:canAddToSelection()
	return #self.currentSelection < self.nextDraw.maxPicks
end

-----------------------------------------------------------------------------------------

return DrawManager