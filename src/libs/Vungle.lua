-----------------------------------------------------------------------------------------

Vungle = {}	

-----------------------------------------------------------------------------------------

function Vungle:new()  

	local object = {
		afterVideoSeen = nil
	}

	setmetatable(object, { __index = Vungle })
	return object
end

-----------------------------------------------------------------------------------------

function Vungle:init()
	ads.init( "vungle", "com.adillions" , function(event) self:adListener(event) end )
end

-----------------------------------------------------------------------------------------

function Vungle:adListener(event)

	-- video ad not yet downloaded and available
	if event.type == "adStart" and event.isError then
		print("Downloading video ad ...")
		-- wait 5 seconds before retrying to display ad
		timer.performWithDelay(1000, function() self.tryToShowAd() end)
		-- video ad displayed and then closed

	elseif event.type == "adEnd" then
		print ( "videoSeen" )
		if(self.afterVideoSeen) then
			self.afterVideoSeen()
		end

		print("--- vungle false")
		native.setActivityIndicator( false )
		self.afterVideoSeen = nil

	else
		print( "Received event:")
		utils.vardump( event )
	end
end

-----------------------------------------------------------------------------------------

function Vungle:tryToShowAd()

	print("--- vungle true")
	native.setActivityIndicator( true )
	ads.show( "incentivized", { 
		isBackButtonEnabled = true, 
		isCloseShown = false 
	} )
end

-----------------------------------------------------------------------------------------

return Vungle