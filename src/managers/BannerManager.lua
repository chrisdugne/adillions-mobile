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
    
    if(router.view ~= router.HOME) then
        return
    end
    
    self:createNewBanner()
    
    if(self.currentBanner) then
        transition.to(self.currentBanner, {x = - display.contentWidth})
    end
    
    transition.to(self.newBanner, {x = 0, onComplete = function() 
        display.remove(self.currentBanner) 
        self.currentBanner = self.newBanner 
    end})
    
    timer.performWithDelay(self.timing, function()
        self:next()
    end)
    
end

-----------------------------------------------------------------------------------------

function BannerManager:createNewBanner()

    print("draw new banner")
    self.newBanner = display.newGroup()
    self.newBanner.contentWidth = display.contentWidth    
    self.newBanner.contentHeight = display.contentHeight * 0.3
    self.newBanner.x = display.contentWidth
    self.newBanner.y = display.contentHeight * 0.6
    self.newBanner.anchorY = 0
    hud:insert(self.newBanner)
    
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
end

-----------------------------------------------------------------------------------------

function BannerManager:drawText(source, element)
    
    local url = source .. "/" .. LANG ..  "/" .. element.name 
    
    viewManager.drawRemoteImage(
        url, 
        self.newBanner, 
        self.newBanner.contentWidth  * element.x, 
        self.newBanner.contentHeight * element.y, 
        1, 1, 
        function(image) image:toBack() end
    )
    
end

-----------------------------------------------------------------------------------------

function BannerManager:drawImage()

end

-----------------------------------------------------------------------------------------

return BannerManager