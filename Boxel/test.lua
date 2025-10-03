local API = require("boxelAPI")

function Main()
    term.clear()
    term.setCursorPos(1, 1)
    sleep(2.5)
    -- term.clear()
    -- term.setCursorPos(1,1)
    -- print(textutils.serializeJSON(API.GetChestCache()))
    -- print(tostring(#API.GetChests()))
    -- print(tostring(#API.GetChestCache()))
    -- print(tostring(#API.GetItems()))
    -- sleep()
    print(textutils.serialiseJSON(API.GetItems()["minecraft:oak_log"]))

    local searchTerm = ""

    -- Filter items
    local filtered_items = {}
    for key, value in pairs(API.GetItems()) do
        if string.find(API.DisplayName(key):lower(), searchTerm:lower()) or true then
            filtered_items[key] = value.total
        end
    end
    local y = 0



    -- Display items
    for name, count in pairs(filtered_items) do
        print(name .. " x" .. count)
    end
end

parallel.waitForAny(
    Main,
    function()
        print("Watching starting")
        while true do API.WatchChests() end
        print("Watching stopped")
    end
)
