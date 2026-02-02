function gameManager()

end

function handleMainMenuButton(_buttonPressed)
    if _buttonPressed == 1 and isMouseOverButton(buttonsMainMenu.quit) then love.event.quit()
    elseif _buttonPressed == 1 and isMouseOverButton(buttonsMainMenu.play) then gameState = "play"
    end
end

function allTheFullscreenChangeStuff()
    local pw, ph = love.graphics.getDimensions()
    priorWinDim = {w = pw, h = ph}
    isFullScreen = not isFullScreen
    love.window.setFullscreen(isFullScreen)
    local cw, ch = love.graphics.getDimensions()
    currWinDim.w, currWinDim.h = cw, ch 
    local recalcRatio = (currWinDim.w / priorWinDim.w)
    -- use the recalcRatio like below:
    -- PLAYER_STATS_ARR.x, PLAYER_STATS_ARR.y = PLAYER_STATS_ARR.x * recalcRatio, PLAYER_STATS_ARR.y * recalcRatio
end

function handleCollision()

end

function handleInteraction()
   -- check for interactable
   -- starts conversation/does interactable
   
end
