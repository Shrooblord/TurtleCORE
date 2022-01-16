-- stand-alone installer tool -- no external libraries; all included in this file
--  for easy 'getting and installing'
-- this file on GitHub: https://raw.githubusercontent.com/Shrooblord/TurtleCORE/main/install/standaloneInstaller.lua
-- also on Pastebin for convenience: https://pastebin.com/2PF0aFRA
-- TurtleCORE (C) Jango Course, 2017-2022

--lib/http/req.lua
local function req(url_in)
    http.request(url_in)

    local requesting = true

    while requesting do
        local e, url, src = os.pullEvent()

        if e == "http_success" then
            local res = src.readAll()
            src.close()

            requesting = false
            return res
        elseif e == "http_failure" then
            print("[E]: Server did not respond.")
            requesting = false
        end
    end
end

local res = req("https://raw.githubusercontent.com/Shrooblord/TurtleCORE/main/install/update.lua")
print(res["sha"])

-- save SHA of update.lua to file 'SHA' so we can do a diff later and update all necessary files
