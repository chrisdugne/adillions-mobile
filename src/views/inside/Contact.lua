-----------------------------------------------------------------------------------------
--
-- AppHome.lua
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--   unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()
 
 ------------------

 self.top     = HEADER_HEIGHT + display.contentHeight*0.01
 self.yGap     = display.contentHeight*0.15

 self.column1 = display.contentWidth*0.3
 self.column2 = display.contentWidth*0.7

 ------------------

 hud.bg   = display.newImageRect(hud, "assets/images/hud/Infos_Bg.png", display.contentWidth, display.viewableContentHeight*0.8)
 hud.bg.x  = display.contentWidth*0.5
 hud.bg.y  = display.contentHeight*0.5

 ------------------

 hud.facebook     = display.newImage( hud, "assets/images/icons/socials/social_facebook.png")  
 hud.facebook.x    = self.column1
 hud.facebook.y    = self.top + self.yGap

 utils.onTouch(hud.facebook, function()
  analytics.event("Links", "facebook") 
  system.openURL( "https://www.facebook.com/pages/Adillions/379432705492888" )
 end)

 hud.twitter    = display.newImage( hud, "assets/images/icons/socials/social_twitter.png")  
 hud.twitter.x    = self.column2
 hud.twitter.y   = self.top + self.yGap

 utils.onTouch(hud.twitter, function()
  analytics.event("Links", "twitter") 
  system.openURL( "http://www.twitter.com/adillions" )
 end)

 ------------------

 hud.blog     = display.newImage( hud, "assets/images/icons/socials/social_rss.png")  
 hud.blog.x     = self.column1
 hud.blog.y    = self.top + self.yGap * 2

 utils.onTouch(hud.blog, function()
  analytics.event("Links", "blog") 
  system.openURL( "http://blog.adillions.com/" )
 end)

 hud.pinterest    = display.newImage( hud, "assets/images/icons/socials/social_pinterest.png")  
 hud.pinterest.x   = self.column2
 hud.pinterest.y  = self.top + self.yGap * 2

 utils.onTouch(hud.pinterest, function()
  analytics.event("Links", "pinterest") 
  system.openURL( "http://www.pinterest.com/adillions" )
 end)

 ------------------

 hud.linkedin     = display.newImage( hud, "assets/images/icons/socials/social_linkedin.png")  
 hud.linkedin.x    = self.column1
 hud.linkedin.y    = self.top + self.yGap * 3

 utils.onTouch(hud.linkedin, function()
  analytics.event("Links", "linkedin") 
  system.openURL( "http://www.linkedin.com/company/adillions" )
 end)

 hud.googleplus   = display.newImage( hud, "assets/images/icons/socials/social_googleplus.png")  
 hud.googleplus.x   = self.column2
 hud.googleplus.y  = self.top + self.yGap * 3

 utils.onTouch(hud.googleplus, function()
  analytics.event("Links", "googleplus") 
  system.openURL( "http://plus.google.com/" )
 end)
 
 ------------------

 hud.youtube     = display.newImage( hud, "assets/images/icons/socials/social_youtube.png")  
 hud.youtube.x     = self.column1
 hud.youtube.y    = self.top + self.yGap * 4

 utils.onTouch(hud.youtube, function()
  analytics.event("Links", "youtube") 
  system.openURL( "http://www.youtube.com/user/adillions" )
 end)

 hud.mail    = display.newImage( hud, "assets/images/icons/socials/social_mail.png")  
 hud.mail.x    = self.column2
 hud.mail.y   = self.top + self.yGap * 4

 utils.onTouch(hud.mail, function()
  analytics.event("Links", "mail") 
  
    local options =
    {
     body = "",
     subject = "Hi Adillions !",
    }
    
    native.showPopup("mail", options)
 end)
 
 ---------------------------------------------------------------------------------

 viewManager.setupView(0)
 self.view:insert(hud)
 
 viewManager.darkerBack()
end

------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
 self:refreshScene()
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene