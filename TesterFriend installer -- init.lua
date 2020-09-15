            --[[INITIALISATION VERSION 23 - 22/12/2017 – 15/09/2020]]--
--........................................................................--
--  This script downloads all the scripts for the given turtle archetype
--  so that a disk can be printed that other turtles will use.

--  scriptBank              --  TesterFriend
--      chGve1ci

--  persistence.lua         --  Universal
--      gk73Uiq6

--  init (this)             --  TesterFriend
--      0uzdbjGW

--  startup                 --  Universal
--      KAHCQZsT

--  Version                 --  TesterFriend
--      05DraKmw

--  startupFile             --  TesterFriend
--      WQDvNciF

--  textAPI                 --  Universal
--      8trZ7R3B

--  moveAPI					--  Universal
--      PKNfkdAd
--........................................................................--

versionNo = 23;

args = { ... };

local delay = 0;

aScrpt = nil;

function printDelay(txt)
    os.sleep(delay);
    print(txt);
end

function askUser()
    while true do
        local evt, par1 = os.pullEvent("key");
        if evt == "key" then
            if par1 == keys.y then
                return true
            elseif par1 == keys.n then
                return false
            end
        end
    end
end

function preSetup()
    --Things that must be true before we can start setup.
    local inFront, blockFront = turtle.inspect();
    if not inFront then
        return false
    elseif blockFront["name"] == "computercraft:disk_drive" then
        if blockFront["state"].state == "full" then
            term.setTextColor(colors.orange);
            printDelay("Any contents on this disk will be erased. Are you sure you wish to continue [Y/N]?");
            term.setTextColor(colors.white);
            return askUser()
        end
    end
    return false
end

function checkVersionDiff()
    local cNo = 0;
    
    term.setTextColor(colors.lightBlue);
    printDelay("Loading new init as API...");
    os.loadAPI("/tmp/download/init_new");
    
    cNo = assert(init_new.versionNo, "NaN - init_new load failure.");
    
    term.setTextColor(colors.lightBlue);
    printDelay("Unloading new init API...");
    
    os.unloadAPI("/tmp/download/init_new");
    
    if cNo > versionNo then
        term.setTextColor(colors.yellow);
        printDelay("Newer version "..cNo.." available!");
        if fs.exists("/tmp/init_old") then fs.delete("/tmp/init_old") end
        fs.move("/tmp/init", "tmp/init_old");
        fs.move("/tmp/download/init_new", "tmp/init");
        return false
    else
        term.setTextColor(colors.lightBlue);
        print("Version "..cNo.." older or the same.");
        fs.delete("/tmp/download");
        return true
    end
end

