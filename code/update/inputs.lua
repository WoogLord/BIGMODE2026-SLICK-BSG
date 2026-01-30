function love.keypressed(key)
    if key == INPUTS_ARR.debug then isDebug = not isDebug end
    if key == INPUTS_ARR.pause then love.event.quit() end
    if key == INPUTS_ARR.fullscreen then allTheFullscreenChangeStuff() end

    -- ui -- mainMenu
    if gameState == "mainmenu" then
        if key == INPUTS_ARR.down[1] or key == INPUTS_ARR.down[2] then
            selOptionMain = math.min(selOptionMain + 1 , #menuOptionsMain)
        elseif key == INPUTS_ARR.up[1] or key == INPUTS_ARR.up[2] then 
            selOptionMain = math.max(selOptionMain - 1 , 1)
        elseif key == INPUTS_ARR.select[1] or key == INPUTS_ARR.select[2] then
            if menuOptionsMain[selOptionMain] == "play" then
                gameState = "play"
            elseif menuOptionsMain[selOptionMain] == "quit" then
                love.event.quit()
            end
        elseif key == INPUTS_ARR.left[1] or key == INPUTS_ARR.left[2] and menuOptionsMain[selOptionMain] == "volume" then
            volumeMaster = math.max(volumeMaster - 0.1, 0)
        elseif key == INPUTS_ARR.right[1] or key == INPUTS_ARR.right[2] and menuOptionsMain[selOptionMain] == "volume" then
            volumeMaster = math.min(volumeMaster + 0.1, 1.0)
        end
    end
end

-- handle inputs - mouse
function isMouseOverButton(_button)
    local mx, my = love.mouse.getPosition()
    return mx > _button.x and mx < _button.x + _button.w and my > _button.y and my < _button.y + _button.h
end

function love.mousepressed(_x, _y, _buttonPressed, _isTouch, _presses)
    if gameState == "mainmenu" then
        handleMainMenuButton(_buttonPressed)
    end
end

function playerControls()
    if gameState == "2dTopDown" then
        --== MOVEMENT ==--
        player.currentAnimState = "Idle"
        -- Angles are in UPLEFT, DOWNLEFT, DOWNRIGHT, UPRIGHT order, then UP, LEFT, DOWN, RIGHT
        -- note: anims are still 4-directions, movement is 8 dir omni
        if (love.keyboard.isDown(INPUTS_ARR.up[1]) or love.keyboard.isDown(INPUTS_ARR.up[2])) 
            and (love.keyboard.isDown(INPUTS_ARR.left[1]) or love.keyboard.isDown(INPUTS_ARR.left[2])) then
            player.currentAnimState = "WalkUp"
            player.mapTileY = player.mapTileY - (gfxScale * moveSpeed / tileWH)
            player.mapTileX = player.mapTileX - (gfxScale * moveSpeed / tileWH)
        elseif (love.keyboard.isDown(INPUTS_ARR.down[1]) or love.keyboard.isDown(INPUTS_ARR.down[2])) 
            and (love.keyboard.isDown(INPUTS_ARR.left[1]) or love.keyboard.isDown(INPUTS_ARR.left[2])) then
            player.currentAnimState = "WalkRight" player.isFlippedLeft = true
            player.mapTileY = player.mapTileY + (gfxScale * moveSpeed / tileWH)
            player.mapTileX = player.mapTileX - (gfxScale * moveSpeed / tileWH)
        elseif (love.keyboard.isDown(INPUTS_ARR.down[1]) or love.keyboard.isDown(INPUTS_ARR.down[2])) 
            and (love.keyboard.isDown(INPUTS_ARR.right[1]) or love.keyboard.isDown(INPUTS_ARR.right[2])) then
            player.currentAnimState = "WalkDown"
            player.mapTileY = player.mapTileY + (gfxScale * moveSpeed / tileWH)
            player.mapTileX = player.mapTileX + (gfxScale * moveSpeed / tileWH)
        elseif (love.keyboard.isDown(INPUTS_ARR.up[1]) or love.keyboard.isDown(INPUTS_ARR.up[2])) 
            and (love.keyboard.isDown(INPUTS_ARR.right[1]) or love.keyboard.isDown(INPUTS_ARR.right[2])) then
            player.currentAnimState = "WalkRight"
            player.mapTileY = player.mapTileY - (gfxScale * moveSpeed / tileWH)
            player.mapTileX = player.mapTileX + (gfxScale * moveSpeed / tileWH)
        elseif love.keyboard.isDown(INPUTS_ARR.up[1]) or love.keyboard.isDown(INPUTS_ARR.up[2]) then
            player.currentAnimState = "WalkUp"
            player.mapTileY = player.mapTileY - (gfxScale * moveSpeed / tileWH)
        elseif love.keyboard.isDown(INPUTS_ARR.left[1]) or love.keyboard.isDown(INPUTS_ARR.left[2]) then
            player.currentAnimState = "WalkRight" player.isFlippedLeft = true
            player.mapTileX = player.mapTileX - (gfxScale * moveSpeed / tileWH)
        elseif love.keyboard.isDown(INPUTS_ARR.down[1]) or love.keyboard.isDown(INPUTS_ARR.down[2]) then
            player.currentAnimState = "WalkDown"
            player.mapTileY = player.mapTileY + (gfxScale * moveSpeed / tileWH)
        elseif love.keyboard.isDown(INPUTS_ARR.right[1]) or love.keyboard.isDown(INPUTS_ARR.right[2]) then
            player.currentAnimState = "WalkRight"
            player.mapTileX = player.mapTileX + (gfxScale * moveSpeed / tileWH)
        end
        player.mapTrueX, player.mapTrueY = (player.mapTileX * tileWH) , (player.mapTileY * tileWH)
    end
end