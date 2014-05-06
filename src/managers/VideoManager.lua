-----------------------------------------------------------------------------------------

VideoManager = {} 

-----------------------------------------------------------------------------------------

function VideoManager:new()  

    local object = {
        afterVideoSeen  = nil,
        nbVideoToSee    = 0
    }

    setmetatable(object, { __index = VideoManager })
    return object
end

-----------------------------------------------------------------------------------------

function VideoManager:play(afterVideoSeen, resetCounter)

    self.afterVideoSeen = afterVideoSeen
    
    if(resetCounter) then
        self.nbVideoToSee = 1
    end
    
    if(self.nbVideoToSee == 0) then
        self.afterVideoSeen()

    else
        self.nbVideoToSee = self.nbVideoToSee - 1
        self:playYume()
    end
end

-----------------------------------------------------------------------------------------

function VideoManager:playYume()
    self.webView = native.newWebView( 
        display.contentCenterX, 
        display.contentCenterY, 
        display.contentWidth, 
        display.contentHeight
    )

    local platform      = "IOS"
    if(ANDROID) then platform = "Android" end
    
    local url           = SERVER_URL .. "mvideo" .. platform .. "?lang=" .. LANG
    self.listener       = function(event) self:videoListener(event) end

    self.webView:request( url )
    self.webView:addEventListener( "urlRequest", self.listener) 
end

-----------------------------------------------------------------------------------------

function VideoManager:playVungle()
    vungle.afterVideoSeen = self.afterVideoSeen
    vungle:tryToShowAd()
end

-----------------------------------------------------------------------------------------

function VideoManager:closeYumeVideo(event)
    self.webView:removeEventListener( "urlRequest", self.listener )
    self.webView:removeSelf()
    self.webView = nil
end

-----------------------------------------------------------------------------------------

function VideoManager:videoListener(event)
    
    if event.url then
        print(event.url)

        if event.url == SERVER_URL .. "yume_completed?status=true" then
            print("Completed ! ")
            self:closeYumeVideo()
            self.afterVideoSeen()
                 
        elseif  event.url == SERVER_URL .. "yume_novideo" 
        or      event.url == SERVER_URL .. "yume_completed?status=false"
        or      event.url == SERVER_URL .. "yume_error" then
            print("Error !")
            self:closeYumeVideo()  
            self:playVungle()  
        end

    end

end

-----------------------------------------------------------------------------------------

return VideoManager