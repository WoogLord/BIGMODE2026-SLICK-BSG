function init()
    gameState = "mainmenu"
    inventoryHandler = false
    gfxScale = 4
    portScale = 1 / 4 * gfxScale
    moveSpeed = 0
    moveSpeedDampener = 0.40
    globalSpriteTimer = 0

    INPUTS_ARR = {
        fullscreen = "f", debug = "f3", pause = "escape"
        , up = {"w","up"}, left = {"a","left"}, down = {"s","down"}, right = {"d","right"}
        , jump = " "
        , select = {"return", "z"}, cancel = "x"
        , inventory = "i"
    }
    player = {
        currentAnimState = "Idle"
        , isFlippedLeft = false
        , mapTileX = 0, mapTileY = 0
        , mapTrueX = 0, mapTrueY = 0
        , speed = 10
    }
    floater = {}
    
    -- fonts
    mainMenuFont = love.graphics.newFont(32)
    debugFont = love.graphics.newFont(16)
    buttonFont = love.graphics.newFont(24)

    -- window/screen logic
    screenW, screenH = love.window.getDesktopDimensions()
    currWinDim = {w = screenW-math.floor(screenW*0.10), h = screenH-math.floor(screenH*0.10)}
    love.window.setMode(currWinDim.w, currWinDim.h)
    isFullScreen = false
    love.window.setFullscreen(isFullScreen)

    -- SpriteSheet sizing for pixels
    tileWH = 32

    -- music and sound
    volumeMaster = 0.5

    -- Inventory Object
    InventoryBag = {{name = "Dooker", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"}}

    -- Inventory variables
    inventoryScale = 3
    inventoryCellSize = 32 * inventoryScale
    inventoryCols = 5
    inventoryRows = 2
end