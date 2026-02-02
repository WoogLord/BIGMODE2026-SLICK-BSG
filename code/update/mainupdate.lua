function gameManager()
    player.mapTrueX, player.mapTrueY = (player.mapTileX * tileWH) , (player.mapTileY * tileWH)
    player.lastMapTileX, player.lastMapTileY = player.mapTileX, player.mapTileY
    player.hitbox.x = currWinDim.w / 2 - (tileWH / 2) + (8 * gfxScale)
    player.hitbox.y = currWinDim.h / 2 - (tileWH / 2) + (16 * gfxScale)
    handleCollision()
    handleInteraction()
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

function checkCollision(_a, _b)
    -- basic rectangle collision
    return _a.x < _b.x + _b.hitbox.w -- x min
        and _a.x + _a.hitbox.w > _b.x -- x max
        and _a.y < _b.y + _b.hitbox.h -- y min
        and _a.y + _a.hitbox.h > _b.y -- y max
end

function isRedPixel(_x, _y) -- the red being whatever we need to check
    _x = math.floor(_x)
    _y = math.floor(_y)
    if _x < 0 or _y < 0 or _x >= bg_01_collisionData:getWidth() or _y >= bg_01_collisionData:getHeight() then return false end
    local r,g,b,a = bg_01_collisionData:getPixel(_x, _y)
    print("checking coords: x ".._x..", y ".._y.."; and colors r"..r..", g"..g..", b"..b..", a"..a)
    return r == (192 / 255) and g == (33/ 255) and b == (33/ 255) and a == (255/ 255)
end

function handleCollision()
    if isRedPixel(player.mapTrueX + (8 * gfxScale), player.mapTrueY + (16 * gfxScale)) then
        player.isColliding = true
        player.mapTileX, player.mapTileY = player.lastMapTileX, player.lastMapTileY
    else
        player.isColliding = false
    end
end

function handleInteraction()
   -- check for interactable
   -- starts conversation/does interactable
   
end
