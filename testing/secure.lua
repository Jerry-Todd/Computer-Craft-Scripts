
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
local customPeripheral = copy(peripheral)

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
    
    -- Special handling for "wget run"
    if command == "wget" and args[1] == "run" and args[2] then
        if prompt(
            "Program attempts to download and run:",
            args[2]
        ) then
            -- Download to a temporary file
            local tempFile = ".secure_temp_" .. os.epoch("utc")
            local success = shell.run("wget", args[2], tempFile)
            
            if success and fs.exists(tempFile) then
                -- Run in secure environment
                os.run(env, tempFile)
                -- Clean up
                fs.delete(tempFile)
            else
                print("Download failed")
                return false
            end
        else
            return false
        end
    else
        -- Normal command handling
        if prompt(
            "Program attempts to run:",
            command .. " " .. table.concat(args, " ")
        ) then
            shell.run(command, table.unpack(args))
        else
            return false
        end
    end
end

customFs.makeDir = function(...)
    local args = {...}
    if prompt(
        "Program attempts fs.makeDir with:",
        table.concat(args, " ")
    ) then
        return fs.makeDir(...)
    else
        return false
    end
end

customFs.move = function(...)
    local args = {...}
    if prompt(
        "Program attempts fs.move with:",
        table.concat(args, " ")
    ) then
        return fs.move(...)
    else
        return false
    end
end

customFs.copy = function(...)
    local args = {...}
    if prompt(
        "Program attempts fs.copy with:",
        table.concat(args, " ")
    ) then
        return fs.copy(...)
    else
        return false
    end
end

customFs.delete = function(...)
    local args = {...}
    if prompt(
        "Program attempts fs.delete with:",
        table.concat(args, " ")
    ) then
        return fs.delete(...)
    else
        return false
    end
end

customFs.open = function(...)
    local args = {...}
    if prompt(
        "Program attempts fs.open with:",
        table.concat(args, " ")
    ) then
        return fs.open(...)
    else
        return false
    end
end

customPeripheral.call = function(...)
    local args = {...}
    if prompt(
        "Program attempts peripheral.call with:",
        table.concat(args, " ")
    ) then
        return peripheral.call(...)
    else
        return false
    end
end

local env = {
    shell = customShell,
    fs = customFs,
    peripheral = customPeripheral,
    require = require
}
local filename = args[1]
if not filename:match("%.lua$") then
    filename = filename .. ".lua"
end
os.run(env, filename)