
local scripts_folder = fs.list("scripts")

local scripts = {}

for i, script in ipairs(scripts_folder) do
    if string.sub(script, -4) == ".lua" then
        table.insert(scripts, script)
    end
end

term.clear()
term.setCursorPos(2, 2)

print("Launch script (arrow keys & enter)")

for i, script in ipairs(scripts) do
    term.setCursorPos(4, 2 + i * 2)
    print(script)
end

Cursor = 1

function Move_cursor(direction)

    term.setCursorPos(2, 2 + Cursor * 2)
    print(" ")

    if direction == "up" then
        Cursor = Cursor - 1
    elseif direction == "down" then
        Cursor = Cursor + 1
    end

    if Cursor < 1 then
        Cursor = #scripts
    elseif Cursor > #scripts then
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
        shell.run("scripts/" .. scripts[Cursor])
        break
    end
end