--Maybe at some point extract this awesome installer/progress bar thing into its own GUI API, 'cause it's freakin' ace
function downloadScripts(allScripts, noScripts)
    term.setTextColor(colors.lightBlue);
    printDelay("Starting download...");
    os.sleep(3);
    term.clear();
    term.setCursorPos(5,1);
    term.setTextColor(colors.yellow);
    term.write("[[");
    term.setTextColor(colors.lightBlue);
    term.write(" DOWNLOADING INSTALLATION ");
    term.setTextColor(colors.yellow);
    term.write("]]");
    term.setTextColor(colors.white);
    term.setCursorPos(1,2);
    if not fs.isDir("/tmp") then fs.makeDir("/tmp") end
    term.write("Downloading "..noScripts.." scripts...");
    
    local sleepDelay, n, currentChunks = 0.2, 0, 0;
    
    for k, v in pairs(allScripts) do
        
        term.setCursorPos(1,9);
        term.write("                                       ");
        term.setCursorPos(1,9);
        term.setTextColor(colors.white)  --white
        term.write("Progress:");
        
        local totalProgPercentStr = tostring(math.floor(n/noScripts*100));
        local totalProgPercentStrLen = #totalProgPercentStr;
        term.setCursorPos(14-totalProgPercentStrLen,9);
        term.setTextColor(colors.lightBlue)  --white
        term.write(tostring(math.floor(n/noScripts*100)));
        
        term.setCursorPos(14,9);
        term.write("% ");
        term.setTextColor(colors.white)  --white
        term.write("- File: ");
        term.setTextColor(colors.yellow);
        term.write(tostring(n).."/"..tostring(noScripts));
        
        term.setCursorPos(1,3);
        term.write("                                       ");
        term.setCursorPos(1,3);
        term.setTextColor(colors.lightBlue);  --light blue
        term.write("Downloading "..k);
        os.sleep(sleepDelay);

        if fs.exists("/tmp/"..k) then fs.delete("/tmp/"..k) end
        term.setCursorPos(1,4);
        term.write("                                       ");
        term.setCursorPos(1,5);
        term.write("                                       ");
        term.setCursorPos(1,6);
        term.write("                                       ");
        term.setCursorPos(1,4);
        term.setTextColor(colors.white);
        shell.run("pastebin","get",v,"/tmp/"..k);
        os.sleep(sleepDelay);
        term.setCursorPos(1,4);
        term.write("                                       ");
        term.setCursorPos(1,5);
        term.write("                                       ");
        term.setCursorPos(1,6);
        term.write("                                       ");
        term.setCursorPos(1,4);
        term.setTextColor(colors.green);  --green
        term.write(k.." downloaded! Moving...");
        os.sleep(sleepDelay);

        if fs.exists("disk/"..k) then fs.delete("disk/"..k) end
        fs.move("/tmp/"..k, "disk/"..k);
        n = n + 1;
        
        term.setCursorPos(1,5);
        term.write("                                       ");
        term.setCursorPos(1,6);
        term.write("                                       ");
        term.setCursorPos(1,5);
        term.setTextColor(colors.lightBlue);  --light blue
        term.write(k.." moved to");
        term.setCursorPos(1,6);
        term.write("  disk/"..k);
        os.sleep(sleepDelay);
        
        --Progress bar
        term.setCursorPos(5,1);
        term.setTextColor(colors.yellow);
        term.write("[[")
        --Determine how much % needs filling in 10% chunks
        local fullStr = " DOWNLOADING INSTALLATION ";
        local chunksTotal = #fullStr;
        local chunksFilledFraction = n/noScripts;
        local chunksFilled = math.floor(chunksTotal * chunksFilledFraction);
        
        term.setCursorPos(1,9);
        term.write("                                       ");
        term.setCursorPos(1,9);
        term.setTextColor(colors.white)  --white
        term.write("Progress:");
        
        term.setCursorPos(14,9);
        term.setTextColor(colors.lightBlue)  --white
        term.write("% ");
        term.setTextColor(colors.white)  --white
        term.write("- File: ");
        term.setTextColor(colors.yellow);
        term.write(tostring(n).."/"..tostring(noScripts));
        
        --Fill that many with blue background and white text
        for i=currentChunks, chunksFilled, 1 do
            term.setCursorPos(7,1);
            term.setTextColor(colors.white);
            term.setBackgroundColor(colors.blue);
            local strChunk = fullStr:sub(0, i+1);
            term.write(strChunk);
        
            --Fill the rest with the remaining string in original colour.
            term.setTextColor(colors.lightBlue);
            term.setBackgroundColor(colors.black);
            local strRemaining = fullStr:sub(i+2);
            term.write(strRemaining);
            term.setTextColor(colors.yellow);
            term.write("]]");
            term.setTextColor(colors.white);
            
            totalProgPercentStr = tostring(math.floor(i/chunksTotal*100));
            totalProgPercentStrLen = #totalProgPercentStr;
            term.setCursorPos(14-totalProgPercentStrLen,9);
            term.setTextColor(colors.lightBlue);  --light blue
            term.write(tostring(totalProgPercentStr));
            
            term.setTextColor(colors.white)  --white
            
            os.sleep(0);
        end
        currentChunks = chunksFilled;
    end
    
    os.sleep(sleepDelay);
    term.setCursorPos(1,10);
    
    term.setTextColor(colors.lightBlue);
    term.write("Renaming disk...");
    local c = fs.open("disk/Version", "r");
        c.readLine();
        local diskName = c.readLine();
    c.close();
    disk.setLabel("front", diskName);
    
    term.setCursorPos(1,11);
    term.setTextColor(colors.green);
    term.write("Disk renamed to "..diskName);
    
    os.sleep(4);
    
    term.setTextColor(colors.white);  --white
