-- Debugger

function drawDebug()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(debugFont)
    love.graphics.print("Current gameState: " .. gameState, 0, 0)
    love.graphics.print("Current playState: " .. playState, 0, 20)
    love.graphics.print("Current inventoryHandler: " .. tostring(inventoryHandler), 0, 40)
    love.graphics.print("Current player.mapTileX: " .. player.mapTileX .. ", player.mapTileY: " .. player.mapTileY, 0, 60)
    love.graphics.print(
        "Current player.lastMapTileX: " .. player.lastMapTileX .. ", player.lastMapTileY: " .. player.lastMapTileY, 0, 80)
    love.graphics.print("Current player.mapTrueX: " .. player.mapTrueX .. ", player.mapTrueY: " .. player.mapTrueY, 0,
        100)
    love.graphics.print("Current player.isColliding: " .. tostring(player.isColliding), 0, 120)
    love.graphics.print("Current interactingWith: " .. tostring(interactingWith), 0, 140)
    love.graphics.print("Current gothGirlConvoState: " .. gothGirlConvoState, 0, 160)
    love.graphics.print(tostring(interactables[1].portrait.anim.animations[1][1]), 0, 180)
    love.graphics.print("In boss fight?"..tostring(isInBossFight), 0, 200)
    love.graphics.print("inner: "..inner..", outter: "..outter, 0, 220)
    love.graphics.print("States " .. "goth:".. gothGirlConvoState .. ", sorority:" .. sororityGirlConvoState .. ", Influ:" .. influencerGirlConvoState .. ", Jacket:" .. jacketGuyConvoState .. ", abs:" .. absGuyConvoState .. ", shoes:" .. shoesGirlConvoState .. ", shorts:" .. shortsGuyConvoState .. ", mew:" .. mewGuyConvoState .. ", jacket2:" .. jacketGuyNOJacketConvoState, 0, 240)
    love.graphics.print("InventoryBag: " .. table.concat(InventoryBag, ", "), 0, 260)
    love.graphics.setColor(1,0.5,0.5,1 )
    love.graphics.print("Current influencerCurrentHP: "..influencerCurrentHP, 0, 280)
    love.graphics.print("Current influencerMaxHP: "..influencerMaxHP, 0, 300)
    love.graphics.print("Current influencerTotalHeal: "..influencerTotalHeal..", influencerBaseHeal: "..influencerBaseHeal, 0, 320)
    love.graphics.print("Current playerTotalDamage: "..playerTotalDamage..", playerBaseDamage: "..playerBaseDamage, 0, 340)
end

-- Top level state handler

function drawStateMachine()
    if gameState == "mainmenu" then
        drawMainMenu()
    elseif gameState == "play" then
        drawPlay()
    elseif gameState == 'defeat' then
        drawDefeat()
    elseif gameState == 'victory' then
        drawVictory()
    end
end

-- Main menu

