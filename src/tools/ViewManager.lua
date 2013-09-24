-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function initBack()
	hud.back = display.newImageRect( hud, "assets/images/blur.jpg", display.contentWidth, display.contentHeight)  
	hud.back.x = display.viewableContentWidth/2  
	hud.back.y = display.viewableContentHeight/2
end

------------------------------------------------------------------

function drawButton(text, x, y, action)

	local button = display.newImage(hud, "assets/images/hud/button.png")
	button.x = x
	button.y = y
	
	button.loginText = display.newText( {
		parent = hud,
		text = text,     
		x = x,
		y = y - display.contentHeight*0.01,
		font = FONT,   
		fontSize = 45,
	} )

	utils.onTouch(button, action)

	hud.buttons[#hud.buttons] = button 

	return button
end

-----------------------------------------------------------------------------------------

