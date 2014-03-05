-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local widget = require( "widget" )

local ICON_SIZE = 95
local SMALL_THEME_SCALE = 0.59
local MEDIUM_THEME_SCALE = 0.79

-----------------------------------------------------------------------------------------

function setupView(selectedTab, menuType)
    initBack()
    initHeader()
    buildMenu(selectedTab, menuType)
end

-----------------------------------------------------------------------------------------

-- globalBack not to have a black screen while changing views
function initGlobalBack()
-- local globalBack = display.newImageRect( "assets/images/bg.jpg", display.contentWidth, display.contentHeight)  
-- globalBack.x = display.viewableContentWidth*0.5 
-- globalBack.y = display.viewableContentHeight*0.5
-- globalBack:toBack()

-- display.setDefault( "background", 227, 225, 226 )
end

-----------------------------------------------------------------------------------------

function initBack()
    display.setDefault( "background", 237/255, 235/255, 236/255 )
end

function darkerBack()
    display.setDefault( "background", 227/255, 225/255, 226/255 )
end

-----------------------------------------------------------------------------------------

function initHeader()

    hud.headerRect = display.newImageRect( hud, "assets/images/header.png", display.contentWidth, HEADER_HEIGHT)  
    hud.headerRect.x = display.viewableContentWidth*0.5 
    hud.headerRect.y = HEADER_HEIGHT*0.5

    hud.logo = display.newImage( hud, "assets/images/logo.png")  
    hud.logo.x = display.contentWidth*0.5
    hud.logo.y = HEADER_HEIGHT*0.5

    hud.headerButton = display.newImage( hud, "assets/images/icons/header.button.png")  
    hud.headerButton.x = display.contentWidth*0.9
    hud.headerButton.y = HEADER_HEIGHT*0.5
    hud.headerButton.anchorX = 0.5
    hud.headerButton.anchorY = 0.44
    
    utils.onTouch(hud.headerButton, function()
        analytics.event("Gaming", "showStatus") 
        userManager:showStatus()
    end)
end

-----------------------------------------------------------------------------------------

function initBoard()
    hud.board = widget.newScrollView
    {
        id      = "board",
        top      = 0,
        left      = 0,
        friction    = 1.5,
        width      = display.contentWidth,
        height     = display.contentHeight,
        bottomPadding   = MENU_HEIGHT + HEADER_HEIGHT + display.contentHeight*0.1,
        hideBackground  = true,
        horizontalScrollDisabled  = true,
        verticalScrollDisabled   = false,
        hideScrollBar      = true,
    }
end

-----------------------------------------------------------------------------------------

function showPoints(nbPoints)
    -- local text = viewManager.newText({
    --  parent    = hud, 
    --  text     = "+ " .. nbPoints,     
    --  x      = display.contentWidth*0.97,
    --  y      = display.contentHeight*0.05,
    --  fontSize   = 65
    -- })
    --
    -- transition.to(text, { time=1500, alpha=0, x=display.contentWidth*0.84 })

    local plural = ""
    if(nbPoints > 1) then plural = 's' end
    message("+ " .. nbPoints .. " pt" .. plural)
end

-----------------------------------------------------------------------------------------

function message(message)

    if(hud.messager) then
        transition.to(hud.messager, { time=300, alpha=0 } )
    end

    hud.messager = display.newGroup()
    hud.messager.y = -200

    hud.messager.popupRect   = drawBorder( hud.messager, 
    0, HEADER_HEIGHT, 
    display.contentWidth+100, HEADER_HEIGHT*0.6,
    240/255,240/255,240/255
    )  
    hud.messager.popupRect.x = display.contentWidth*0.5
    hud.messager.popupRect.alpha = 0.95

    hud.messager.text = viewManager.newText({
        parent    = hud.messager, 
        text     = message,     
        x      = display.contentWidth*0.5,
        y      = HEADER_HEIGHT - 12,
        fontSize   = 35
    })

    hud.messager.text:setFillColor(5/255)

    transition.to(hud.messager, { time=500, y=-HEADER_HEIGHT/2 - 5, onComplete=function()
            timer.performWithDelay(2000, function()
                transition.to(hud.messager, { time=500, y=-200} )
            end)
        end })
end

-----------------------------------------------------------------------------------------

