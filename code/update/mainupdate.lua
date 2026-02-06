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

function gameManager()
    player.mapTrueX, player.mapTrueY = (player.mapTileX * tileWH), (player.mapTileY * tileWH)
    player.hitbox.x = currWinDim.w / 2 - (tileWH / 2) + (9 * gfxScale)
    player.hitbox.y = currWinDim.h / 2 - (tileWH / 2) + (18 * gfxScale)

    handleCollision()
    handleConversation()
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

function isRedPixel(_x, _y, _w, _h) -- the red being whatever we need to check
    _x = math.floor(_x)
    _y = math.floor(_y)
    if _x < 0 or _y < 0 or (_x + _w) >= bg_01_collisionData:getWidth() or (_y + _h) >= bg_01_collisionData:getHeight() then return true end
    for w = 0, _w - 1, 1 do
        for h = 0, _h - 1, 1 do
            local r, g, b, a = bg_01_collisionData:getPixel(_x + w, _y + h)
            if r == (192 / 255) and g == (33 / 255) and b == (33 / 255) and a > 0 then
                return true
            end
        end
    end
end

function handleCollision()
    if isRedPixel(player.mapTrueX - (tileWH / 2) + (6 * gfxScale), player.mapTrueY - (tileWH / 2) + (8 * gfxScale)
        , player.hitbox.w, player.hitbox.h) then
        player.isColliding = true
        player.mapTileX, player.mapTileY = player.lastMapTileX, player.lastMapTileY
        player.mapTrueX, player.mapTrueY = player.lastMapTrueX, player.lastMapTrueY
    else
        player.isColliding = false
        lastPositionSave()
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
                if contains(InventoryBag, interactables[1].passingItems[1], true) then
                    currentDialogTreeId = interactables[1].passPoints[1]
                else
                    currentDialogTreeId = interactables[1].checkPoints[1]
                end
            end
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

        if currentDialogTreeNode["checkPoint"] ~= nil then
            gothGirlConvoState = currentDialogTreeNode.checkPoint
        end
    end
end

function handleDialogSelection()
    if currentDialogTreeNode == nil or disableSelect == true then return end
    local selectedOption = currentDialogTreeNode.responses[selDialogOption]
    if selectedOption == nil then return end

    if selectedOption.nextDialog == "failure" then
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
        gothGirlConvoState = 2 --ending number
        return
    end

    currentDialogTreeId = selectedOption.nextDialog
    selDialogOption = 1
end
