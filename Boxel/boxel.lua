W, H = term.getSize()

-- Import Basalt
if not fs.exists("basalt") then
    print('Basalt not found, installing...')
    shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt2/main/install.lua -r")
end
local basalt = require("basalt")
-- Import BoxelAPI
if not fs.exists("boxelAPI") then
    print('Boxel API not found, installing...')
    shell.run(
        "wget https://raw.githubusercontent.com/Jerry-Todd/Computer-Craft-Scripts/refs/heads/main/Boxel/boxelAPI.lua")
end
local API = require("boxelAPI")

-- Main GUI
local function mainMenu(frame)
    frame:addLabel()
        :setText("Boxel - ")
        :setPosition(1, 1)
        :setSize(8, 3)
        :setForeground(colors.white)

    frame:addButton()
        :setText("Quit")
        :setSize(4, 1)
        :setBackground(colors.red)
        :setForeground(colors.white)
        :setPosition(W - 3, 1)
        :onClick(function()
            basalt.stop()
            os.exit()
        end)

    frame:addButton()
        :setText("Search")
        :setSize(6, 1)
        :setBackground(colors.cyan)
        :setForeground(colors.white)
        :setPosition(9, 1)

    -- frame:addButton()
    --     :setText("Info")
    --     :setPosition(16, 1)
    --     :setSize(4, 1)
    --     :setBackground(colors.blue)
    --     :setForeground(colors.white)

    frame:addLabel()
        :setText(string.rep("=", W))
        :setPosition(1, 2)
        :setSize(W, 1)
        :setForeground(colors.white)
end

-- Search GUI
local function searchMenu(frame)
    frame:setPosition(1, 3)
        :setSize(W, H - 2)

    local debug = frame:addLabel()
        :setText("")
        :setPosition(1, 1)
        :setSize(W, 1)
        :setBackground(colors.black)
        :setForeground(colors.red)

    frame:addButton()
        :setText("Deposit")
        :setPosition(W - 9, 2)
        :setSize(9, 1)
        :setBackground(colors.gray)
        :setForeground(colors.white)

    local search = frame:addInput()
        :setPosition(2, 2)
        :setSize(W - 15, 1)
        :setForeground(colors.white)
        :setBackground(colors.gray)
        :setFocusedBackground(colors.gray)
        :setPlaceholder("search...")
        :setPlaceholderColor(colors.lightGray)

    frame:addButton()
        :setText("X")
        :setPosition(W - 13, 2)
        :setSize(3, 1)
        :setBackground(colors.red)
        :setForeground(colors.white)
        :onClick(function()
            search:setText("")
        end)

    local scrollFrame = frame:addFrame()
        :setPosition(2, 4)
        :setSize(W - 2, H - 6)
        :setBackground(colors.black)

    

    local function listItems(searchTerm)
        
        debug:setText(tostring(#API.GetItems()))

        -- Filter items
        local filtered_items = {}
        for key, value in pairs(API.GetItems()) do
            if string.find(API.DisplayName(key):lower(), searchTerm:lower()) then
                filtered_items[key] = value.total
            end
        end
        local y = 0

        -- Display items
        scrollFrame:clear()
        for name, count in pairs(filtered_items) do
            y = y + 1
            local text = name .. " x" .. count
            local button = scrollFrame:addButton()
                :setText("Take")
                :setSize(6, 1)
                :setPosition(1, y)
            if y % 2 == 1 then
                button:setBackground(colors.lightGray)
                    :setForeground(colors.black)
            else
                button:setBackground(colors.gray)
                    :setForeground(colors.white)
            end
            scrollFrame:addLabel()
                :setText(text)
                :setSize(#text, 1)
                :setPosition(8, y)
                :setForeground(colors.white)
        end
    end

    listItems(search.text)
    search:onChange("text", function(self, text)
        listItems(text)
    end)
end

-- Init frame
local f_main = basalt.getMainFrame()
f_main:setBackground(colors.black)
mainMenu(f_main)

-- Init search GUI
local f_search = f_main:addFrame()
searchMenu(f_search)

-- Initialize chest data
API.WatchChests()

-- Start Basalt with continuous monitoring
parallel.waitForAny(
    basalt.run,
    function()
        while true do API.WatchChests() end
    end
)

