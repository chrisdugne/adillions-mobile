-----------------------------------------------------------------------------------------
--
-- router.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

LOADING             = 1
OUTSIDE             = 2
NO_INTERNET         = 3
TUTORIAL            = 4
LOGIN               = 5
SIGNIN              = 6
SIGNINFB            = 7
HOME                = 8
MYTICKETS           = 9
RESULTS             = 10
PROFILE             = 11
FILLLOTTERYTICKET   = 12
INFO                = 13
INVITEFRIENDS       = 14
SELECTADDITIONALNUMBER = 15

-----------------------------------------------------------------------------------------

view = nil

-----------------------------------------------------------------------------------------

function resetScreen()
    if(hud.timer) then timer.cancel(hud.timer) end
    utils.emptyGroup(hud)
    utils.emptyGroup(hud.selection)
end

-----------------------------------------------------------------------------------------

function openLoading()
    resetScreen()
    storyboard.gotoScene( "src.views.Loading" )
    view = LOADING
end

-----------------------------------------------------------------------------------------

function openOutside()
    analytics.pageview("Outside")

    resetScreen()
    print("router : openOutside")
    storyboard.gotoScene( "src.views.Outside" )
    view = OUTSIDE
end

-----------------------------------------------------------------------------------------

function openNoInternet()
    resetScreen()
    storyboard.gotoScene( "src.views.NoInternet" )
    view = NO_INTERNET
end

-----------------------------------------------------------------------------------------

function openTutorial()
    analytics.pageview("Tutorial")

    resetScreen()
    storyboard.gotoScene( "src.views.tutorial.Tutorial" )
    view = TUTORIAL
end

-----------------------------------------------------------------------------------------

function openLogin()
    analytics.pageview("Login")

    resetScreen()
    storyboard.gotoScene( "src.views.Login" )
    view = LOGIN
end

-----------------------------------------------------------------------------------------

function openSignin()
    analytics.pageview("Signin")

    resetScreen()
    storyboard.gotoScene( "src.views.Signin" )
    view = SIGNIN
end

-----------------------------------------------------------------------------------------

function openSigninFB()
    analytics.pageview("SigninFB")

    resetScreen()
    storyboard.gotoScene( "src.views.SigninFB" )
    view = SIGNINFB
end

-----------------------------------------------------------------------------------------

function openHome()
    analytics.pageview("Home")

    resetScreen()
    storyboard.gotoScene( "src.views.inside.Home" )
    view = HOME
end

-----------------------------------------------------------------------------------------

function openMyTickets()
    analytics.pageview("MyTickets")

    resetScreen()
    storyboard.gotoScene( "src.views.inside.MyTickets" )
    view = MYTICKETS
end

-----------------------------------------------------------------------------------------

function openResults()
    analytics.pageview("Results")

    resetScreen()
    storyboard.gotoScene( "src.views.inside.Results" )
    view = RESULTS
end

-----------------------------------------------------------------------------------------

function openProfile()
    analytics.pageview("Profile")

    resetScreen()
    storyboard.gotoScene( "src.views.inside.Profile" )
    view = PROFILE
end

-----------------------------------------------------------------------------------------

function openInfo()
    analytics.pageview("Info")

    resetScreen()
    storyboard.gotoScene( "src.views.inside.Info" )
    view = INFO
end

-----------------------------------------------------------------------------------------

function openFillLotteryTicket()
    analytics.pageview("FillLotteryTicket")

    resetScreen()
    storyboard.gotoScene( "src.views.inside.FillLotteryTicket" )
    view = FILLLOTTERYTICKET
end

-----------------------------------------------------------------------------------------

function openSelectAdditionalNumber()
    analytics.pageview("SelectAdditionalNumber")

    resetScreen()
    storyboard.gotoScene( "src.views.inside.SelectAdditionalNumber" )
    view = SELECTADDITIONALNUMBER
end

-----------------------------------------------------------------------------------------

function openInviteFriends(next)
    analytics.pageview("InviteFriends")

    resetScreen()
    storyboard.gotoScene( "src.views.inside.InviteFriends" , {params = {next=next}})
    view = INVITEFRIENDS
end

-----------------------------------------------------------------------------------------
