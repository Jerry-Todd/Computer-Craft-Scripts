W, H = term.getSize()

-- Import Basalt
if not fs.exists("basalt.lua") then
    print('Basalt not found, installing...')
    shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt2/main/install.lua -f")
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
        :setText("Reload")
        :setSize(6, 1)
        :setBackground(colors.gray)
        :setForeground(colors.white)
        :setPosition(W - 10, 1)
        :onClick(function()
            API.ClearCache()
        end)

    local b_stats = frame:addButton()
        :setText("Info")
        :setSize(4, 1)
        :setBackground(colors.gray)
        :setForeground(colors.white)
        :setPosition(16, 1)

    local b_search = frame:addButton()
        :setText("Search")
        :setSize(6, 1)
        :setBackground(colors.blue)
        :setForeground(colors.white)
        :setPosition(9, 1)

    b_stats:onClick(function()
        SelectTab(F_stats)
        b_stats:setBackground(colors.blue)
        b_search:setBackground(colors.gray)
    end)

    b_search:onClick(function() 
        SelectTab(F_search)
        b_search:setBackground(colors.blue)
        b_stats:setBackground(colors.gray)
    end)

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

    Deposit = frame:addButton()
        :setText("Deposit")
        :setPosition(W - 9, 2)
        :setSize(9, 1)
        :setBackground(colors.gray)
        :setForeground(colors.white)
        :onClick(function()
            Deposit:setForeground(colors.yellow)
            Deposit:setText("Working")
            API.DepositAll()
            Deposit:setForeground(colors.white)
            Deposit:setText("Deposit")
        end)

    local ItemList = frame:addScrollFrame()
        :setPosition(2, 4)
        :setSize(W - 3, H - 6)
        :setBackground(colors.black)

    Search = frame:addInput()
        :setPosition(2, 2)
        :setSize(W - 15, 1)
        :setForeground(colors.white)
        :setBackground(colors.gray)
        :setPlaceholder("search...")
        :setPlaceholderColor(colors.lightGray)
        :onChange("text", function(self, text)
            ItemList:setOffset(0, 0)
        end)

    frame:addButton()
        :setText("X")
        :setPosition(W - 13, 2)
        :setSize(3, 1)
        :setBackground(colors.red)
        :setForeground(colors.white)
        :onClick(function()
            Search:setText("")
            ItemList:setOffset(0, 0)
        end)

    function listItems(searchTerm)
        -- Filter items
        local filtered_items = {}
        local items = API.GetItems()

        if not items or next(items) == nil then
            ItemList:clear()
            ItemList:addLabel()
                :setText("Storage is empty")
                :setSize(20, 1)
                :setPosition(1, 1)
                :setForeground(colors.white)
            return
        end

        for key, value in pairs(API.GetItems()) do
            local prettyName = API.DisplayName(key)
            if string.find(prettyName:lower(), searchTerm:lower()) then
                filtered_items[key] = value.total
            end
        end

        if not filtered_items or next(filtered_items) == nil then
            ItemList:clear()
            ItemList:addLabel()
                :setText("Nothing found")
                :setSize(20, 1)
                :setPosition(1, 1)
                :setForeground(colors.white)
            return
        end

        -- Sort items alphabetically
        local sorted_items = {}
        for name, count in pairs(filtered_items) do
            table.insert(sorted_items, {name = name, count = count, displayName = API.DisplayName(name)})
        end
        table.sort(sorted_items, function(a, b)
            return a.displayName:lower() < b.displayName:lower()
        end)

        local y = 0

        -- Display items
        ItemList:clear()
        for _, item in ipairs(sorted_items) do
            y = y + 1
            local text = item.displayName .. " x" .. item.count
            local button = ItemList:addButton()
                :setText("Take")
                :setSize(6, 1)
                :setPosition(1, y)
                :onClick(function()
                    API.TakeStack(item.name)
                    listItems(Search.text)
                end)
            local label = ItemList:addLabel()
                :setText(text)
                :setSize(#text, 1)
                :setPosition(8, y)
                :setForeground(colors.white)
            if y % 2 == 1 then
                button:setBackground(colors.lightGray)
                    :setForeground(colors.black)
                label:setForeground(colors.white)
            else
                button:setBackground(colors.gray)
                    :setForeground(colors.white)
                label:setForeground(colors.lightGray)
            end
            
        end
    end

    listItems(Search.text)
    Search:onChange("text", function(self, text)
        listItems(text)
    end)
    return listItems
end

-- Info GUI
function InfoMenu(frame)
    frame:setPosition(1, 3)
        :setSize(W, H - 2)
        
    frame:addLabel()
        :setText("Boxel by Jerry")
        :setPosition(2, H - 2)
        :setSize(40,1)

    local basaltCredit = frame:addLabel()
        :setText("GUI powered by Basalt 2")
        :setSize(40,1)
    basaltCredit:setPosition(W - #basaltCredit.text, H - 2)

    frame:addLabel()
        :setText("Storage:")
        :setPosition(2,2)
        :setSize(40,1)

    frame:addLabel()
        :setText("Chest count: " .. #API.GetChests())
        :setPosition(3,4)
        :setSize(40,1)

    local stats = frame:addLabel()
        :setText("Estimated usage: Loading...")
        :setPosition(3,6)
        :setSize(40,1)
    
    local slots = frame:addLabel()
        :setText("Total slots: Loading...")
        :setPosition(3,8)
        :setSize(40,1)

    local used_slots = frame:addLabel()
        :setText("Used slots: Loading...")
        :setPosition(3,10)
        :setSize(40,1)

    return {stats, slots, used_slots}
end

-- Tab switching
function SelectTab(frame)
    F_search:setSize(0, H - 2)
    F_stats:setSize(0, H - 2)

    frame:setSize(W, H - 2)
end

-- Init frame
F_main = basalt.getMainFrame()
F_main:setBackground(colors.black)
MainMenu(F_main)

-- Init search GUI
F_search = F_main:addFrame()
local listItems = SearchMenu(F_search)

-- Init stats GUI
F_stats = F_main:addFrame()
local stats = InfoMenu(F_stats)

SelectTab(F_search)

-- Start Basalt with continuous monitoring
parallel.waitForAny(
    basalt.run,
    function()
        while true do
            API.CheckChests(function()
                listItems(Search.text)
            end)
        end
    end,
    function()
        while true do
            sleep(0.25)
            listItems(Search.text)
        end
    end,
    function()
        sleep(1)
        -- local updated = false
        while true do
            local storage, used_storage, slots, used_slots = 0, 0, 0, 0
            for i, c in pairs(API.GetChests()) do
                slots = slots + c.size()
                storage = slots * 64
                local list = c.list()
                used_slots = used_slots + #c.list()
                for slot, item in pairs(list) do
                    used_storage = used_storage + item.count
                end
            end
            stats[1]:setText("Estimated usage: " .. math.floor((used_storage / storage) * 100) .. "%")
            stats[2]:setText("Total slots: " .. slots)
            stats[3]:setText("Used slots: " .. used_slots)
            sleep(1)
        end
        sleep(9999)
    end
)