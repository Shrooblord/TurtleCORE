--[[MOVEMENT API VERSION 10 - 07/08/2017 - 22/12/2017]]--
--This general-purpose movement API should provide some common functionality used by all of turtle kind, such as
--investigating surroundings for possible movement options, moving when isolated from peers and the network,
--and in general moving about in the world.
--........................................................................--

versionNo = 10;

--This is diggy diggy hole stuff
function digRound()
    local dU, dD, dF, dL, dB, dR = false, false, false, false, false, false
    if turtle.detectUp() then
        dU = turtle.digUp();
    end
    
    if turtle.detectDown() then
        dD = turtle.digDown();
    end
    
    if turtle.detect() then
        dF = turtle.dig();
    end
    
    turtle.turnLeft();  --left
    if turtle.detect() then
        dL = turtle.dig();
    end
    
    turtle.turnLeft();  --behind
    if turtle.detect() then
        dB = turtle.dig();
    end
    
    turtle.turnLeft();  --right
    if turtle.detect() then
        dR = turtle.dig();
    end
    
    turtle.turnLeft();  --reset orientation
    
    return dU, dD, dF, dL, dB, dR
end

function tryMoveDownCliff(firstDir, countL, countR, onlyOnce)  --attempts to find a way around a cliff in front
    local firstDir, countL, countR = firstDir or "left", countL or 0, countR or 0;
    
    if handleDir("down") then
        if handleDir("down") then
            if not turtle.detectDown() then --This is too far; it's a cliff
                handleDir("up");  --reset to top block
                handleDir("up");
                handleDir("back");
                
                if firstDir == "left" then
                
                    turtle.turnLeft();
                    if handleDir("forward") then
                        turtle.turnRight();
                        return tryMoveDownCliff("left", countL+1, countR, true)
                    else
                        turtle.turnRight();
                        turtle.turnRight();
                        handleDir("forward");
                        if handleDir("forward") then
                            turtle.turnLeft();
                            return tryMoveDownCliff("right", countL, countR+1, true)
                        else
                            turtle.turnLeft();
                            error("We seem to be trapped here.");
                        end
                    end
                elseif firstDir == "right" then
                    turtle.turnRight();
                    if handleDir("forward") then
                        turtle.turnLeft();
                        return tryMoveDownCliff("right", countL, countR+1, true)
                    else
                        turtle.turnLeft();
                        turtle.turnLeft();
                        handleDir("forward");
                        if handleDir("forward") then
                            turtle.turnRight();
                            return tryMoveDownCliff("left", countL+1, countR, true)
                        else
                            turtle.turnRight();
                            error("We seem to be trapped here.");
                        end
                    end
                else
                    error("moveAPI - tryMoveDownCliff(): firstDir: somehow this got sent a wrong argument: "..tostring(firstDir));
                end
            else
                print("gonna return tMDC2");
                return tryMoveDownCliff(firstDir, countL, countR, true) --true, countL-countR, countR-countL
            end
        else
            print("gonna return tMDC1");
            return tryMoveDownCliff(firstDir, countL, countR, true) --true, countL-countR, countR-countL
        end
    else
        local endOfCliff, cL, cR = false, 0, 0;  --Is that the end of the cliff? Or is there more to it?
        if onlyOnce then
            --if handleDir("forward") then
                --print("forward??");
                endOfCliff, cL, cR = tryMoveDownCliff(firstDir, countL, countR);
                print("countL: "..tostring(countL).."; countR: "..tostring(countR).."; cL: "..tostring(cL).."; cR: "..tostring(cR));
                countL = countL + cL;
                countR = countR + cR;
                if endOfCliff then
                    return true, countL, countR
                else
                    error("what??");
                end
            --else
            --    error("help!");
            --end
        end
        return true, countL, countR
    end
end

