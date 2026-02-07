-- UTILITY FUNCTIONS

-- Generic contains function: checks whether a table contains the given string.
-- Usage: `local has = contains(InventoryBag, "Jacket", true)`
-- third arg `caseInsensitive` is optional (default false)
function contains(tbl, searchStr, caseInsensitive)
    if not tbl or not searchStr then return false end
    for _, v in ipairs(tbl) do
        if type(v) == "string" and type(searchStr) == "string" then
            if caseInsensitive then
                if v:lower() == searchStr:lower() then return true end
            else
                if v == searchStr then return true end
            end
        end
    end
    return false
end

--Random number generator
function randomNumber(max)
    return love.math.random(1, max)
end


function gameManager()
    player.mapTrueX, player.mapTrueY = (player.mapTileX * tileWH), (player.mapTileY * tileWH)
    player.hitbox.x = currWinDim.w / 2 - (tileWH / 2) + (9 * gfxScale)
    player.hitbox.y = currWinDim.h / 2 - (tileWH / 2) + (18 * gfxScale)

    handleCollision()
    handleConversation()

    if isInBossFight == true and not bossFightIntroMovie:isPlaying() then
        bossFightGameState()
    end
    -- if bossFightIntroMovie:isPlaying() then isInBossFight = true else isInBossFight = false end
end

function handleMainMenuButton(_buttonPressed)
    if _buttonPressed == 1 and isMouseOverButton(buttonsMainMenu.quit) then
        love.event.quit()
    elseif _buttonPressed == 1 and isMouseOverButton(buttonsMainMenu.play) then
        gameState = "play"
    end
end

function allTheFullscreenChangeStuff()
    local pw, ph = love.graphics.getDimensions()
    priorWinDim = { w = pw, h = ph }
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
    return _a.mapTrueX < _b.mapTrueX + (interactableHitbox.w * 3 / 6)                  -- x min
        and _a.mapTrueX + _a.hitbox.w > (_b.mapTrueX - (interactableHitbox.w * 3 / 6)) -- x max
        and _a.mapTrueY < _b.mapTrueY + (interactableHitbox.h * 3 / 6)                 -- y min
        and _a.mapTrueY + _a.hitbox.h > (_b.mapTrueY - (interactableHitbox.h * 3 / 6)) -- y max
end

function isRedPixel(_collisionData, _x, _y, _w, _h) -- the red being whatever we need to check
    _x = math.floor(_x)
    _y = math.floor(_y)
    if _x < 0 or _y < 0 or (_x + _w) >= _collisionData:getWidth() or (_y + _h) >= _collisionData:getHeight() then return true end
    for w = 0, _w - 1, 1 do
        for h = 0, _h - 1, 1 do
            local r, g, b, a = _collisionData:getPixel(_x + w, _y + h)
            if r == (192 / 255) and g == (33 / 255) and b == (33 / 255) and a > 0 then
                return true
            end
        end
    end
end

function handleCollision()
    if isRedPixel(currentCollisionData, player.mapTrueX - (tileWH / 2) + (6 * gfxScale), player.mapTrueY - (tileWH / 2) + (8 * gfxScale)
        , player.hitbox.w, player.hitbox.h) then
        player.isColliding = true
        player.mapTileX, player.mapTileY = player.lastMapTileX, player.lastMapTileY
        player.mapTrueX, player.mapTrueY = player.lastMapTrueX, player.lastMapTrueY
    else
        player.isColliding = false
        lastPositionSave()
    end
    if isRedPixel(bg_Collision_InClub_Data, player.mapTrueX - (tileWH / 2) + (6 * gfxScale), player.mapTrueY - (tileWH / 2) + (8 * gfxScale)
        , player.hitbox.w, player.hitbox.h) then
        player.inClub = true
    else
        player.inClub = false
    end
end

function lastPositionSave()
    player.lastMapTileX, player.lastMapTileY = player.mapTileX, player.mapTileY
    player.lastMapTrueX, player.lastMapTrueY = player.mapTrueX, player.mapTrueY
end

function handleInteraction()
    for _, interacts in pairs(interactables) do
        if checkCollision(player, interacts) then return interacts.id end
    end
    return 0
end

-- CONVERSATION HANDLING FUNCTIONS

