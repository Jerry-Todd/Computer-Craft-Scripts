W, H = term.getSize()

-- Import Basalt
if not fs.exists("basalt.lua") then
    print('Basalt not found, installing...')
    shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt2/main/install.lua -r")
end
local basalt = require("basalt")
-- Import BoxelAPI
if not fs.exists("boxelAPI.lua") then
    print('Boxel API not found, installing...')
    shell.run(
        "wget https://raw.githubusercontent.com/Jerry-Todd/Computer-Craft-Scripts/refs/heads/main/Boxel/boxelAPI.lua")
end
local API = require("boxelAPI")

-- Main GUI
function MainMenu(frame)
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
            sleep(0.1)
            os.exit()
        end)

    frame:addButton()
        :setText("Search")
        :setSize(6, 1)
        :setBackground(colors.blue)
        :setForeground(colors.white)
        :setPosition(9, 1)

    frame:addLabel()
        :setText(string.rep("=", W))
        :setPosition(1, 2)
        :setSize(W, 1)
        :setForeground(colors.white)
end

-- Search GUI
function SearchMenu(frame)
    frame:setPosition(1, 3)
        :setSize(W, H - 2)

    frame:addButton()
        :setText("Deposit")
        :setPosition(W - 9, 2)
        :setSize(9, 1)
        :setBackground(colors.gray)
        :setForeground(colors.white)

    Search = frame:addInput()
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
            Search:setText("")
        end)

    local scrollFrame = frame:addFrame()
        :setPosition(2, 4)
        :setSize(W - 2, H - 6)
        :setBackground(colors.black)

    function listItems(searchTerm)
        
        -- Filter items
        local filtered_items = {}
        for key, value in pairs(API.GetItems()) do
            local prettyName = API.DisplayName(key)
            if string.find(prettyName:lower(), searchTerm:lower()) then
                filtered_items[key] = value.total
            end
        end
        local y = 0

        -- Display items
        scrollFrame:clear()
        for name, count in pairs(filtered_items) do
            y = y + 1
            local text = API.DisplayName(name) .. " x" .. count
            local button = scrollFrame:addButton()
                :setText("Take")
                :setSize(6, 1)
                :setPosition(1, y)
                :onClick(function ()
                    API.TakeStack(name)
                end)
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

    listItems(Search.text)
    Search:onChange("text", function(self, text)
        listItems(text)
    end)
    return listItems
end

-- Init frame
local f_main = basalt.getMainFrame()
f_main:setBackground(colors.black)
MainMenu(f_main)

-- Init search GUI
local f_search = f_main:addFrame()
local listItems = SearchMenu(f_search)

-- Start Basalt with continuous monitoring
parallel.waitForAny(
    basalt.run,
    function()
        while true do 
            API.CheckChests(function()
                listItems(Search.text)
            end)  
        end
    end
)

