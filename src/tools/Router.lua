-----------------------------------------------------------------------------------------
--
-- router.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function resetScreen()
	utils.emptyGroup(hud)
	hud.buttons = {}
end

-----------------------------------------------------------------------------------------

function openOutside()
	resetScreen()
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

function openGame()
	resetScreen()
	storyboard.gotoScene( "src.views.inside.Game" )
end

---------------------------------------------