function tryMoveAroundObstacle(direction)
    local devL, devR = 0, 0;
    
    if direction == "forward" then
    --So something's in the way. Can we move over it? Try up to two blocks high - if it's any higher than that, we'll have to find another way around.
    --Remember, we want to move forwards eventually.
        if handleDir("up") then
            if handleDir("forward") then
                return true --It worked!                    
            elseif handleDir("up") then
                if handleDir("forward") then
                    return true  --It worked!
                else
                    --Better try something else
                    handleDir("down");
                    handleDir("down");
                    turtle.turnLeft();
                    if handleDir("forward") then
                        devL = devL + 1;
                        turtle.turnRight();
                        if handleDir("forward") then
                            return true, devL, devR  --that worked! but now we've deviated slightly off-course
                        end
                    else
                        turtle.turnRight();
                        turtle.turnRight();
                        handleDir("forward");
                        if handleDir("forward") then
                            devR = devR + 1;
                            turtle.turnLeft();
                            if handleDir("forward") then
                                return true, devL, devR  --that worked! but now we've deviated slightly off-course
                            end
                        else
                            error(":(");
                        end
                    end
                end
            end
        end  
    elseif direction == "back" then
    elseif direction == "up" then
    elseif direction == "down" then
    else
        error("moveAPI - tryMoveAround(): direction: somehow this got sent a wrong argument: "..tostring(direction));
    end
end

--This handles trying to move and moving into blocks correctly; normally, turtles would freeze up doing this, but this solves that issue
function tryMove(direction)
    
    --This works because even just a frame delay is enough for the code to evaluate a single attempt at moving immediately;
    --if it worked, it worked; if it didn't, we immediately know, and will definitely already know by the time the next frame hits
    --It basically allows for a "timeout" timer that doesn't delay code execution for more than a single frame. How cool is that!
    --Why this strange frame delay construction? Because turtles actually get stuck in a loop when told to move somewhere they can't
    --(i.e. something in the way). So breaking them out of that loop is critical!
    
    local t = os.startTimer(0);
    
    if direction == "forward" then
        if turtle.forward() then
            os.queueEvent("moved");
        end
    elseif direction == "back" then
        if turtle.back() then
            os.queueEvent("moved");
        end
    elseif direction == "up" then
        if turtle.up() then
            os.queueEvent("moved");
        end
    elseif direction == "down" then
        if turtle.down() then
            os.queueEvent("moved");
        end
    else
        error("moveAPI - tryMove(): direction: expected 'forward', 'back', 'up' or 'down', but got "..tostring(direction));
    end
    
    while true do
        local evt, tID = os.pullEvent();
        if evt == "timer" then
            if tID == t then
                print("Move failed; something in the way.");
                break
            end
        elseif evt == "moved" then
            --print("Moved "..direction.." successfully.");
            return true
        end
    end
    return false
end

