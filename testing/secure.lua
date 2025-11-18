
print("Securely running script")

local w, h = term.getSize()

local args = {...}

local permissions = {
    viewFiles = false,
    readFiles = false
}

function copy(orig)
    local copy = {}
    for k, v in pairs(orig) do
        copy[k] = v
    end
    return copy
end

local customShell = copy(shell)
local customFs = copy(fs)

function prompt(...)
    local c = term.getTextColor()
    term.setTextColor(colors.yellow)
    for i, v in ipairs({...}) do
        print(v)
    end
    write("Allow?  y/N: ")
    term.setTextColor(c)
    local input = read()
    if input == 'y' or input == 'Y' then
        return true
    end
    term.setTextColor(colors.blue)
    print("Attempt blocked")
    term.setTextColor(c)
    return false
end

customShell.run = function(command, ...)
    local args = {...}
    if prompt(
        "Program attempts to run:",
        command .. " " .. table.concat(args, " ")
    ) then
        shell.run(command, table.unpack(args))
    else
        return false
    end
end

customFs.makeDir = function(...)
    local args = {...}
    if prompt(
        "Program attempts makeDir with:",
        table.concat(args, " ")
    ) then
        return fs.makeDir(...)
    else
        return false
    end
end

local env = {
    shell = customShell,
    fs = customFs
}
setmetatable(env, { __index = _G })
local filename = args[1]
if not filename:match("%.lua$") then
    filename = filename .. ".lua"
end
local fn = loadfile(filename)
setfenv(fn, env)
fn()