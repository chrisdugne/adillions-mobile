-----------------------------------------------------------------------------------------
--
-- router.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function resetScreen()

	display.remove(hud.likePageWebview)

	utils.emptyGroup(hud)
	utils.emptyGroup(hud.selection)
	
	hud.buttons = {}
end

-----------------------------------------------------------------------------------------

function openOutside()
	resetScreen()
	print("router : openOutside")	
	storyboard.gotoScene( "src.views.Outside" )
end

-----------------------------------------------------------------------------------------

function openLogin()
	resetScreen()
	storyboard.gotoScene( "src.views.Login" )
end

-----------------------------------------------------------------------------------------

function openSignin()
	resetScreen()
	storyboard.gotoScene( "src.views.Signin" )
end

-----------------------------------------------------------------------------------------

function openSigninFB()
	resetScreen()
	storyboard.gotoScene( "src.views.SigninFB" )
end

-----------------------------------------------------------------------------------------

function openHome()
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Home" )
end

-----------------------------------------------------------------------------------------

function openMyTickets()
	resetScreen()
	storyboard.gotoScene( "src.views.inside.MyTickets" )
end

-----------------------------------------------------------------------------------------

function openConfirmation()
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Confirmation" )
end

-----------------------------------------------------------------------------------------

function openResults()
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Results" )
end

-----------------------------------------------------------------------------------------

function openProfile()
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Profile" )
end

-----------------------------------------------------------------------------------------

function openInfo()
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Info" )
end

-----------------------------------------------------------------------------------------

function openVideo()
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Video" )
end

-----------------------------------------------------------------------------------------

function openFillLotteryTicket()
	resetScreen()
	storyboard.gotoScene( "src.views.inside.FillLotteryTicket" )
end

-----------------------------------------------------------------------------------------

function openSelectAdditionalNumber()
	resetScreen()
	storyboard.gotoScene( "src.views.inside.SelectAdditionalNumber" )
end

-----------------------------------------------------------------------------------------

function openInviteFriends()
	resetScreen()
	storyboard.gotoScene( "src.views.inside.InviteFriends" )
end