function closePopup(popup, now, action)

    if(popup) then
        display.remove(popup.close)
        transition.cancel(popup)

        if(not now) then
            transition.to(popup, {
                time        = 250, 
                alpha       = 0, 
                onComplete  = function()
                    utils.emptyGroup(popup)
                    if(action ~= nil) then
                        action()
                    end
                end
            })
        else
            utils.emptyGroup(popup)
            if(action ~= nil) then
                action()
            end
        end

    end

end

------------------------------------------------------------------

function closePopin(now, action)

    if(hud.popin) then
        display.remove(hud.popin.close)
        transition.cancel(hud.popin)

        if(not now) then
            transition.to(hud.popin, {
                time        = 250, 
                y           = display.contentHeight*1.2, 
                onComplete  = function()
                    utils.emptyGroup(popin)
                    if(action ~= nil) then
                        action()
                    end
                end
            })
        else
            utils.emptyGroup(popin)
            if(action ~= nil) then
                action()
            end
        end

    end
    
end

------------------------------------------------------------------

function showPopin()
    
    local height = display.contentHeight*0.35
    
    ----------------------------------------------------------
    
    closePopin()
    hud.popin = display.newGroup()
    hud.popin.anchorX = 0
    hud.popin.anchorY = 0
    hud.popin.headerMiddle = -height/2.4
    hud.popin.contentMiddle = height/12

    ----------------------------------------------------------
    
    hud.popin.popinRect = display.newImageRect( hud.popin, "assets/images/menus/popin.bg.png", display.contentWidth, height)
    hud.popin.popinRect.x = 0 
    hud.popin.popinRect.y = 0
    hud.popin:insert(hud.popin.popinRect)
    
    ----------------------------------------------------------
    -- header
    
    hud.popin.closedown     = display.newImage( hud.popin, I "closedown.png")  
    hud.popin.closedown.x   = display.contentWidth * 0.45
    hud.popin.closedown.y   = hud.popin.headerMiddle

    ----------------------------------------------------------
    
    hud.popin.touchBack = drawBorder( hud.popin, 
        0, 0, 
        display.contentWidth, display.contentHeight,
        50/255,50/255,50/255
    )  
    hud.popin.touchBack.x      = 0
    hud.popin.touchBack.y      = -display.contentHeight*0.7
    hud.popin.touchBack.alpha  = 0.01
    hud.popin:insert(hud.popin.touchBack)
    
    ----------------------------------------------------------

    hud.popin.x = display.contentWidth * 0.5
    hud.popin.y = display.contentHeight * 1.2
    hud.popin:toFront()
    
    ----------------------------------------------------------
    
    transition.to(hud.popin, { time = 250, y = display.contentHeight - height/2 } )

    ----------------------------------------------------------
    
    utils.onTap(hud.popin.touchBack, function() 
        closePopin() 
        return false
    end)

    utils.onTap(hud.popin.popinRect, function() 
        closePopin() 
        return true 
    end)
    
end

------------------------------------------------------------------

--- no parameter : display.contentWidth*0.95, display.contentHeight*0.95
--  only height  : square : height, height
--  note : square grey BG doesnt close
function showPopup(height, square)

    local width = display.contentWidth*0.95
    
    if(not height) then
        height = display.contentHeight*0.95
    elseif(square) then
        width = height
    end

    local popup = display.newGroup()

    local backGrey = drawBorder( popup, 
        0, 0, 
        display.contentWidth+50, display.viewableContentHeight+50,
        50/255,50/255,50/255
    )  
    
    backGrey.x   = display.viewableContentWidth*0.5 
    backGrey.y   = display.viewableContentHeight*0.5
    backGrey.alpha = 0.85

    popup.bg = display.newImageRect( popup, "assets/images/hud/Popup_BG.png", width, height)
    popup.bg.x = display.contentWidth*0.5 
    popup.bg.y = display.contentHeight*0.5

    popup:toFront()

    if(square) then
        utils.onTap(backGrey, function() return true end)
    else
        utils.onTap(backGrey, function() closePopup(popup) return true end)
    end
    
    utils.onTap(popup.bg, function() return true end)
    
    return popup
end

------------------------------------------------------------------

