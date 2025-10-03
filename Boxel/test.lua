


local API = require("boxelAPI")

function Main()
    term.clear()
    term.setCursorPos(1,1)
    sleep(0.5)
    print(tostring(#API.GetChests()))
    -- print(tostring(#API.GetChestCache()))
    -- sleep(0.5)
end

parallel.waitForAny(
    Main,
    function()
        API.WatchChests()
    end
)
