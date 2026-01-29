local dir = love.filesystem.getSourceBaseDirectory()
package.path = dir .. "/?.lua;" .. dir .. "/?/init.lua;" .. package.path

love.graphics.setDefaultFilter("nearest","nearest")

-- love.load functions
local initF require "code.init.startgame"
local initUIF require "code.init.initUI"

-- love.update functions
local updF require "code.update.mainupdate"
local inputsF require "code.update.inputs"
local statsF require "code.update.statsmanager"

-- love.draw functions
local drawF require "code.draw.maindraw"
local animsF require "code.draw.animmanager"
local uiF require "code.draw.ui"

function love.load()
    init()
    initUI()
end

function love.update(dt)
    love.timer.sleep(1/60)
    gameManager()
    speedManager(dt)
    doFloaters()
end

function love.draw()
    drawStateMachine()
    if isDebug == true then drawDebug() end
end