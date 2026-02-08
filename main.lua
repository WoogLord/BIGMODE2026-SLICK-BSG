local dir = love.filesystem.getSourceBaseDirectory()
package.path = dir .. "/?.lua;" .. dir .. "/?/init.lua;" .. package.path

love.graphics.setDefaultFilter("nearest","nearest")

-- love.load functions
local initF require "code.init.startgame"
local inituiF require "code.init.initui"
local initartF require "code.init.initart"

-- love.update functions
local updF require "code.update.mainupdate"
local inputsF require "code.update.inputs"
local statsF require "code.update.statsmanager"
local soundF require "code.update.soundmanager"

-- love.draw functions
local drawF require "code.draw.maindraw"
local animsF require "code.draw.animmanager"
local uiF require "code.draw.ui"

function love.load()
    love.window.setTitle("One Night Window")
    icon = love.image.newImageData("assets/icon.png")
    love.window.setIcon(icon)
    init()
    initUI()
    assignSpriteSheets()
    assignLayerArt()
    assignPortraits()
end

function love.update(dt)
    love.timer.sleep(1/60)
    defeatTimer = defeatTimer + dt
    bossFightTimer = bossFightTimer + dt
    bossFightFadeOutTimer = bossFightFadeOutTimer + dt
    influencerHealTimer = influencerHealTimer + dt
    itemGetSfxDelayTime = itemGetSfxDelayTime + dt
    creditsMovieStallTime = creditsMovieStallTime + dt
    introMovieStallTime = introMovieStallTime + dt
    alphaTween = math.min((globalSpriteTimer) / introWindUpTime, 1)
    defeatAlphaTween = math.min(defeatTimer / defeatWindUpTime, 1)
    bossFightAlphaTween = math.min(bossFightFadeOutTimer / bossFightFadeOutWindDownTime, 1)
    gameManager()    
    speedManager(dt)
    doFloaters()
    animationManager(dt)
    soundManager(dt)
    playerControls()
end

function love.draw()
    drawStateMachine()
    if isDebug == true then drawDebug() end
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(debugFont)
    if isDebug then love.graphics.print("ONE NIGHT WINDOW - "..buildVersion.." - build time: 02-07-2026 at 8:46p ET", 5 * gfxScale, currWinDim.h-(gfxScale)-debugFont:getHeight(debugFont)) end
end