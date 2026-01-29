function init()
    gameState = "mainmenu"
    INPUTS_ARR = {
        fullscreen = "f", debug = "f3", pause = "escape"
        , up = {"w","up"}, left = {"a","left"}, down = {"s","down"}, right = {"d","right"}
        , select = {"return", "z"}, cancel = "x"
        , inventory = {"i"}
    }

    mainMenuFont = love.graphics.newFont(32)

    -- window/screen logic
    screenW, screenH = love.window.getDesktopDimensions()
    currWinDim = {w = screenW-math.floor(screenW*0.10), h = screenH-math.floor(screenH*0.10)}
    love.window.setMode(currWinDim.w, currWinDim.h)
    isFullScreen = true
    love.window.setFullscreen(isFullScreen)

    -- SpriteSheet sizing for pixels
    tileWH = 32
end