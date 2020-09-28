--      [[    TESTERFRIEND:   THE FRIENDLY NEIGHBOURHOOD TEST BOT   ]]      --
--                                  v1                                    --
--........................................................................--

versionNo = 28;

--[[....................................]]--
 
--[[          INITIALISATION            ]]--
 
if not os.loadAPI("/moveAPI") then error("moveAPI failed to load!") end
if not os.loadAPI("/textAPI") then error("textAPI failed to load!") end

term.clear();
local turtleType = os.getComputerLabel();

--Move out of the Disk bay.
if not turtle.detectDown() then
    turtle.down();
end
 
--[[....................................]]--
 
--[[       FUNCTION DEFINITIONS         ]]-- 

function showError(longError, shortError, sleeptime)
    sleeptime = sleeptime or 2; --default to 2 seconds
    local turtleType = os.getComputerLabel();
    term.setCursorPos(1,1);
    textAPI.writeCol("ERROR: "..longError, "e"); --red
    os.setComputerLabel("§4E: "..shortError);
    os.sleep(sleeptime);
    os.setComputerLabel(turtleType);
    term.setCursorPos(1,1);
    term.write("                                       ");
    term.setCursorPos(1,2);
    term.write("                                       ");
    term.setCursorPos(1,1);
end

function checkRoutine(colour)
    turtle.forward();
    local inspected, blockData = turtle.inspectDown();
    if colour == "red" then
        if inspected then
            term.setCursorPos(1,4);
            --print("Block name: ", blockData.name, "; ", type(blockData.name));
            --print("Block metadata: ", blockData.metadata, "; ", type(blockData.metadata));
            if blockData.name == "minecraft:wool" and blockData.metadata == 14 then --red wool
                return true;
            else
                turtle.back();
                showError("Expected Red Wool but found something else.", "UNKWN BLK");
                return false;
            end
        else
            turtle.back();
            showError("Did not find block beneath.", "NO BLOCK");
            return false;
        end
    else
        turtle.back();
        showError("Could not find routine. What do?", "NO TYPE");
        return false;
    end
    showError("Execution isn't supposed to reach here. :(", "BAD CODE");
    return false;
end
 
function attemptMove(dir, errTime, moveAmount)
    moveAmount = moveAmount or 1;
    local moveSuccess, msg = moveAPI.go{direction=dir, amount=moveAmount};           
    if moveSuccess == false then
        showError(msg, "MOVE FAIL", errTime);
        return false;
    else
        return true;
    end
    return false;
end

--[[....................................]]--

--[[ Test 1: Move straight, w/ obstacles ]]--

--Find if block is red wool (colour code for this test).
local routineFound = checkRoutine("red");
if routineFound then
    local failed, moveSuccess, msg, detected, inspected, blockData, forwards, elevationDiff = 0, nil, nil, false, nil, nil, 0, 0;
    
    while not detected do
        while failed == 0 do            
            moveSuccess = attemptMove("forward", 0);
            if moveSuccess == false then
                failed = 1; --try moving up
            else
                forwards = forwards + 1;
                inspected, blockData = turtle.inspectDown();
                if blockData.name == "minecraft:wool" and blockData.metadata == 14 then --red wool
                    detected = true; --once we exit out of this while failed == 0 loop, we end execution of this routine
                    term.setCursorPos(1,3);
                    textAPI.writeCol("MISSION ACCOMPLISHED.");
                    os.setComputerLabel("§aDone!");
                    os.sleep(2);
                    os.setComputerLabel(turtleType);
                    turtle.turnRight();
                    attemptMove("forward", 5, 2);
                    turtle.turnRight();
                    
                    --First let's reset to the starting platform's height.
                --<<...
                    while elevationDiff > 0 do
                        attemptMove("down", 5);
                        elevationDiff = elevationDiff - 1;
                    end
                    
                    while elevationDiff < 0 do
                        attemptMove("up", 5);
                        elevationDiff = elevationDiff + 1;
                    end
                ---...>>
                    --Then let's try to move back to the starting platform in a straight line.
                    while forwards > 0 do
                        attemptMove("forward", 5);
                        forwards = forwards - 1;
                    end

                    turtle.turnRight();
                    attemptMove("forward", 5, 2);
                    turtle.turnRight();
                    attemptMove("back", 5); --Because the start of this routine was "move forward 1 block", so let's move back
                    failed = -1; --exit out of the loop
                end
                
                if not turtle.detectDown() then --Whenever above a hole, try to move down.
                    failed = 2;
                    break; --break out of this iteration of the while loop
                end
                
            end
        end
        
        while failed == 1 do
            moveSuccess = attemptMove("up", 0);
            if moveSuccess == false then
                failed = 2; --try moving down
            else
                elevationDiff = elevationDiff + 1;
                if not turtle.detect() then --if there's nothing in front, we should try moving there; else, keep going up
                    failed = 0; --try and move forwards
                end
            end
        end
        
        while failed == 2 do
            moveSuccess = attemptMove("down", 0);
            if moveSuccess == false then
                showError("Couldn't move up, down or forwards.", "MOVE FAIL", 5);
                failed = -1; --break out of the whole loop; abort
            else
                elevationDiff = elevationDiff - 1;
                if turtle.detectDown() then --if we've reached the floor, start to move along it; else, continue going down
                    failed = 0; --try and move forwards
                end
            end
        end
        
        if failed == -1 then
            break; --break out of the while loop; abort
        end
        
    end
    
   --showError("Failed to move to requested position.", "MOVE FAIL");
    
end


--[[....................................]]--

--[[            TERMINATION             ]]--
os.unloadAPI("/textAPI");
os.unloadAPI("/moveAPI");
--[[....................................]]--