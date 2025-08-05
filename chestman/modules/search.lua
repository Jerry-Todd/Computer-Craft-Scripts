local M = {}

function M.Menu()
    local w, h = term.getSize()
    local gui = require("modules.gui-util")

    term.clear()
    term.setCursorPos(1, 1)
    term.setCursorPos(2, 4)
    term.write('Loading...')

    local chests = require('modules.chests')
    local items = chests.GetAllItems()
    local searchText = ''

    while true do
        term.clear()
        term.setCursorPos(1, 1)
        print("Chestman - Search")
        gui.seperator('=')

        term.setCursorPos(2, 4)
        term.write("> " .. searchText .. " ")
        local sx, sy = term.getCursorPos()
        term.setCursorBlink(true)

        term.setCursorPos(1, 6)
        local found_items = M.search(searchText, items)
        local print_count = 0
        for key, value in pairs(found_items) do
            print_count = print_count + 1
            if print_count > h - 5 then break end
            local bx, by = term.getCursorPos()
            print('          ' .. DisplayName(key) .. ' x' .. value)
            gui.drawBox(bx + 1, by, 6, 'take')
        end

        term.setCursorPos(sx - 1, sy)

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
    end
end

function M.search(search_term, items)
    local filtered_items = {}

    for key, value in pairs(items) do
        if string.find(DisplayName(key):lower(), search_term:lower()) then
            filtered_items[key] = value
        end
    end

    return filtered_items
end

function DisplayName(name)
    -- Remove everything before the colon (:) in the item name
    local display_key = name
    local colon_pos = string.find(display_key, ":")
    if colon_pos then
        display_key = string.sub(display_key, colon_pos + 1)
    end

    -- Replace underscores with spaces
    display_key = string.gsub(display_key, "_", " ")

    -- Capitalize the first letter
    if #display_key > 0 then
        display_key = string.upper(string.sub(display_key, 1, 1)) .. string.sub(display_key, 2)
    end

    return display_key
end

return M
