function init()
    gameState = "mainmenu"
    playState = ""
    conversationState = ""
    inventoryHandler = false
    gfxScale = 4
    portScale = 1 / 4 * gfxScale
    moveSpeed = 0
    globalSpriteTimer = 0
    updownFloating = 0
    alphaTween = 0

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
        , hitbox = {w = 14, h = 14}
        , isColliding = false
        , inClub = false
    }
    floater = {}
    
    -- fonts
    mainMenuFont = love.graphics.newFont(32 / 4 * gfxScale)
    debugFont = love.graphics.newFont(16/ 4 * gfxScale)
    buttonFont = love.graphics.newFont(24/ 4 * gfxScale)

    -- window/screen logic
    screenW, screenH = love.window.getDesktopDimensions()
    currWinDim = {w = 1920, h = 1080}
    love.window.setMode(currWinDim.w, currWinDim.h)
    isFullScreen = false
    love.window.setFullscreen(isFullScreen)

    -- SpriteSheet sizing for pixels
    tileWH = 32

    -- music and sound
    volumeMaster = 0.5
    nowPlaying = {}
    currentTrack = nil
    needNextTrack = true
    lastPlayedMusic = nil
    lastPlayedAnnouncement = nil
    currentSongDuration = 0
    -- titleMusic = love.audio.newSource("assets/music/Title_theme_outside.mp3", "stream", true)
    titleMusic = love.audio.newSource("assets/music/Title_theme_outside.mp3", "stream", true)
    musicClubTracks = {
          mus_01_aye = love.audio.newSource("assets/music/Aye.mp3", "stream", false)
        -- mus_02_rave
        -- mus_03_rave2
        , mus_04_funkyRave = love.audio.newSource("assets/music/Funky_Rave.mp3", "stream", false)
        , mus_05_rave3_no_L = love.audio.newSource("assets/music/rave_3_no_L.mp3", "stream", false)
    }
    flattenedMusicClubTracks = {}
    for _, src in pairs(musicClubTracks) do
        src:setLooping(false)
        flattenedMusicClubTracks[#flattenedMusicClubTracks+1] = src
    end
    credits = 0 -- mus_06_rave3_w_L
    
      -- Inventory Object
    InventoryBag = {{name = "Dooker", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"},{name = "Hair Gel", image = love.graphics.newImage("assets/art/spritesheets/player-sheet.png"), description = "Makes hair goonable"}}

    -- Inventory variables
    inventoryScale = 3
    inventoryCellSize = 32 * inventoryScale
    inventoryCols = 5
    inventoryRows = 2

    -- Interactables RICHARD THESE CONTAIN DIALOGUES
    interactableHitbox = {w = 48, h = 48}
    interactables = {
        {id = 1, name = "gothGirl", vanityName = "Layla", mapTrueX = (5 * tileWH), mapTrueY = (5 * tileWH)}
        , {id = 2, name = "sororityGirl", vanityName = "Bertha", mapTrueX = (7 * tileWH), mapTrueY = (6 * tileWH)}
    }
end