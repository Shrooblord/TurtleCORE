--      [[    WALLACE:   THE FRIENDLY NEIGHBOURHOOD BOT BUTLER   ]]      --
--                                  v1                                    --
--........................................................................--

versionNo = 2;

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

--  ...

--[[....................................]]--
 
--[[          EXECUTION LOOP            ]]-- 



shell.run("buildRoof");



--[[....................................]]--

--[[            TERMINATION             ]]--
os.unloadAPI("/textAPI");
os.unloadAPI("/moveAPI");
--[[....................................]]--