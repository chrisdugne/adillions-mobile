-----------------------------------------------------------------------------------------

SponsorpayTools = {} 

-----------------------------------------------------------------------------------------

function SponsorpayTools:new()  

 local object = {
  afterVideoSeen = nil
 }

 setmetatable(object, { __index = SponsorpayTools })
 return object
end

-----------------------------------------------------------------------------------------

function SponsorpayTools:init(userUID)

 local appId = "16796"
 local userId = userUID
 local securityToken = "7e10113fe4f9d215497ef336ce22b9aa"
 local token = sponsorpay.start( appId, userId, securityToken )
   
 sponsorpay.setShowMBERewardNotification( false )
end

-----------------------------------------------------------------------------------------

function SponsorpayTools:requestOffers()
 native.setActivityIndicator( true )
 sponsorpay.requestMBEOffers( function(event) self:mbeListener(event) end )
end

function SponsorpayTools:mbeListener( event )

 native.setActivityIndicator( false )
 
 local message = ""
 if event.success then
  message = "Has offers? " .. tostring(event.mbe.hasOffers)
  
  if(event.mbe.hasOffers) then
     sponsorpay.startMBEEngagement(function(event) self:sponsorpayVideoSeen(event) end)
    else
     vungle:tryToShowAd()
    end
 else
  message = "Error\nMessage: " .. event.error.message .. "\nType: " .. event.error.type .. "\nCode: " .. event.error.code
 end
end

function SponsorpayTools:sponsorpayVideoSeen( event )
 utils.tprint(event)
 if(event.status == "CLOSE_FINISHED") then
  self.afterVideoSeen()
 else
  router.openHome()
 end
 
end

-----------------------------------------------------------------------------------------

return SponsorpayTools