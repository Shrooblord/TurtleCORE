--      [[    GREAT A'TUIN:   THE PROGENITOR OF ALL TURTLE KIND   ]]      --
--                                  v2                                    --
--........................................................................--

versionNo = 2;

--[[        FUNCTION    DEFINITIONS     ]]--

function burnInventory()
    for i = 1, 16 do -- loop through the slots
        turtle.select(i); -- change to the slot
        if turtle.refuel(0) then -- if it's valid fuel
            local halfStack = math.ceil(turtle.getItemCount(i)/2); -- work out half of the amount of fuel in the slot
            turtle.refuel(halfStack); -- consume half the stack as fuel
            print("OM NOM NOM NOM NOM");
        end
    end
    print("Fuel level now at "..tostring(turtle.getFuelLevel()));
end

function spiralMove(direction, z, mine, locate)
   local n, z, mine = 1, z or 3, mine or false;

    for i=1, z, 1 do
        for i=1, 2, 1 do
            for i=1, n, 1 do  --n, z-1, z
                moveAPI.go{direction="forward", throughBlocks=mine, findBlock=locate};
                if mine then moveAPI.digRound() end
            end
            if direction == "right" then
                turtle.turnRight();
            else
                turtle.turnLeft();
            end
        end
        n = n+1        
    end

    for i=1, z, 1 do  --the final 
        moveAPI.go{direction="forward", throughBlocks=mine, findBlock=locate};
        if mine then moveAPI.digRound() end
    end
    if direction == "right" then
        turtle.turnRight();
    else
        turtle.turnLeft();
    end
end

--[[....................................]]--

--[[          INITIALISATION            ]]--


print("I AM AWAKENED.");

if not os.loadAPI("/moveAPI") then error("moveAPI failed to load!") end
if not os.loadAPI("/textAPI") then error("textAPI failed to load!") end



--[[....................................]]--

--                   [[PHASE 1: Humble Beginnings]]                       --


--  At this point, we have no fuel. We are desperate. We must find fuel.
--  Also, we haven't actually started constructing our Turtle society yet,
--  so there are no sacred/critical blocks we have to watch out for not
--  to destroy: martial law, go nuts and mine everything for fuel!!



--                        [[    PREREQUISITS    ]]                        --
--  Unfortunately, the Great A'Tuin is not yet so Great that he can spawn
--  himself from nothing, and can move about on fuel conjured from
--  non-existence.
--  He requires the player to set him up with a couple of things still...
--    [Category]        [Item]        [Count]
--    # Body:     * Advanced Turtle     (1)
--    # Items:    * Diamond Pick        (1)
--                * Coal                (3)

--........................................................................--

--Ok so what is the first thing we need? Fuel. So let's burn that little chunk of coal.
burnInventory();

--[[     MINING APPROACH     ]]--

--local moveResult = moveAPI.go{direction="down", amount=15, throughBlocks=true, findBlock="minecraft:coal_ore"};
--if moveResult == "blockFound" then
--    burnInventory();
--end

--.....[[    SPIRAL MINE    ]].....--

--This basically makes a 3-level figure-eight strip, taking only 2*(z+1)^2+3 steps to completely mine an area of 8*(z+1)^2 eg. 35 steps to mine 144 blocks (z=3). Pretty good huh? ;)
--[[
spiralMove("right", 10, true, "minecraft:coal_ore");
moveAPI.go{direction="down", amount=3, throughBlocks=true, findBlock="minecraft:coal_ore"};
spiralMove("left", 10, true, "minecraft:coal_ore");
]]--

--[[        PLAYER-LIKE APPROACH        ]]--
--The concept here is that we mimic a player's start of game: punch tree, get wood, make bench, make furnace, smelt wood, make fuel ---> git gud
--Perhaps this will prove more fruitful, although we'd have to be smart about detecting/testing whether the Biome we're in has enough trees to
--be worth looking for them, or whether we quickly should head underground to try and recuperate our losses, without staying invested in the surface for too long.

--Run around, occasionally spiralling out to search.
while true do
    local foundIt = nil;
    foundIt = moveAPI.go{direction="forward", followLandscape=true, findBlock="minecraft:log"};
    if foundIt == "blockFound" then
        break
    end
end


--........................................................................--
--                    [[PHASE 2: I Need a Friend]]                        --

--  Everyone gets lonely when isolated. The Great A'Tuin is no exception.
--  turtle.inspect() is your friend to determine what blocks are, and if
--  they are suitable for building another Turtle with

--........................................................................--




--........................................................................--
--                     [[PHASE 3: Trusty Steed]]                          --

--  The need for fuel will be less if we have a craft to operate...!
--  Huzzah!

--........................................................................--



--[[            TERMINATION             ]]--

os.unloadAPI("/textAPI");
os.unloadAPI("/moveAPI");

--[[....................................]]--