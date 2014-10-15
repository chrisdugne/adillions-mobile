--------------------------------------------------------------------------------

BannerManager = {}

--------------------------------------------------------------------------------

function BannerManager:new()

    local object = {
        banners = {},
        needle  = 0,
        timing  = 5000
    }

    setmetatable(object, { __index = BannerManager })
    return object
end

--------------------------------------------------------------------------------

function BannerManager:reset()
    if(self.timer) then
        timer.cancel(self.timer)
    end
end

--------------------------------------------------------------------------------

function BannerManager:start()
    self:reset()
    self:next()
end

--------------------------------------------------------------------------------

function BannerManager:stop()
    self:reset()
    display.remove(hud.currentBanner)
end

--------------------------------------------------------------------------------

function BannerManager:next()

    if(router.view ~= router.HOME) then
        return
    end

    self:prepareNewBanner()
    self:applyBanner()

    self.timer = timer.performWithDelay(self.timing, function()
        self:next()
    end)

end

--------------------------------------------------------------------------------

function BannerManager:waitingForDrawing(lottery)

    if(router.view ~= router.HOME) then
        return
    end

    self:createNewBanner()

    ------------------------

    local bg = display.newImageRect(
        hud.newBanner,
        "assets/images/hud/home/winnings.bg.png",
        display.contentWidth,
        display.contentHeight * 0.32
    )

    bg.x = display.viewableContentWidth*0.5
    bg.y = display.contentHeight*0.16

    ------------------------

    local marginLeft = display.contentWidth  * 0.077
    local xGap       = display.contentWidth  * 0.12
    local ballsY     = display.contentHeight * 0.15
    local numbers    = lottery.result

    ------------------------

    if(numbers) then

        local text1   = display.newImage(
            hud.newBanner,
            I "banner.winningselection.png"
        )

        text1.anchorX = 0
        text1.x       = display.viewableContentWidth*0.01
        text1.y       = display.contentHeight*0.03

        local text2 = display.newImage(
            hud.newBanner,
            I "banner.winners.png"
        )

        text2.x = display.viewableContentWidth*0.5
        text2.y = display.contentHeight*0.235


        for j = 1,#numbers-1 do
            viewManager.drawBall(
                hud.newBanner,
                numbers[j],
                marginLeft + xGap*j,
                ballsY
            )
        end

        viewManager.drawTheme(
            hud.newBanner,
            lottery,
            numbers[#numbers],
            marginLeft + xGap*#numbers,
            ballsY
        )

    ------------------------

    else
        local text2 = display.newImage( hud.newBanner, I "waitingdrawing.png")
        text2.x     = display.viewableContentWidth*0.5
        text2.y     = display.contentHeight*0.15

    end

    ------------------------

    self:applyBanner()

end

--------------------------------------------------------------------------------

function BannerManager:prepareNewBanner()
    self.needle = self.needle + 1
    if(self.needle > #self.banners) then self.needle = 1 end

    self:createNewBanner()
    local banner = self.banners[self.needle]

    for i = 1,#banner.elements do
        self:drawComponent(banner.source, banner.elements[i], hud.newBanner, i)
    end
end

--------------------------------------------------------------------------------

function BannerManager:createNewBanner()

    hud.newBanner = display.newGroup()
    hud.newBanner.contentWidth = display.contentWidth
    hud.newBanner.contentHeight = display.contentHeight * 0.3
    hud.newBanner.x = 0
    hud.newBanner.alpha = 0
    hud.newBanner.y = display.contentHeight * 0.6
    hud:insert(hud.newBanner)

    hud.newBanner:toBack()
end

--------------------------------------------------------------------------------

function BannerManager:applyBanner()
    if(hud.currentBanner) then
        transition.to(hud.currentBanner, {alpha = 0})
    end

    transition.to(hud.newBanner, {alpha = 1, onComplete = function()
        display.remove(hud.currentBanner)
        hud.currentBanner = hud.newBanner
    end})
end

--------------------------------------------------------------------------------

function BannerManager:drawComponent(source, element, parent, position)

    if(element.action
    and element.action == 3
    and not userManager.user.networks.connectedToFacebook)
    then
        return
    end

    if(element.type == "text") then
        source = source .. "/" .. LANG
    end

    local url = source .. "/" .. element.name
    local banner = self.needle

    viewManager.drawRemoteImage(
        url,
        parent,
        position,
        parent.contentWidth  * element.x,
        parent.contentHeight * element.y,
        element.anchorX     or 0.5,
        element.anchorY     or 0.5,
        element.scaleX      or 1,
        element.scaleY      or 1,
        function(image)
            if(self.needle ~= banner) then
                display.remove(image)
            else
                if(element.action) then
                    utils.onTouch(image, function()
                        bannerManager:action(source, element)
                    end)
                end
            end
        end,
        "_" .. self.needle,
        element.fitToScreen,
        element.height
    )

end

--------------------------------------------------------------------------------

function BannerManager:action(source, element)

    if(element.action == 0) then
        viewManager.openWeb(element.url, function() end)
    end

    if(element.action == 1) then
        shareManager:inviteForInstants()
    end

    if(element.action == 2) then
        self:openPopup(source, element.actionContent)
    end

    if(element.action == 3) then
        shareManager:simplePost(element.share)
    end

end

--------------------------------------------------------------------------------

function BannerManager:openPopup(source, elements)

    local popup = viewManager.showPopup()

    --------------------------

    for i = 1,#elements do
        self:drawComponent(source, elements[i], popup, i)
    end

    --------------------------

    popup.close         = display.newImage( popup, "assets/images/hud/CroixClose.png")
    popup.close.x       = display.contentWidth*0.88
    popup.close.y       = display.contentHeight*0.09

    utils.onTouch(popup.close, function()
        viewManager.closePopup(popup)
    end)

end

--------------------------------------------------------------------------------

return BannerManager
