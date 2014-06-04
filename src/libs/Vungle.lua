-----------------------------------------------------------------------------------------

Vungle = {} 

-----------------------------------------------------------------------------------------

function Vungle:new()  

    local object = {
        afterVideoSeen      = nil,
        attemptGetVideo     = 0,
        vungleON            = false
    }

    setmetatable(object, { __index = Vungle })
    return object
end

-----------------------------------------------------------------------------------------

function Vungle:init()
    local appId = ""

    if (ANDROID) then
        appId = "adillions.android"
    else
        appId = "com.adillions.v1"
    end

    vungleON = false
    ads.init( "vungle", appId , function(event) self:adListener(event) end )
end

-----------------------------------------------------------------------------------------

function Vungle:tryToShowAd(retrying)

    if(not retrying) then
        self.vungleON = true
        self.attemptGetVideo = 0
    end

    if(self.attemptGetVideo < 4) then
        self.attemptGetVideo = self.attemptGetVideo + 1
        native.setActivityIndicator( true )

        ads.show( "incentivized", { 
            isBackButtonEnabled = true, 
            isCloseShown = false 
        } )
    else
        viewManager.message(T "Vungle has no ad, please try later")
        native.setActivityIndicator( false )
        self.afterVideoSeen = nil
        self.vungleON = false
    end

end

-----------------------------------------------------------------------------------------

function Vungle:adListener(event)

    -- video ad not yet downloaded and available
    if event.type == "adStart" and event.isError then
        print("Downloading video ad ... " .. self.attemptGetVideo )

        -- wait 3 seconds before retrying to display ad
        timer.performWithDelay(3000, function() 
            native.setActivityIndicator( false )
            timer.performWithDelay(50, function() 
                self:tryToShowAd(true)
            end)
        end)
        -- video ad displayed and then closed

    elseif event.type == "adEnd" then
        timer.performWithDelay(50, function() 
            native.setActivityIndicator( false )
        end)

        if(self.afterVideoSeen) then
            self.afterVideoSeen()
        end

        self.afterVideoSeen = nil
        self.vungleON = false

    else
        if(DEV) then
            print( "Vungle | Received an other event :")
            utils.vardump( event )
        end
    end
end

-----------------------------------------------------------------------------------------

return Vungle