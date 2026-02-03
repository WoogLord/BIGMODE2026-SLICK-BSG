function assignSpriteSheets()
    -- player
    player.spriteSheet = love.graphics.newImage("assets/art/spritesheets/player-sheet.png")
    player.anim = playerAnimationArray
    player.anim:BuildAnimations(player.spriteSheet)
    player.anim.currAnimState = 3
    -- everyone Else

    thingsBeingAnimated = {
        player.anim
    }

end

function assignLayerArt()
    -- bgs
    bg_01_nightclub = love.graphics.newImage("assets/art/bgs/bg_01_master - All layers.png")

    -- top
    bg_01_topLayer = love.graphics.newImage("assets/art/bgs/bg_01_master - All layers.png")

    -- collision
    -- debug
    bg_01_collision = love.graphics.newImage("assets/art/bgs/bg_01_master - Collision.png")
    bg_01_collisionData = love.image.newImageData("assets/art/bgs/bg_01_master - Collision.png")

    -- interactables
    
end

function assignPortraits()
    -- tests
    port_test_360 = love.graphics.newImage("assets/art/portraits/360360.png")
    port_test_256 = love.graphics.newImage("assets/art/portraits/256256.png")
end