end

--........................................................................--

function main(arg)
    
    if arg == "downloadNew" then
        --  Always make sure the installation files on the disk are up-to-date.
        term.setTextColor(colors.lightBlue);
        printDelay("Downloading fresh copy of initAPI file...");
        if fs.exists("/tmp/download/init_new") then fs.delete("/tmp/download/init_new"); end
        if not fs.isDir("/tmp/download") then fs.makeDir("/tmp/download") end    
        shell.run("pastebin", "get", "0uzdbjGW", "/tmp/download/init_new");
        
        term.setTextColor(colors.lightBlue);
        printDelay("Checking current script version...");
        return checkVersionDiff()  --Is our installation current?
            
        
    elseif arg == "deleteOld" then
        term.setTextColor(colors.yellow);
        printDelay("Deleting old installation.");
        if fs.exists("/tmp/init_old") then fs.delete("/tmp/init_old") end

        term.setTextColor(colors.lightBlue);
        printDelay("Re-running download to check installation is current...");  -- Run again to make sure we're up to date now (version should be same now)
        if main("downloadNew") then
            return true
        else
            return false
        end
    
    
    elseif arg == "testTableLoad" then
        
        printDelay("Loading persistence API...");
        os.loadAPI("/persistenceAPI");
        
        t_original = {1, 2, ["a"] = "string", b = "test", {"subtable", [4] = 2}};
        printDelay("Storing data...");
        persistenceAPI.persistence.store("/store/storage.lua", t_original);
        printDelay("Loading data...");
        t_restored = persistenceAPI.persistence.load("/store/storage.lua");
        
        delay = 0.8;
        
        printDelay("Printing retrieved data...");
        for k,v in pairs(t_restored) do
            x, y = term.getCursorPos();
            term.write(k);
            term.write(": ");
            if type(v) == "table" then
                xx, yy = term.getCursorPos();
                
                for kk,vv in pairs(v) do
                    term.write("  ");
                    term.write(kk);
                    term.write(": ");
                    term.write(vv);
                    
                    term.setCursorPos(4,yy);
                    term.scroll(1);
                end
            else
                term.write(v);
                term.setCursorPos(1,y);
                term.scroll(1);
            end
        end
        
        printDelay("Unloading persistence API...");
        os.unloadAPI("/persistenceAPI");
        
        printDelay("Returning from test...");
        return true
        
        
    elseif arg == "install" then
        
        if not fs.isDir("/tmp") then fs.makeDir("/tmp") end
        os.sleep(0);
        if fs.exists("/tmp/scriptBank") then fs.delete("/tmp/scriptBank") end
        term.setTextColor(colors.lightBlue);
        printDelay("Downloading scriptBank...");
        shell.run("pastebin","get","chGve1ci", "/tmp/scriptBank");   -- In the future, this script should somehow self-determine which are the scripts this specific turtle archetype needs.
        os.sleep(0);
        
        if fs.exists("/persistenceAPI") then fs.delete("/persistenceAPI") end
        printDelay("Downloading persistence API...");
        shell.run("pastebin","get","gk73Uiq6", "/persistenceAPI");
        os.sleep(0);
        
        printDelay("Loading scriptBank...");
        os.loadAPI("/tmp/scriptBank");
        printDelay("Loading persistence API...");
        os.loadAPI("/persistenceAPI");
        
        if fs.exists("/tmp/store/t_scripts") then fs.delete("/tmp/store/t_scripts") end
        if not fs.isDir("/tmp/store") then fs.makeDir("/tmp/store") end
        
        printDelay("Saving tables...");
        persistenceAPI.persistence.store("/tmp/store/t_scripts", scriptBank.allScripts, scriptBank.noScripts);
        term.setTextColor(colors.green);
        printDelay("Tables saved.");
        os.sleep(0);
        
        term.setTextColor(colors.lightBlue);
        printDelay("Loading tables...")
        local allScripts, noScripts = persistenceAPI.persistence.load("/tmp/store/t_scripts");
        term.setTextColor(colors.green);
        printDelay("Tables loaded.");
        os.sleep(0);
        
        term.setTextColor(colors.lightBlue);
        printDelay("Unloading scriptBank...");
        os.unloadAPI("/tmp/scriptBank");
        term.setTextColor(colors.lightBlue);
        printDelay("Unloading persistence API...");
        os.unloadAPI("/persistenceAPI");
        
        downloadScripts(allScripts, noScripts);
        
        os.sleep(0);
        return true
        
    elseif arg == "cleanup" then
        --Let's clean up after ourselves shan't we
        --This step is actually surprisingly simple and intuitive; delete everything, and reboot
        --so that if this Turtle is actually supposed to be installing the software we downloaded,
        --it will, and if it isn't, it won't (which is already perfectly handled by the disk/startup script itself.)
        term.clear();
        term.setCursorPos(1,1);
        term.setTextColor(colors.lightBlue);
        printDelay("Removing installation environment...");
        fs.delete("/tmp");
        term.setTextColor(colors.green);
        printDelay("Temporary directory cleared.");
        term.setTextColor(colors.lightBlue);
        printDelay("Rebooting...");
        os.sleep(2);
        os.reboot();
        
    else
        term.setCursorPos(1,2);
        term.write("                                       ");
        term.setCursorPos(1,3);
        term.write("                                       ");
        term.setCursorPos(1,2);
        term.setTextColor(colors.red);  --red
        term.write("ERROR: No arguments supplied.");
        term.setCursorPos(1,3);
        term.write("Script will exit.");
        os.sleep(2);
        term.setTextColor(colors.white);  --white   
        return false
    end
    
    error("Execution isn't supposed to come to this point. :(");
    return false  --if we got to here, something went wrong
