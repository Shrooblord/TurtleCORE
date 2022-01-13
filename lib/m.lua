-- movement library
-- TurtleCORE (C) Jango Course, 2017-2022

require("switch")
local inv = require("inv")

-- error handling
-- returns true if error sustained; error out
-- returns false if error was resolved; usually means that the movement will be attempted anew
local function moveErr(e)
    if type(e) == "string" then
        local errStr = "[E]: "
        local error = true

        switch(e, { 
            ['Out of fuel'] = function()
                if inv.findCoal() then
                    error = false -- error resolved
                else
                    errStr = errStr .. "FEED ME!!"
                end
            end,
    
            ['default'] = function()  -- for default
                errStr = errStr .. "Undefined error while attempting move."
            end
        })

        if error then print(errStr) end
        return error
    end
end



-- movement functions
-- return true if successfully moved

-- forwards
local function f()
    local _, e = turtle.forward()
    if e then 
        if not moveErr(e) then f() end
        return false
    end
    return true
end

-- backwards
local function b()
    local _, e = turtle.back()
    if e then 
        if not moveErr(e) then b() end
        return false
    end
    return true
end

-- left
local function l()
    turtle.turnLeft()
    local _, e = turtle.forward()
    if e then 
        turtle.turnRight()
        if not moveErr(e) then l() end
        return false
    end
    return true
end

-- right
local function r()
    turtle.turnRight()
    local _, e = turtle.forward()
    if e then 
        turtle.turnLeft()
        if not moveErr(e) then r() end
        return false
    end
    return true
end

-- up
local function u()
    local _, e = turtle.up()
    if e then 
        if not moveErr(e) then u() end
        return false
    end
    return true
end

-- down
local function d()
    local _, e = turtle.down()
    if e then 
        if not moveErr(e) then d() end
        return false
    end
    return true
end


-- export
return {
    moveErr = moveErr,
    f = f,
    b = b,
    l = l,
    r = r,
    u = u,
    d = d,
} 
