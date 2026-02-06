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

function AnimClass:BuildAnimations(_spriteSheet, _tileSizeW, _tileSizeH)
    for i = 1, #self.animState, 1 do
        self.animations[i] = self.animations[i] or {} 
        for j = 1, self.frames[i], 1  do
            self.animations[i][j] = love.graphics.newQuad(
                _tileSizeW*(j-1), (i-1) * _tileSizeH, _tileSizeW, _tileSizeH, _spriteSheet:getDimensions()
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

portraitAnimationArray = AnimClass:new(
    {"neutral", "angry", "disgust", "happy"}
    , {1, 1, 1, 1}
    , {{}, {}, {}, {}}
    , {4, 4, 4, 4}
    , {false, false, false, false}
    , {false, false, false, false}
)

jacketGuyAnimationArray = AnimClass:new({"IdleDown"}, {4}, {{}}, {4}, {false}, {false})
everyoneElseAnimationArray = AnimClass:new({"IdleDown"}, {4}, {{}}, {4}, {false}, {false})

function animationManager(_dt)
    globalSpriteTimer = globalSpriteTimer + _dt
    updownFloating = math.sin(love.timer.getTime()) * 2
    
    for _, thing in ipairs(thingsBeingAnimated) do
        local localSpriteTimer, timing = 0, 0
        local randomStagger = math.random(1,3)

        if thing.isRandomizedStagger[thing.currAnimState] then 
            timing = thing.framesPerSecond[thing.currAnimState] + randomStagger 
        else timing = thing.framesPerSecond[thing.currAnimState] 
        end

        if thing.isLocal[thing.currAnimState] then
            localSpriteTimer = localSpriteTimer + _dt
            thing.currentAnim = thing.animations[thing.currAnimState][math.ceil(localSpriteTimer*timing % thing.frames[thing.currAnimState])]
        else
            thing.currentAnim = thing.animations[thing.currAnimState][math.ceil(globalSpriteTimer*timing % thing.frames[thing.currAnimState])]
        end
    end
end