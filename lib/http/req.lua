-- http request library
-- TurtleCORE (C) Jango Course, 2017-2022

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

return req
