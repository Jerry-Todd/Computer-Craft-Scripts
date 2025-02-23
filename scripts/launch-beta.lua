-- version: 5

local term_width, term_height = term.getSize()
local max_options = math.floor(term_height / 2) - 1

local options = {}
local options_path = {}

-- local scripts_folder = fs.list("scripts")
-- local options_folder = fs.list("scripts/options")

-- for i, o in ipairs(options_folder) do
--     if string.sub(o, -4) == ".lua" then
--         table.insert(options, o)
--         table.insert(options_path, "scripts/options/" .. o)
--     end
-- end

-- for i, s in ipairs(scripts_folder) do
--     if string.sub(s, -4) == ".lua" then
--         table.insert(options, s)
--         table.insert(options_path, "scripts/" .. s)
--     end
-- end

for i = 1, 20 do
    table.insert(options, "dummy option " .. i)
    table.insert(options_path, "")
end

Cursor = 1
Page = 1

function LoadPage()
    term.clear()
    term.setCursorPos(2, 2)
    print("Launcher - Page " .. Page)
    for i = 1, max_options do
        local o_num = ((Page - 1) * max_options) + i
        if options[o_num] == nil then
            break
        end
        term.setCursorPos(4, 2 + i * 2)
        -- print(string.sub(options[o_num], 1, #options[o_num] - 4))
        print(options[o_num])
    end
end

function SetCursor(icon)
    term.setCursorPos(2, 2 + ((Page - 1) * max_options) + Cursor * 2)
    io.write(icon)
end

function Control(direction)
    SetCursor(" ")

    if direction == "up" then
        Cursor = Cursor - 1
    elseif direction == "down" then
        Cursor = Cursor + 1
    end

    if Cursor < 1 then
        Cursor = #options
    elseif Cursor > #options then
        Cursor = 1
    end

    Page = math.ceil(Cursor / max_options)

    LoadPage()

    SetCursor(">")
end

Control(nil)

while true do
    local event, key = os.pullEvent("key")
    key = keys.getName(key)
    Control(key)
    if key == "enter" then
        term.clear()
        term.setCursorPos(1, 1)
        shell.run(options_path[Cursor])
        break
    end
end

LoadPage()
