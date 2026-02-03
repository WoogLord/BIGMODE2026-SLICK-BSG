function love.keypressed(key)
    if key == INPUTS_ARR.debug then isDebug = not isDebug end
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
                playState = "exploring"
            elseif menuOptionsMain[selOptionMain] == "quit" then
                love.event.quit()
            end
        elseif key == INPUTS_ARR.left[1] or key == INPUTS_ARR.left[2] and menuOptionsMain[selOptionMain] == "volume" then
            volumeMaster = math.max(volumeMaster - 0.1, 0)
        elseif key == INPUTS_ARR.right[1] or key == INPUTS_ARR.right[2] and menuOptionsMain[selOptionMain] == "volume" then
            volumeMaster = math.min(volumeMaster + 0.1, 1.0)
        end
    end
    
    
    -- ui -- play
    if gameState == "play" then
        if playState == "exploring" then
            if inventoryHandler then
                if key == INPUTS_ARR.down[1] or key == INPUTS_ARR.down[2] then
                    selOptionInv = math.min(selOptionInv + 5 , #InventoryBag)
                elseif key == INPUTS_ARR.up[1] or key == INPUTS_ARR.up[2] then 
                    selOptionInv = math.max(selOptionInv - 5, 1) 
                elseif key == INPUTS_ARR.left[1] or key == INPUTS_ARR.left[2] then
                    selOptionInv = math.min(selOptionInv - 1 , #InventoryBag)
                elseif key == INPUTS_ARR.right[1] or key == INPUTS_ARR.right[2] then
                    selOptionInv = math.max(selOptionInv + 1, 1)
                elseif key == INPUTS_ARR.inventory then inventoryHandler = not inventoryHandler
                end
            elseif conversationState ~= "" then
                if key == INPUTS_ARR.pause then playState = "pause"
                elseif key == INPUTS_ARR.select[1] or key == INPUTS_ARR.select[2] then
                    -- RICHARD: progress dialogue
                end
            else
                --pause toggle
                if key == INPUTS_ARR.pause then playState = "pause"
                -- Inventory logic
                elseif key == INPUTS_ARR.inventory then inventoryHandler = not inventoryHandler
                elseif key == INPUTS_ARR.select[1] or key == INPUTS_ARR.select[2] then
                    interactingWith = handleInteraction()
                    if interactingWith ~= 0 then
                        startConversationWith(interactingWith)
                    end
                end
            end
        elseif playState == "pause" then
            --pause toggle
            if key == INPUTS_ARR.pause then playState = "exploring"
            -- Pause quit
            elseif key == INPUTS_ARR.cancel then love.event.quit()
            end
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
    if gameState == "play" and playState == "exploring" and not inventoryHandler and conversationState == "" then
        --== MOVEMENT ==--
        if player.facing == "Down" then player.anim.currAnimState = 1 player.isFlippedLeft = false
        elseif player.facing == "Up" then player.anim.currAnimState = 2 player.isFlippedLeft = false
        elseif player.facing == "Right" then player.anim.currAnimState = 3 player.isFlippedLeft = false
        elseif player.facing == "Left" then player.anim.currAnimState = 3 player.isFlippedLeft = true
        end
        -- Angles are in UPLEFT, DOWNLEFT, DOWNRIGHT, UPRIGHT order, then UP, LEFT, DOWN, RIGHT
        -- note: anims are still 4-directions, movement is 8 dir omni
        if (love.keyboard.isDown(INPUTS_ARR.up[1]) or love.keyboard.isDown(INPUTS_ARR.up[2])) 
            and (love.keyboard.isDown(INPUTS_ARR.left[1]) or love.keyboard.isDown(INPUTS_ARR.left[2])) then
            player.anim.currAnimState = 5 player.facing = "Up" player.isFlippedLeft = false
            player.mapTileY = player.mapTileY - (gfxScale * moveSpeed / tileWH)
            player.mapTileX = player.mapTileX - (gfxScale * moveSpeed / tileWH)
        elseif (love.keyboard.isDown(INPUTS_ARR.down[1]) or love.keyboard.isDown(INPUTS_ARR.down[2])) 
            and (love.keyboard.isDown(INPUTS_ARR.left[1]) or love.keyboard.isDown(INPUTS_ARR.left[2])) then
            player.anim.currAnimState = 6 player.facing = "Left" player.isFlippedLeft = true
            player.mapTileY = player.mapTileY + (gfxScale * moveSpeed / tileWH)
            player.mapTileX = player.mapTileX - (gfxScale * moveSpeed / tileWH)
        elseif (love.keyboard.isDown(INPUTS_ARR.down[1]) or love.keyboard.isDown(INPUTS_ARR.down[2])) 
            and (love.keyboard.isDown(INPUTS_ARR.right[1]) or love.keyboard.isDown(INPUTS_ARR.right[2])) then
            player.anim.currAnimState = 4 player.facing = "Down" player.isFlippedLeft = false
            player.mapTileY = player.mapTileY + (gfxScale * moveSpeed / tileWH)
            player.mapTileX = player.mapTileX + (gfxScale * moveSpeed / tileWH)
        elseif (love.keyboard.isDown(INPUTS_ARR.up[1]) or love.keyboard.isDown(INPUTS_ARR.up[2])) 
            and (love.keyboard.isDown(INPUTS_ARR.right[1]) or love.keyboard.isDown(INPUTS_ARR.right[2])) then
            player.anim.currAnimState = 6 player.facing = "Right" player.isFlippedLeft = false
            player.mapTileY = player.mapTileY - (gfxScale * moveSpeed / tileWH)
            player.mapTileX = player.mapTileX + (gfxScale * moveSpeed / tileWH)
        elseif love.keyboard.isDown(INPUTS_ARR.up[1]) or love.keyboard.isDown(INPUTS_ARR.up[2]) then
            player.anim.currAnimState = 5 player.facing = "Up" player.isFlippedLeft = false
            player.mapTileY = player.mapTileY - (gfxScale * moveSpeed / tileWH)
        elseif love.keyboard.isDown(INPUTS_ARR.left[1]) or love.keyboard.isDown(INPUTS_ARR.left[2]) then
            player.anim.currAnimState = 6 player.facing = "Left" player.isFlippedLeft = true
            player.mapTileX = player.mapTileX - (gfxScale * moveSpeed / tileWH)
        elseif love.keyboard.isDown(INPUTS_ARR.down[1]) or love.keyboard.isDown(INPUTS_ARR.down[2]) then
            player.anim.currAnimState = 4 player.facing = "Down" player.isFlippedLeft = false
            player.mapTileY = player.mapTileY + (gfxScale * moveSpeed / tileWH)
        elseif love.keyboard.isDown(INPUTS_ARR.right[1]) or love.keyboard.isDown(INPUTS_ARR.right[2]) then
            player.anim.currAnimState = 6 player.facing = "Right" player.isFlippedLeft = false
            player.mapTileX = player.mapTileX + (gfxScale * moveSpeed / tileWH)
        end
    end
end