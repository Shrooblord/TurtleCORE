--[[UNIVERSAL INSTALLER DOWNLOADER VERSION 1 - 15/09/2020 - 15/09/2020]]--

--[[

Copy and paste the line below in a CC computer command line to create an Installer Disk.

pastebin run Mr3dPJLw

]]--
 
local scripts = {
    {id = "KAHCQZsT", name = "startup", file = "/disk/startup.lua"},
    {id = "gk73Uiq6", name = "persistence", file = "/disk/persistence.lua"},
    {id = "8trZ7R3B", name = "textAPI", file = "/disk/textAPI.lua"},
    {id = "PKNfkdAd", name = "moveAPI", file = "/disk/moveAPI.lua"},
    {id = "WDkH4qQM", name = "rednetAPI", file = "/disk/rednetAPI.lua"},
    {id = "kWKeivDW", name = "RSAAPI", file = "/disk/RSAAPI.lua"},
    {id = "BnhHe4Px", name = "queueAPI", file = "/disk/queueAPI.lua"},
}
 
if not http then
   printError("HTTP API required for creating Universal Installer Disk!")
   return
end

if not fs.exists("/disk/") then
    printError("To create an installer disk, you need to insert a disk!")
    return
end
 
local function get(script)
   print("")
   print("Downloading: " .. script.name)
   local response = http.get("http://pastebin.com/raw.php?i=" .. textutils.urlEncode(script.id))
   if response then
      local contents = response.readAll()
      response.close()
      local file = fs.open(script.file, "w")
      file.write(contents)
      file.close()
      print("Saved script: " .. script.file)
      print("")
   else
      printError("Could not retrieve " .. script.name .. " from Pastebin.")
   end
end

print("")
print("Universal Turtle Installer Disk Downloader")
print("")
print("This will write to the disk, overwriting any previous: ")
for index, script in pairs(scripts) do
   print(index .. ". " .. script.name)
end
print("")

print("Press any key to continue.")
while true do
    os.pullEvent("key");
    break
end
term.clear();

for index, _ in pairs(scripts) do
    get(index)
end

print("")
print("All done! Press any key to run the Installer now")
print("or remove the Disk from the drive at this time")
print("and relocate it to a drive beside the Turtle")
print("you want to install the Universal Software on.")

print("Press any key to reboot.")
while true do
    os.pullEvent("key");
    break
end
term.clear();
os.reboot();
