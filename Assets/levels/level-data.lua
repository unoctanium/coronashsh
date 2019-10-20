----------------------------------------
-- LEVEL DATA
----------------------------------------
-- number = 1 -- number of level
-- name = "" -- name of level
-- bonusTime = 0 -- time to complete shake with bonus
-- bonus = 0 -- bonus received when completed within bonusTime
-- shakingsNeeded = 0 -- number of shaling moves needed to complete level

-- paint = nil -- level Background . See https://docs.coronalabs.com/api/type/ShapeObject/fill.html
--      Solid:  
--          paint = { 1, 0, 0.5 }  
--      Gradient: 
--          paint = {
--              type = "gradient",
--              color1 = { 1, 0, 0.4 },
--              color2 = { 1, 0, 0, 0.2 },
--              direction = "down"
--          }
--      Bitmap image: 
--          paint = {
--              type = "image",
--              filename = "texture1.png"
--          }
--      Composite: 
--          paint = {
--              type = "composite",
--              paint1 = { type="image", filename="wood.png" },
--              paint2 = { type="image", filename="dust.png" }
--          }
--          effect = "composite.average"
-- effect = nil -- Fill effect or shader  
-- shakerImage = nil -- level Shaker Image
-- shakerOutline = "" -- index name of outline of shaler in Assets.objects.shapedefs

-- particleSystem : {} 
-- particleSystem.filename = nil -- Filename of Mix 1 Texture, i.e. "Assets/textures/particle-liquid-1.png",
-- particleSystem.colorMixingStrength = 0.01 -- ,ixing strength of liquidFun. min is 0.01
-- particleSystem.radius = 4, -- Radius of physical body of liquid pqarticle
-- particleSystem.imageRadius = 5, -- Radius of image representation of liquid particle
-- particleSystem.gravityScale = 1, sclae of gravity for particles

-- particleGroup1/2 : {}
-- particleGroup.flags = "": "water" | "tensile". "colorMixing" will be added automaticlly"
-- particleGroup.dx = 0: X Offset of Liquid from Bowl X,Y
-- particleGroup.dy = 0: Y Offset of Liquid from Bowl X,Y
-- particleGroup.color = {0,0,0,0}: Color of Liquid
-- particleGroup.halfWidth = 0: half width of mix Group 
-- particleGroup.halfHeight = 0: half height of Mix Group


local leveldata = {
    { 
        number = 1,
        name = "Level 1",
        bonusTime = 20,
        bonus = 0,
        shakingsNeeded = 30,
        paint = { 192/255,222/255,21/255,1 },
        effect = nil,
        shakerImage = "Assets/objects/shaker-1.png",
        shakerOutline = "shaker-1-outline",
        particleSystem = {
            filename = "Assets/particle-liquid-1.png",
            colorMixingStrength = 0.01,
            radius = 4,--3, 
            imageRadius = 5,--4, 
            gravityScale = 1.0,
            strictContactCheck = true
        },
        particleGroup1 = {
            flags = "tensile",
            dx = 35,
            dy = 30,
            color = { 0.9, 0.2, 0.2, 1},
            halfWidth = 35,
            halfHeight = 110
        },
        particleGroup2 = {
            flags = "tensile",
            dx = -35,
            dy = 30,
            color = { 0.2, 0.3, 0.9, 1},
            halfWidth = 35,
            halfHeight = 110
        }
    },
}


return leveldata