function drawStateMachine()
    if gameState == "mainmenu" then drawMainMenu()
    elseif gameState == "play" then drawPlay()
    end
end

function drawMainMenu()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(mainMenuFont)
    love.graphics.print("this is the mainmenu")
    
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

function drawPlay()
    love.graphics.draw(bg_01_dirt,0,0,0,gfxScale,gfxScale)
    love.graphics.draw(player.spriteSheet,0,0,0,gfxScale,gfxScale)
    
    nineSlicer(
        0, currWinDim.h * 3 / 5, currWinDim.w, currWinDim.h
        , {0.7, 0.7, 0.7, 0.7}
        , chatbox_9slice
    )

    love.graphics.draw(port_test_360, currWinDim.w * 18 / 24, currWinDim.h *  31 / 48, 0,portScale,portScale)
    love.graphics.draw(port_test_256, currWinDim.w * 1 / 24, currWinDim.h * 17 / 24, 0,portScale,portScale)
end

function drawDebug()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(debugFont)
    love.graphics.print("Current gameState: "..gameState,0,0)
end