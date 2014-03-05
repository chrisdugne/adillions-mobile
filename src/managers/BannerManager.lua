-----------------------------------------------------------------------------------------

BannerManager = {} 

-----------------------------------------------------------------------------------------

function BannerManager:new()  

    local object = {
        banners     = {},
        needle      = 0,
        timing      = 3000
    }

    setmetatable(object, { __index = BannerManager })
    return object
end

-----------------------------------------------------------------------------------------

function BannerManager:start()
    self:next()
end

-----------------------------------------------------------------------------------------

function BannerManager:next()
    
    if(router.view ~= router.HOME) then
        return
    end
    
    self:createNewBanner()
    
    if(hud.currentBanner) then
        transition.to(hud.currentBanner, {alpha = 0})
    end
    
    transition.to(hud.newBanner, {alpha = 1, onComplete = function() 
        display.remove(hud.currentBanner) 
        hud.currentBanner = hud.newBanner
    end})
    
    timer.performWithDelay(self.timing, function()
        self:next()
    end)
    
end

-----------------------------------------------------------------------------------------

function BannerManager:createNewBanner()

    hud.newBanner = display.newGroup()
    hud.newBanner.contentWidth = display.contentWidth    
    hud.newBanner.contentHeight = display.contentHeight * 0.3
    hud.newBanner.x = 0
    hud.newBanner.alpha = 0
    hud.newBanner.y = display.contentHeight * 0.6
    hud:insert(hud.newBanner)
    
    hud.newBanner:toBack() 
    hud.subheaderBG:toBack() 
    
    self.needle = self.needle + 1
    if(self.needle > #self.banners) then self.needle = 1 end
    
    local source    = self.banners[self.needle].source
    local elements  = self.banners[self.needle].elements
    
    for i = 1,#elements do
        
        if(elements[i].type == "text") then
            self:drawText(source, elements[i])
        
        elseif(elements[i].type == "image") then
            self:drawImage(source, elements[i])
            
        end
    end
end

-----------------------------------------------------------------------------------------

function BannerManager:drawText(source, element)
    
    local url = source .. "/" .. LANG ..  "/" .. element.name 
    
    viewManager.drawRemoteImage(
        url, 
        hud.newBanner, 
        hud.newBanner.contentWidth  * element.x, 
        hud.newBanner.contentHeight * element.y, 
        1, 1, 
        function(image) image:toBack() end,
        "_" .. self.needle
    )
    
end

-----------------------------------------------------------------------------------------

function BannerManager:drawImage()

end

-----------------------------------------------------------------------------------------

return BannerManager