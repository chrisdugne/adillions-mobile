--------------------------------------------------------------------------------
--
-- router.lua
--
--------------------------------------------------------------------------------

module(..., package.seeall)

--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------

view = nil

--------------------------------------------------------------------------------

function resetScreen()
    if(hud.timer) then timer.cancel(hud.timer) end
    utils.emptyGroup(hud)
    utils.emptyGroup(hud.selection)
end

--------------------------------------------------------------------------------

function openView(id, class, params)

    if( router.view == LOADING ) then
        timer.performWithDelay(250, function()
            router.openView(id, class)
        end)
    else
        resetScreen()
        storyboard.gotoScene( class, params )
    end

    view = id
end

--------------------------------------------------------------------------------

function openLoading()
    resetScreen()
    storyboard.gotoScene( "src.views.Loading" )
    view = LOADING
end

--------------------------------------------------------------------------------

function openOutside()
    analytics.pageview("Outside")
    print("router : openOutside")
    router.openView(OUTSIDE, "src.views.Outside")
end

--------------------------------------------------------------------------------

function openNoInternet()
    router.openView(NO_INTERNET, "src.views.NoInternet")
end

--------------------------------------------------------------------------------

function openTutorial()
    analytics.pageview("Tutorial")
    router.openView(TUTORIAL, "src.views.tutorial.Tutorial")
end

--------------------------------------------------------------------------------

function openLogin()
    analytics.pageview("Login")
    router.openView(LOGIN, "src.views.Login")
end

--------------------------------------------------------------------------------

function openSignin()
    analytics.pageview("Signin")
    router.openView(SIGNIN, "src.views.Signin")
end

--------------------------------------------------------------------------------

function openHome()
    analytics.pageview("Home")
    router.openView(HOME, "src.views.inside.Home")
end

--------------------------------------------------------------------------------

function openMyTickets()
    analytics.pageview("MyTickets")
    router.openView(MYTICKETS, "src.views.inside.MyTickets")
end

--------------------------------------------------------------------------------

function openResults()
    analytics.pageview("Results")
    router.openView(RESULTS, "src.views.inside.Results")
end

--------------------------------------------------------------------------------

function openProfile()
    analytics.pageview("Profile")
    router.openView(PROFILE, "src.views.inside.Profile")
end

--------------------------------------------------------------------------------

function openInfo()
    analytics.pageview("Info")
    router.openView(INFO, "src.views.inside.Info")
end

--------------------------------------------------------------------------------

function openFillLotteryTicket()
    analytics.pageview("FillLotteryTicket")
    router.openView(FILLLOTTERYTICKET, "src.views.inside.FillLotteryTicket")
end

--------------------------------------------------------------------------------

function openSelectAdditionalNumber()
    analytics.pageview("SelectAdditionalNumber")
    router.openView(SELECTADDITIONALNUMBER, "src.views.inside.SelectAdditionalNumber")
end

--------------------------------------------------------------------------------

function openInviteFriends(next)
    analytics.pageview("InviteFriends")
    router.openView(INVITEFRIENDS, "src.views.inside.InviteFriends" , {params = {next=next}})
end

--------------------------------------------------------------------------------
