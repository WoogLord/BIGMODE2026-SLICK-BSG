function init()
    buildVersion = "v5"
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
    introWindUpTime = 1
    drawnMapOffsetX = 0
    drawnMapOffsetY = 0
    
    -- defeat screen
    defeatScreen = love.graphics.newImage("assets/art/ui/defeat.png")
    defeatAlphaTween = 0
    defeatTimer = 0
    defeatWindUpTime = 5

    -- Bossfight shit
    isInBossFight = false
    influencerMaxHP = 250
    influencerCurrentHP = 200
    influencerBaseHeal = 1
    influencerTotalHeal = 1
    influencerHealTimer = 0
    playerBaseDamage = 1
    playerTotalDamage = 1
    bossFightTimer = 0
    bossFightHeart = love.graphics.newImage("assets/art/bossfightstuff/bossfight_heart.png")
    bossFightBG = {spriteSheet = love.graphics.newImage("assets/art/bossfightstuff/frame_11_final.png")}
    bossFightStaticClash = {spriteSheet = love.graphics.newImage("assets/art/bossfightstuff/Final beam clash - mod_clash-Sheet.png")}
    bossFightLeftKame = {spriteSheet = love.graphics.newImage("assets/art/bossfightstuff/Kamahema animation_blue-Sheet.png")}
    bossFightRightKame = {spriteSheet = love.graphics.newImage("assets/art/bossfightstuff/Kamahema animation_red-Sheet.png")}
    bossFightBeamElectricity = {spriteSheet = love.graphics.newImage("assets/art/bossfightstuff/Final beam clash - mod_beam_electricity-Sheet.png")}
    bossFightElectricity = {spriteSheet = love.graphics.newImage("assets/art/bossfightstuff/Final beam clash - mod_electricity-Sheet.png")}
    bossFightSpliceLeftKame = love.graphics.newImage("assets/art/bossfightstuff/kamehemahe-blue-splice.png")
    bossFightSpliceRightKame = love.graphics.newImage("assets/art/bossfightstuff/kamehemahe-red-splice.png")
    bossFightFadeOutTimer = 0
    bossFightFadeOutWindDownTime = 3
    bossFightAlphaTween = 1

    -- item get
    isGettingItem = false
    currentItemBeingGot = ""
    currentItemBeingGotInt = 1
    itemGetSfxDelayTimer = 5
    itemGetSfxDelayTime = 0
    isPlayingDelayedSfx = false
    delayedSfx = nil

    bossFightArtArray = {
        bossFightStaticClash, bossFightLeftKame, bossFightRightKame, bossFightBeamElectricity, bossFightElectricity
    }
    for i, bossFightArt in pairs(bossFightArtArray) do
        bossFightArt.anim = bossFightPixelAnimationArray
        bossFightArt.anim:BuildAnimations(bossFightArt.spriteSheet, 480, 270)
        bossFightArt.anim.currAnimState = 1
    end
    bossFightBG.anim = bossFightVectorAnimationArray
    bossFightBG.anim:BuildAnimations(bossFightBG.spriteSheet, 1920, 1080)
    bossFightBG.anim.currAnimState = 1

    INPUTS_ARR = {
        fullscreen = "f", debug = "f3", pause = "escape"
        , up = {"w","up"}, left = {"a","left"}, down = {"s","down"}, right = {"d","right"}
        , jump = " "
        , select = {"return", "z", "e"}, cancel = "x"
        , inventory = "i"
        , bossFightDebug = "b"
    }
    player = {
        isFlippedLeft = false
        , facing = "Right"
        , mapTileX = 1, mapTileY = 15.5
        , mapTrueX = 0, mapTrueY = 0
        , lastMapTileX = 1, lastMapTileY = 15.5 
        , lastMapTrueX = 0, lastMapTrueY = 0
        , speed = 25
        , items = {
            love.graphics.newImage("assets/art/Nightclubitems/item01_jacket.png")
            , love.graphics.newImage("assets/art/Nightclubitems/item02_hair.png")
            , love.graphics.newImage("assets/art/Nightclubitems/item03_shades.png")
            , love.graphics.newImage("assets/art/Nightclubitems/item04_abs.png")
            , love.graphics.newImage("assets/art/Nightclubitems/item05_shoes.png")
            , love.graphics.newImage("assets/art/Nightclubitems/item06_pants.png")
            , love.graphics.newImage("assets/art/Nightclubitems/item07_mew.png")
        }
        , itemSfx = {
            love.audio.newSource("assets/sfx/sillyvoicelines/item01_jacket.mp3", "stream", false)
            , love.audio.newSource("assets/sfx/sillyvoicelines/item02_hair.mp3", "stream", false)
            , love.audio.newSource("assets/sfx/sillyvoicelines/item03_shades.mp3", "stream", false)
            , love.audio.newSource("assets/sfx/sillyvoicelines/item04_abs.mp3", "stream", false)
            , love.audio.newSource("assets/sfx/sillyvoicelines/item05_shoes.mp3", "stream", false)
            , love.audio.newSource("assets/sfx/sillyvoicelines/item06_pants.mp3", "stream", false)
            , love.audio.newSource("assets/sfx/sillyvoicelines/item07_mew.mp3", "stream", false)
            , love.audio.newSource("assets/sfx/sillyvoicelines/youGot_01.mp3", "stream", false)
            , love.audio.newSource("assets/sfx/sillyvoicelines/youGot_02.mp3", "stream", false)
        }
        , hitbox = {w = 14, h = 14, tileX = 0, tileY = 0}
        , isColliding = false
        , inClub = false
    }
    player.mapTrueX, player.mapTrueY = (player.mapTileX * 32), (player.mapTileY * 32)
    player.lastMapTrueX, player.lastMapTrueY = player.mapTrueX, player.mapTrueY
    floater = {}
    
    -- fonts
    mainMenuFont = love.graphics.newFont(32 / 4 * gfxScale)
    debugFont = love.graphics.newFont(16/ 4 * gfxScale)
    buttonFont = love.graphics.newFont(24/ 4 * gfxScale)
    npcDialogueFont = love.graphics.newFont(48 / 4 * gfxScale)
    responseFont = love.graphics.newFont(36 / 4 * gfxScale)

    -- window/screen logic
    screenW, screenH = love.window.getDesktopDimensions()
    gfxScale = math.floor((screenW - 1) / 480)
    portScale = 1 / 4 * gfxScale
    currWinDim = {w = 1920 / 4 * gfxScale, h = 1080 / 4 * gfxScale}
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
    currentAnnouncement = nil
    currentSongDuration = 999 -- make this 999 if you dont want announcer to fire immediately
    currentSongTimePlayedFor = 0
    -- titleMusic = love.audio.newSource("assets/music/Title_theme_outside.mp3", "stream", true)
    titleMusic = love.audio.newSource("assets/music/Title_theme_outside.mp3", "stream", true)
    musicClubTracks = {
          mus_01_aye = love.audio.newSource("assets/music/Aye.mp3", "stream", false)
        -- mus_02_rave
        -- mus_03_rave2
        , mus_04_funkyRave = love.audio.newSource("assets/music/Funky_Rave.mp3", "stream", false)
        , mus_05_rave3_no_L = love.audio.newSource("assets/music/rave_3_no_L.mp3", "stream", false)
    }
    musicClubTracksData = {
        mus_01_aye = {bpm = 108, dropBeatStart = 100, dropBeatEnd = 110}
        , mus_04_funkyRave = {bpm = 126, dropBeatStart = 100, dropBeatEnd = 110}
        , mus_05_rave3_no_L = {bpm = 132, dropBeatStart = 100, dropBeatEnd = 110}
    }
    flattenedMusicClubTracks = {}
    for _, src in pairs(musicClubTracks) do
        src:setLooping(false)
        flattenedMusicClubTracks[#flattenedMusicClubTracks+1] = src
    end
    sillyVoiceLines = {
        fogMachine = love.audio.newSource("assets/sfx/sillyvoicelines/FogMachine.mp3", "stream", false)
        , help = love.audio.newSource("assets/sfx/sillyvoicelines/Help.mp3", "stream", false)
        , insanity = love.audio.newSource("assets/sfx/sillyvoicelines/Insanity.mp3", "stream", false)
        , meatwad = love.audio.newSource("assets/sfx/sillyvoicelines/Meatwad.mp3", "stream", false)
        , piss = love.audio.newSource("assets/sfx/sillyvoicelines/Piss.mp3", "stream", false)
        , seymour = love.audio.newSource("assets/sfx/sillyvoicelines/Seymour.mp3", "stream", false)
        , sock = love.audio.newSource("assets/sfx/sillyvoicelines/Sock.mp3", "stream", false)
    }
    flattenedAnnouncements = {}
    for _, src in pairs(sillyVoiceLines) do
        src:setLooping(false)
        flattenedAnnouncements[#flattenedAnnouncements+1] = src
    end
    sfxSources = {
          menuSelection = love.audio.newSource("assets/sfx/regular ah soundeffects/Menu_interaction.mp3", "stream", false)
        , menuOK = love.audio.newSource("assets/sfx/regular ah soundeffects/SFX_7.wav", "stream", false)
    }
    bossFightMusic = love.audio.newSource("assets/music/spam.mp3", "stream", false)
    
    -- Movies
    bossFightIntroMovie = love.graphics.newVideo("assets/videos/bossFightCutscene.ogv")
    gameIntroMovie = love.graphics.newVideo("assets/videos/intro_cutscene.ogv")
    creditsMovie = love.graphics.newVideo("assets/videos/credits.ogv")
    introMovieStallTime = 0
    introMovieTotalDuration = gameIntroMovie:getSource():getDuration("seconds")
    creditsMovieStallTime = 0

    -- Inventory Object
    -- InventoryBag = {"Bigmode Blazer", "Bald-Be-Gone TM", "Heavenly Shades", "Miniature Broflex", "Agarthan Fjordans", "Slick Slacks", "Book of Mew"}
    InventoryBag = {}
    InventoryImages = {
        ["Bigmode Blazer"] = {image = love.graphics.newImage("assets/art/Nightclubitems/item01_jacket.png"), name = "Bigmode Blazer", description = "Ripped straight from a cool dude's back. "}
        , ["Bald-Be-Gone TM"] = {image = love.graphics.newImage("assets/art/Nightclubitems/item02_hair.png"), name = "Bald-Be-Gone TM", description = "Beautiful hair in a bottle."}
        , ["Heavenly Shades"] = {image = love.graphics.newImage("assets/art/Nightclubitems/item03_shades.png"), name = "Heavenly Shades", description = "Makes it a little hard to see."}
        , ["Miniature Broflex"] = {image = love.graphics.newImage("assets/art/Nightclubitems/item04_abs.png"), name = "Miniature Broflex", description = "Somehow, you got abs."}
        , ["Agarthan Fjordans"] = {image = love.graphics.newImage("assets/art/Nightclubitems/item05_shoes.png"), name = "Agarthan Fjordans", description = "Strong shoe game = strong woo game"}
        , ["Slick Slacks"] = {image = love.graphics.newImage("assets/art/Nightclubitems/item06_pants.png"), name = "Slick Slacks", description = "Better than crapped briefs."}
        , ["Book of Mew"] = {image = love.graphics.newImage("assets/art/Nightclubitems/item07_mew.png"), name = "Book of Mew", description = "Written by Yakub himself."}
    }
    -- Inventory variables
    inventoryScale = 3
    inventoryCellSize = 32 * inventoryScale * gfxScale / 4
    inventoryCols = 5
    inventoryRows = 2

    -- CONVERSATION SECTION

    gothGirlConvoState = 0
    sororityGirlConvoState = 0
    influencerGirlConvoState = 0

    jacketGuyConvoState = 0
    hairGuyConvoState = 0
    shadesGuyConvoState = 0
    absGuyConvoState = 0
    shoesGirlConvoState = 0
    shortsGuyConvoState = 0
    mewGuyConvoState = 0
    jacketGuyNOJacketConvoState = 0
    biggieConvoState = 0

    isJackenStolen = false

    -- Interactables
    interactableHitbox = {w = 48, h = 48}
    interactables = {
        {id = 1, name = "gothGirl", vanityName = "Layla", mapTrueX = (9 * tileWH), mapTrueY = (13 * tileWH), checkPoints = {"48a", "1d"}, passPoints = {"1c1"}, passingItems = {"Bigmode Blazer"}, tileH = 32, tileW = 32}
        , {id = 2, name = "sororityGirl", vanityName = "Bertha", mapTrueX = (19 * tileWH), mapTrueY = (18 * tileWH), checkPoints = {"2z", "1", "36a", "1c"}, passPoints = {"1", "1a", "1b"}, passingItems = {"Bald-Be-Gone TM", "Heavenly Shades", "Miniature Broflex"}, tileH = 32, tileW = 32}
        , {id = 3, name = "influencerGirl", vanityName = "Starchild", mapTrueX = (28 * tileWH), mapTrueY = (22 * tileWH), checkPoints = {"1", "3", "5", "1a"}, passPoints = {"3", "5", "10"}, passingItems = {"Agarthan Fjordans", "Slick Slacks", "Book of Mew"}, tileH = 32, tileW = 32}
        , {id = 4, name = "jacketGuy", vanityName = "Axel", mapTrueX = (18 * tileWH), mapTrueY = (22.5 * tileWH), tileH = 48, tileW = 32}
        , {id = 5, name = "hairGuy", vanityName = "Monoxydillian", mapTrueX = (12 * tileWH), mapTrueY = (24 * tileWH), tileH = 32, tileW = 32}
        , {id = 6, name = "shadesGuy", vanityName = "Kamina", mapTrueX = (16 * tileWH), mapTrueY = (17 * tileWH), tileH = 32, tileW = 32}
        , {id = 7, name = "absGuy", vanityName = "Greaser", mapTrueX = (22 * tileWH), mapTrueY = (12 * tileWH), tileH = 32, tileW = 32}
        , {id = 8, name = "shoesGirl", vanityName = "Rebecca", mapTrueX = (20 * tileWH), mapTrueY = (23 * tileWH), tileH = 32, tileW = 32}
        , {id = 9, name = "shortsGuy", vanityName = "Marc", mapTrueX = (18 * tileWH), mapTrueY = (5 * tileWH), tileH = 32, tileW = 32}
        , {id = 10, name = "mewGuy", vanityName = "Yakub", mapTrueX = (7 * tileWH), mapTrueY = (4 * tileWH), tileH = 32, tileW = 32}
        , {id = 11, name = "jacketGuyNOJacket", vanityName = "AscendedAxel", mapTrueX = (18 * tileWH), mapTrueY = (22.5 * tileWH), tileH = 48, tileW = 32}
        -- bonus fellas
        , {id = 12, name = "biggie", vanityName = "Biggimus Modicus", mapTrueX = (15.5 * tileWH), mapTrueY = (25.5 * tileWH), tileH = 32, tileW = 32}
       --[[ , {id = 13, name = "gothGirlFriend1", vanityName = "Toxic", mapTrueX = (22 * tileWH), mapTrueY = (25 * tileWH), tileH = 32, tileW = 32}
        , {id = 14, name = "gothGirlFriend2", vanityName = "Wasteland", mapTrueX = (23 * tileWH), mapTrueY = (23 * tileWH), tileH = 32, tileW = 32}]]
    }
    sororityDrawYOffset = 0

    -- Conversation Trees
    gothGirlTree = {
        {id = "1", npcEmotion = 2, npcText = "Who the fuck are you.... and why are you wearing that ugly ass shirt?", responses = {{text = "Oh this old thing? Your Mom gave it to me last night?", nextDialog = "2a"}, {text = "Woah, that's a lot of hostility. I haven't even said anything yet.", nextDialog = "2b"}, {text = "Dang Shawtty. Why you gotta be like that.", nextDialog = "2c"}}},
        {id = "2a", npcEmotion = 1, npcText = "Ha! Yeah right. Like my mom would talk to a loser like you.", responses = {{text =  "Your mother is a lady of fine tastes. She clearly enjoys a refined man.", nextDialog = "3a"}, {text = " You know who else would talk to a loser like me?", nextDialog = "3b"}}},
        {id = "3a", npcEmotion = 1, npcText = "You've clearly never met her. Her main hobby is smoking METH behind the gas station closest to our house.", responses = {{text = "I mean, who can blame a girl for wanting a good time.", nextDialog = "4a"}, {text = "Fuck... Is your Dad chill at least?", nextDialog = "4b"}}},
        {id = "4a", npcEmotion = 2, npcText = "Me. My fucking mother is literally a drug addict. I never want to associate with anyone like that again.", responses = {{text = "Want some meth?", nextDialog = "5a"}, {text = "Woah. I'm sorry. I didn't mean to get so deep.", nextDialog = "5b"}}},
        {id = "5a", npcEmotion = 3, npcText = "Give it to me! What the fuck is wrong with you? You'll ruin your life!", responses = {{text = "I'm joking, I'm joking! I've never even seen meth.", nextDialog = "6a"}, {text = "Woah! Woah! Its like $80 a gram. Be careful!", nextDialog = "6b"}}},
        {id = "6a", npcEmotion = 4, npcText = "Ok good. I couldn't live  seeing another life ruined.", responses = {{text = "My dad was in and out of jail while I was growing up. I know how you feel. Joking can sometimes make it easier.", nextDialog = "7a"}, {text = "Ask me anything. You can get to know me.", nextDialog = "19a" }}},
        {id = "7a", npcEmotion = 1, npcText = "I know what you mean. Sorry, I just get defensive sometimes. I'm Layla.", responses = {{text = "Pretty name for a pretty girl.", nextDialog = "8a" }, {text = "Yeah, I don't need your name, I just need your number.", nextDialog = "8b"}}},
        {id = "8a", npcEmotion = 4, npcText = "*Blushes* Thanks. You're kinda ugly but at least you're sweet.", responses = {{text = "Ugly? You just mean my shirt right??", nextDialog = "9a" }, {text = "So what are you doing in this corner by yourself?", nextDialog = "19a"}}},
        {id = "9a", npcEmotion = 1, npcText = "No haha. You're short, fat, and you've got the hair of a 50 year old. You could use some work. ", responses = {{text = "But I can make you smile. That's what counts. ", nextDialog = "10a" }, {text = "I'm just trying to get you number and subsiquently hit. Are you letting me or not?", nextDialog = "19a"}}},
        {id = "10a", npcEmotion = 1, npcText = "That's definitely part of it. I'll give you that. ", responses = {{text = "How about I get your number and I can make you laugh over dinner?", nextDialog = "47b"}}}, 
        {id = "3b", npcEmotion = 3, npcText = ".............", responses = {{text = "*shit pants*", nextDialog = "reset"}, {text = "MY MOM.", nextDialog = "11a"}}},
        {id = "11a", npcEmotion = 4, npcText = "WOOOOOOOOOOOOOOOOOOOOOOOOOOOOAH *high fives* That's what I'm talking about.", responses = {{text = "-->", nextDialog = "47b"}}},
        {id = "4b", npcEmotion = 2, npcText = "Do I look like I have a fucking father figure?", responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "5b", npcEmotion = 1, npcText = "It's Ok. I've just had a really rough night. ", responses = {{text = "What happened?", nextDialog = "23a"}, {text = "Are we talking like a P80 or more of a P320?", nextDialog = "12b"}}},
        {id = "6b", npcEmotion = 2, npcText = "You know what?! LEAVE ME ALONE", responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "8b", npcEmotion = 2, npcText = "I knew you were a fucking clown.", responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "12b", npcEmotion = 2, npcText = "What the fuck does that even mean?", responses = {{text = "Never mind. *laughs nervously* What happened?", nextDialog = "23a"}, {text = "Clearly you know nothing about sandpaper. ", nextDialog = "13a"}}},
        {id = "13a", npcEmotion = 3, npcText = "What the fuck is wrong with you. No, I don't know anything about sandpaper.", responses = {{text = "You said your night was rough. So I asked how rough using sandpaper grit levels. ", nextDialog = "14a"}, {text = "Sorry, its all the meth that I'm on.", nextDialog = "14b"}}},
        {id = "14a", npcEmotion = 2, npcText = ".....................................", responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "14b", npcEmotion = 2, npcText = "What is wrong with you?? I just want to be left alone.", responses = {{text = "Is it because you're goth?", nextDialog = "15a"}, {text = "What's wrong? Maybe I can help.", nextDialog = "23a"}}},
        {id = "15a", npcEmotion = 2, npcText = "NO ITS NOT BECAUSE I'M GOTH YOU IDIOT.", responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "2b", npcEmotion = 2, npcText = "Oh, I'm hostile??!! Who just approaches a random girl in the club when she's by herself???", responses = {{text = "I mean... most guys? Its a club", nextDialog = "16a"}, {text = "Guys who like lonely girls.", nextDialog = "16b"}}},
        {id = "16a", npcEmotion = 1, npcText = "Erm... Ok fair enough.", responses = {{text = "Ok. Lets literally start over.", nextDialog = "1"}, {text = "Do you want to dance?", nextDialog = "25a"}}},
        {id = "16b", npcEmotion = 2, npcText = "Fuck off. Its not like I like to be alone.", responses = {{text = "But you're goth... That's like, the goth thing. What are you even doing in a club? ", nextDialog = "17a"}, {text = "Well, why are you alone?", nextDialog = "19a"}}},
        {id = "17a", npcEmotion = 3, npcText = "You're such a dick. My stupid friends made me come.", responses = {{text = "*looks around* You're all alone though....  What gives?", nextDialog = "23a"}, {text = "More ladies? Where are they at??", nextDialog = "52a"}}},
        {id = "2c", npcEmotion = 3, npcText = "Ummmm... I guess your right. Your shirt is kinda cringe though. Get a slick jacket and maybe the girls in here will pay you more attention.", responses = {{text = "But I've already got the girl's attention I'm interested in.", nextDialog = "18a"}}},
        {id = "18a", npcEmotion = 2, npcText = "Get the fuck out of here. I don't even know you.", responses = {{text = "Ask me anything. You can get to know me.", nextDialog = "19a"}, {text = "Come on. I like heavy metal. I think about sorrow often. I've never even walked into a church.", nextDialog = "19b"}}},
        {id = "19a", npcEmotion = 1, npcText = "Are you so desperate to talk to a girl you need to pick the lonely one in the corner?", responses = {{text = "So you ARE lonely. I knew it. give me a chance. Its better than being alone.", nextDialog = "20a"}, {text = "I am desperate yes.", nextDialog = "20b"}}},
        {id = "20a", npcEmotion = 1, npcText = "I would rather be alone than with some doofus who's trying to get in my pants.", responses = {{text = "I mean.... Would you let me in?", nextDialog = "21a"}}},
        {id = "21a", npcEmotion = 2, npcText = "NO! GET THE FUCK OUT OF HERE!", responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "20b", npcEmotion = 4, npcText = "*chuckles* At least you're honest. Are you here alone?", responses = {{text = "Woah is that a smile?? And yes. I'm new to town.", nextDialog = "22a"}, {text = "A friend of mine works here so kinda, but not really", nextDialog = "22b"}}},
        {id = "22a", npcEmotion = 1, npcText = "I've lived here for years but this is the first time I've been clubbing.", responses = {{text = "Look at us. Both trying new things on our own. ", nextDialog = "23a"}, {text = "Are you more the type to stay at home and chill with friends?", nextDialog = "23a"}}},
        {id = "23a", npcEmotion = 1, npcText = "Well, my friends bailed on me. We all got here and five minutes in they were in the VIP section without me. Some big influencer is in there.", responses = {{text = "I mean the VIP section does look pretty lit. I'd probably leave you too.", nextDialog = "24a"}, {text = "That's rough. Those are some bad friends.", nextDialog = "24b"}}},
        {id = "24a", npcEmotion = 2, npcText = "GRRRRRR LEAVE ME THE FUCK ALONE!", responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "24b", npcEmotion = 4, npcText = "Yeah, the worst. At least this music is pretty hype. ", responses = {{text = "Do you want to dance?", nextDialog = "25a"}, {text = "Here, I know what will make you feel better. *does a series of comically awful dance moves*", nextDialog = "25b"}}},
        {id = "25a", npcEmotion = 1, npcText = "Nah, I'm good. I'm not in the mood.", responses = {{text = "Boooo. Come on. What else are you going to do?", nextDialog = "26a"}, {text = "I gotcha. Tell me about yourself.", nextDialog = "26b"}}},
        {id = "26a", npcEmotion = 3, npcText = "I said I'm good. I just want to leave but my friend is my ride.", responses = {{text = "I could give you a ride on my scooter.", nextDialog = "27a"}, {text = "Oooh. Captive Audience. ", nextDialog = "27b"}}},
        {id = "27a", npcEmotion = 1, npcText = "That's very nice but also a little pathetic...", responses = {{text = "-->", nextDialog = "8a"}}},
        {id = "27b", npcEmotion = 4, npcText = "Ha, you could say that.", responses = {{text = "You know, once you warm up, you're pretty chill.", nextDialog = "28a"}, {text = "So what's going on in the VIP section?", nextDialog = "28b"}}},
        {id = "28a", npcEmotion = 1, npcText = "Yeah. I tend to bite people's heads off. Tonight has just been rough.", responses = {{text = "Are we talking like a P80 or more of a P320?.", nextDialog = "29a"}}},
        {id = "29a", npcEmotion = 2, npcText = "What the fuck does that even mean?", responses = {{text = "Never mind. *laughs nervously* What happened?", nextDialog = "23a"}, {text = "Clearly you know nothing about sandpaper.", nextDialog = "30a"}}}, --DUPED ROW?
        {id = "30a", npcEmotion = 3, npcText = "What the fuck is wrong with you. No, I don't know anything about sandpaper.", responses = {{text = "You said your night was rough. So I asked how rough using sandpaper grit levels.", nextDialog = "31a"}, {text = "Sorry, its all the meth that I'm on. ", nextDialog = "31b"}}}, --DUPED ROW?
        {id = "31a", npcEmotion = 2, npcText = ".....................................", responses = {{text = "-->", nextDialog = "reset"}}}, --DUPED ROW?
        {id = "31b", npcEmotion = 2, npcText = "What is wrong with you?? I just want to be left alone.", responses = {{text = "Is it because you're goth?", nextDialog = "32a"}, {text = "What's wrong? Maybe I can help.", nextDialog = "23a"}}}, --DUPED ROW?
        {id = "28b", npcEmotion = 1, npcText = "I'm not really sure. There's some influencer girl but I've never heard of her.", responses = {{text = "Meh, who cares. I'm happy hanging with you.", nextDialog = "8a"}, {text = "Damn. I better get in there. I love Egirls.", nextDialog = "33a"}}},
        {id = "33a", npcEmotion = 1, npcText = "You love Egirls huh? Yeah, get the fuck out of here.", responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "26b", npcEmotion = 1, npcText = "I'm 24. I like terrible horror movies and I like guys who can make me laugh.", responses = {{text = "Oh yeah. Watch this. *does a series of comedic dance moves*", nextDialog = "25b"}, {text = "Are pity laughs acceptable? I get a lot of those.", nextDialog = "34a"}}},
        {id = "34a", npcEmotion = 1, npcText = "Nope.....", responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "25b", npcEmotion = 4, npcText = "Hahaha. Ok Stop! You're embarrassing yourself", responses = {{text = "What do you mean? Those were more normal dance moves.", nextDialog = "35a"}, {text = "It made you laugh so it was worth it.", nextDialog = "35b"}}},
        {id = "35a", npcEmotion = 4, npcText = "Haha sure. You know, you're not a bad guy after all.", responses = {{text = "How about I get your number and we can hang out in the future? I promise to make you laugh more.", nextDialog = "47b"}}},
        {id = "35b", npcEmotion = 4, npcText = "That was actually kind of sweet.", responses = {{text = "How about I get your number and we can hang out in the future? I promise to make you laugh more.", nextDialog = "47b"}}},
        {id = "22b", npcEmotion = 1, npcText = "That's pretty cool. You've got some connections in this place.", responses = {{text = "It's nothing huge. He's just a server in the VIP area.", nextDialog = "23a"}, {text = "Meh, I'm mostly here for the ladies.", nextDialog = "36a"}}},
        {id = "36a", npcEmotion = 1, npcText = "Oh yeah? How many phone number have you got tonight?", responses = {{text = "Zero", nextDialog = "37a"}, {text = "Three", nextDialog = "37b"}, {text = "One..... after I get yours.", nextDialog = "47b"}}},
        {id = "37a", npcEmotion = 3, npcText = "Probably because you have no game and you have that weird stain on your crotch", responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "38b", npcEmotion = 3, npcText = "Yeah, I don't think so.", responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "37b", npcEmotion = 1, npcText = "Big shot over here. I bet they're all fake.", responses = {{text = "Oh yeah? How about I call one.", nextDialog = "38a"}, {text = "How about you give me yours and I'll have 3 fake ones and one real.", nextDialog = "38b"}}}, 
        {id = "38a", npcEmotion = 1, npcText = "Be my guest.", responses = {{text = "*call a girls phone number*", nextDialog = "39a"}, {text = "Why would I want to call another girl when I have you right in front of me?", nextDialog = "39b"}}},
        {id = "39a", npcEmotion = 1, npcText = "...", responses = {{text = "*You realize you were bluffing and are now awkwardly staring at your phone. You put your phone in your pocket embarrassed. How could you be so foolish", nextDialog = "40a"}}},
        {id = "40a", npcEmotion = 3, npcText = "Ha! That's what I thought. What a loser.", responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "39b", npcEmotion = 4, npcText = "*Blushes* Thanks. You're kinda ugly but at least you're sweet", responses = {{text = "Ugly? You just mean my shirt right??", nextDialog = "41a"}}},
        {id = "41a", npcEmotion = 4, npcText = "No haha. You're short, fat, and you've got the hair of a 50 year old. You could use some work.", responses = {{text = "But I can make you smile. That's what counts.", nextDialog = "42a"}, {text = "I'm just trying to get you number and subsequently hit. Are you letting me or not?", nextDialog = "19a"}}},
        {id = "42a", npcEmotion = 1, npcText = "That's definitely part of it. I'll give you that.", responses = {{text = "How about I get your number and I can make you laugh over dinner?", nextDialog = "47b"}}},
        {id = "19b", npcEmotion = 1, npcText = "Ok asshole. Just beacause I have purple hair, doesn't mean I like metal and fucking sorrow.", responses = {{text = "Ok, lets start over. How's your relationship with your dad?", nextDialog = "4b"}, {text = "Well... Do you like metal?", nextDialog = "43b"}}},
        {id = "43b", npcEmotion = 1, npcText = "I do happen to like metal but its not because I'm goth. And no, I don't like sorrow.", responses = {{text = "See, We do have something in common.", nextDialog = "44a"}, {text = "Are you more of an aluminum fan or a copper fan?", nextDialog = "44b"}}},
        {id = "44a", npcEmotion = 1, npcText = "I guess you're right. I've been a bitch. Sorry.", responses = {{text = "Nah, you're good. We all get a little heated sometimes.", nextDialog = "45a"}, {text = "I mean... I wasn't going to say it....", nextDialog = "45b"}}},
        {id = "45a", npcEmotion = 1, npcText = "Thanks for being so chill.", responses = {{text = "I'm a chill guy and I'm looking for a pretty girl like you to hang with.", nextDialog = "8a"}, {text = "*shits pants* Thanks....", nextDialog = "46a"}}},
        {id = "46a", npcEmotion = 3, npcText = "What the fuck? Did you just shit yourself?", responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "45b", npcEmotion = 4, npcText = "HaHa. You're kinda funny.", responses = {{text = "I was being serious. You're a bitch.", nextDialog = "47a"}, {text = "Funny enough to get your number?", nextDialog = "47b"}}},
        {id = "47a", npcEmotion = 1, npcText = "Go be dick somewhere else then.", responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "47b", npcEmotion = 1, npcText = "Ok, that was kinda slick. You're not getting my number yet though.", responses = {{text = "What will it take to get it?", nextDialog = "48a"}, {text = "Its because of my ugly ass shirt isn't it. ", nextDialog = "48a"}}},   
        {id = "48a", npcEmotion = 3, npcText = "That shirt is gross. Get a jacket or something to cover it up. I cant been seen giving my number to someone looking like that.", responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 1}, --CHECKPOINT 1
        {id = "44b", npcEmotion = 1, npcText = "Definitely copper. I value conductivity way too much.", responses = {{text = "Why would you want a fan to be conductive? It doesn't affect the airflow.", nextDialog = "49a"}, {text = "I think I'm in love.", nextDialog = "49b"}}},
        {id = "49a", npcEmotion = 1, npcText = "True but I use the electric field it creates to protect me from 5G wifi.", responses = {{text = "I carry this totem of Jakub around so the hyperboreans don't slaughter me when they return.", nextDialog = "50a"}, {text = "Understandable. Have a nice day", nextDialog = "failure"}}},
        {id = "50a", npcEmotion = 4, npcText = "Wow. You believe in hyperborea too! Do you want my number?", responses = {{text = "100%. What is it?", nextDialog = "51a"}, {text = "Nah, I rather just smash tonight and never see you again.", nextDialog = "51b"}}},
        {id = "51a", npcEmotion = 1, npcText = "Well actually, I don't want anyone seeing me giving you my number. You look awful. Go get a jacket to cover that horrible shirt.", responses = {{text = "-->", nextDialog = "reset"}}, checkPoint = 1}, --CHECKPOINT Setter for 1
        {id = "51b", npcEmotion = 2, npcText = "And just like that, you fucked yourself.", responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "49b", npcEmotion = 4, npcText = "Woah. Calm down. Lets slow down. I'm Layla.", responses = {{text = "Pretty name for a pretty girl.", nextDialog = "8a"}, {text = "Yeah, I don't need your name, I just need your number. ", nextDialog = "8b"}}},
        {id = "52a", npcEmotion = 3, npcText = "You talk a big game but you look like ass.", responses = {{text = "At least I don't smell like ass.", nextDialog = "53a"}, {text = "I'll have you know I'm a hit with the ladies. I have loads of gal pals.", nextDialog = "36a"}}},
        {id = "53a", npcEmotion = 1, npcText = "I mean, I guess. Thats like, the bare minimum.", responses = {{text = "-->", nextDialog = "reset"}}},
        -- post checkpoint 1
        {id = "1c1", npcEmotion = 1, npcText = "Wow, you look so much better. You almost look cool.....", responses = {{text = "So.... about the number?", nextDialog = "1c2a"}, {text = "You want to head back to my place now?", nextDialog = "1c2b"}}},
        {id = "1c2a", npcEmotion = 4, npcText = "Here! Give me a call sometime. I think I've had enough clubbing for one night.", responses = {{text = "-->", nextDialog = "success"}}},
        {id = "1c2b", npcEmotion = 3, npcText = "You're pushing your luck. Take my number and go before I change my mind.", responses = {{text = "-->", nextDialog = "success"}}},
        -- post checkpoint 2
        {id = "1d", npcEmotion = 4, npcText = "Text me sometime soon!", responses = {{text = "-->", nextDialog = "success"}}},
    }

    sororityGirlTree = {
        {id = "1p", npcText = "Go get another girl's number, then I'll talk to you.", npcEmotion = 2, responses = {{text = "-->", nextDialog = "2p"}}},
        {id = "2p", npcText = "*Under her beath* That'll take him all night.", npcEmotion = 2, responses = {{text = "-->", nextDialog = "success"}}},
        --part 1 checkpoint 0
        {id = "1z", npcText = "Ew Get away! Have you even looked in a mirror? Your hair looks awful!", npcEmotion = 4, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 1}, -- CHECKPOINT 1
        {id = "2z", npcText = "Maybe if you fixed that yee yee ass haircut, you'd get some bitches on your dick.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}}},
        --part 2 post checkpoint 1
        {id = "1", npcText = "Wow, you fixed your hair. You don't look like you're 50 anymore.", npcEmotion = 1, responses = {{text = "That's too bad, I bet you're into older men.", nextDialog = "2"}, {text = "I'm actually 24 and very good looking.", nextDialog = "10"}}}, 
        {id = "2", npcText = "Only if they have a lot of money.", npcEmotion = 1, responses = {{text = "I'm pretty loaded. I can show you a good time.", nextDialog = "3"}, {text = "I've got 10 billion Elon shit coins if that counts.", nextDialog = "8"}}},
        {id = "3", npcText = "Oh yeah?? Why don't you show me and the girls.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "1x"}}},
        {id = "1x", npcText = "*Multiple silhouettes of girls fade in*", npcEmotion = 4, responses = {{text = "I'm more of a minimalist. Less is more, you know.", nextDialog = "4"}, {text = "Bet. *Opens wallet*", nextDialog = "27x"}}},
        {id = "4", npcText = "Less is more? I bet that's what you tell yourself whenever your pants are off.", npcEmotion = 1, responses = {{text = "Maybe I do. Sometimes you've got to let things breath.", nextDialog = "5"}, {text = "Hey, hey. Three inches is average..... Some say maybe even a little big.", nextDialog = "6"}}},
        {id = "5", npcText = "I wish you'd breath less around me. You're ugly face is scaring my sisters. Go stick a bag on your head.", npcEmotion = 3, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 2}, -- CHECKPOINT 2
        {id = "6", npcText = "Not for me. Bye.", npcEmotion = 3, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "7", npcText = "Sounds great!", npcEmotion = 1, responses = {{text = "-->", nextDialog = "7e"}}},
        {id = "7e", npcText = "*she takes your $10 and gives it to her friend to make a run to the bar.*", npcEmotion = 1, responses = {{text = "-->", nextDialog = "7f"}}},
        {id = "7f", npcText = "Go touch grass.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "8", npcText = "And how much is that worth?", npcEmotion = 1, responses = {{text = "About 4,424,297.84 Zimbabwe dollars.", nextDialog = "9"}, {text = "It could get you like 3 or 4 drinks at the bar.", nextDialog = "9"}}},
        {id = "9", npcText = "How about you take all that money a get some sunglasses to hide that ugly face.", npcEmotion = 3, responses = {{text = "-->", nextDialog = "success"}},checkPoint = 2}, -- CHECKPOINT 2
        {id = "10", npcText = "Ha you look waaaaay older. Just not quite 50. A solid 45.  Why are you even talking to me? I'm trying to hang out with my sisters.", npcEmotion = 1, responses = {{text = "I knew you were in a sorority. You look like every other bitch here.", nextDialog = "11"}, {text = "What sorority are you in?", nextDialog = "12"}}},
        {id = "11", npcText = "*multiple girls walk over with only slight variations of their appearance*", npcEmotion = 2, responses = {{text = "-->", nextDialog = "28"}}},
        {id = "12", npcText = "Take a guess!", npcEmotion = 1, responses = {{text = "Tau Iota Tau?", nextDialog = "13"}, {text = "Delta Iota Kappa?", nextDialog = "14"}, {text = "Sigma Beta?", nextDialog = "22"}}},
        {id = "13", npcText = "They're huge but no. We're smaller.", npcEmotion = 1, responses = {{text = "I give up. They seem all the same", nextDialog = "15"}, {text = "You've got me stumped. Which one?", nextDialog = "17"}}},
        {id = "14", npcText = "No, but I really love that one.", npcEmotion = 1, responses = {{text = "I give up. They seem all the same", nextDialog = "15"}, {text = "You've got me stumped. Which one?", nextDialog = "17"}}},
        {id = "15", npcText = "That's not true at all. We pay good money to have these friends.", npcEmotion = 1, responses = {{text = "Yeah.... So you just pay for friends and that's it?", nextDialog = "16"}}},
        {id = "16", npcText = "*starts lightly sweating* Well uh.... no... We do charity too.", npcEmotion = 3, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "17", npcText = "Sigma Beta! The sorority with the hottest girls and the wealthiest dads.", npcEmotion = 1, responses = {{text = "I'm more interested in the dads now.", nextDialog = "18"}, {text = "You guys are super hot. Give me your number and I can come to a function.", nextDialog = "19"}}},
        {id = "18", npcText = "What the fuck. Get out of here. ", npcEmotion = 2, responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "19", npcText = "Ewww no. I wouldn't be caught dead giving my number to someone with that face.", npcEmotion = 3, responses = {{text = "Hypothetically, if I were to fix it, would you give me your number?", nextDialog = "20"}, {text = "Oof. Its not like I can fix my face.", nextDialog = "21"}}, checkPoint = 2}, --CHECKPOINT 2
        {id = "20", npcText = "With a body like that,? No way. You're way too fat. ", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}}},
        {id = "21", npcText = "True, but not my problem. Bye!", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}}},
        {id = "22", npcText = "Wow yes! I'm surprised you got it! You're not half bad. If you had some sunglasses to cover that face I might give you my number.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "30"}}},
        {id = "23", npcText = "*Multiple girls come into sight with only slight variations of their appearance*", npcEmotion = 1, responses = {{text = "-->", nextDialog = "24"}}},
        {id = "24", npcText = "We all look nothing alike. *they say in unison. *", npcEmotion = 1, responses = {{text = "-->", nextDialog = "25"}}},
        {id = "25", npcText = "Get out of here. You're scaring away the good looking guys!", npcEmotion = 1, responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "27x", npcText = "*You open your wallet and a small moth flies out. You see you have a single 10 dollar bill*", npcEmotion = 1, responses = {{text = "-->", nextDialog = "27"}}},
        {id = "27", npcText = "Heh............. Do one of you want a shot?", npcEmotion = 1, responses = {{text = "-->", nextDialog = "7"}}},
        {id = "28", npcText = "We all look nothing alike. *They say in unison.*", npcEmotion = 1, responses = {{text = "-->", nextDialog = "29"}}},
        {id = "29", npcText = "Get out of here. You're Scaring away the good looking guys!", npcEmotion = 2, responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "30", npcText = "Sigma Beta see ya later!", npcEmotion = 4, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 2}, --CHECKPOINT 2
            --part 3 post checkpoint 2
        {id = "1a", npcText = "Wait..... Its you? You look different....", npcEmotion = 3, responses = {{text = "-->", nextDialog = "2a"}}},
        {id = "2a", npcText = "You don't look half bad but if you want to date a Sigma Beta you need to be hot.", npcEmotion = 1, responses = {{text = "I many not be hot but I know I look cool.", nextDialog = "3a"}}},
        {id = "3a", npcText = "Ha, you do look a little cool. You're not making me viscerally sick anymore.", npcEmotion = 1, responses = {{text = "We're moving in the right direction. What are you studying?", nextDialog = "4a"}, {text = "Want to see something viscerally sick?", nextDialog = "34a"}}},
        {id = "4a", npcText = "I'm studying communications and gender studies.", npcEmotion = 1, responses = {{text = "Ok, I'll have a large iced coffee with oat milk.", nextDialog = "5a"}, {text = "Oh really? How about we get out of here and study our chemistry?", nextDialog = "13a"}}},
        {id = "5a", npcText = "Haha. I honestly wasn't expecting that. I actually work at a radio station as a host.", npcEmotion = 1, responses = {{text = "Radio? You're way too pretty. Why not TV?", nextDialog = "6a"}, {text = "That's actually really cool? What do you talk about?", nextDialog = "9a"}}},
        {id = "6a", npcText = "Thank you, but its not for me. I love music too much. ", npcEmotion = 1, responses = {{text = "You know, you really do seem different from all the rest of these girls.", nextDialog = "7a"}, {text = "I think music kind of sucks. I'm more of a interpretive dance kind of guy.", nextDialog = "10a"}}},
        {id = "7a", npcText = "I hate the trope that we're all the same. Sure, we all have the same hair, clothes, and physical features but we all have unique personalities. ", npcEmotion = 1, responses = {{text = "I'd like to get to know your personality a bit more. Can I get your number?", nextDialog = "8a"}}},
        {id = "8a", npcText = "You know.... I would but, you're just too fat. Maybe loose some weight and find me again.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}},checkPoint = 3}, --CHECKPOINT 3
        {id = "9a", npcText = "I run a show and play new age jazz. Most of the sisters don't get it. They even tease me for not liking pop music. It doesn't bother me though.", npcEmotion = 1, responses = {{text = "You know, you really do seem different from all the rest of these girls.", nextDialog = "7a"}, {text = "I think music kind of sucks. I'm more of a interpretive dance kind of guy.", nextDialog = "10a"}}},
        {id = "10a", npcText = "Ok Squidward. With a body like that, I can't see you doing interpretative dance. How much do you weigh? ", npcEmotion = 1, responses = {{text = "Listen, that doesn't matter. Just let me hit and I'll be on my way. ", nextDialog = "11a"}, {text = "Like 280 pounds, but most of it's muscle. ", nextDialog = "12a"}}},
        {id = "11a", npcText = "Ew! What the fuck. I almost liked you for a second.", npcEmotion = 2, responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "12a", npcText = "Yeah right. I can believe the 280 but you're at least 40% body fat. Get out of here, you're embarrassing me.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}},checkPoint = 3}, --CHECKPOINT 3
        {id = "13a", npcText = "Ugg bit of a cliche. Do you really think I've never heard that one?", npcEmotion = 1, responses = {{text = "-->", nextDialog = "2a"}}},
        {id = "14a", npcText = "Ummmmm...... What the fuck was that?", npcEmotion = 3, responses = {{text = "A Nollie Backside kickflip. What else could it be? ", nextDialog = "15a"}, {text = "Yikes. Risky play, forget about that.", nextDialog = "20a"}}},
        {id = "15a", npcText = "Damn, I thought it was a backside heelflip. I didn't know you skate. ", npcEmotion = 1, responses = {{text = "Yeah, I'm a bit of a flat ground demon. Don't let my weight fool you.", nextDialog = "16a"}, {text = "I actually don't. I'm literally a poser.", nextDialog = "19a"}}},
        {id = "16a", npcText = "You are on the bigger side for a skater. But I do love a guy with some moves.", npcEmotion = 1, responses = {{text = "Oh really? Give me your number and maybe I can show you some other kinds of moves. If you know what I mean.", nextDialog = "17a"}, {text = "Love? How formal. I humbly request your phone number.", nextDialog = "18a"}}},
        {id = "17a", npcText = "Normally that wouldn't work on me but you're cool. Unfortunately, I can't be seen with you in front of my sisters. If you were fit, that would be a whole nother story.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}},checkPoint = 3}, --CHECKPOINT 3
        {id = "18a", npcText = "Ok, you just ruined the vibe. See ya later boy.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "19a", npcText = "That's cringe as fuck. Get out of here.", npcEmotion = 2, responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "20a", npcText = "You're kind of a weirdo but in a good way. Like, you're interesting but slightly annoying.", npcEmotion = 1, responses = {{text = "Annoying? Do you see these sunglasses? Do you see this jacket? Does Annoying really matter?", nextDialog = "21a"}, {text = "My mom always told me I was slightly annoying.", nextDialog = "26a"}}},
        {id = "21a", npcText = "Yeah, I see them. It's all not enough to make up for all your other........ issues.", npcEmotion = 1, responses = {{text = "Issues? I've overcome so much. *starts crying*", nextDialog = "22a"}, {text = "Issues? What am I, a magazine? I'm perfect.", nextDialog = "23a"}}},
        {id = "22a", npcText = "Crying in the club, great idea. That's how you get loads of girls' numbers.", npcEmotion = 3, responses = {{text = "-->", nextDialog = "failure"}}},
        {id = "23a", npcText = "Says the guy who was balding just a few minutes ago.", npcEmotion = 1, responses = {{text = 'Yeah, but look at my hair now. What "issues" could I possibly have?', nextDialog = "24a"}, {text = "Woah, you're not supposed to remember that.", nextDialog = "25a"}}},
        {id = "24a", npcText = "I'm sorry but you're chopped as hell. Loose like 80 pounds and then you can talk to me.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 3}, --CHECKPOINT 3
        {id = "25a", npcText = "Why not? Because its convenient for the plot?", npcEmotion = 1, responses = {{text = ".............................", nextDialog = "2a"}}},
        {id = "26a", npcText = "Haha. My mom too, in a loving way.", npcEmotion = 1, responses = {{text = "I was always the problem child but it was because I wanted to stand out, make a memorable moment.", nextDialog = "27a"}, {text = "I'm just joking, both my parents died when I was 5.", nextDialog = "32a"}}},
        {id = "27a", npcText = "I know exactly how you feel, getting carried away and getting in trouble.", npcEmotion = 1, responses = {{text = "Yeah, sometimes I go too far. That's why I have a few restraining orders against me.", nextDialog = "28a"}, {text = "You strike me as the type of girl who can get a little naughty.", nextDialog = "29a"}}},
        {id = "28a", npcText = "Hey, you made some memories right? Just not good ones.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "35a"}}},
        {id = "29a", npcText = "Yeah? Maybe, but probably not with you.", npcEmotion = 1, responses = {{text = "But not with me? Where's my hug at? ", nextDialog = "30a"}, {text = "Probably not?? That's not a definite no.", nextDialog = "31a"}}},
        {id = "30a", npcText = "You're one of those guys? You've almost given me the ick. ", npcEmotion = 3, responses = {{text = "-->", nextDialog = "2a"}}},
        {id = "31a", npcText = "You're right about that but you just too fat. Like, its not even a dad bod. You're just obese.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "36a"}}},
        {id = "32a", npcText = "Oh.... way to kill the vibe. Sorry to hear that though....Pity wont get you my number.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "2a"}}},
        {id = "34a", npcText = "*Does a nollie backside kickflip on an imaginary skateboard *", npcEmotion = 1, responses = {{text = "-->", nextDialog = "14a"}}},
        {id = "35a", npcText = "I do like a bad boy though.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "2a"}}},
        {id = "36a", npcText = "Honestly, if you were jacked, it would be a different story.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 3}, --CHECKPOINT 3
            --part 4 post checkpoint 3
        {id = "1b", npcText = "Wow, have you hit the gym? You're actually pretty hot now.", npcEmotion = 4, responses = {{text = "A hot guy for a hot girl. Can I get that number now?", nextDialog = "2b"}}},
        {id = "2b", npcText = "Definitely! I need to take you to some functions! The sisters are going to be so jealous!", npcEmotion = 4, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 4}, -- CHECKPOINT 4
            -- part 5 post checkpoint 4
        {id = "1c", npcText = "Call me tomorrow! I have a function coming up!", npcEmotion = 4, responses = {{text = "-->", nextDialog = "success"}}}
    }

    influencerGirlTree = {
        {id = "1", npcText = "Um, EWWWW. Do you even know who I am?? I'm Starchild Queen of this city. I'm livestreaming right now.", npcEmotion = 2, responses = {{text = "-->", nextDialog = "2"}}}, -- No items
        {id = "2", npcText = "OMG chat! Look at this dork's shoes hahahaha. ", npcEmotion = 2, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 1}, -- Checkpoint 1
        {id = "3", npcText = "You're back, and you got rid of those terrible shoes? How did you get in the VIP section anyway? You look like a clown in those shorts.", npcEmotion = 3, responses = {{text = "-->", nextDialog = "4"}}}, -- Item 1
        {id = "4", npcText = "Julio, kick this loser out of here", npcEmotion = 2, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 2}, -- Checkpoint 2
        {id = "5", npcText = "GRRRR. I thought it was clear last time that I wanted you out. ", npcEmotion = 3, responses = {{text = "-->", nextDialog = "6"}}}, -- Item 2
        {id = "6", npcText = "Do I need to call Julio again??", npcEmotion = 2, responses = {{text = "No need. How do you like the pants??", nextDialog = "7"}}},
        {id = "7", npcText = "I don't give a fuck. Get out. The VIP section is for famous and hot people, like me.", npcEmotion = 3, responses = {{text = "-->", nextDialog = "8"}}}, 
        {id = "8", npcText = "I have 10 million followers and I don't even know who you are.", npcEmotion = 3, responses = {{text = "-->", nextDialog = "9"}}},
        {id = "9", npcText = "On top of all that, you have the worst jawline I'VE EVER SEEN!!!!", npcEmotion = 3, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 3}, -- CHECKPOINT 3
        {id = "10", npcText = "Hello handso............", npcEmotion = 1, responses = {{text = "-->", nextDialog = "11"}}},-- Item 3
        {id = "11", npcText = "It's you???", npcEmotion = 1, responses = {{text = "-->", nextDialog = "12"}}},
        {id = "12", npcText = "What the fuck happened to your face???? You look.... Hot!", npcEmotion = 1, responses = {{text = "I'm a looks maxer now baby. I'm hotter than everyone in here..... Even you.", nextDialog = "13"}}},
        {id = "13", npcText = "NO! I... I can't be outdone by a... a nobody.", npcEmotion = 3, responses = {{text = "-->", nextDialog = "14"}}},
        {id = "14", npcText = "You're so hot though.....", npcEmotion = 1, responses = {{text = "-->", nextDialog = "15"}}},
        {id = "15", npcText = "Must... Resist!", npcEmotion = 3, responses = {{text = "I've got too much Rizz for you to handle. Give me your number, you know you want to.", nextDialog = "16"}}},
        {id = "16", npcText = "No!!!!!", npcEmotion = 3, responses = {{text = "-->", nextDialog = "17"}}},
        {id = "17", npcText = "Never!!!!!!!!!!!!", npcEmotion = 3, responses = {{text = "-->", nextDialog = "18"}}},
        {id = "18", npcText = "HYYYAAAAAAAAAAAAAAA!!!!!!!!!!!!", npcEmotion = 3, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 4},
            -- part 2 post checkpoint 4 -- LAST OF THE GAME
        {id = "1a", npcText = "I can't believe it. You're...you're too...", npcEmotion = 1, responses = {{text = "-->", nextDialog = "2a"}}, checkPoint = 5},
        {id = "2a", npcText = "Slick", npcEmotion = 4, responses = {{text = "I did all of this for you.", nextDialog = "3a"}}, checkPoint = 5},
        {id = "3a", npcText = "You did?", npcEmotion = 4, responses = {{text = "This whole night was about getting your number while I had a chance.", nextDialog = "4a"}}, checkPoint = 5},
        {id = "4a", npcText = "You know, I love a man who takes action.", npcEmotion = 4, responses = {{text = "-->", nextDialog = "5a"}}, checkPoint = 5},
        {id = "5a", npcText = "Here take my number!! I'd love to go on a date sometime!", npcEmotion = 4, responses = {{text = "-->", nextDialog = "6a"}}, checkPoint = 5},
        {id = "6a", npcText = "I'd love to go out with someone. I can't look up everything about them online!", npcEmotion = 4, responses = {{text = "-->", nextDialog = "7a"}}, checkPoint = 5},
        {id = "7a", npcText = "I'm so EXCITED!!!!!", npcEmotion = 4, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 5},
    }   
    
    jacketGuyTree = {
        {id = "1", npcText = "You like the jacket bro? It's genuine Armadillo leather.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "2", npcText = "Chicks dig a guy in a bomber jacket.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "3", npcText = "Not going to lie, its getting a little hot in here", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "4", npcText = "Hey loser, your shirt looks like a piece of crap.", npcEmotion = 1, responses = {{text = "*you reach out and rip the jacket off his back*", nextDialog = "5"}}},
        {id = "5", npcText = "Erm..... I guess you can have it. You're probably more happy to have it than I am to lose it.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 2}, -- Checkpoint 2
    }     
    hairGuyTree = {
        {id = "1", npcText = "Where are all the little mamas at?", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "2", npcText = "*You like the hair? Its thick, just how I like my women.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "3", npcText = "No smoking, fire hazard over here.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "4", npcText = "As a man with great hair I have a duty to help a brother in need.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "5"}}},
        {id = "5", npcText = "Take this finasteride. It'll turn your norwood 7 into a hollywood 10.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 2}, -- Checkpoint 2
        {id = "6", npcText = "Nice locks my man.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
    }     
    shadesGuyTree = {
        {id = "1", npcText = "Want to buy some deathsticks?", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "2", npcText = "Beat it kid. You're scarring the huzz.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "3", npcText = "There are two wolves inside all of us.", npcEmotion = 1, responses = {{text = "One is gay.", nextDialog = "reset"}, {text = "And the other is also gay.", nextDialog = "reset"}}},
        {id = "4", npcText = "If you're trying to get some girls tonight I suggest you put on some shades.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "5"}}},
        {id = "5", npcText = "Here, I have a spare pair. Girls love a dude with some mystery.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 2}, -- Checkpoint 2
        {id = "6", npcText = "It may be hard to see, but you'll look cool if you trip.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
    }
    absGuyTree = {
        {id = "1", npcText = "Clear liquor only, I'm cutting right now.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "2", npcText = "I heard if you bring 10 girls in, you get free drinks all night.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "3", npcText = "I started body building for the ladies but I just end up staring at other dudes all day.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "4", npcText = "What do you weigh, like 300 pounds? You need to hit the gym. Take this Miniature Broflex and start pumping iron right now.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 2}, -- Checkpoint 2    
        {id = "5", npcText = "Damn dude, the cut went crazy. Like the physique.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
    }
    shoesGirlTree = {
        {id = "1", npcText = "This song is fucking bop.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "2", npcText = "Do you like my outfit?? My shoes even match.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "3", npcText = "I'm surprised they let me in here.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "4", npcText = "You look like you need a shoe game upgrade. Take these, it would totally go with your outfit", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 2}, -- Checkpoint 2
        {id = "5", npcText = "You look halfway decent now. Maybe some girls will pay attention to you now.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
    }
    shortsGuyTree = {
        {id = "1", npcText = "Not yet... Not yet.... *is pissing self*", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "2", npcText = "Have you seen that goth baddie in the corner? I wish I could talk to her.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "3", npcText = "Did you know piss is stored in the balls?", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "4", npcText = "Bro, did you shit your shorts??? They look fucking awful. Take these pants and get away from me.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 2}, -- Checkpoint 2
        {id = "5", npcText = "At least you don't smell like ass anymore....", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
    }
    mewGuyTree = {
        {id = "1", npcText = "You don't get this beautiful by having a door slammed in your face", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "2", npcText = "Hmmm.... You have the most negative canthal tilt I've ever seen.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "3", npcText = "Sorry, no time to chat. I'm jaw sculpting right now.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "4", npcText = "Maybe I should try bone smashing....", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
        {id = "5", npcText = "Wow you're a sorry sight. I sensed you failed to rizz up that girl in the VIP section. I feel kinda bad.....", npcEmotion = 1, responses = {{text = "-->", nextDialog = "6"}}},
        {id = "6", npcText = "For you right now. I'm mogging you that hard.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "7"}}},
        {id = "7", npcText = "Here take this. Its the looksmaxer's holy book, The Book Of Mew.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "8"}}},
        {id = "8", npcText = "Read it and you too will learn the way of the chad. *mews harder than you thought possible. *", npcEmotion = 1, responses = {{text = "-->", nextDialog = "success"}}, checkPoint = 2}, -- Checkpoint 2
        {id = "9", npcText = "Looking good. I bet the ladies are all over you now.", npcEmotion = 1, responses = {{text = "-->", nextDialog = "10"}}},
        {id = "10", npcText = "Look at us, just a couple of chads on a night out. ", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
    }
    jacketGuyNOJacketTree = {
        {id = "1", npcText = "N-n-nice jacket dude....", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}},
    }
    biggieFrogTree = {
        {id = "1", npcText = "Look... I didn't do it!  I don't even know how to drive!", npcEmotion = 1, responses = {{text = "-->", nextDialog = "reset"}}}
    }
end
