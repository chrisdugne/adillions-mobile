-----------------------------------------------------------------------------------------

VideoManager = {}	

-----------------------------------------------------------------------------------------

function VideoManager:new()  

	local object = {
	}

	setmetatable(object, { __index = VideoManager })
	return object
end

-----------------------------------------------------------------------------------------

function VideoManager:play(afterVideoSeen)

	if(SIMULATOR or userManager.user.extraTickets > 0) then
		if(afterVideoSeen == router.openFillLotteryTicket) then
			viewManager.message(T "Extra Ticket" .. "!")
		end
		afterVideoSeen()
	else
   	sponsorpayTools.afterVideoSeen = afterVideoSeen
   	vungle.afterVideoSeen = afterVideoSeen
   
   --	sponsorpayTools:requestOffers()
   	vungle:tryToShowAd()
   end
end

-----------------------------------------------------------------------------------------

return VideoManager