-- installer tool
-- TurtleCORE (C) Jango Course, 2017-2022

-- #TODO: also create an easy one-liner code that allows you to install *this*
--      script on a turtle. Once it has this, this script will cascade-install
--      all requirements automatically. But it needs this first. So you need to
--      run the one-liner in-game.

--this file...!
http.request("https://raw.githubusercontent.com/Shrooblord/TurtleCORE/main/install.lua")

local requesting = true

while requesting do
    local e, url, src = os.pullEvent()

    if e == "http_success" then
        local res = src.readAll()

        src.close()
        print(res)

        requesting = false
    elseif event == "http_failure" then
        print("[E]: Server did not respond.")
        requesting = false
    end
end
