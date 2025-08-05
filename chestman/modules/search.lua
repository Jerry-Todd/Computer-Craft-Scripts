local M = {}

function M.Menu()
    local w, h = term.getSize()
    local gui = require("modules.gui-util")

    term.setCursorPos(2, 4)
    term.write('Loading...')

    local chests = require('modules.chests')
    local items = chests.GetAllItems()

    term.clear()
    term.setCursorPos(1, 1)

    print("Chestman - Search")
    gui.seperator('=')

    local searchText = ''

    while true do
        local event, key = os.pullEvent()

        if event == 'char' then
            if key == 'space' then
                searchText = searchText .. ''
            end
            searchText = searchText .. key
        end

        if event == 'key' then
            if keys.getName(key) == 'backspace' then
                searchText = searchText:sub(1, #searchText - 1)
            end
        end

        term.clear()
        term.setCursorPos(1, 1)
        print("Chestman - Search")
        gui.seperator('=')
        
        term.setCursorPos(2, 4)
        term.write("> " .. searchText .. " ")
        local x, y = term.getCursorPos()
        term.setCursorBlink(true)

        term.setCursorPos(1, 6)
        local found_items = M.search(searchText, items)
        local print_count = 0
        for key, value in pairs(found_items) do
            print_count = print_count + 1
            if print_count > h - 5 then break end
            print(' ' .. key .. ' x' .. value)
        end

        term.setCursorPos(x - 1, y)
    end
end

function M.search(search_term, items)
    local filtered_items = {}

    for key, value in pairs(items) do
        if string.find(key:lower(), search_term:lower()) then
            filtered_items[key] = value
        end
    end

    return filtered_items
end

return M
