
local scripts_folder = fs.list("scripts")
local options_folder = fs.list("scripts/options")

local options = {}

for i, o in ipairs(options_folder) do
    if string.sub(o, -4) == ".lua" then
        table.insert(options, o)
    end
end

for i, s in ipairs(scripts_folder) do
    if string.sub(s, -4) == ".lua" then
        table.insert(options, s)
    end
end

term.clear()
term.setCursorPos(2, 2)

print("Launch script (arrow keys & enter)")

for i, o in ipairs(options) do
    term.setCursorPos(4, 2 + i * 2)
    print(string.sub(o, 1, #o-4))
end

Cursor = 1

function Move_cursor(direction)

    term.setCursorPos(2, 2 + Cursor)
    print(" ")

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

    term.setCursorPos(2, 2 + Cursor * 2)
    print(">")
end

Move_cursor(nil)

while true do
    local event, key = os.pullEvent("key")
    key = keys.getName(key)
    Move_cursor(key)
    if key == "enter" then
        term.clear()
        term.setCursorPos(1, 1)
        shell.run("scripts/" .. options[Cursor])
        break
    end
end

