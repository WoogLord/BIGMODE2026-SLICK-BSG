function init()
    gameState = "mainmenu"
    playState = ""
    inventoryHandler = false
    gfxScale = 4
    portScale = 1 / 4 * gfxScale
    moveSpeed = 0
    globalSpriteTimer = 0

    INPUTS_ARR = {
        fullscreen = "f", debug = "f3", pause = "escape"
        , up = {"w","up"}, left = {"a","left"}, down = {"s","down"}, right = {"d","right"}
        , jump = " "
        , select = {"return", "z"}, cancel = "x"
        , inventory = "i"
    }
    player = {
        isFlippedLeft = false
        , facing = "Right"
        , mapTileX = 0, mapTileY = 0
        , mapTrueX = 0, mapTrueY = 0
        , lastMapTileX = 0, lastMapTileY = 0 
        , speed = 25
        , items = {
            hairGrowGel = {isAcquired = false, spriteRef = love.graphics.newImage("assets/art/Nightclubitems/Beer.png")}
        }
        , hitbox = {w = 16, h = 16}
        , isColliding = false
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
    musicClubTracks = {
        -- mus_01_aye
        -- mus_02_rave
        -- mus_03_rave2
        mus_04_funkyRave = love.audio.newSource("assets/music/Funky_Rave.mp3", "stream")
        , mus_05_rave3_no_L = love.audio.newSource("assets/music/rave_3_no_L.mp3", "stream")
    }
    credits = 0 -- mus_06_rave3_w_L
    
end