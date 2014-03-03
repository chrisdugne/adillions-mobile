-----------------------------------------------------------------------------------------

BannerManager = {} 

-----------------------------------------------------------------------------------------

function BannerManager:new()  

    local object = {
        banners     = {},
        needle      = 0,
        timing      = 5000
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
    
    if(hud.banner) then
        display.remove(hud.banner)
    end
    
    hud.banner = display.newGroup()
    hud:insert(hud.banner)
    hud.banner.contentWidth = display.contentWidth    
    hud.banner.contentHeight = display.contentHeight * 0.3
    hud.banner.y = display.contentHeight * 0.6
    hud.banner.anchorY = 0
    
    self.needle = self.needle + 1
    if(self.needle > #self.banners) then self.needle = 1 end
    
    local source    = self.banners[2].source
    local elements  = self.banners[2].elements
    
    for i = 1,#elements do
        
        if(elements[i].type == "text") then
            self:drawText(source, elements[i])
        
        elseif(elements[i].type == "image") then
            self:drawImage(source, elements[i])
            
        end
        
    end
    
    timer.performWithDelay(self.timing, function()
        self:next()
    end)
    
end

-----------------------------------------------------------------------------------------

function BannerManager:drawText(source, element)
    
    local url = source .. "/" .. LANG ..  "/" .. element.name 
    
    viewManager.drawRemoteImage(
        url, 
        hud.banner, 
        hud.banner.contentWidth  * element.x, 
        hud.banner.contentHeight * element.y, 
        1, 1, 
        function(image) image:toBack() end
    )
    
end

-----------------------------------------------------------------------------------------

function BannerManager:drawImage()

end

-----------------------------------------------------------------------------------------

return BannerManager