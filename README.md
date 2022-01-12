# Intall New Code
1. Use https://tweaked.cc/module/http.html to perform an HTTP GET https://computercraft.info/wiki/Http.request for the code in this repo using the url https://stackoverflow.com/a/53227723
2. get latest commit to the repo's `main` branch: https://stackoverflow.com/a/45727280
3. is this a different SHA than what we have recorded on disk (see step 6) / do we not have a SHA recorded on disk?
4. compare the SHA of the latest main to the SHA we have on disk and find the diff: https://docs.github.com/en/rest/reference/commits#compare-two-commits
5. DL all the files that were modified since the SHA stored on disk
6. if all successful, copy the SHA of the latest `main` to disk for later
7. You have now updated to latest version of the codebase!

# Communicate
The Turtles will communicate using http GET and POST requests to a personal website, eg. shrooblord.com -- or perhaps using websockets
They will tell each other where they are, what they've explored of the world, where to find goodies...
'Chemical trails' like ants?
Shared directives?
Instant shared knowledge?
Instant 'fleet recall' command?
the sky is the limit...
