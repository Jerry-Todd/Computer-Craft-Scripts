local w, h = term.getSize()

local gui = require("modules.gui-util")

local chests = { peripheral.find('minecraft:chest') }

if #chests == 0 then
    error('No containers connected', 0)
end

local ButtonsResult = nil

function Buttons()
    term.clear()
    term.setCursorPos(1, 1)

    print("Chestman - Storage Manager")
    gui.seperator('=')

    gui.drawBox(2, 4, (w / 2) - 1)
    gui.drawBox(2, 5, (w / 2) - 1, "Search")
    gui.drawBox(2, 6, (w / 2) - 1)

    gui.drawBox((w / 2) + 2, 4, (w / 2) - 1)
    gui.drawBox((w / 2) + 2, 5, (w / 2) - 1, "Deposit all")
    gui.drawBox((w / 2) + 2, 6, (w / 2) - 1)

    term.setCursorPos(1, 8)

    while true do
        local event, b, x, y = os.pullEvent("mouse_click")
        if event == "mouse_click" and b == 1 then
            -- Search button
            if gui.isClickInButton(x, y, 2, 4, (w / 2) - 2) or
                gui.isClickInButton(x, y, 2, 5, (w / 2) - 2) or
                gui.isClickInButton(x, y, 2, 6, (w / 2) - 2) then
                ButtonsResult = 'search'
                return
            end
            -- Search button
            if gui.isClickInButton(x, y, (w / 2) + 2, 4, (w / 2) - 2) or
                gui.isClickInButton(x, y, (w / 2) + 2, 5, (w / 2) - 2) or
                gui.isClickInButton(x, y, (w / 2) + 2, 6, (w / 2) - 2) then
                ButtonsResult = 'deposit'
                return
            end
        end
    end
end

function Info()
    return
    sleep(1000)
end

-- while true do

parallel.waitForAny(Buttons, Info)

if ButtonsResult then
    if ButtonsResult == 'search' then
        local search = require("modules.search")
        search.Menu()
    elseif ButtonsResult == 'deposit' then

    end
end

-- end
