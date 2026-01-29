function init()
    gameState = "mainmenu"
    gfxScale = 3
    moveSpeed = 0
    moveSpeedDampener = 0.40
    INPUTS_ARR = {
        fullscreen = "f", debug = "f3", pause = "escape"
        , up = {"w","up"}, left = {"a","left"}, down = {"s","down"}, right = {"d","right"}
        , jump = " "
        , select = {"return", "z"}, cancel = "x"
        , inventory = {"i"}
    }
    player = {
        currentAnimState = "Idle"
        , isFlippedLeft = false
        , mapTileX = 0, mapTileY = 0
        , mapTrueX = 0, mapTrueY = 0
        , speed = 10
    }
    floater = {}
    
    mainMenuFont = love.graphics.newFont(32)
    debugFont = love.graphics.newFont(16)
    buttonFont = love.graphics.newFont(24)

    -- window/screen logic
    screenW, screenH = love.window.getDesktopDimensions()
    currWinDim = {w = screenW-math.floor(screenW*0.10), h = screenH-math.floor(screenH*0.10)}
    love.window.setMode(currWinDim.w, currWinDim.h)
    isFullScreen = true
    love.window.setFullscreen(isFullScreen)

    -- SpriteSheet sizing for pixels
    tileWH = 32
end