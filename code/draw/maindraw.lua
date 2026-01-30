function drawStateMachine()
    if gameState == "mainmenu" then drawMainMenu()
    elseif gameState == "play" then drawPlay()
    end
end

function drawMainMenu()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(mainMenuFont)
    love.graphics.print("this is the mainmenu", currWinDim.w / 2 - (#tostring("this is the mainmenu")*mainMenuFont:getHeight()), currWinDim.h / 2)
    for i, button in pairs(buttonsMainMenu) do
        drawButton(button)
    end
end

function drawPlay()
    love.graphics.draw(bg_01_dirt,0,0,0,gfxScale,gfxScale)
    love.graphics.draw(player.spriteSheet,0,0,0,gfxScale,gfxScale)
    love.graphics.setColor(0.7, 0.7, 0.7, 0.7)
    love.graphics.rectangle("fill", 0, currWinDim.h * 3 / 5, currWinDim.w, currWinDim.h)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(port_test_360, currWinDim.w * 18 / 24, currWinDim.h * 2 / 3, 0,portScale,portScale)
    love.graphics.draw(port_test_256, currWinDim.w * 1 / 24, currWinDim.h * 17 / 24, 0,portScale,portScale)
end

function drawDebug()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(debugFont)
    love.graphics.print("Current gameState: "..gameState,0,0)
end