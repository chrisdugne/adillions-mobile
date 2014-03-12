-----------------------------------------------------------------------------------------

VideoManager = {} 

-----------------------------------------------------------------------------------------

function VideoManager:new()  

    local object = {
        nbVideoToSee = 0
    }

    setmetatable(object, { __index = VideoManager })
    return object
end

-----------------------------------------------------------------------------------------

function VideoManager:play(afterVideoSeen, resetCounter)

    if(resetCounter) then
        self.nbVideoToSee = 1
    end

    if(SIMULATOR) then
--    if(SIMULATOR or userManager.user.extraTickets > 0) then
--    if(ANDROID or SIMULATOR or userManager.user.extraTickets > 0) then
        if(afterVideoSeen == router.openFillLotteryTicket) then
            viewManager.message(T "Instant Ticket" .. "!")
        end
        afterVideoSeen()
    elseif(self.nbVideoToSee == 0) then
        afterVideoSeen()

    else
        self.nbVideoToSee = self.nbVideoToSee - 1
        sponsorpayTools.afterVideoSeen = afterVideoSeen
        vungle.afterVideoSeen = afterVideoSeen

        -- sponsorpayTools:requestOffers()
        vungle:tryToShowAd()
    end
end

-----------------------------------------------------------------------------------------

return VideoManager