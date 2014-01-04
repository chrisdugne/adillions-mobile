-----------------------------------------------------------------------------------------
--
-- router.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

view = nil

-----------------------------------------------------------------------------------------

function resetScreen()

	if(hud.timer) then timer.cancel(hud.timer) end
	display.remove(hud.likePageWebview)

	utils.emptyGroup(hud)
	utils.emptyGroup(hud.selection)
	
	hud.buttons = {}
end

-----------------------------------------------------------------------------------------

function openOutside()
	analytics.pageview("Outside")
	
	resetScreen()
	print("router : openOutside")	
	storyboard.gotoScene( "src.views.Outside" )
end

-----------------------------------------------------------------------------------------

function openTutorial()
	analytics.pageview("Tutorial")
	
	resetScreen()
	storyboard.gotoScene( "src.views.tutorial.Tutorial" )
end

-----------------------------------------------------------------------------------------

function openLogin()
	analytics.pageview("Login")
	
	resetScreen()
	storyboard.gotoScene( "src.views.Login" )
end

-----------------------------------------------------------------------------------------

function openSignin()
	analytics.pageview("Signin")
	
	resetScreen()
	storyboard.gotoScene( "src.views.Signin" )
end

-----------------------------------------------------------------------------------------

function openSigninFB()
	analytics.pageview("SigninFB")
	
	resetScreen()
	storyboard.gotoScene( "src.views.SigninFB" )
end

-----------------------------------------------------------------------------------------

function openHome()
	analytics.pageview("Home")

	resetScreen()
	storyboard.gotoScene( "src.views.inside.Home" )
end

-----------------------------------------------------------------------------------------

function openMyTickets()
	analytics.pageview("MyTickets")

	resetScreen()
	storyboard.gotoScene( "src.views.inside.MyTickets" )
end

-----------------------------------------------------------------------------------------

function openConfirmation(backFromInvite)
	analytics.pageview("Confirmation")
	
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Confirmation", {params = {backFromInvite=backFromInvite}} )
end

-----------------------------------------------------------------------------------------

function openResults()
	analytics.pageview("Results")
	
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Results" )
end

-----------------------------------------------------------------------------------------

function openProfile()
	analytics.pageview("Profile")
	
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Profile" )
end

-----------------------------------------------------------------------------------------

function openInfo()
	analytics.pageview("Info")
	
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Info" )
end

-----------------------------------------------------------------------------------------

function openVideo()
	analytics.pageview("Video")
	
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Video" )
end

-----------------------------------------------------------------------------------------

function openFillLotteryTicket()
	analytics.pageview("FillLotteryTicket")
	
	resetScreen()
	storyboard.gotoScene( "src.views.inside.FillLotteryTicket" )
end

-----------------------------------------------------------------------------------------

function openOptions()
	analytics.pageview("Options")
	
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Options" )
end

-----------------------------------------------------------------------------------------

function openContact()
	analytics.pageview("Contact")
	
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Contact" )
end

-----------------------------------------------------------------------------------------

function openTerms()
	analytics.pageview("Terms")
	
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Terms" )
end

-----------------------------------------------------------------------------------------

function openRewards()
	analytics.pageview("Rewards")
	
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Rewards" )
end

-----------------------------------------------------------------------------------------

function openSelectAdditionalNumber()
	analytics.pageview("SelectAdditionalNumber")
	
	resetScreen()
	storyboard.gotoScene( "src.views.inside.SelectAdditionalNumber" )
end

-----------------------------------------------------------------------------------------

function openInviteFriends(next)
	analytics.pageview("InviteFriends")
	
	resetScreen()
	storyboard.gotoScene( "src.views.inside.InviteFriends" , {params = {next=next}})
end