function startConversationWith(_interactableID)
    if _interactableID == 0 then
        print("no babe detected...")
    else 
        print(interactables[_interactableID].vanityName)
        conversationState = interactables[_interactableID].vanityName

        -- Goth girl section
        if conversationState == interactables[1].vanityName then
            if gothGirlConvoState == 0 then
                currentDialogTreeId = "1"
            elseif gothGirlConvoState == 1 then
                jacketGuyConvoState = 1
                if contains(InventoryBag, interactables[1].passingItems[1], true) then
                    currentDialogTreeId = interactables[1].passPoints[1]
                else
                    currentDialogTreeId = interactables[1].checkPoints[1]
                end
            end
        -- Sorority girl section
        elseif conversationState == interactables[2].vanityName then
            if sororityGirlConvoState == 0 then
                currentDialogTreeId = "1z"
            elseif sororityGirlConvoState == 1 then
                if contains(InventoryBag, interactables[2].passingItems[1], true) then
                    currentDialogTreeId = interactables[2].passPoints[1]
                else
                    currentDialogTreeId = interactables[2].checkPoints[1]
                end
            elseif sororityGirlConvoState == 2 then
                hairGuyConvoState = 1
                if contains(InventoryBag, interactables[2].passingItems[2], true) then
                    currentDialogTreeId = interactables[2].passPoints[2]
                else
                    currentDialogTreeId = interactables[2].checkPoints[2]
                end
            elseif sororityGirlConvoState == 3 then
                if contains(InventoryBag, interactables[2].passingItems[3], true) then
                    currentDialogTreeId = interactables[2].passPoints[3]
                else
                    currentDialogTreeId = interactables[2].checkPoints[3]
                end
            end
        -- Influancer girl section
        elseif conversationState == interactables[3].vanityName then
            if influencerGirlConvoState == 0 then
                currentDialogTreeId = "1"
            elseif influencerGirlConvoState == 1 then
                if contains(InventoryBag, interactables[3].passingItems[1], true) then
                    currentDialogTreeId = interactables[3].passPoints[1]
                else
                    currentDialogTreeId = interactables[3].checkPoints[1]
                end
            elseif influencerGirlConvoState == 2 then
                if contains(InventoryBag, interactables[3].passingItems[2], true) then
                    currentDialogTreeId = interactables[3].passPoints[2]
                else
                    currentDialogTreeId = interactables[3].checkPoints[2]
                end
            elseif influencerGirlConvoState == 3 then
                if contains(InventoryBag, interactables[3].passingItems[3], true) then
                    currentDialogTreeId = interactables[3].passPoints[3]
                else
                    currentDialogTreeId = interactables[3].checkPoints[3]
                end
            end
        elseif conversationState == interactables[4].vanityName then
            --NEEDS TO BE TESTED
            if jacketGuyConvoState == 0 then
                currentDialogTreeId = tostring(math.random(3))
            elseif jacketGuyConvoState == 1 then
                currentDialogTreeId = "4"
            elseif jacketGuyConvoState == 2 then

                --logic to swap to no jacket guy
                currentDialogTreeId = "4" --REMOVE
            end
        elseif conversationState == interactables[5].vanityName then
            --NEEDS TO BE TESTED
            if hairGuyConvoState == 0 then
                currentDialogTreeId = tostring(math.random(3))
            elseif hairGuyConvoState == 1 then
                currentDialogTreeId = "4"
            elseif hairGuyConvoState == 2 then
                currentDialogTreeId = "6"
            end
        elseif conversationState == interactables[6].vanityName then
            --NEEDS TO BE TESTED
            if shadesGuyConvoState == 0 then
                currentDialogTreeId = tostring(math.random(3))
            elseif shadesGuyConvoState == 1 then
                currentDialogTreeId = "4"
            elseif shadesGuyConvoState == 2 then
                currentDialogTreeId = "6"
            end
        elseif conversationState == interactables[7].vanityName then
            --NEEDS TO BE TESTED
            if absGuyConvoState == 0 then
                currentDialogTreeId = tostring(math.random(3))
            elseif absGuyConvoState == 1 then
                currentDialogTreeId = "4"
            elseif absGuyConvoState == 2 then
                currentDialogTreeId = "5"
            end
        elseif conversationState == interactables[8].vanityName then
            --NEEDS TO BE TESTED
            if shoesGirlConvoState == 0 then
                currentDialogTreeId = tostring(math.random(3))
            elseif shoesGirlConvoState == 1 then
                currentDialogTreeId = "4"
            elseif shoesGirlConvoState == 2 then
                currentDialogTreeId = "5"
            end
        elseif conversationState == interactables[9].vanityName then
            --NEEDS TO BE TESTED
            if shortsGuyConvoState == 0 then
                currentDialogTreeId = tostring(math.random(3))
            elseif shortsGuyConvoState == 1 then
                currentDialogTreeId = "4"
            elseif shortsGuyConvoState == 2 then
                currentDialogTreeId = "5"
            end
        elseif conversationState == interactables[10].vanityName then
            --NEEDS TO BE TESTED
            if mewGuyConvoState == 0 then
                currentDialogTreeId = tostring(math.random(4))
            elseif mewGuyConvoState == 1 then
                currentDialogTreeId = "5"
            elseif mewGuyConvoState == 2 then
                currentDialogTreeId = "9"
            end
        elseif conversationState == interactables[11].vanityName then
            --NEEDS TO BE TESTED
            currentDialogTreeId = "1" 
        end
    end
