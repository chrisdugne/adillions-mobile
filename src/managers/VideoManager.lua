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
        self.tryYume = 0 
        self:playYume()
    end
end

-----------------------------------------------------------------------------------------

function VideoManager:playYume()
    
    self.tryYume = self.tryYume + 1
     
    self.webView = native.newWebView( 
        display.contentCenterX, 
        display.contentCenterY, 
        display.contentWidth, 
        display.contentHeight
    )

    local platform      = "Android"
--    if(IOS) then platform = "IOS" end
--    local url           = API_URL .. "mvideo" .. platform .. "?lang=" .. LANG
    
    local url           = API_URL .. "mvideo?lang=" .. LANG
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

        if event.url == API_URL .. "yume_completed?status=true" then
            self:closeYumeVideo()
            self.afterVideoSeen()
                 
        elseif  event.url == API_URL .. "yume_completed?status=false"
        or      event.url == API_URL .. "yume_wrong_playing" then
            self:closeYumeVideo()
            if(self.tryYume < 3 ) then
                self:playYume()
            else
                self:playVungle()  
            end

        elseif  event.url == API_URL .. "yume_novideo" 
        or      event.url == API_URL .. "yume_error" then
            self:closeYumeVideo()  
            self:playVungle()  
        end

    end

end

-----------------------------------------------------------------------------------------

return VideoManager