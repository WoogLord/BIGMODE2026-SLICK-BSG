function drawStateMachine()
    if gameState == "mainmenu" then drawMainMenu()
    elseif gameState == "play2dTopDown" then draw2dTopDown()
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

function draw2dTopDown()
    love.graphics.draw(bg_01_dirt,0,0,0,gfxScale,gfxScale)
    love.graphics.draw(player.spriteSheet,0,0,0,gfxScale,gfxScale)
end

function drawDebug()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(debugFont)
    love.graphics.print("Current gameState: "..gameState,0,0)
end