end


if args[1] == "run" then
    term.clear();
    term.setCursorPos(1,1);
    
    local shellID = multishell.getCurrent();
    multishell.setFocus(shellID);
    
    term.setTextColor(colors.white);
    term.write("    [[");
    term.setTextColor(colors.yellow);
    term.write("Initialisation script v");
    term.setTextColor(colors.lightBlue);
    term.write(versionNo);
    term.setTextColor(colors.white);
    term.write("]]");
	term.setCursorPos(1,2);
    multishell.setTitle(shellID, "Installer v"..versionNo.." - Running");
    
    --First of all, let's make sure the setup conditions are all in-place
    if preSetup() then
        if main("downloadNew") then
            if main("deleteOld") then
                --[[
                main("testTableLoad");
                printDelay("Test success!");
                return
                ]]--
                main("install");
                main("cleanup");  --This will finish execution
            else
                error("Error deleting the old installation.");
            end
        else
            shell.exit();  --Queue this tab to close once execution has completed.
            multishell.setTitle(shellID, "Installer v"..versionNo.." - Closing");
            shell.switchTab(shell.openTab("/tmp/init", "run"));  -- We have replaced this file with a new one; load that new shell.
            term.setTextColor(colors.white);
            term.clear();
            term.setCursorPos(1,1);
            return  -- Finish execution. This file will be removed from the file system (in favour of the newly downloaded one).
        end
    else
        term.setTextColor(colors.red);
        printDelay("Installation environment incorrect.");
        term.setTextColor(colors.white);
        printDelay("Please ensure the following are true:");
        term.setTextColor(colors.yellow);
        printDelay(" * I am facing a Disk Drive;");
        printDelay(" * That Drive has an empty Disk in it;");
        printDelay(" * You want me to install on that Disk.");
        term.setTextColor(colors.lightBlue);
        printDelay("Setup these conditions, and retry.");
        term.setTextColor(colors.white);
    end
--else
    --printDelay("Script loaded as API.");
end