local M = {}

function M.Menu()
    local w, h = term.getSize()
    local gui = require("modules.gui-util")

    term.clear()
    term.setCursorPos(2, 2)

    local chests = require('modules.chests')
    local items
    parallel.waitForAny(function ()
        gui.pendingMessage('Loading')
    end, function ()
        items = chests.GetAllItems()
    end)
    local searchText = ''

    while true do
        term.clear()
        term.setCursorPos(1, 1)
        print("Chestman - Search")
        gui.seperator('=')

        gui.drawBox(2, 4, 6, 'back')
        term.setCursorPos(9, 4)
        term.write("> " .. searchText .. " ")
        local sx, sy = term.getCursorPos()
        term.setCursorBlink(true)

        term.setCursorPos(1, 6)
        local found_items = M.search(searchText, items)
        local print_count = 0
        local displayed_items = {}
        for key, value in pairs(found_items) do
            print_count = print_count + 1
            if print_count > h - 6 then break end
            local bx, by = term.getCursorPos()
            if print_count % 2 == 0 then
                gui.drawBox(bx + 1, by, 6, 'take')
            else
                gui.drawBox(bx + 1, by, 6, 'take', colors.lightGray, colors.black)
            end
            term.setCursorPos(9, by)
            print(DisplayName(key) .. ' x' .. value)
            table.insert(displayed_items, key)
        end

        term.setCursorPos(sx - 1, sy)

        local event, key, x, y = os.pullEvent()

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

        if event == "mouse_click" and key == 1 then

            if gui.isClickInButton(x, y, 2, 4, 6) then
                term.setCursorBlink(false)
                return
            end

            for i, value in pairs(displayed_items) do
                if gui.isClickInButton(x, y, 1, 5 + i, 6) then
                    term.setCursorBlink(false)
                    parallel.waitForAny(
                        function ()
                            TakeItemHandler(chests, items, value)
                        end,
                        function ()
                            term.setCursorPos(2,4)
                            term.clearLine()
                            gui.pendingMessage('Taking items')
                        end
                    )
                end
            end
        end
    end
end

function TakeItemHandler(chests, items, value)
    local taken = chests.TakeItem(value)
    if taken > 0 then
        -- Update the items table
        if items[value] then
            items[value] = items[value] - taken
            if items[value] <= 0 then
                items[value] = nil -- Remove item completely if count is 0 or less
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
