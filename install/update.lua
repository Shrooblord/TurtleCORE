-- updater tool
-- TurtleCORE (C) Jango Course, 2017-2022

-- 0. get SHA of current installation (from file called SHA made during install / update)
-- 1. get latest commit on main branch
-- https://api.github.com/repos/Shrooblord/TurtleCORE/commits/main
-- 2. --> get SHA
-- 3. use this to compare two SHAs: https://docs.github.com/en/rest/reference/commits#compare-two-commits
-- 4. resolve diff: add files with status 'added'; remove files with status 'removed';
--      mv renamed files; delete and re-download 'modified' files
-- 5. update SHA file with SHA retrieved in 0.
-- 6. update complete!

local req = require("lib.http.req")

--this file...!
req("https://raw.githubusercontent.com/Shrooblord/TurtleCORE/main/install/update.lua")
