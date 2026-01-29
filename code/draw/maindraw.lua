function drawStateMachine()
    if gameState == "mainmenu" then drawMainMenu() 
    end
end

function drawMainMenu()
    love.graphics.setFont(mainMenuFont)
    love.graphics.print("this is the mainmenu", currWinDim.w / 2, currWinDim.h / 2)
end