function refreshHomeTimer()

    if(hud.timer) then timer.cancel(hud.timer) end

    local days,hours,min,sec = utils.getDaysHoursMinSec(math.round((lotteryManager.nextDrawing.date - SERVER_TIME - system.getTimer())/1000))

    if(days <= 0 and hours <= 0 and min <= 0 and sec <= 0) then
        days,hours,min,sec = utils.getDaysHoursMinSec(math.round((lotteryManager.nextDrawing.date - SERVER_TIME - system.getTimer())/1000))
    end

    if(days < 10) then days = "0"..days end 
    if(hours < 10) then hours = "0"..hours end 
    if(min < 10) then min = "0"..min end 
    if(sec < 10) then sec = "0"..sec end 

    hud.timerDisplay.text = days .. " : " .. hours .. " : " .. min .. " : " .. sec
              
    local next = utils.getDaysHoursMinSec(math.round(SERVER_TIME - TIMER)/1000)
    hud.timer = timer.performWithDelay((math.round(next/15) + 1) * 150, function ()
        refreshHomeTimer()
    end)
end

------------------------------------------------------------------

function refreshPopupTimer(popup, lastTime)

    if(popup.timer) then timer.cancel(popup.timer) end
    if(not popup.timerDisplay) then return end

    local now = os.time() * 1000
    local hoursSpent, minSpent, secSpent, msSpent = utils.getHoursMinSecMillis(now - lastTime)

    if(tonumber(minSpent) >= lotteryManager.nextLottery.ticketTimer) then 
        viewManager.closePopup(popup)
    else
        -- local h = 1 - tonumber(hoursSpent)
        local m = lotteryManager.nextLottery.ticketTimer - 1 - tonumber(minSpent)
        local s = 59 - tonumber(secSpent) 

        -- if(h < 10) then h = "0"..h end 
        if(m < 10) then m = "0"..m end 
        if(s < 10) then s = "0"..s end 

        -- popup.timerDisplay.text = h .. " : " .. m .. " : " .. s
        popup.timerDisplay.text = m .. " : " .. s
        popup.timer = timer.performWithDelay(1000, function ()
            refreshPopupTimer(popup, lastTime)
        end)
    end 

end

------------------------------------------------------------------

function animatePrice(nextMillis)

    if(not nextMillis) then nextMillis = 3 end

    timer.performWithDelay(nextMillis, function()
        local lotteryPriceDollars = lotteryManager:priceDollars(lotteryManager.nextDrawing)
        local priceToReach = utils.countryPrice(lotteryPriceDollars, COUNTRY, lotteryManager.nextDrawing.rateUSDtoEUR)

        local ratio = (20 * priceToReach)/(priceToReach - hud.priceCurrentDisplay)
        local toAdd = math.floor(priceToReach/ratio)
        if(toAdd == 0) then toAdd = 1 end

        hud.priceCurrentDisplay = math.round(hud.priceCurrentDisplay + toAdd)

        if(hud.priceCurrentDisplay >= priceToReach) then
            hud.priceCurrentDisplay = math.round(priceToReach) 
        else
            nextMillis = 1000/(priceToReach - hud.priceCurrentDisplay)
            animatePrice(nextMillis)
        end

        hud.priceDisplay.text = utils.displayPrice(hud.priceCurrentDisplay, COUNTRY)
    end)
end

------------------------------------------------------------------

function newText(options)

    local finalOptions = {}
    finalOptions.text   = options.text
    finalOptions.font   = options.font or FONT
    finalOptions.fontSize  = options.fontSize or 48
    finalOptions.align   = options.align or "center"

    if(options.width) then
        finalOptions.width = options.width
    end

    if(options.height) then
        finalOptions.height = options.height
    end

    local text = display.newText( finalOptions )

    text:setFillColor(0)
    text.x = options.x
    text.y = options.y

    text.anchorX = options.anchorX or 0.5
    text.anchorY = options.anchorY or 0.5

    if(options.parent) then
        options.parent:insert(text)
    end

    return text

end

------------------------------------------------------------------

function drawBorder(parent, x, y, width, height, r, g, b, anchorX, anchorY)

    -----------------------------------

    if(not width) then
        width = 250
    end

    if(not height) then
        height = 90
    end

    -----------------------------------

    if(not r) then r = 239 end
    if(not g) then g = 237 end
    if(not b) then b = 238 end

    local gray = r - 19
    -----------------------------------

    if(not anchorX) then anchorX = 0.5 end
    if(not anchorY) then anchorY = 0.5 end

    -----------------------------------
    -- rounded buttons 1 color

    local border = display.newRoundedRect(parent, 0, 0, width, height, 17)
    border.anchorX = anchorX 
    border.anchorY = anchorY
    border.x = x 
    border.y = y
    border.strokeWidth = 1
    border:setFillColor(r,g,b)
    border:setStrokeColor(gray)
    parent:insert(border)

    return border