end

function handleConversation()
    function findDialogNode(tree, id)
        if not tree or not id then return nil end
        if not tree._index then
            tree._index = {}
            for _, node in ipairs(tree) do
                if node.id ~= nil then
                    tree._index[tostring(node.id)] = node
                end
            end
        end
        return tree._index[tostring(id)]
    end

    if conversationState == "" then
        return

        -- Goth girl section
    elseif conversationState == interactables[1].vanityName then
        currentDialogTreeNode = findDialogNode(gothGirlTree, currentDialogTreeId)

        -- set portrait animation based on npcEmotion
        interactables[1].portrait.anim.currAnimState = currentDialogTreeNode.npcEmotion

        if currentDialogTreeNode["checkPoint"] ~= nil then
            gothGirlConvoState = currentDialogTreeNode.checkPoint
        end

        --Sorority girl section
    elseif conversationState == interactables[2].vanityName then
        currentDialogTreeNode = findDialogNode(sororityGirlTree, currentDialogTreeId)

        -- set portrait animation based on npcEmotion
        interactables[2].portrait.anim.currAnimState = currentDialogTreeNode.npcEmotion

        if currentDialogTreeNode["checkPoint"] ~= nil then
            sororityGirlConvoState = currentDialogTreeNode.checkPoint
        end
        --Influancer girl section
    elseif conversationState == interactables[3].vanityName then
        currentDialogTreeNode = findDialogNode(influencerGirlTree, currentDialogTreeId)

        -- set portrait animation based on npcEmotion
        interactables[3].portrait.anim.currAnimState = currentDialogTreeNode.npcEmotion

        if currentDialogTreeNode["checkPoint"] ~= nil then
            influencerGirlConvoState = currentDialogTreeNode.checkPoint
        end
    elseif conversationState == interactables[4].vanityName then
        currentDialogTreeNode = findDialogNode(jacketGuyTree, currentDialogTreeId)

        if currentDialogTreeNode["checkPoint"] ~= nil then
            jacketGuyConvoState = currentDialogTreeNode.checkPoint
        end
    elseif conversationState == interactables[5].vanityName then
        currentDialogTreeNode = findDialogNode(hairGuyTree, currentDialogTreeId)

        if currentDialogTreeNode["checkPoint"] ~= nil then
            hairGuyConvoState = currentDialogTreeNode.checkPoint
        end
    elseif conversationState == interactables[6].vanityName then
        currentDialogTreeNode = findDialogNode(shadesGuyTree, currentDialogTreeId)

        if currentDialogTreeNode["checkPoint"] ~= nil then
            shadesGuyConvoState = currentDialogTreeNode.checkPoint
        end
    elseif conversationState == interactables[7].vanityName then
        currentDialogTreeNode = findDialogNode(absGuyTree, currentDialogTreeId)

        if currentDialogTreeNode["checkPoint"] ~= nil then
            absGuyConvoState = currentDialogTreeNode.checkPoint
        end
    elseif conversationState == interactables[8].vanityName then
        currentDialogTreeNode = findDialogNode(shoesGirlTree, currentDialogTreeId)

        if currentDialogTreeNode["checkPoint"] ~= nil then
            shoesGirlConvoState = currentDialogTreeNode.checkPoint
        end
    elseif conversationState == interactables[9].vanityName then
        currentDialogTreeNode = findDialogNode(shortsGuyTree, currentDialogTreeId)

        if currentDialogTreeNode["checkPoint"] ~= nil then
            shortsGuyConvoState = currentDialogTreeNode.checkPoint
        end
    elseif conversationState == interactables[10].vanityName then
        currentDialogTreeNode = findDialogNode(mewGuyTree, currentDialogTreeId)

        if currentDialogTreeNode["checkPoint"] ~= nil then
            mewGuyConvoState = currentDialogTreeNode.checkPoint
        end
    end
