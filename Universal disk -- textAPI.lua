--[[TEXT API VERSION 1 - 07/08/2017]]--
--This file is a library of text manipulation/display functions
--that all turtles and monitors will be using.
--So instead of all having their own variation of those functions, they all
--simply call this API to handle all that.

local versionNo = 1;

function splitWords(txtLines, limit)
    while #txtLines[#txtLines] > limit do
        txtLines[#txtLines+1] = txtLines[#txtLines]:sub(limit+1);
        txtLines[#txtLines-1] = txtLines[#txtLines-1]:sub(1,limit);
    end
end

function wrapTxt(str, limit)
    local txtLines, here, limit, found = {}, 1, limit or 72, str:find("(%s+)()(%S+)()")

    if found then
        txtLines[1] = string.sub(str,1,found-1);  -- Put the first word of the string in the first index of the table.
    else txtLines[1] = str end

    str:gsub("(%s+)()(%S+)()",
        function(sp, st, word, fi)  -- Function gets called once for every space found.
            splitWords(txtLines, limit)

            if fi-here > limit then
                here = st;
                txtLines[#txtLines+1] = word;                                            -- If at the end of a line, start a new table index...
            else txtLines[#txtLines] = txtLines[#txtLines].." "..word end  -- ... otherwise add to the current table index.
        end)

    splitWords(txtLines, limit);

    return txtLines
end

--So text colour is no longer supported by normal Turtles,
--  but term.blit IS; this will simply term.write the text if
--  the Turtle is not an Advanced Turtle, and will apply colours
--  if it is!!
--term.blit to screen, with default colour white and def bg black
function writeCol(str,colTxt,colBg)
    local colTxt, colBg, tbl = colTxt or "0", colBg or "f", nil;
    local w, h = term.getSize();
    local curPosX = term.getCursorPos();
    
    str = tostring(str);
    --str = str:gsub("%§(.)","");  --First, let's cut out and colour codes that may be passed in, eg. §b
    
    tbl = wrapTxt(str, w-curPosX);  --Wrap the text to the terminal width-current cursor X position
    
    for _,v in pairs(tbl) do
        local cT, cB = v, v;
        --For each character in cT, substitute with colTxt && again for cB, colBg
        cT = cT:gsub(".",colTxt);
        cB = cB:gsub(".",colBg);
        term.blit(v,cT,cB);
        if #tbl > 1 then
            local _, y = term.getCursorPos();
            term.setCursorPos(curPosX,y+1);
            while y >= h do
                term.scroll(1);
                y = y - 1;
                term.setCursorPos(curPosX,y+1);
            end
            os.sleep(0);
        end
    end
end

function askUser(timeout)
    local userTimeout = nil;
    if timeout then
        userTimeout = os.startTimer(10);
    end
    while true do
        local evt, par1 = os.pullEvent();
        if evt == "timer" and par1 == userTimeout then
            return true
        elseif evt == "key" then
            if par1 == keys.y then
                return true
            elseif par1 == keys.n then
                return false
            end
        end
    end
end