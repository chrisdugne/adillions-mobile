----------------------------------------------------------------------------

Vungle = {}

----------------------------------------------------------------------------

function Vungle:new()

    local object = {
        afterVideoSeen      = nil,
        vungleON            = false
    }

    setmetatable(object, { __index = Vungle })
    return object
end

----------------------------------------------------------------------------

function Vungle:init()
    local appId = ""

    if (ANDROID) then
        appId = "adillions.android"
    else
        appId = "com.adillions.v1"
    end

    print("Vungle init : " .. appId)
    vungleON = false
    ads.init( "vungle", appId , function(event) self:adListener(event) end )
end

----------------------------------------------------------------------------

function Vungle:tryToShowAd(retrying)

    if(not retrying) then
        self.vungleON = true
    end

    native.setActivityIndicator( true )

    print("Vungle tryToShowAd")
    ads.show( "incentivized", {
        isBackButtonEnabled = true,
    } )

end

----------------------------------------------------------------------------

function Vungle:adListener(event)

    native.setActivityIndicator( false )

    print("Vungle adListener", event)
    if(event.isError) then
        viewManager.message(T "Vungle has no ad, please try later")
        self.afterVideoSeen = nil
        self.vungleON = false

    elseif event.type == "adStart" then


    elseif event.type == "adEnd" then

        if(self.afterVideoSeen) then
            self.afterVideoSeen()
        end

        self.afterVideoSeen = nil
        self.vungleON = false

    end
end

----------------------------------------------------------------------------

return Vungle