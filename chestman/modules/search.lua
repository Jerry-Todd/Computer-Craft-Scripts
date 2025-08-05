local M = {}

function M.Menu()
    local w,h = term.getSize()
    local gui = require("modules.gui-util")

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

        term.setCursorPos(2,4)
        term.write("> " .. searchText .. " ")
        local x, y = term.getCursorPos()
        term.setCursorPos(x-1, y)
        term.setCursorBlink(true)



    end

    sleep(20)
end

function M.search() 

end

return M
