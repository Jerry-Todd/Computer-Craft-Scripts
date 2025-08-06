local w, h = term.getSize()

local gui = require("modules.gui-util")
local chests = require("modules.chests")

chests.GetChests()
-- chests.GetInterface()

local ButtonsResult = nil

function Buttons()
    term.getCursorBlink(false)
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
    while true do
        local containers = chests.GetChests()

        term.setCursorPos(2, 8)
        term.clearLine()
        print(' - Chests: ' .. #containers)

        local storage = 0
        local used_storage = 0
        for i, c in pairs(containers) do
            storage = storage + (c.size() * 64)
            local list = c.list()
            for slot, item in pairs(list) do
                used_storage = used_storage + item.count
            end
        end

        term.clearLine()
        print(' - Storage: '..used_storage/storage ..'%')
        term.clearLine()
        print(' - Items: '..used_storage..'/'..storage)

        sleep(1)
    end
end

while true do
    parallel.waitForAny(Buttons, Info)

    if ButtonsResult then
        if ButtonsResult == 'search' then
            local search = require("modules.search")
            search.Menu()
        elseif ButtonsResult == 'deposit' then
            parallel.waitForAny(
                chests.DepositAll,
                function()
                    term.clear()
                    term.setCursorPos(2, 2)
                    gui.pendingMessage('Depositing')
                end
            )
        end
    end
end
