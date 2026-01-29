AnimClass = {}
AnimClass.__index = AnimClass

function AnimClass:new(
          _animState, _frames, _animations
    )
    local tAC = {} -- tAC = tempAnimClass
    setmetatable(tAC, AnimClass)

    tAC.animState = _animState
    tAC.frames, tAC.animations = _frames, _animations

    return tAC
end

function AnimClass:BuildAnimations(_spriteSheet)
    local retArr = {}
    for i = 1, #self.animState, 1 do
        retArr[i] = {}
        for j = 1, self.frames[i], 1  do
            self.animations[i][j] = love.graphics.newQuad(
                tileWH*(j-1), (i-1) * tileWH, tileWH, tileWH, _spriteSheet:getDimensions()
            )
            retArr[i][j] = love.graphics.newQuad(
                tileWH*(j-1), (i-1) * tileWH, tileWH, tileWH, _spriteSheet:getDimensions()
            )
        end
    end
    return retArr
end
