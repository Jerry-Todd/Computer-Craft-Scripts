W, H = term.getSize()

-- Import Basalt
if not fs.exists("basalt") then
    print('Basalt not found, installing...')
    shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt2/main/install.lua -r")
end
local basalt = require("basalt") or null

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
            os.exit()
        end)

    frame:addButton()
        :setText("Search")
        :setSize(6, 1)
        :setBackground(colors.cyan)
        :setForeground(colors.white)
        :setPosition(9, 1)

    frame:addButton()
        :setText("Info")
        :setPosition(16, 1)
        :setSize(4, 1)
        :setBackground(colors.blue)
        :setForeground(colors.white)

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

    frame:addButton()
        :setText("Deposit")
        :setPosition(W - 10, 2)
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
        :focus()

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
        :setSize(W-2, H-6)
        :setBackground(colors.black)

    local y = 0
    for name, count in pairs(Items) do
        y = y + 1
        local text = name .. " x" .. count
        scrollFrame:addButton()
            :setText("Take")
            :setSize(4, 1)
            :setPosition(1, y)
            :setBackground(colors.lightGray)
            :setForeground(colors.black)
        scrollFrame:addLabel()
            :setText(text)
            :setSize(#text, 1)
            :setPosition(6, y)
            :setForeground(colors.white)
    end
end

-- temp fake items
Items = {
    Gold = 24,
    Iron = 24,
    Diamond = 24,
    Emerald = 24,
    Coal = 24,
    Redstone = 16,
    Lapis = 32,
    Copper = 20,
    Netherite = 2,
    Quartz = 18,
    Amethyst = 12,
    Obsidian = 8,
    Sand = 64,
    Gravel = 64,
    Oak_Wood = 48,
    Spruce_Wood = 36,
    Birch_Wood = 40,
    Apple = 10,
    Carrot = 25,
    Potato = 30,
    Wheat = 50,
    String = 22,
    Gunpowder = 15,
    Bone = 19,
    Leather = 14,
    Ender_Pearl = 5,
    Blaze_Rod = 7,
}

-- Init frame
local f_main = basalt.getMainFrame()
f_main:setBackground(colors.black)
mainMenu(f_main)

-- Init search GUI
local f_search = f_main:addFrame()
searchMenu(f_search)

-- Start Basalt
basalt.run()