end

function handleDialogSelection()
    if currentDialogTreeNode == nil or disableSelect == true then return end
    local selectedOption = currentDialogTreeNode.responses[selDialogOption]
    if selectedOption == nil then return end

    if selectedOption.nextDialog == "failure" then
        defeatTimer = 0
        conversationState = ""
        currentDialogTreeNode = nil
        gameState = "defeat"
        return
    end

    if selectedOption.nextDialog == nil or selectedOption.nextDialog == "reset" then
        conversationState = ""
        currentDialogTreeNode = nil
        return
    end

    if selectedOption.nextDialog == "success" then
        -- Goth girl section
        if conversationState == interactables[1].vanityName then
            if gothGirlConvoState == 1 then
                jacketGuyConvoState = 1
                gothGirlConvoState = 2
            end
        -- Sorority girl section
        elseif conversationState == interactables[2].vanityName then
            if sororityGirlConvoState == 1 and gothGirlConvoState == 2 then
                hairGuyConvoState = 1 
            elseif sororityGirlConvoState == 2 then
                shadesGuyConvoState = 1
            elseif sororityGirlConvoState == 3 then
                absGuyConvoState = 1
            elseif sororityGirlConvoState == 4 then
                -- HAVE SORORITY GIRLS MOVE OUT OF WAY HERE
            end
        --Influancer girl section
        elseif conversationState == interactables[3].vanityName then
            if influencerGirlConvoState == 1 then
                shoesGirlConvoState = 1 
            elseif influencerGirlConvoState == 2 then
                shortsGuyConvoState = 1
            elseif influencerGirlConvoState == 3 then
                mewGuyConvoState = 1
            elseif influencerGirlConvoState == 4 then
            -- TRIGGER BOSS FIGHT HERE
            end
        elseif conversationState == interactables[4].vanityName then
            if jacketGuyConvoState == 1 then   
                table.insert(InventoryBag, "Jacket")
                --SWITCH JACKGUY OUT OF NO JACKET GUY HERE
            end
        elseif conversationState == interactables[5].vanityName then
            if hairGuyConvoState == 1 then   
                table.insert(InventoryBag, "Finasteride Hair Gel")
                
            end    
        elseif conversationState == interactables[6].vanityName then
            if shadesGuyConvoState == 1 then   
                table.insert(InventoryBag, "Sunglasses")
            end    
        elseif conversationState == interactables[7].vanityName then
            if absGuyConvoState == 1 then   
                table.insert(InventoryBag, "Bowflex")
            end    
        elseif conversationState == interactables[8].vanityName then
            if shoesGirlConvoState == 1 then   
                table.insert(InventoryBag, "Pants")
            end
        elseif conversationState == interactables[9].vanityName then
            if shortsGuyConvoState == 1 then   
                table.insert(InventoryBag, "Shoes")
            end
        elseif conversationState == interactables[10].vanityName then
            if mewGuyConvoState == 1 then   
                table.insert(InventoryBag, "Book of Mew")
            end
        end
        conversationState = ""
        currentDialogTreeNode = nil
    end

    currentDialogTreeId = selectedOption.nextDialog
    selDialogOption = 1
end

-- CUTSCENES/MOVIES AND BOSSFIGHT
function bossFightInit()
    bossFightTimer = 0
    if bossFightIntroMovie then
        isInBossFight = true
        -- bossFightIntroMovie:setVolume(volumeMaster)
        bossFightIntroMovie:play()
    end
end

function bossFightGameState()
    influencerTotalHeal = influencerBaseHeal * math.floor(math.min(math.ceil((1 - influencerCurrentHP / influencerMaxHP) * 20), 20)) -- scales with missing hp
    playerTotalDamage = playerBaseDamage * math.floor(math.min(math.max((bossFightTimer - 10) / 5, 1), 10)) -- scales with time

    if influencerHealTimer > 0.48 then
        influencerCurrentHP = math.min(influencerMaxHP - 5, influencerTotalHeal + influencerCurrentHP)
        influencerHealTimer = 0
    end

    if influencerCurrentHP == 0 then
        influencerHealTimer = 0
        if bossFightFadeOutTimer >  bossFightFadeOutWindDownTime + 5 then
            isInBossFight = false
        end
    else
        bossFightFadeOutTimer = 0
    end
end