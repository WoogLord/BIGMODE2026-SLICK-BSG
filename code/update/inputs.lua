function love.keypressed(key)
    if key == INPUTS_ARR.debug then isDebug = not isDebug end
    if key == INPUTS_ARR.fullscreen then allTheFullscreenChangeStuff() end

    -- ui -- mainMenu
    if gameState == "mainmenu" and globalSpriteTimer > introWindUpTime then
        if key == INPUTS_ARR.down[1] or key == INPUTS_ARR.down[2] then
            sfxManager(sfxSources.menuSelection, false)
            selOptionMain = math.min(selOptionMain + 1 , #menuOptionsMain)
        elseif key == INPUTS_ARR.up[1] or key == INPUTS_ARR.up[2] then 
            sfxManager(sfxSources.menuSelection, false)
            selOptionMain = math.max(selOptionMain - 1 , 1)
        elseif key == INPUTS_ARR.select[1] or key == INPUTS_ARR.select[2] or key == INPUTS_ARR.select[3] then
            sfxManager(sfxSources.menuOK, false)
            if menuOptionsMain[selOptionMain] == "PLAY" then
                gameState = "play"
                playState = "exploring"
            elseif menuOptionsMain[selOptionMain] == "QUIT" then
                love.event.quit()
            end
        elseif key == INPUTS_ARR.left[1] or key == INPUTS_ARR.left[2] and menuOptionsMain[selOptionMain] == "VOLUME" then
            sfxManager(sfxSources.menuSelection, false)
            volumeMaster = math.max((math.floor(volumeMaster * 10) - 1) / 10, 0)
        elseif key == INPUTS_ARR.right[1] or key == INPUTS_ARR.right[2] and menuOptionsMain[selOptionMain] == "VOLUME" then
            sfxManager(sfxSources.menuSelection, false)
            volumeMaster = math.min((math.floor(volumeMaster * 10) + 1) / 10, 1.0)
        end
    end
    
    -- ui -- play

    if gameState == "play" then
        if playState == "exploring" then
            if key == INPUTS_ARR.bossFightDebug then bossFightInit() end
            if isInBossFight then 
                if key == INPUTS_ARR.cancel then
                    influencerCurrentHP = math.max(influencerCurrentHP - playerTotalDamage, 0)
                end
            elseif isGettingItem then
                if key == INPUTS_ARR.select[1] or key == INPUTS_ARR.select[2] or key == INPUTS_ARR.select[3] then
                    -- exit get item state
                    table.insert(InventoryBag, currentItemBeingGot)
                    -- currentItemBeingGotInt = #InventoryBag + 1
                    isGettingItem = false
                end
            elseif inventoryHandler then --Inventory Logic
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
            elseif conversationState ~= "" then --Conversation logic
                if key == INPUTS_ARR.pause then playState = "pause"
                elseif key == INPUTS_ARR.select[1] or key == INPUTS_ARR.select[2] or key == INPUTS_ARR.select[3] then
                    sfxManager(sfxSources.menuOK, false)               
                    handleDialogSelection()
                elseif key == INPUTS_ARR.down[1] or key == INPUTS_ARR.down[2] then
                    sfxManager(sfxSources.menuSelection, false)
                    selDialogOption = math.min(selDialogOption + 1 , #currentDialogTreeNode.responses)
                elseif key == INPUTS_ARR.up[1] or key == INPUTS_ARR.up[2] then
                    sfxManager(sfxSources.menuSelection, false)
                    selDialogOption = math.max(selDialogOption - 1 , 1)
                elseif key == INPUTS_ARR.cancel then -- UPDATE LATER
                    conversationState = ""
                    currentDialogTreeNode = nil
                end
            else
                --pause toggle
                if key == INPUTS_ARR.pause then playState = "pause"
                -- Inventory logic
                elseif key == INPUTS_ARR.inventory then inventoryHandler = not inventoryHandler
                elseif key == INPUTS_ARR.select[1] or key == INPUTS_ARR.select[2] or key == INPUTS_ARR.select[3] then
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
            elseif key == INPUTS_ARR.down[1] or key == INPUTS_ARR.down[2] then
                sfxManager(sfxSources.menuSelection, false)
                selOptionPause = math.min(selOptionPause + 1 , #menuOptionsPause)
            elseif key == INPUTS_ARR.up[1] or key == INPUTS_ARR.up[2] then 
                sfxManager(sfxSources.menuSelection, false)
                selOptionPause = math.max(selOptionPause - 1 , 1)
            elseif key == INPUTS_ARR.select[1] or key == INPUTS_ARR.select[2] or key == INPUTS_ARR.select[3] then
                sfxManager(sfxSources.menuOK, false)
                if menuOptionsPause[selOptionPause] == "UNPAUSE" then
                    playState = "exploring"
                elseif menuOptionsPause[selOptionPause] == "QUIT" then
                    love.event.quit()
                end
            elseif key == INPUTS_ARR.left[1] or key == INPUTS_ARR.left[2] and menuOptionsPause[selOptionPause] == "VOLUME" then
                sfxManager(sfxSources.menuSelection, false)
                volumeMaster = math.max((math.floor(volumeMaster * 10) - 1) / 10, 0)
            elseif key == INPUTS_ARR.right[1] or key == INPUTS_ARR.right[2] and menuOptionsPause[selOptionPause] == "VOLUME" then
                sfxManager(sfxSources.menuSelection, false)
                volumeMaster = math.min((math.floor(volumeMaster * 10) + 1) / 10, 1.0)
            elseif key == INPUTS_ARR.cancel then love.event.quit()
            end
        end        
    end

    if gameState == "defeat" then
        if key == INPUTS_ARR.cancel then
            player.mapTileX = 1
            player.mapTileY = 15.5
            gameState = "play"
            playState = "exploring"        
        end
    end

    if gameState == "victory" then
        if key == INPUTS_ARR.cancel then
            love.event.quit()
        end
    end
end

-- -- handle inputs - mouse
-- function isMouseOverButton(_button)
--     local mx, my = love.mouse.getPosition()
--     return mx > _button.x and mx < _button.x + _button.w and my > _button.y and my < _button.y + _button.h
-- end

-- function love.mousepressed(_x, _y, _buttonPressed, _isTouch, _presses)
--     if gameState == "mainmenu" then
--         handleMainMenuButton(_buttonPressed)
--     end
-- end

function playerControls()
    if gameState == "play" and playState == "exploring" and not inventoryHandler and conversationState == "" and not isGettingItem then
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
            player.mapTileY = player.mapTileY - (4 * moveSpeed / tileWH)
            player.mapTileX = player.mapTileX - (4 * moveSpeed / tileWH)
        elseif (love.keyboard.isDown(INPUTS_ARR.down[1]) or love.keyboard.isDown(INPUTS_ARR.down[2])) 
            and (love.keyboard.isDown(INPUTS_ARR.left[1]) or love.keyboard.isDown(INPUTS_ARR.left[2])) then
            player.anim.currAnimState = 6 player.facing = "Left" player.isFlippedLeft = true
            player.mapTileY = player.mapTileY + (4 * moveSpeed / tileWH)
            player.mapTileX = player.mapTileX - (4 * moveSpeed / tileWH)
        elseif (love.keyboard.isDown(INPUTS_ARR.down[1]) or love.keyboard.isDown(INPUTS_ARR.down[2])) 
            and (love.keyboard.isDown(INPUTS_ARR.right[1]) or love.keyboard.isDown(INPUTS_ARR.right[2])) then
            player.anim.currAnimState = 4 player.facing = "Down" player.isFlippedLeft = false
            player.mapTileY = player.mapTileY + (4 * moveSpeed / tileWH)
            player.mapTileX = player.mapTileX + (4 * moveSpeed / tileWH)
        elseif (love.keyboard.isDown(INPUTS_ARR.up[1]) or love.keyboard.isDown(INPUTS_ARR.up[2])) 
            and (love.keyboard.isDown(INPUTS_ARR.right[1]) or love.keyboard.isDown(INPUTS_ARR.right[2])) then
            player.anim.currAnimState = 6 player.facing = "Right" player.isFlippedLeft = false
            player.mapTileY = player.mapTileY - (4 * moveSpeed / tileWH)
            player.mapTileX = player.mapTileX + (4 * moveSpeed / tileWH)
        elseif love.keyboard.isDown(INPUTS_ARR.up[1]) or love.keyboard.isDown(INPUTS_ARR.up[2]) then
            player.anim.currAnimState = 5 player.facing = "Up" player.isFlippedLeft = false
            player.mapTileY = player.mapTileY - (4 * moveSpeed / tileWH)
        elseif love.keyboard.isDown(INPUTS_ARR.left[1]) or love.keyboard.isDown(INPUTS_ARR.left[2]) then
            player.anim.currAnimState = 6 player.facing = "Left" player.isFlippedLeft = true
            player.mapTileX = player.mapTileX - (4 * moveSpeed / tileWH)
        elseif love.keyboard.isDown(INPUTS_ARR.down[1]) or love.keyboard.isDown(INPUTS_ARR.down[2]) then
            player.anim.currAnimState = 4 player.facing = "Down" player.isFlippedLeft = false
            player.mapTileY = player.mapTileY + (4 * moveSpeed / tileWH)
        elseif love.keyboard.isDown(INPUTS_ARR.right[1]) or love.keyboard.isDown(INPUTS_ARR.right[2]) then
            player.anim.currAnimState = 6 player.facing = "Right" player.isFlippedLeft = false
            player.mapTileX = player.mapTileX + (4 * moveSpeed / tileWH)
        end
    end
end