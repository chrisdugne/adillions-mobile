-----------------------------------------------------------------------------

VideoManager = {}

-----------------------------------------------------------------------------

function VideoManager:new()

    local object = {
        afterVideoSeen  = nil,
        nbVideoToSee    = 0
    }

    setmetatable(object, { __index = VideoManager })
    return object
end

-----------------------------------------------------------------------------

function VideoManager:play(afterVideoSeen, resetCounter)

    self.afterVideoSeen = afterVideoSeen

    if(resetCounter) then
        self.nbVideoToSee = 1
    end

    if(SIMULATOR or self.nbVideoToSee == 0) then
        self.afterVideoSeen()

    else
        self.nbVideoToSee = self.nbVideoToSee - 1
        self.tryYume = 0
        self:playYume()
--        self:playVungle()
    end
end

-----------------------------------------------------------------------------

function VideoManager:playYume()
    print('playYume')
    self.tryYume = self.tryYume + 1

    self.webView = native.newWebView(
        display.viewableContentWidth*0.5,
        display.viewableContentHeight*0.5,
        display.viewableContentWidth+5,
        display.viewableContentHeight+5
    )

    local platform      = "Android"
--    if(IOS) then platform = "IOS" end
--    local url           = OLD_API_URL .. "mvideo" .. platform .. "?lang=" .. LANG

    local url           = OLD_API_URL .. "mvideo?lang=" .. LANG
    self.listener       = function(event) self:videoListener(event) end

    self.webView:request( url )
    self.webView:addEventListener( "urlRequest", self.listener)
end

-----------------------------------------------------------------------------

function VideoManager:playVungle()
    print('playVungle')
    vungle.afterVideoSeen = self.afterVideoSeen
    vungle:tryToShowAd()
end

-----------------------------------------------------------------------------

function VideoManager:closeYumeVideo(event)
    self.webView:removeEventListener( "urlRequest", self.listener )
    self.webView:removeSelf()
    self.webView = nil
end

-----------------------------------------------------------------------------

function VideoManager:videoListener(event)

    if event.url then
        print(event.url)

        if event.url == OLD_API_URL .. "yume_completed?status=true" then

            print('--> 1 : ok')
            self:closeYumeVideo()
            self.afterVideoSeen()

        elseif  event.url == OLD_API_URL .. "yume_completed?status=false"
        or      event.url == OLD_API_URL .. "yume_wrong_playing" then
            print('--> 2 : retry or leave  ' .. self.tryYume)
            self:closeYumeVideo()
            if(self.tryYume < 2 ) then
                self:playYume()
            else
                timer.performWithDelay(200, function()
                    self:playVungle()
                end)
            end

        elseif  event.url == OLD_API_URL .. "yume_novideo"
        or      event.url == OLD_API_URL .. "yume_error" then
            print('--> 3 : leave')
            self:closeYumeVideo()
            timer.performWithDelay(200, function()
                self:playVungle()
            end)
        end

    end

end

-----------------------------------------------------------------------------

return VideoManager