function drawMainMenu()
    love.graphics.setColor(1, 1, 1, alphaTween)
    love.graphics.setFont(mainMenuFont)

    love.graphics.draw(mainMenuImage, 0, 0, 0, gfxScale, gfxScale)

    if globalSpriteTimer > introWindUpTime then
        for i, option in ipairs(menuOptionsMain) do
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(option, currWinDim.w / 2 - (#option * 10) + gfxScale, currWinDim.h / 2 + (i - 1) * 40)
            if i == selOptionMain then
                love.graphics.setColor(139 / 255, 77 / 255, 188 / 255, 1) -- Highlight selected option in red
            else
                love.graphics.setColor(1, 1, 1) -- Normal color
            end
            -- are things not centered?  check here lol, fix #option
            love.graphics.print(option, currWinDim.w / 2 - (#option * 10), currWinDim.h / 2 + (i - 1) * 40)
        end

        for j = 1, 10, 1 do
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.rectangle("fill", currWinDim.w / 2 + (#menuOptionsPause[2] * 10) + (j * 12) + gfxScale,
                currWinDim.h / 2 + mainMenuFont:getHeight() + 21, 6, 6)
            if math.floor(volumeMaster * 10) == j then
                love.graphics.setColor(139 / 255, 77 / 255, 188 / 255, 1)
            else
                love.graphics.setColor(1, 1,
                    1)
            end
            love.graphics.rectangle("fill", currWinDim.w / 2 + (#menuOptionsMain[2] * 10) + (j * 12),
                currWinDim.h / 2 + mainMenuFont:getHeight() + 21, 6, 6)
        end
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.print(volumeMaster * 10, currWinDim.w / 2 + (#menuOptionsPause[2] * 10) + 144 + gfxScale,
            currWinDim.h / 2 + mainMenuFont:getHeight() + 6)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(volumeMaster * 10, currWinDim.w / 2 + (#menuOptionsMain[2] * 10) + 144,
            currWinDim.h / 2 + mainMenuFont:getHeight() + 6)
    end
end

-- Play state handler and play drawing functions

function drawPlay()
    if playState == "exploring" then
        if isInBossFight then 
            drawBossFight()
        else
            drawExploring()
        end
    elseif playState == "pause" then
        drawExploring()
        drawPauseMenu()
    end
end

function drawExploring()
    love.graphics.setColor(1, 1, 1, 1)
    local mapOffsetX = tileWH * gfxScale * (-1 * player.mapTileX)
    local mapOffsetY = tileWH * gfxScale * (-1 * player.mapTileY)
    drawnMapOffsetX = mapOffsetX + (currWinDim.w / 2 - (tileWH / 2))
    drawnMapOffsetY = mapOffsetY + (currWinDim.h / 2 - (tileWH / 2))

    -- terrain + scenery
    love.graphics.draw(bg_floor_tiles, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)
    love.graphics.draw(bg_WALLS, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)
    love.graphics.draw(bg_DJ_Stairs, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)
    love.graphics.draw(bg_DJ_Stage, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)
    love.graphics.draw(bg_Sorority_Top, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)
    love.graphics.draw(bg_Sorority_Mid, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)
    love.graphics.draw(bg_Sorority_Bot, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)
    love.graphics.draw(bg_Characters_01, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)
    love.graphics.draw(bg_Characters_02, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)
    love.graphics.draw(bg_Furniture, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)
    love.graphics.draw(bg_BathroomShadow, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)
    love.graphics.draw(bg_Items_01_Props, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)
    love.graphics.draw(bg_BIGGIE, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)

    love.graphics.setColor(1, 1, 1, 1)

    if isDebug then
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.draw(currentCollisionDraw
        , drawnMapOffsetX, drawnMapOffsetY
        , 0, gfxScale, gfxScale)
    end
    love.graphics.setColor(1, 1, 1, 1)

    drawInteractables(drawnMapOffsetX, drawnMapOffsetY)
    drawPlayer()

    love.graphics.setColor(1, 1, 1, 0.45)
    love.graphics.draw(bg_DJ_Opacity_45, drawnMapOffsetX, drawnMapOffsetY, 0, gfxScale, gfxScale)

    -- draw cool shader thing
    love.graphics.setColor(1, 0, 1, 0.05)
    love.graphics.rectangle("fill", 0, 0, currWinDim.w, currWinDim.h)

    -- wrap this in conversation condition handler thing
    if conversationState ~= "" then
        drawConversation()
    else
        drawInteractableButton()
    end

    -- Inventory call
    if inventoryHandler == true then drawInventory() end
end

function drawPlayer()
    love.graphics.setColor(1, 1, 1, 1)
    -- change spriteSheets for each item
    -- default
    local flip = player.isFlippedLeft and -1 or 1
    local flipOffset = player.isFlippedLeft and (tileWH * gfxScale) or 0

    love.graphics.draw(player.spriteSheet, player.anim.currentAnim
    , currWinDim.w / 2 - (tileWH / 2) + flipOffset, currWinDim.h / 2 - (tileWH / 2)
    , 0, gfxScale * flip, gfxScale)

    -- hair -- pompadour -- minoxidyl-phensitride
    -- glasses -- gurenn lagann glasses --
    -- face -- mew
    -- jacket -- leather jacket
    -- abs -- bowflex
    -- pants -- ???
    -- shoes -- ???

    if isDebug then
        love.graphics.setColor(0.5, 1, 0.5, 0.5)
        love.graphics.rectangle("fill"
        , player.hitbox.x, player.hitbox.y
        , player.hitbox.w * gfxScale, player.hitbox.h * gfxScale
        )
    end
end

function drawInteractables()
    for _, interacts in pairs(interactables) do
        local iX, iY = (interacts.mapTrueX * gfxScale) + drawnMapOffsetX,
            (interacts.mapTrueY * gfxScale) + drawnMapOffsetY
        if isDebug then
            love.graphics.setColor(0.5, 0.5, 1, 0.5)
            love.graphics.rectangle("fill", iX - (interactableHitbox.w / 6 * gfxScale),
                iY - (interactableHitbox.h / 6 * gfxScale)
                , interactableHitbox.w * gfxScale, interactableHitbox.h * gfxScale)
        end
        love.graphics.setColor(1, 1, 1, 1)
        if _ == 4 or _ == 11 then
            if contains(InventoryBag, "jacket", false) then
                love.graphics.draw(interactables[11].spriteSheet, interactables[11].anim.currentAnim, iX, iY, 0, gfxScale, gfxScale)
            else
                love.graphics.draw(interactables[4].spriteSheet, interactables[4].anim.currentAnim, iX, iY, 0, gfxScale, gfxScale)
            end
        else
            love.graphics.draw(interacts.spriteSheet, interacts.anim.currentAnim, iX, iY, 0, gfxScale, gfxScale)
        end
    end
end

function drawInteractableButton()
    for _, interacts in pairs(interactables) do
        local iX, iY = (interacts.mapTrueX * gfxScale) + drawnMapOffsetX,
            (interacts.mapTrueY * gfxScale) + drawnMapOffsetY
        if checkCollision(player, interacts) then
            love.graphics.setColor(0.5, 0.5, 0.5, 1)
            love.graphics.setFont(mainMenuFont)
            love.graphics.print("PRESS", iX - (tileWH * gfxScale * 2 / 3),
                iY + 4 - (tileWH * gfxScale * 2 / 5) - (updownFloating))
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print("PRESS", iX - (tileWH * gfxScale * 2 / 3),
                iY - (tileWH * gfxScale * 2 / 5) - (updownFloating))
            love.graphics.setColor(0.5, 0.5, 0.5, 1)
            love.graphics.draw(z_key_art, iX + (tileWH * gfxScale / 4), iY - (tileWH * gfxScale / 2), 0, gfxScale / 2,
                gfxScale / 2)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(z_key_art, iX + (tileWH * gfxScale / 4),
                iY - (tileWH * gfxScale / 2) - 4 - (updownFloating / 4), 0, gfxScale / 2, gfxScale / 2)
        end
    end
end

function drawConversation()
    love.graphics.setColor(1, 1, 1, 1)

    -- use each girls text bubble
    if interactables[interactingWith].chatbox then
        chatboxRenderer(
            0, currWinDim.h * 2 / 3, currWinDim.w, currWinDim.h
            , { 0.7, 0.7, 0.7, 0.7 }
            , interactables[interactingWith].chatbox
        )
    else
        -- default chatbox
    end

    if interactables[interactingWith].portrait.spriteSheet then
        love.graphics.draw(interactables[interactingWith].portrait.spriteSheet, interactables[interactingWith].portrait.anim.currentAnim
            , currWinDim.w * 18 / 24, currWinDim.h * 31 / 48
            , 0, portScale, portScale)
    else
        -- default portrait
    end

    if interactables[interactingWith].portraitFrame then
        love.graphics.draw(interactables[interactingWith].portraitFrame
            , (currWinDim.w * 18 / 24) - (20), (currWinDim.h * 31 / 48) - (20),
            0, portScale, portScale)
    else
        -- default portraitFrame
    end

    -- DIALOG TEXT

    -- npc text section

    -- Disables the ability to use the select buttons
    disableSelect = true

    -- Typewriter effect
    if _G.__typewriteState == nil then
        _G.__typewriteState = { lastText = "", startTime = love.timer.getTime(), speed = 45 } -- speed = chars/sec
    end

    local fullText = currentDialogTreeNode.npcText or ""

    -- reset when dialog text changes
    if _G.__typewriteState.lastText ~= fullText then
        _G.__typewriteState.lastText = fullText
        _G.__typewriteState.startTime = love.timer.getTime()
    end

    local elapsed = love.timer.getTime() - _G.__typewriteState.startTime
    local charsToShow = math.floor(elapsed * _G.__typewriteState.speed)
    if charsToShow < 0 then charsToShow = 0 end
    if charsToShow > #fullText then charsToShow = #fullText end

    local toShow = string.sub(fullText, 1, charsToShow)
    love.graphics.printf(toShow, 160, currWinDim.h * 2 / 3 + 150, 1250, "left", 0, 1, 1)

    -- Response logic
    local delayAfterFinish = 0.4

    if charsToShow >= #fullText then
        if _G.__typewriteState.finishedTime == nil then
            _G.__typewriteState.finishedTime = love.timer.getTime()
        end

        local textHAdder = 0

        if love.timer.getTime() - _G.__typewriteState.finishedTime >= delayAfterFinish then
            for i, option in ipairs(currentDialogTreeNode.responses or {}) do
                local px, py = currWinDim.w * 1 / 5, currWinDim.h * 1 / 3 + (i - 1) * 70 + textHAdder
                local font = love.graphics.getFont()
                local scale = .9
                local padX, padY = 8, 4
                local textLimit = px * 3
                local textH = font:getHeight() * scale
                local getTextWidth = font:getWidth(option.text) * scale

                if getTextWidth > textLimit then
                    textH = textH * math.ceil(getTextWidth / textLimit)
                end
                local rectH = textH + padY * 2

                -- background rectangle
                love.graphics.setColor(0, 0, 0, 0.6)
                love.graphics.rectangle("fill", px - padX, py - padY, textLimit, rectH, 4, 4)

                -- rectangle outline if selected
                if i == selDialogOption then
                    love.graphics.setLineWidth(2)
                    love.graphics.setColor(139 / 255, 77 / 255, 188 / 255, 1)
                    love.graphics.rectangle("line", px - padX, py - padY, textLimit, rectH, 4, 4)
                    love.graphics.setLineWidth(1)
                end

                -- text (override color)
                if i == selDialogOption then
                    love.graphics.setColor(139 / 255, 77 / 255, 188 / 255, 1)
                else
                    love.graphics.setColor(1, 1, 1)
                end
                
                -- The +150 is a patch, not the best long term fix, but it prevents text from going outside of the chatbox when the text is long and wraps around. The textLimit variable is used to determine when to add line height to the next response option, but the actual limit for the text is a little higher than that to give it some padding on the right side of the chatbox.
                love.graphics.printf(option.text, px, py, textLimit + 100, "left", 0, scale, scale)

                -- Adds line height if text wraps
                if getTextWidth > textLimit then
                    textHAdder = textHAdder + (textH / 2)
                end

                -- Enables the ability to use the select buttons again
                disableSelect = false
            end
        end
    else
        _G.__typewriteState.finishedTime = nil
    end
end

function drawInventory()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(mainMenuFont)

    -- Base rectangle
    local baseRecWidth = inventoryCellSize * inventoryCols
    local baseRecHeight = inventoryCellSize * inventoryRows
    love.graphics.setColor(.8, .7, .3, 1)
    love.graphics.rectangle("fill", (currWinDim.w / 2) - (baseRecWidth / 2), (currWinDim.h / 2) - (baseRecHeight / 2),
        baseRecWidth + 100, baseRecHeight, 10, 10)

    -- Inventory grid
    love.graphics.setColor(.212, .203, .154, 1) -- Set color for the grid lines

    for row = 1, inventoryRows do
        for col = 1, inventoryCols do
            local x = (currWinDim.w / 2) - (baseRecWidth / 2) + (col - 1) * inventoryCellSize
            local y = (currWinDim.h / 2) - (baseRecHeight / 2) + (row - 1) * inventoryCellSize
            -- Draw a rectangle for the slot
            love.graphics.rectangle("line", x, y, inventoryCellSize, inventoryCellSize)
        end
    end

    -- Inventory grid highlighter
    for i, option in ipairs(InventoryBag) do
        if i == selOptionInv then
            love.graphics.setColor(1, .7, .3, .4)

            local xCalc = 1
            local yCalc = 1

            if i >= 1 and i <= 5 then
                xCalc = i
            end
            if i >= 6 and i <= 10 then
                yCalc = 2
                xCalc = i - 5
            end

            local x = (currWinDim.w / 2) - (baseRecWidth / 2) + (xCalc - 1) * inventoryCellSize
            local y = (currWinDim.h / 2) - (baseRecHeight / 2) + (yCalc - 1) * inventoryCellSize
            love.graphics.rectangle("fill", x, y, inventoryCellSize, inventoryCellSize)
            love.graphics.setColor(.212, .203, .154, 1) -- Set color highlighted item text
            if option.name then
                love.graphics.print(option.name, (currWinDim.w / 2), (currWinDim.h / 2) - 130, 0, 1.5, 1.5)    
            end
            if option.description then
                love.graphics.print(option.description, (currWinDim.w / 2) - 50, (currWinDim.h / 2) + 110, 0, 1.5, 1.5)    
            end
        end
    end

    -- Base Rectangle outline
    love.graphics.setColor(.8, .5, .3, 1) -- Set color for the outline
    love.graphics.setLineWidth(8)
    love.graphics.rectangle("line", (currWinDim.w / 2) - (baseRecWidth / 2) - 3,
        (currWinDim.h / 2) - (baseRecHeight / 2) - 3, baseRecWidth + 103, baseRecHeight + 3, 10, 10)

    -- Inventory items
    love.graphics.reset()

    for row = 1, inventoryRows do
        for col = 1, inventoryCols do
            local item = InventoryBag[(row - 1) * inventoryCols + col]
            if item ~= nil then
                local x = (currWinDim.w / 2) - (inventoryCellSize * inventoryCols / 2) + (col - 1) * inventoryCellSize
                local y = (currWinDim.h / 2) - (inventoryCellSize * inventoryRows / 2) + (row - 1) * inventoryCellSize

                -- RICHARD, i added this shit here (player.anim.animations[1][1]) to get rid of the spritesheet dupe issue you had
                love.graphics.draw(item.image, player.anim.animations[1][1], x, y, 0, inventoryScale, inventoryScale)
            end
        end
    end

    -- Show player
    love.graphics.reset()
    love.graphics.draw(player.spriteSheet, player.anim.animations[1][1], currWinDim.w / 2 + 225, currWinDim.h / 2 - 55, 0,
        gfxScale, gfxScale)
end

function drawPauseMenu()
    -- draw cool shader thing
    love.graphics.setColor(0.5, 0.5, 0.5, 0.1)
    love.graphics.rectangle("fill", 0, 0, currWinDim.w, currWinDim.h)

    if globalSpriteTimer > introWindUpTime then
        for i, option in ipairs(menuOptionsPause) do
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.print(option, currWinDim.w / 2 - (#option * 10) + gfxScale, currWinDim.h / 2 + (i - 1) * 40)
            if i == selOptionPause then
                love.graphics.setColor(139 / 255, 77 / 255, 188 / 255, 1) -- Highlight selected option in red
            else
                love.graphics.setColor(1, 1, 1) -- Normal color
            end
            -- are things not centered?  check here lol, fix #option
            love.graphics.print(option, currWinDim.w / 2 - (#option * 10), currWinDim.h / 2 + (i - 1) * 40)
        end

        for j = 1, 10, 1 do
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.rectangle("fill", currWinDim.w / 2 + (#menuOptionsPause[2] * 10) + (j * 12) + gfxScale,
                currWinDim.h / 2 + mainMenuFont:getHeight() + 21, 6, 6)
            if math.floor(volumeMaster * 10) == j then
                love.graphics.setColor(139 / 255, 77 / 255, 188 / 255, 1)
            else
                love.graphics.setColor(1, 1,
                    1)
            end
            love.graphics.rectangle("fill", currWinDim.w / 2 + (#menuOptionsPause[2] * 10) + (j * 12),
                currWinDim.h / 2 + mainMenuFont:getHeight() + 21, 6, 6)
        end
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.print(volumeMaster * 10, currWinDim.w / 2 + (#menuOptionsPause[2] * 10) + 144 + gfxScale,
            currWinDim.h / 2 + mainMenuFont:getHeight() + 6)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(volumeMaster * 10, currWinDim.w / 2 + (#menuOptionsPause[2] * 10) + 144,
            currWinDim.h / 2 + mainMenuFont:getHeight() + 6)
    end
    love.graphics.setColor(1, 1, 1, alphaTween)
    love.graphics.setFont(mainMenuFont)
end

function drawDefeat()
    local isStupidDraw = false
    love.graphics.setColor(1, 1, 1, defeatAlphaTween)
    if isStupidDraw then
        love.graphics.draw(defeatScreen,0,0,0,gfxScale,gfxScale)
        love.graphics.draw(player.spriteSheet, player.anim.animations[3][3], currWinDim.w / 2, currWinDim.h / 2, 90, gfxScale * 3, gfxScale * 3)
        love.graphics.setColor(139 / 255, 77 / 255, 188 / 255, 1)
        love.graphics.print("You are forever bitchless", (currWinDim.w / 2) - #("You are forever bitchless"), currWinDim.h / 3, 0, 2, 2)
    else
        love.graphics.draw(defeatScreen,0,0,0,gfxScale,gfxScale)
        love.graphics.draw(player.spriteSheet, player.anim.animations[3][3]
            , (currWinDim.w / 2) - (gfxScale * 3 * tileWH / 2), (currWinDim.h / 2) + (gfxScale * 3 * tileWH * 2 / 3)
            , math.rad(270), gfxScale * 3, gfxScale * 3)
        love.graphics.setColor(139 / 255, 77 / 255, 188 / 255, defeatAlphaTween)
        love.graphics.print("You are forever bitchless"
            , (currWinDim.w / 2) - #"You are forever bitchless"*(mainMenuFont:getHeight() / 2), currWinDim.h / 3
            , 0, 2, 2)
    end
end

function drawVictory()
    love.graphics.print("Good job bud!", currWinDim.w / 2, currWinDim.h / 2, 0, 2, 2)
end

function drawBossFight()
    love.graphics.setColor(1,1,1,1 )
    love.graphics.draw(bossFightStatics, 0, 0, 0, gfxScale / 4, gfxScale / 4)
    -- love.graphics.draw(bossFightHisCore, 0, 0, 0, gfxScale, gfxScale)


    love.graphics.setColor(1,1,1,1 )
    -- rendered on top so movie plays
    if bossFightIntroMovie:isPlaying() then 
        love.graphics.draw(bossFightIntroMovie, 0, 0, 0, gfxScale / 4, gfxScale / 4)
    else end
end