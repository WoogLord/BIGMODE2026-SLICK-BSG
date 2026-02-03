-- Debugger

function drawDebug()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(debugFont)
    love.graphics.print("Current gameState: "..gameState,0,0)
    love.graphics.print("Current playState: "..playState,0,20)
    love.graphics.print("Current inventoryHandler: "..tostring(inventoryHandler),0,40)
    love.graphics.print("Current player.mapTileX: "..player.mapTileX..", player.mapTileY: "..player.mapTileY,0,60)
    love.graphics.print("Current player.lastMapTileX: "..player.lastMapTileX..", player.lastMapTileY: "..player.lastMapTileY,0,80)
    love.graphics.print("Current player.mapTrueX: "..player.mapTrueX..", player.mapTrueY: "..player.mapTrueY,0,100)
    love.graphics.print("Current player.isColliding: "..tostring(player.isColliding),0,120)
end

-- Top level state handler

function drawStateMachine()
    if gameState == "mainmenu" then drawMainMenu()
    elseif gameState == "play" then drawPlay()
    elseif gameState == 'defeat' then drawDefeat()
    elseif gameState == 'victory' then drawVictory()
    end
end

-- Main menu

function drawMainMenu()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(mainMenuFont)
    love.graphics.print("this is the mainmenu 8=D")
    
    -- old button code
    -- for i, button in pairs(buttonsMainMenu) do
    --     drawButton(button)
    -- end

    for i, option in ipairs(menuOptionsMain) do
        if i == selOptionMain then love.graphics.setColor(1, 0, 0)  -- Highlight selected option in red
        else love.graphics.setColor(1, 1, 1)  -- Normal color
        end
        -- are things not centered?  check here lol, fix #option
        love.graphics.print(option, currWinDim.w / 2 - (#option * 10), currWinDim.h / 2 + (i - 1) * 40)
    end  

    for j=1, 10, 1 do 
        if math.floor(volumeMaster*10) == j then love.graphics.setColor(0, 0, 1) else love.graphics.setColor(1, 1, 1) end
        love.graphics.rectangle("fill", currWinDim.w / 2 + (#menuOptionsMain[2] * 10) + (j*12), currWinDim.h / 2 + mainMenuFont:getHeight() + 21, 6, 6)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(volumeMaster*10, currWinDim.w / 2 + (#menuOptionsMain[2] * 10) + 144, currWinDim.h / 2 + mainMenuFont:getHeight() + 6)
end

-- Play state handler and play drawing functions

function drawPlay()
    if playState == "exploring" then drawExploring()
    elseif playState == "conversation" then drawConversation()
    elseif playState == "pause" then drawPauseMenu()
    end
end

function drawExploring()
    love.graphics.setColor(1,1,1,1)
    local mapOffsetX = tileWH * gfxScale * (-1 * player.mapTileX)
    local mapOffsetY = tileWH * gfxScale * (-1 * player.mapTileY)
    local drawnMapOffsetX = mapOffsetX + (currWinDim.w / 2 - (tileWH / 2))
    local drawnMapOffsetY = mapOffsetY + (currWinDim.h / 2 - (tileWH / 2))
   
    -- terrain + scenery
    love.graphics.draw(bg_01_nightclub
        ,drawnMapOffsetX, drawnMapOffsetY
        ,0,gfxScale,gfxScale)

    if isDebug then 
        love.graphics.setColor(1,1,1,0.5)
        love.graphics.draw(bg_01_collision
            ,drawnMapOffsetX, drawnMapOffsetY
            ,0,gfxScale,gfxScale)
    end
    love.graphics.setColor(1,1,1,1)
    
    drawInteractables(drawnMapOffsetX, drawnMapOffsetY)
    drawPlayer() 

    -- Inventory call
    if inventoryHandler == true then drawInventory() end    
end

function drawPlayer()
    love.graphics.setColor(1,1,1,1)
    -- change spriteSheets for each item
    -- default
    local flip = player.isFlippedLeft and -1 or 1  
    local flipOffset = player.isFlippedLeft and (tileWH * gfxScale) or 0 
    
    love.graphics.draw(player.spriteSheet, player.anim.currentAnim
            ,currWinDim.w / 2 - (tileWH / 2) + flipOffset, currWinDim.h / 2 - (tileWH / 2)
            ,0,gfxScale * flip,gfxScale)

    -- hair -- pompadour -- minoxidyl-phensitride
    -- glasses -- gurenn lagann glasses -- 
    -- face -- mew
    -- jacket -- leather jacket
    -- abs -- bowflex
    -- pants -- ???
    -- shoes -- ???

    if isDebug then 
        love.graphics.setColor(0.5,1,0.5,0.5)
        love.graphics.rectangle("fill"
            , player.hitbox.x, player.hitbox.y
            , player.hitbox.w * gfxScale, player.hitbox.h * gfxScale
        )
    end
end

function drawInteractables(_drawnMapOffsetX, _drawnMapOffsetY)
    for _, interacts in pairs(interactables) do
        print("testin this part")
        love.graphics.draw(interacts.spriteSheet, interacts.anim.currentAnim, interacts.mapTrueX * gfxScale, interacts.mapTrueY * gfxScale, 0, gfxScale, gfxScale)
    end
end

function drawConversation()
    nineSlicer(
        0, currWinDim.h * 2 / 3, currWinDim.w, currWinDim.h
        , {0.7, 0.7, 0.7, 0.7}
        , chatbox_9slice
    )
    
    love.graphics.draw(port_test_360, currWinDim.w * 18 / 24, currWinDim.h *  31 / 48, 0,portScale,portScale)
    love.graphics.draw(port_test_256, currWinDim.w * 1 / 24, currWinDim.h * 17 / 24, 0,portScale,portScale)

end

function drawInventory()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(mainMenuFont)
    
    -- Base rectangle
    local baseRecWidth = inventoryCellSize * inventoryCols
    local baseRecHeight = inventoryCellSize * inventoryRows
    love.graphics.setColor(.8, .7, .3, 1)
    love.graphics.rectangle("fill", (currWinDim.w / 2) - (baseRecWidth / 2), (currWinDim.h / 2) - (baseRecHeight / 2), baseRecWidth + 100, baseRecHeight, 10, 10)

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
            love.graphics.print(option.name, (currWinDim.w / 2), (currWinDim.h / 2) - 130, 0 , 1.5, 1.5)
            love.graphics.print(option.description, (currWinDim.w / 2) - 50, (currWinDim.h / 2) + 110, 0 , 1.5, 1.5)

        end
        
       
    end  

    -- Base Rectangle outline
    love.graphics.setColor(.8, .5, .3, 1) -- Set color for the outline
    love.graphics.setLineWidth(8)
    love.graphics.rectangle("line", (currWinDim.w / 2) - (baseRecWidth / 2) - 3, (currWinDim.h / 2) - (baseRecHeight / 2) - 3, baseRecWidth + 103, baseRecHeight + 3, 10, 10)

    -- Inventory items
    love.graphics.reset()

    for row = 1, inventoryRows do
        for col = 1, inventoryCols do
            local item = InventoryBag[(row - 1) * inventoryCols + col]
            if item ~= nil then
                local x = (currWinDim.w / 2) - (inventoryCellSize * inventoryCols / 2) + (col - 1) * inventoryCellSize
                local y = (currWinDim.h / 2) - (inventoryCellSize * inventoryRows / 2) + (row - 1) * inventoryCellSize
                
                -- hey richard, i added this shit here (player.anim.animations[1][1]) to get rid of the spritesheet dupe issue you had
                love.graphics.draw(item.image, player.anim.animations[1][1], x, y, 0, inventoryScale, inventoryScale)
            end
        end
    end

    -- Show player
    love.graphics.reset()
    love.graphics.draw(player.spriteSheet, player.anim.animations[1][1], currWinDim.w / 2 + 225, currWinDim.h / 2 - 55, 0, gfxScale, gfxScale)
end

function drawPauseMenu()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(mainMenuFont)
    love.graphics.print("PAUSE", currWinDim.w / 2, currWinDim.h / 2, 0,portScale, portScale)
    love.graphics.print("Press x to quit game :(", currWinDim.w / 2 - 35, currWinDim.h / 2 + 120, 0, .5, .5)
end

function drawDefeat()

end

function drawVictory()

end