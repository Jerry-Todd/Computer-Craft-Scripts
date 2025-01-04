local termWidth, termHeight = term.getSize() -- Get terminal size
local statusBar = window.create(term.native(), 1, termHeight, termWidth, 1)
local terminal = window.create(term.native(), 1, 1, termWidth, termHeight - 1)

term.redirect(terminal)

Unity = coroutine.create(function()
    while true do
        local previousTerm = term.redirect(statusBar)
        term.setBackgroundColor(colors.white)
        term.clear()
        term.redirect(previousTerm)
        term.setCursorPos(1, 1)
        term.write("Status: Everything is OK")

        term.redirect(previousTerm)

        -- Yield for a short time to prevent excessive CPU usage
        sleep(0.1)
    end
end)

coroutine.resume(Unity)

-- Properly initialize the shell in the new terminal window
local function runShell()
    -- Save the original environment
    local originalTerm = term.current()

    -- Redirect terminal for the shell
    term.redirect(terminal)

    -- Initialize and run the shell
    local shellPath = "/rom/programs/shell.lua"
    if fs.exists(shellPath) then
        shell = dofile(shellPath) -- Load and execute the shell script
    else
        print("Shell not found!")
    end

    -- Restore the original terminal environment after the shell exits
    term.redirect(originalTerm)
end

-- Run the shell in the top terminal window
runShell()