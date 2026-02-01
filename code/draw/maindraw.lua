-- Debugger

function drawDebug()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(debugFont)
    love.graphics.print("Current gameState: "..gameState,0,0)
    love.graphics.print("Current playState: "..playState,0,20)
    love.graphics.print("Current inventoryHandler: "..tostring(inventoryHandler),0,40)
end

-- Top level state handler

function drawStateMachine()
    if gameState == "mainmenu" then drawMainMenu()
    elseif gameState == "play" then drawPlay()
    end
end

-- Main menu

function drawMainMenu()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(mainMenuFont)
    love.graphics.print("this is the mainmenu 8=D")
    
    -- old button code
    -- for i, button in pairs(buttonsMainMenu) do
    --     drawButton(button)
    -- end

    for i, option in ipairs(menuOptionsMain) do
        if i == selOptionMain then love.graphics.setColor(1, 0, 0)  -- Highlight selected option in red
        else love.graphics.setColor(1, 1, 1)  -- Normal color
        end
        -- are things not centered?  check here lol, fix #option
        love.graphics.print(option, currWinDim.w / 2 - (#option * 10), currWinDim.h / 2 + (i - 1) * 40)
    end  

    for j=1, 10, 1 do 
        if math.floor(volumeMaster*10) == j then love.graphics.setColor(0, 0, 1) else love.graphics.setColor(1, 1, 1) end
        love.graphics.rectangle("fill", currWinDim.w / 2 + (#menuOptionsMain[2] * 10) + (j*12), currWinDim.h / 2 + mainMenuFont:getHeight() + 21, 6, 6)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(volumeMaster*100, currWinDim.w / 2 + (#menuOptionsMain[2] * 10) + 144, currWinDim.h / 2 + mainMenuFont:getHeight() + 6)
end

-- Play state handler and play drawing functions

function drawPlay()
    if playState == "exploring" then drawExploring()
    elseif playState == "conversation" then drawConversation()
    elseif playState == "pause" then drawPauseMenu()
    end
end

function drawExploring()
    

    love.graphics.draw(bg_01_dirt,0,0,0,gfxScale,gfxScale)
    love.graphics.draw(player.spriteSheet,0,0,0,gfxScale,gfxScale)
    
    nineSlicer(
        0, currWinDim.h * 3 / 5, currWinDim.w, currWinDim.h
        , {0.7, 0.7, 0.7, 0.7}
        , chatbox_9slice
    )
    
    love.graphics.draw(port_test_360, currWinDim.w * 18 / 24, currWinDim.h *  31 / 48, 0,portScale,portScale)
    love.graphics.draw(port_test_256, currWinDim.w * 1 / 24, currWinDim.h * 17 / 24, 0,portScale,portScale)love.graphics.draw(bg_01_dirt,0,0,0,gfxScale,gfxScale)
    love.graphics.draw(player.spriteSheet,0,0,0,gfxScale,gfxScale)
    
    nineSlicer(
        0, currWinDim.h * 3 / 5, currWinDim.w, currWinDim.h
        , {0.7, 0.7, 0.7, 0.7}
        , chatbox_9slice
    )
    
    love.graphics.draw(port_test_360, currWinDim.w * 18 / 24, currWinDim.h *  31 / 48, 0,portScale,portScale)
    love.graphics.draw(port_test_256, currWinDim.w * 1 / 24, currWinDim.h * 17 / 24, 0,portScale,portScale)

    -- Inventory call

    if inventoryHandler == true then
        drawInventory()
    end
end

function drawConversation()

end

function drawInventory()
    love.graphics.rectangle("fill", currWinDim.w / 4, currWinDim.h / 4, 700, 400)
    love.graphics.draw(player.spriteSheet,currWinDim.w / 4 + 550,currWinDim.h / 4 + 140,0,gfxScale,gfxScale)
end

function drawPauseMenu()
    love.graphics.print("PAUSE", currWinDim.w / 2, currWinDim.h / 2, 0,portScale,portScale)
    love.graphics.print("Press x to quit game :(", currWinDim.w / 2 - 35, currWinDim.h / 2 + 120, 0, .5, .5)
end