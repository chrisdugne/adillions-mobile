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
	print("videoManager.play")
	if(SIMULATOR) then
   	print("simulator : afterVideoSeen")
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