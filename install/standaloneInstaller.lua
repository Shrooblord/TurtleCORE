-- stand-alone installer tool for easy 'getting and installing'
--   no external libraries required; all will be downloaded by this file
-- this file on GitHub: https://raw.githubusercontent.com/Shrooblord/TurtleCORE/main/install/standaloneInstaller.lua
-- also on Pastebin for convenience: https://pastebin.com/2PF0aFRA
-- TurtleCORE (C) Jango Course, 2017-2022

-- json.lua by rxi
fs.makeDir("vendor")
shell.run("pastebin", "get", "YWepwTWS", "vendor/json.lua")

-- lib/http/req.lua
fs.makeDir("lib")
fs.makeDir("lib/http")
shell.run("pastebin", "get", "BR3xERWq", "lib/http/req.lua")

local installer = [[
local json = require("vendor.json")
local req = require("lib.http.req")

local latestCommit = json.decode(req("https://api.github.com/repos/Shrooblord/TurtleCORE/commits/main"))

for k, v in pairs(latestCommit) do
    print(k)
end

--check SHA of latest commit -- different from the SHA stored on disk / no SHA stored on disk?
--local update = req("https://raw.githubusercontent.com/Shrooblord/TurtleCORE/main/install/update.lua")
-- save SHA of latest commit to file 'SHA' so we can do a diff later and update all necessary files

-- install over all files created including vendor/json.lua and lib/http/req.lua since the files on
--    GitHub are 'leading' and the ones on Pastebin aren't guaranteed to be up-to-date
]]

fs.makeDir("install")
local install = fs.open("install/install.lua", "w")
    install.write(installer)
install.close()

shell.run("install/install.lua")
