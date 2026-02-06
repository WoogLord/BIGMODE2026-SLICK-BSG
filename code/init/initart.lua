function assignSpriteSheets()
    -- player
    player.spriteSheet = love.graphics.newImage("assets/art/spritesheets/player-sheet.png")
    player.anim = playerAnimationArray
    player.anim:BuildAnimations(player.spriteSheet, tileWH, tileWH)
    player.anim.currAnimState = 3

    thingsBeingAnimated = {
        player.anim
    }

    -- girls
    interactables[1].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Goth girl security-Sheet.png")
    interactables[2].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Frat girl-Sheet.png")
    interactables[3].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Influencer sprite-Sheet.png")
    -- item NPCs
    interactables[4].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Leather Jacket guy-Sheet.png")
    interactables[5].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Hair guy for game-Sheet.png")
    interactables[6].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Kamina Shades Sprite-Sheet.png")
    interactables[7].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Abs npc Sprite-Sheet.png")
    interactables[8].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Girl with Blue hair sprite-Sheet.png")
    interactables[9].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Shorts NPC Sprite-Sheet.png")
    interactables[10].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Mewing Man Sprite-Sheet.png")
    -- Juice NPCs
    interactables[11].spriteSheet = love.graphics.newImage("assets/art/SpriteCharacters/Leather Jacket guy WO-Sheet.png")
    interactables[12].spriteSheet = love.graphics.newImage("assets/art/ifhesinvinciblewhycaniseehim.png")

    -- add everyone else to animation array
    for i, interacts in pairs(interactables) do
        if i == 4 or i == 11 then interacts.anim = jacketGuyAnimationArray else interacts.anim = everyoneElseAnimationArray end
        print(interacts.tileW..interacts.tileH)
        interacts.anim:BuildAnimations(interacts.spriteSheet, interacts.tileW, interacts.tileH)
        interacts.anim.currAnimState = 1
        table.insert(thingsBeingAnimated, interacts.anim)
        print(thingsBeingAnimated[i])
    end
end

function assignLayerArt()
    -- bgs
    bg_floor_tiles = love.graphics.newImage("assets/art/bgs/bg_floor_tiles.png")
    bg_WALLS = love.graphics.newImage("assets/art/bgs/bg_WALLS.png")
    bg_DJ_Stairs = love.graphics.newImage("assets/art/bgs/bg_DJ_Stairs.png")
    bg_DJ_Stage = love.graphics.newImage("assets/art/bgs/bg_DJ_Stage.png")
    bg_DJ_Opacity_45 = love.graphics.newImage("assets/art/bgs/bg_DJ_Opacity_45.png")
    bg_Sorority_Top = love.graphics.newImage("assets/art/bgs/bg_Sorority_Top.png")
    bg_Sorority_Mid = love.graphics.newImage("assets/art/bgs/bg_Sorority_Mid.png")
    bg_Sorority_Bot = love.graphics.newImage("assets/art/bgs/bg_Sorority_Bot.png")
    bg_Characters_01 = love.graphics.newImage("assets/art/bgs/bg_Characters_01.png")
    bg_Characters_02 = love.graphics.newImage("assets/art/bgs/bg_Characters_02.png")
    bg_Furniture = love.graphics.newImage("assets/art/bgs/bg_Furniture.png")
    bg_BathroomShadow = love.graphics.newImage("assets/art/bgs/bg_BathroomShadow.png")
    bg_Items_01_Props = love.graphics.newImage("assets/art/bgs/bg_Items_01_Props.png")
    bg_BIGGIE = love.graphics.newImage("assets/art/bgs/bg_BIGGIE.png")

    -- collision
    -- debug
    bg_Collision_PreSorortiy = love.graphics.newImage("assets/art/bgs/bg_Collision_PreSorortiy.png")
    bg_Collision_PostSorortiy = love.graphics.newImage("assets/art/bgs/bg_Collision_PostSorortiy.png")
    bg_Collision_InClub = love.graphics.newImage("assets/art/bgs/bg_Collision_InClub.png")

    bg_Collision_PreSorortiy_Data = love.image.newImageData("assets/art/bgs/bg_Collision_PreSorortiy.png")
    bg_Collision_PostSorortiy_Data = love.image.newImageData("assets/art/bgs/bg_Collision_PostSorortiy.png")
    bg_Collision_InClub_Data = love.image.newImageData("assets/art/bgs/bg_Collision_InClub.png")

    currentCollisionDraw = bg_Collision_PreSorortiy
    currentCollisionData = bg_Collision_PreSorortiy_Data

    -- interactables
    z_key_art = love.graphics.newImage("assets/art/ui/z_key.png")
end

function assignPortraits()
    -- tests
    port_test_360 = love.graphics.newImage("assets/art/portraits/360360.png")
    port_test_256 = love.graphics.newImage("assets/art/portraits/256256.png")

    -- chatbox
    interactables[1].chatbox = {
        fill = love.graphics.newImage("assets/art/ui/gothGirl_chatbox_fill.png")
        , outline = love.graphics.newImage("assets/art/ui/gothGirl_chatbox_outline.png")
    }

    -- portraits
    interactables[1].portrait = {spriteSheet = love.graphics.newImage("assets/art/portraits/Layla Sprite Sheet_FINAL.png")}
    interactables[2].portrait = {spriteSheet = love.graphics.newImage("assets/art/portraits/Sorority Sprite Sheet_FINAL.png")}
    interactables[3].portrait = {spriteSheet = love.graphics.newImage("assets/art/portraits/Starchild Sprite Sheet_FINAL.png")}

    portraitArr = {
        interactables[1].portrait,
        interactables[2].portrait,
        interactables[3].portrait,
    }

    -- portrait assignment for animations
    for i, portrait in pairs(portraitArr) do
        portrait.anim = portraitAnimationArray
        portrait.anim:BuildAnimations(portrait.spriteSheet, 360, 360)
        portrait.anim.currAnimState = 1
        table.insert(thingsBeingAnimated, portrait.anim)
        print(thingsBeingAnimated[i])
    end
    
    -- portrait Frame
    interactables[1].portraitFrame = love.graphics.newImage("assets/art/portraits/Goth_girl_portrait Frame.png")
    interactables[2].portraitFrame = love.graphics.newImage("assets/art/portraits/Sorority portrait Frame.png")
    interactables[3].portraitFrame = love.graphics.newImage("assets/art/portraits/Influencer portrait Frame.png")

end