--This is an abstraction from 4 different movement options down into only one that handles everything itself
function handleDir(direction, force, findBlock, followLandscape)
    if force then
        if type(force) ~= "boolean" then
            error("moveAPI - handleDir(): force: expected boolean, but got "..type(direction));
        end
    elseif findBlock then
        if type(findBlock) ~= "string" then  --This one causes the _go command to abort early if the turtle runs into the block specified
            error("moveAPI - handleDir(): findBlock: expected string but instead got "..type(findBlock));
        end
    elseif followLandscape then
        if type(followLandscape) ~= "boolean" then
            error("moveAPI - handleDir(): followLandscape: expected boolean, but got "..type(followLandscape));
        elseif force then
            error("moveAPI - handleDir(): followLandscape and force are incompatible. Choose one or the other.");
        end
    end
    
    local blockFound = false;
    
    if direction == "forward" then
        local inspected, blockData = turtle.inspect();
        if ((not inspected) or (blockData.name == "minecraft:tallgrass") or (blockData.name == "minecraft:vine")) then
            local mF = tryMove("forward");
            if mF then
                
                if followLandscape then
                    --Let's try to move down, but avoid cliffs (> 2 blocks down)
                    local wentDownCliff, devL, devR = tryMoveDownCliff();
                    if wentDownCliff then
                        if (devL > 0 or devR > 0) then
                            if not handleDir("forward") then
                                error("bleh");
                            end
                        end
                    else
                        return false, "cliff", "could not navigate around cliff"
                    end
                        --But if we deviated some amount from our path, let's get back on our target vector.
                    while (devL ~= 0 or devR ~= 0) do
                        while (devL > 0) do
                            print("dL: "..tostring(devL));
                            turtle.turnRight();
                            if not handleDir("forward") then
                                local moved, dL, dR = tryMoveAroundObstacle("forward");
                                error("devL: "..tostring(devL).."; devR: "..tostring(devR).."; dL: "..tostring(dL).."; dR: "..tostring(dR));
                                devL = devL + dL - dR;  --if we deviated from either side, best keep track of that
                            else
                                tryMoveDownCliff("left");  --left is "forwards" / following our target vector in this case, as seen from our initial starting point
                                devL = devL - 1;
                            end
                            turtle.turnLeft();
                        end

                        while (devR > 0) do
                            print("dR: "..tostring(devR));
                            turtle.turnLeft();
                            if not handleDir("forward") then
                                local moved, dL, dR = tryMoveAroundObstacle("forward");
                                error("devL: "..tostring(devL).."; devR: "..tostring(devR).."; dL: "..tostring(dL).."; dR: "..tostring(dR));
                                devR = devR - dL + dR;  --if we deviated from either side, best keep track of that
                            else
                                tryMoveDownCliff("right");  --left is "forwards" / following our target vector in this case, as seen from our initial starting point
                                devR = devR - 1;
                            end
                            turtle.turnRight();
                        end
                    end
                        
                    return true
                    
                end
                return true
            else
                return false, "unknown", "the space ahead was open but we could not move into it somehow"
            end
        else
            --Something in the way!
            
            
            --Is it the block we were looking for?
            if findBlock then
                if inspected then
                    if blockData.name == findBlock then
                        blockFound = true;
                    else
                        --print("Too bad. We're looking for "..findBlock.." but found "..blockData.name.." in front");  --Let's broadcast this on Rednet so we can track the progress as a player on our pocket computer
                    end
                else
                    return false, "failedInspect", "for some reason, we could not inspect the block in front"  --We want to abort here because we may need to error handle this in the parent function; so let's
                end
            end
            if (force or blockData.name == "minecraft:double_plant") then  --plants are ok to destroy, even in non-force mode
                if turtle.dig() then
                    if tryMove("forward") then
                        if blockFound then
                            return true, "blockFound", "we found our target in front, dug it, and are now in its space"
                        end
                        return true
                    else
                        return false, "unknown", "we dug a block but couldn't move forwards into the space afterwards"
                    end
                else
                    return false, "noDig", "we could not dig this block in front of us (is it bedrock?)"
                end    
            else
                if blockFound then
                    return false, "blockFound", "we found our target in front, but weren't allowed to dig it"
                    
                elseif followLandscape then
                    --So something's in the way. Can we move over it? Try two blocks high - if it's any higher than that, we'll have to find another way around.
                    --Remember, we want to move forwards eventually.
                    tryMoveAroundObstacle(direction);
                    
                else
                    return false, "block", "block ahead but we weren't allowed to dig through"
                end
            end
        end
    elseif direction == "back" then
        
        --This presents an interesting case. Presumably, if we're going backwards, we know the space is clear to go through
        --so let's try "just doing that" first; just go back and see if it works; but because the way turtles work is that they
        --get stuck in an execution loop trying to wait for the move to either confirm or fail, and don't actually do anything else,
        --"simply trying" it might hang execution. To solve it, we do this:
        
        local mB = tryMove("back");
        
        if not mB then
            --Now let's see why we couldn't move backwards.
            turtle.turnLeft();
            turtle.turnLeft();
            if turtle.detect() then  --We could get smarter with this in the future, upgrading it to turtle.inspect to get metadata and block id and all that jazz
                --Block in the way!
                
                --Is it the block we were looking for?
                if findBlock then
                    local inspected, blockData = turtle.inspect();
                    if inspected then
                        if blockData.name == findBlock then
                            blockFound = true;
                        else
                            print("Too bad. We're looking for "..findBlock.." but found "..blockData.name.." behind us");  --Let's broadcast this on Rednet so we can track the progress as a player on our pocket computer
                        end
                    else
                        return false, "failedInspect", "for some reason, we could not inspect the block behind us"  --We want to abort here because we may need to error handle this in the parent function; so let's
                    end
                end
                
                if false then
                elseif force then
                    if turtle.dig() then
                        if not turtle.forward() then
                            --Aaaaa something is seriously wrong at this point
                            turtle.turnLeft();  --It's important to return to the state we started out in.
                            turtle.turnLeft();  --Else, we might obliterate future code iterations that count on the turtle being in a particular state.
                            return false, "unknown", "we dug a block but couldn't move backwards into the space afterwards"
                        end
                    else
                        turtle.turnLeft();  --See above.
                        turtle.turnLeft();
                        return false, "noDig", "we could not dig this block backwards (is it bedrock?)"
                    end
                    turtle.turnLeft();  --See above.
                    turtle.turnLeft();
                    if blockFound then
                        return true, "blockFound", "we found our target behind us, dug it, and are now in its space" 
                    else
                        return true  --We ran into a block, but took care of it, and now we're facing the right way again after moving.
                    end
                else
                    turtle.turnLeft();  --See above.
                    turtle.turnLeft();
                    if blockFound then
                        return false, "blockFound", "we found our target behind us, but weren't allowed to dig it"
                    else
                        return false, "block", "block behind but we weren't allowed to dig through"
                    end
                end
            else
                turtle.Left();  --See above.
                turtle.Left();  --We can try to make this more sophisticated later; you might expect turtle.detect() to fail on liquids, which it does, then incorrectly guessing that    
                return false, "unknown", "couldn't move backwards, but detected no block in the way"  -- we can't move through a space that's empty, but it turns out turtles can wade through lava, so it's all cool. O-o
            end
        end
        --If we got here, we moved backwards successfully!
        return true
        
    elseif direction == "up" then
        
        if not turtle.detectUp() then
            local mU = tryMove("up");
            if mU then
                return true
            else
                return false, "unknown", "the space above was open but we could not move into it somehow"
            end
        else
            --Something in the way!
            --Is it the block we were looking for?
            if findBlock then
                local inspected, blockData = turtle.inspectUp();
                if inspected then
                    if blockData.name == findBlock then
                        blockFound = true;
                    else
                        print("Too bad. We're looking for "..findBlock.." but found "..blockData.name.." above");  --Let's broadcast this on Rednet so we can track the progress as a player on our pocket computer
                    end
                else
                    return false, "failedInspect", "for some reason, we could not inspect the block above"  --We want to abort here because we may need to error handle this in the parent function; so let's
                end
            end
            
            if false then
            elseif force then
                if turtle.digUp() then
                    if tryMove("up") then
                        if blockFound then
                            return true, "blockFound", "we found our target above, dug it, and are now in its space"
                        end
                        return true
                    else
                        return false, "unknown", "we dug a block but couldn't move upwards into the space afterwards"
                    end
                else
                    return false, "noDig", "we could not dig this block above of us (is it bedrock?)"
                end
            else
                if blockFound then
                    return false, "blockFound", "we found our target above, but weren't allowed to dig it"
                else
                    return false, "block", "block above but we weren't allowed to dig through"
                end
            end
        end    
    elseif direction == "down" then
        
        if not turtle.detectDown() then
            local mD = tryMove("down");
            if mD then
                return true
            else
                return false, "unknown", "the space below was open but we could not move into it somehow"
            end
        else
            --Something in the way!
            --Is it the block we were looking for?
            if findBlock then
                local inspected, blockData = turtle.inspectDown();
                if inspected then
                    if blockData.name == findBlock then
                        blockFound = true;
                    else
                        print("Too bad. We're looking for "..findBlock.." but found "..blockData.name.." below");  --Let's broadcast this on Rednet so we can track the progress as a player on our pocket computer
                    end
                else
                    return false, "failedInspect", "for some reason, we could not inspect the block below"  --We want to abort here because we may need to error handle this in the parent function; so let's
                end
            end
            
            if false then
            elseif force then
                if turtle.digDown() then
                    if tryMove("down") then
                        if blockFound then
                            return true, "blockFound", "we found our target below, dug it, and are now in its space"
                        end
                        return true
                    else
                        return false, "unknown", "we dug a block but couldn't move down into the space afterwards"
                    end
                else
                    return false, "noDig", "we could not dig this block below us (is it bedrock?)"
                end
            else
                if blockFound then
                    return false, "blockFound", "we found our target below, but weren't allowed to dig it"
                else
                    return false, "block", "block below but we weren't allowed to dig through"
                end
            end
        end
        
    else
        error("moveAPI - handleDir(): direction: expected 'forward', 'back', 'up' or 'down', but got "..tostring(direction));
    end
