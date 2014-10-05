--------------------------------------------------------------------------------
--
-- MyTickets.lua
--
--------------------------------------------------------------------------------

local scene = storyboard.newScene()
local widget = require "widget"

--------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--   unless storyboard.removeScene() is called.
--
--------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

--------------------------------------------------------------------------------

function scene:initBoard()
    viewManager.initBoard(function(event) self:scrollListener(event) end)
    self.currentLottery    = nil
    self.lotteries         = {}
    self.currentLottery    = nil
    self.nbLotteries       = 0
    self.nbPreviousTickets = 0
end

function scene:drawFirstTickets(tickets)
    self:initBoard()
    self:prepareLotteryHeights(tickets)
    self:drawNextLottery()
    self:drawPreviousLotteries(tickets)
    hud:insert(hud.board)

    viewManager.setupView(2)
    viewManager.darkerBack()
    self.view:insert(hud)
end

function scene:refreshScene()

    if(userManager.tickets) then

        if(#userManager.tickets == 0) then
            viewManager.newText({
                parent   = hud,
                text     = T "No ticket",
                x        = display.contentWidth*0.5,
                y        = display.contentHeight*0.15,
                fontSize = 43
            })
            hud.bg               = display.newImage( hud, "assets/images/hud/home/BG_adillions.png")
            hud.playTicketButton = display.newImage( hud, I "filloutticket.button.png")

            hud.bg.x               = display.contentWidth*0.5
            hud.bg.y               = display.contentHeight*0.5
            hud.playTicketButton.x = display.contentWidth*0.5
            hud.playTicketButton.y = display.contentHeight*0.5

            utils.onTouch(hud.playTicketButton, function()
                gameManager:play()
            end)

        else
            self:drawFirstTickets(userManager.tickets)
        end

    else
        self:loadMoreTickets(true)

    end

end

--------------------------------------------------------------------------------

function scene:prepareLotteryHeights(tickets)

    -- compte le nombre de tickets pour calculer la hauteur de drawBorder

    for i = 1,#tickets do

        local ticket = tickets[i]

        if(self.currentLottery ~= ticket.lottery.uid) then
            self.currentLottery = ticket.lottery.uid
            self.lotteries[ticket.lottery.uid] = {}
            self.lotteries[ticket.lottery.uid].nbTickets = 1
        else
            self.lotteries[ticket.lottery.uid].nbTickets = self.lotteries[ticket.lottery.uid].nbTickets + 1
        end
    end

    -- reset
    self.currentLottery = nil

end

--------------------------------------------------------------------------------

function scene:drawNextLottery()

    local marginLeft = display.contentWidth * 0.02
    local xGap       = display.contentWidth *0.1
    local yGap       = display.contentHeight *0.07
    local top        = HEADER_HEIGHT + 80

    local nbNewTickets  = 0
    self.currentLottery = nil
    local borderHeight  = 0

    for i = 1,#userManager.tickets do

        local ticket = userManager.tickets[i]
        if(ticket.lottery.uid == lotteryManager.nextLottery.uid) then

            local numbers  = ticket.numbers
            nbNewTickets = nbNewTickets + 1

            if(self.currentLottery ~= ticket.lottery.uid) then

                -----
                -- juste pour le premier ticket du coup.

                self.currentLottery = ticket.lottery.uid
                self.nbLotteries    = 1
                self.nbTickets      = self.lotteries[self.currentLottery].nbTickets
                borderHeight        = yGap + yGap*self.nbTickets + 20

                viewManager.drawBorder(
                    hud.board,
                    display.contentWidth*0.5,                                               -- x
                    top + (yGap)*(nbNewTickets+self.nbLotteries-2) + borderHeight/2 - 55,   -- y
                    display.contentWidth*0.95,                                              -- width
                    borderHeight,                                                           -- height
                    240,240,240
                )

                viewManager.newText({
                    parent   = hud.board,
                    text     = T "Next drawing" .. " : " .. lotteryManager:date(ticket.lottery, true),
                    x        = display.contentWidth*0.08,
                    y        = top + yGap*(nbNewTickets+self.nbLotteries-2),
                    fontSize = 43,
                    anchorX  = 0,
                    anchorY  = 0.5,
                })

            end

            viewManager.drawTicket(hud.board, ticket.lottery, numbers, marginLeft, top + 50 + yGap*(nbNewTickets-0.5))

        end
    end

    self.nextLotteryTop = top + borderHeight

end

--------------------------------------------------------------------------------

function scene:drawPreviousLotteries(tickets)

    local marginLeft = display.contentWidth * 0.02
    local xGap       = display.contentWidth *0.1
    local yGap       = display.contentHeight *0.17

    for i = 1,#tickets do
        self:drawTicket(tickets[i], marginLeft, xGap, yGap)
    end

end

--------------------------------------------------------------------------------

function scene:drawTicket(ticket, marginLeft, xGap, yGap)

    local top = self.nextLotteryTop

    if(ticket.lottery.uid ~= lotteryManager.nextLottery.uid) then

        -----------------------------------------------------------

        local numbers  = ticket.numbers
        self.nbPreviousTickets = self.nbPreviousTickets + 1

        -----------------------------------------------------------

        if(self.currentLottery ~= ticket.lottery.uid) then

            self.currentLottery = ticket.lottery.uid
            self.nbLotteries    = self.nbLotteries + 1
            self.nbTickets      = self.lotteries[self.currentLottery].nbTickets
            local borderHeight  = yGap + yGap*self.nbTickets - 80

            viewManager.drawBorder(
                hud.board,
                display.contentWidth*0.5,             -- x
                top + (yGap)*(self.nbPreviousTickets+self.nbLotteries-2) + borderHeight/2 - 45,  -- y
                display.contentWidth*0.95,             -- width
                borderHeight                 -- height
            )

            viewManager.newText({
                parent   = hud.board,
                text     = T "Drawing" .. " : " .. lotteryManager:date(ticket.lottery, true, true),
                x        = display.contentWidth*0.08,
                y        = top + yGap*(self.nbPreviousTickets+self.nbLotteries-2),
                fontSize = 42,
                anchorX  = 0,
                anchorY  = 0.5,
            })

        else

            local separator = display.newImage(hud.board, "assets/images/icons/separateur.horizontal.png")
            separator.x     = display.contentWidth*0.5
            separator.y     = top + yGap*(self.nbPreviousTickets+self.nbLotteries-1.82)
            hud.board:insert(separator)
        end

        -----------------------------------------------------------

        viewManager.drawTicket(hud.board, ticket.lottery, numbers, marginLeft, top + yGap*(self.nbPreviousTickets+self.nbLotteries-1.5))

        -----------------------------------------------------------

        viewManager.newText({
            parent   = hud.board,
            text     = T "Winnings" .. " :",
            x        = display.contentWidth*0.1,
            y        = top + yGap*(self.nbPreviousTickets+self.nbLotteries-1.1),
            fontSize = 34,
            anchorX  = 0,
            anchorY  = 0.5,
        })

        -----------------------------------------------------------

        if(ticket.lottery.uid == lotteryManager.nextDrawing.uid) then

            ---------------------------------------------------------------------
            -- waiting for the drawing

            viewManager.newText({
                parent   = hud.board,
                text     = "?",
                x        = display.contentWidth*0.87,
                y        = top + yGap*(self.nbPreviousTickets+self.nbLotteries-1.1),
                fontSize = 37,
                font     = NUM_FONT,
                anchorX  = 1,
                anchorY  = 0.5,
            })

        else
            if(ticket.bonus) then

                ---------------------------------------------------------------------
                -- Stocks (BT)

                if(tonumber(ticket.bonus.stocks) > 0) then
                    viewManager.newText({
                        parent   = hud.board,
                        text     = ticket.bonus.stocks,
                        x        = display.contentWidth*0.87,
                        y        = top + yGap*(self.nbPreviousTickets+self.nbLotteries-1.1),
                        fontSize = 37,
                        font     = NUM_FONT,
                        anchorX  = 1,
                        anchorY  = 0.5,
                    })

                    local iconMoney  = display.newImage( hud.board, "assets/images/icons/notification/stocks.popup.png")
                    iconMoney.x   = display.contentWidth*0.92
                    iconMoney.y    = top + yGap*(self.nbPreviousTickets+self.nbLotteries-1.08)
                    iconMoney:scale(0.5,0.5)
                    hud.board:insert(iconMoney)
                else

                    ---------------------------------------------------------------------
                    -- Instants (IT)

                    viewManager.newText({
                        parent   = hud.board,
                        text     = ticket.bonus.instants,
                        x        = display.contentWidth*0.87,
                        y        = top + yGap*(self.nbPreviousTickets+self.nbLotteries-1.1),
                        fontSize = 37,
                        font     = NUM_FONT,
                        anchorX  = 1,
                        anchorY  = 0.5,
                    })

                    local iconMoney = display.newImage( hud.board, "assets/images/icons/notification/instants.popup.png")
                    iconMoney.x     = display.contentWidth*0.92
                    iconMoney.y     = top + yGap*(self.nbPreviousTickets+self.nbLotteries-1.08)
                    iconMoney:scale(0.5,0.5)
                    hud.board:insert(iconMoney)
                end

            else

                ---------------------------------------------------------------------
                -- Money

                if(ticket.price) then
                    local price = utils.convertAndDisplayPrice(ticket.price, COUNTRY, ticket.lottery.rateUSDtoEUR)

                    viewManager.newText({
                        parent   = hud.board,
                        text     = price,
                        x        = display.contentWidth*0.87,
                        y        = top + yGap*(self.nbPreviousTickets+self.nbLotteries-1.1),
                        fontSize = 37,
                        font     = NUM_FONT,
                        anchorX  = 1,
                        anchorY  = 0.5,

                    })

                    local iconMoney = display.newImage( hud.board, "assets/images/icons/money.png")
                    iconMoney.x     = display.contentWidth*0.92
                    iconMoney.y     = top + yGap*(self.nbPreviousTickets+self.nbLotteries-1.12)
                    hud.board:insert(iconMoney)
                else
                    --- no price, no bonus : '-'

                    viewManager.newText({
                        parent   = hud.board,
                        text     = '-',
                        x        = display.contentWidth*0.92,
                        y        = top + yGap*(self.nbPreviousTickets+self.nbLotteries-1.1),
                        fontSize = 37,
                        font     = NUM_FONT,
                        anchorX  = 1,
                        anchorY  = 0.5,

                    })
                end
            end

        end
    end
end

--------------------------------------------------------------------------------

function scene:loadMoreTickets(first)
    local skip = 0
    if(userManager.tickets) then skip = #userManager.tickets end

    if(first or self.currentLottery) then
        native.setActivityIndicator( true )
        userManager:loadMoreTickets(skip, function(tickets)

            if(#tickets > 0) then
                if(first) then
                    self:drawFirstTickets(tickets)
                else
                    self:prepareLotteryHeights(tickets)
                    self:drawPreviousLotteries(tickets)
                end
            else
                self.currentLottery = nil

            end

            native.setActivityIndicator( false )

        end)
    end
end

--------------------------------------------------------------------------------

function scene:scrollListener(event)

    -- In the event a scroll limit is reached...
    if ( event.limitReached and event.direction == "up") then
        self:loadMoreTickets()
    end

    return true

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

--------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------

return scene