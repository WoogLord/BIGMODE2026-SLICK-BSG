AnimClass = {}
AnimClass.__index = AnimClass

function AnimClass:new(
          _animState, _frames, _animations, _framesPerSecond, _isLocal, _isRandomizedStagger
        --   , _currAnimState, _currFrame
    )
    local tAC = {} -- tAC = tempAnimClass
    setmetatable(tAC, AnimClass)

    tAC.animState = _animState
    tAC.frames, tAC.animations = _frames, _animations
    tAC.framesPerSecond, tAC.isLocal = _framesPerSecond, _isLocal
    tAC.isRandomizedStagger = _isRandomizedStagger
    tAC.currAnimState, tAC.currFrame = 1, 1
    return tAC
end

function AnimClass:BuildAnimations(_spriteSheet)
    for i = 1, #self.animState, 1 do
        self.animations[i] = self.animations[i] or {} 
        for j = 1, self.frames[i], 1  do
            self.animations[i][j] = love.graphics.newQuad(
                tileWH*(j-1), (i-1) * tileWH, tileWH, tileWH, _spriteSheet:getDimensions()
            )
        end
    end
end

playerAnimationArray = AnimClass:new(
    {
        "IdleDown", "IdleUp", "IdleRight"
        , "WalkDown", "WalkUp", "WalkRight"
    }
    , {
        4, 4, 4
        , 4, 4, 4
    }
    , {
        {}, {}, {}
        , {}, {}, {}
    }
    , {
        4, 4, 4
        , 4, 4, 4
    }
    , {
        false, false, false
        , false, false, false
    }
    , {
        false, false, false
        , false, false, false
    }
)
everyoneElseAnimationArray = AnimClass:new( "IdleDown", 4, {}, 12, false, true)

function animationManager(_dt)
    globalSpriteTimer = globalSpriteTimer + _dt
    
    for _, thing in ipairs(thingsBeingAnimated) do
        local localSpriteTimer, timing = 0, 0
        local randomStagger = math.random(1,3)

        if thing.isRandomizedStagger[thing.currAnimState] then 
            timing = thing.framesPerSecond[thing.currAnimState] + randomStagger 
        else timing = thing.framesPerSecond[thing.currAnimState] 
        end

        if thing.isLocal[thing.currAnimState] then
            localSpriteTimer = localSpriteTimer + _dt
            thing.currentAnim = thing.animations[thing.currAnimState][math.ceil(localSpriteTimer*timing % 4)]
        else
            thing.currentAnim = thing.animations[thing.currAnimState][math.ceil(globalSpriteTimer*timing % 4)]
        end
    end
end