end

------------------------------------------------------------------

function drawButton(parent, text, x, y, action, width, height)

    -----------------------------------

    local button = drawBorder(parent, x, y, width, height)

    -----------------------------------

    button.text = display.newText( {
        parent = parent,
        text = text,     
        x = x,
        y = y-6,
        font = FONT,   
        fontSize = 45,
    } )

    button.text:setFillColor(0,0,0)
    utils.onTouch(button, action)

    -- hud.buttons[#hud.buttons] = button 
    parent:insert(button)
    parent:insert(button.text)

    return button
end

------------------------------------------------------------------

function drawRemoteImage( url, parent, x, y, scale, alpha, next, prefix )

    if(not scale) then scale = 1 end
    if(not alpha) then alpha = 1 end
    if(not prefix) then prefix = "" end

    local fileName = prefix .. utils.imageName(url)
    local image = display.newImage( parent, fileName, system.TemporaryDirectory)

    if not image then
        local view = router.view
        local imageReceived = function(event) 
            print("received image on view " .. router.view)
            if(router.view == view) then 
                return insertImage(event.target, parent, x, y, scale, alpha, next) 
            end
        end
        
        print("loading image on view " .. view)
        display.loadRemoteImage( url, "GET", imageReceived, fileName, system.TemporaryDirectory )
    else
        insertImage(image, parent, x, y, scale, alpha, next)
    end

end 

function insertImage(image, parent, x, y, scale, alpha, next)

    image.x    = x
    image.y    = y
    image.xScale  = scale
    image.yScale  = scale
    image.alpha  = alpha

    parent:insert(image)

    if(next) then
        next(image)
    end
end

------------------------------------------------------------------

--- menuType
--  none |  1 : classic, white 
--     2 : confirmation,green
--     3 : grey, white
--     
function buildMenu(tabSelected, menuType)

    local buttonWidth = display.contentWidth/5 - 1
    local centerOn  = ""
    local centerOff  = ""
    local playImage  = ""

    if(not menuType) then
        menuType = 3
    end

    if(menuType == 1) then
        playImage = I "ON3_1.png"
    end

    if(menuType == 2) then
        playImage = I "ON3_2.png"
    end

    if(menuType == 3) then
        playImage = I "OFF3.png"
    end

    local centerOn  = I "ON3_" .. menuType ..  ".png" 
    local centerOff  = I "OFF3_" .. menuType ..  ".png" 

    -- Create the tabBar's buttons
    local tabButtons = 
    {
        {
            width     = buttonWidth, 
            height     = ICON_SIZE,
            defaultFile   = I "OFF1.png",
            overFile    = I "ON1.png",
            onPress = function( event )
                if(tabSelected ~= 1) then 
                    router.openProfile() 
                end 
            end,
            selected = tabSelected == 1
        },
        {
            width     = buttonWidth, 
            height     = ICON_SIZE,
            defaultFile   = I "OFF2.png",
            overFile    = I "ON2.png",
            onPress = function( event )
                if(tabSelected ~= 2) then 
                    router.openMyTickets() 
                end 
            end,
            selected =  tabSelected == 2
        },
        {
            width     = buttonWidth, 
            height     = ICON_SIZE,
            defaultFile   = "assets/images/menus/empty.png",
            overFile    = "assets/images/menus/empty.png",
        },
        {
            width     = buttonWidth, 
            height     = ICON_SIZE,
            defaultFile   = I "OFF4.png",
            overFile    = I "ON4.png",
            onPress = function( event )
                if(tabSelected ~= 4) then 
                    router.openResults() 
                end 
            end,
            selected =  tabSelected == 4
        },
        {
            width     = buttonWidth, 
            height     = ICON_SIZE,
            defaultFile   = I "OFF5.png",
            overFile    = I "ON5.png",
            onPress = function( event )
                if(tabSelected ~= 5) then 
                    router.openInfo() 
                end 
            end,
            selected = tabSelected == 5
        },
    }

    local leftEdge  = "assets/images/menus/empty.png"
    local rightEdge  = "assets/images/menus/empty.png"
    local middle   = "assets/images/menus/empty.png"

    -- Create a tabBar
    local tabBar = widget.newTabBar({
        left          = 0,
        top          = display.contentHeight - MENU_HEIGHT,
        width         = display.contentWidth,
        height         = MENU_HEIGHT,
        backgroundFile      = "assets/images/menus/menu.bg.png",
        tabSelectedLeftFile     = leftEdge,
        tabSelectedRightFile    = rightEdge,
        tabSelectedMiddleFile    = middle,
        tabSelectedFrameWidth    = 20,
        tabSelectedFrameHeight    = MENU_HEIGHT,
        buttons         = tabButtons,
    })

    if(tabSelected == 0 or tabSelected == 6) then
        tabBar:setSelected( 0, false )
    end

    hud:insert( tabBar )

    -------------------

    hud.playButton = display.newImage( hud, playImage )
    hud.playButton.x = display.contentWidth*0.5
    hud.playButton.y = display.contentHeight - hud.playButton.contentHeight/2


    utils.onTap(hud.playButton, function()
        if(tabSelected ~= 0) then 
            router.openHome() 
        end 
    end)

    hud.playButton:toFront()

end

-----------------------------------------------------------------------------------------

function drawBallToPick(num,x,y)

    local ball = display.newImage(hud, "assets/images/balls/ball.small.white.png")
    ball.x = x
    ball.y = y

    ball.text = display.newText( {
        parent = hud,
        text = num,     
        x = x,
        y = y,
        font = NUM_FONT,   
        fontSize = 37,
    } )

    ball.text:setFillColor(0)
    ball.num = num
    ball.selected = false

    utils.onTouch(ball, function()
        if(lotteryManager:canAddToSelection()) then
            lotteryManager:addToSelection(ball.num)
        end
    end)

    hud.balls[num] = ball
end


function drawBallPicked(num)

    local x = hud.balls[num].x
    local y = hud.balls[num].y
    display.remove(hud.balls[num])

    local ball = display.newImage(hud, "assets/images/balls/ball.small.green.png")
    ball.x = x
    ball.y = y

    ball.text = display.newText( {
        parent = hud,
        text = num,     
        x = x,
        y = y,
        font = NUM_FONT,   
        fontSize = 33,
    } )

    ball.text:setFillColor(255)
    ball.num = num
    ball.selected = true

    utils.onTouch(ball, function()
        lotteryManager:removeFromSelection(ball.num)
    end)

    hud.balls[num] = ball
end

-----------------------------------------------------------------------------------------

function drawThemeToPick(num,x,y)

    local ball = {}
    ball.selected  = false
    ball.num   = num

    local content = ""

    if(lotteryManager.nextLottery.theme.balls) then
        content = lotteryManager.nextLottery.theme.balls[LANG]
    else
        content = lotteryManager.nextLottery.theme.icons
    end

    drawThemeIcon(num, hud, content, x, y, 1, 1, function()
        local themeMask = display.newImage(hud, "assets/images/balls/ball.mask.png")
        themeMask.x = x
        themeMask.y = y

        utils.onTouch(themeMask, function()
            if(ball.selected) then
                lotteryManager:cancelAdditionalSelection()
            else
                lotteryManager:addToAdditionalSelection(ball)
            end
        end)
    end)

    hud.text = viewManager.newText({
        parent    = hud, 
        text     = content[num].name,     
        x      = x,
        y      = y + display.contentHeight*0.08,
        fontSize   = 40
    })

    if(content[num].name2) then
        viewManager.newText({
            parent    = hud, 
            text     = content[num].name2,     
            x      = x,
            y      = y + display.contentHeight*0.12,
            fontSize   = 40
        })
    else
        hud.text.y = hud.text.y + display.contentHeight*0.02
    end


end

function drawThemeIcon(num, parent, content, x, y, scale, alpha, next)
    drawRemoteImage(content[num].image, parent, x, y, scale, alpha, next)
end

-----------------------------------------------------------------------------------------

--- 
-- theme sur un ticket ou un result
function drawTheme(parent, lottery, num,x,y, alpha, requireCheck, bigBall)

    if(not alpha) then alpha = 1 end

    local scale = SMALL_THEME_SCALE
    if(bigBall) then 
        scale = 0.78
    end

    local content = ""

    if(lottery.theme.balls) then
        content = lottery.theme.balls[LANG]
    else
        content = lottery.theme.icons
    end

    drawThemeIcon(num, parent, content, x, y, scale, alpha, function()
        local themeMask = display.newImage(parent, "assets/images/balls/ball.mask.png")
        themeMask.x = x
        themeMask.y = y
        themeMask.alpha = alpha
        themeMask:scale(scale, scale)
        parent:insert(themeMask)

        if(requireCheck) then
            local check = display.newImage(parent, "assets/images/icons/check.png")
            check.x = x + 20
            check.y = y - 30
            parent:insert(check)
        end
    end)

end

-----------------------------------------------------------------------------------------

function drawBall(parent, num,x,y, bigBall)

    local size = "small"
    local fontSize = 37
    if(bigBall) then 
        size = "big"
        fontSize = 45 
    end

    local ball = display.newImage(hud, "assets/images/balls/ball.".. size..".green.png")
    ball.x = x
    ball.y = y

    parent:insert(ball)

    ball.text = display.newText( {
        text = num,     
        x = x,
        y = y,
        font = NUM_FONT,   
        fontSize = fontSize,
    } )

    ball.text:setFillColor(255)
    parent:insert(ball.text)

    ball.num = num
    ball.alpha = 1

    return ball
end

-----------------------------------------------------------------------------------------

function drawSelectedBall(selected, x, y, action)

    local ball = display.newImage(hud.selection, "assets/images/balls/ball.big.green.png")
    ball.x = x
    ball.y = y

    if(not selected) then
        selected = ""
        ball.alpha = 0.3
    else
        if(action) then
            utils.onTouch(ball, action)
        end
    end

    ball.text = display.newText( {
        parent = hud.selection,
        text = selected,     
        x = x,
        y = y,
        font = NUM_FONT,   
        fontSize = 47,
    } )

    ball.text:setFillColor(255)

    return ball
end

-----------------------------------------------------------------------------------------

function drawSelectedAdditional(ball,x,y, action)

    if(ball) then

        local content = ""

        if(lotteryManager.nextLottery.theme.balls) then
            content = lotteryManager.nextLottery.theme.balls[LANG]
        else
            content = lotteryManager.nextLottery.theme.icons
        end

        drawThemeIcon(ball.num, hud.selection, content, x, y, MEDIUM_THEME_SCALE, 1, function()
            local themeMask = display.newImage(hud.selection, "assets/images/balls/ball.mask.png")
            themeMask.x = x
            themeMask.y = y
            themeMask:scale(MEDIUM_THEME_SCALE, MEDIUM_THEME_SCALE)

            if(action) then
                utils.onTouch(themeMask, action)
            end
        end)
    end

end

-----------------------------------------------------------------------------------------

function drawSelection(parent, numbers, y)

    -------------------------------------
    -- display

    local nbSelected    = 0
    local xGap          = display.contentWidth*0.14

    -------------------------------------

    for j = 1,#numbers-1 do
        drawBall(parent, numbers[j], xGap*j, y, true)
    end

    drawTheme(parent, lotteryManager.nextLottery, numbers[#numbers], xGap*#numbers, y, 1, false, true)

end

-----------------------------------------------------------------------------------------

function drawTicket(parent, lottery, numbers, x, y)

    local xGap = display.contentWidth *0.12

    for j = 1,#numbers-1 do

        local ball = drawBall(parent, numbers[j], x + xGap*j, y)

        local goodNumber = true

        if(lottery.result) then
            if type(lottery.result) == "string" then lottery.result = json.decode(lottery.result) end

            goodNumber = false
            for w = 1, #lottery.result-1 do
                if(lottery.result[w] == numbers[j]) then
                    goodNumber = true
                end
            end
        end

        if(goodNumber) then
            ball.alpha = 1

            if(lottery.result) then
                local check = display.newImage(parent, "assets/images/icons/check.png")
                check.x = x + xGap*j + 20
                check.y = y - 30
                parent:insert(check)
            end
        else
            ball.alpha = 0.34
        end
    end

    local alpha = 1 
    local themeWon = false

    if(lottery.result) then
        themeWon = lottery.result[#lottery.result] == numbers[#numbers]
        if(not themeWon) then
            alpha = 0.34
        end 
    end

    drawTheme(parent, lottery, numbers[#numbers], x + xGap*#numbers, y, alpha, themeWon)

end

-----------------------------------------------------------------------------------------