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

function openHome()
	resetScreen()
	storyboard.gotoScene( "src.views.Home" )
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

function openVideo()
	resetScreen()
	storyboard.gotoScene( "src.views.Video" )
end

---------------------------------------------