end

--This is the primitive go() function, i.e. the "actual" function that drives everything. Below is the more user-friendly alternative that is called in-code.
function _go(direction, amount, throughBlocks, findBlock, followLandscape)
    --Asserting the correct types input as the arguments
    if type(direction) ~= "string" then
        error("moveAPI - _go(): direction: expected string but instead got "..type(direction));
    elseif type(amount) ~= "number" then
        error("moveAPI - _go(): amount: expected number but instead got "..type(amount));
    elseif amount < 1 then
        error("moveAPI - _go(): amount: must be 1 or greater, but got "..tostring(amount));
    elseif type(throughBlocks) ~= "boolean" then  --This basically acts as a force-move override to any obstacles; if the instruction is to go forward 5 and we encounter a wall with this true, go through the wall
        error("moveAPI - _go(): throughBlocks: expected boolean but instead got "..type(throughBlocks));
    elseif findBlock then
        if type(findBlock) ~= "string" then  --This one causes the _go command to abort early if the turtle runs into the block specified
            error("moveAPI - _go(): findBlock: expected string but instead got "..type(findBlock));
        end
    elseif followLandscape then
        if type(followLandscape) ~= "boolean" then  --move up hills, down troughs etc.; basically, always stay one block above ground level (unless it's a cliff; avoid cliffs)
            error("moveAPI - _go(): followLandscape: expected boolean but instead got "..type(followLandscape));
        end
    end
    
    amount = math.floor(amount);  --Just in case some clown tries passing this a float
    
    local maxMoves = turtle.getFuelLevel();
    local blockFound = false;
    
    if amount > maxMoves then  --This functionally also eradicates the error state where we couldn't move because fuel level was too low, so we don't need to error check for that when we try to take a step! bonus!!
        return false, "fuelLow", "ERROR: Fuel too low: "..tostring(maxMoves).." to move "..tostring(amount).." spaces."
    end
    
    for i=1, amount, 1 do
        local moved, msgType, msg = handleDir(direction, throughBlocks, findBlock, followLandscape, followLine);
        if msgType then
            if not moved then
                if msgType == "blockFound" then
                    print(msg);
                    blockFound = true;
                    break
                else
                    --error(msg);
                    return false, msg;
                end
            else
                if msgType == "blockFound" then
                    print(msg);
                    blockFound = true;
                    break
                end
            end
        end
    end
    
    if blockFound then
        return "blockFound"
    end
    
    --  We may want to do some computations here still: how many steps were remaining (amount-i) if we failed moving? Etc.; error handling basically
    
    return "moveCompleted"
end

--This version of the go() function has optional parameters in the way of a single table argument. This makes it so that we not only can specify any of the parameters
--we want at runtime, and none we don't care about, but also that they can be called in any arbitrary order, which is awesome. Plus, you'll see exactly which param does
--what when calling it, simply because it will be called by param.value rather than simply value, requiring you to go find this go() function and read what its params do.
--Call this through moveAPI.go{paramName=value, param2Name=value} - so as if it's a table; in fact, that's exactly what you're passing it, a single table argument.
function go(params)
    --Mandatory
    if type(params.direction) ~= "string" then
        error("moveAPI - go(): direction: expected string but instead got "..type(direction));
    end
    
    --Call the primitive _go with all optional args specified
    return _go(params.direction,
        params.amount or 1,
        params.throughBlocks or false,
        params.findBlock or nil,
        params.followLandscape or false
    );
end