

function runShell(terminal)
    -- Save the original environment
    local originalTerm = term.current()

    -- Redirect terminal for the shell
    term.redirect(terminal)

    -- Initialize and run the shell
    local shellPath = "/rom/programs/advanced/multishell.lua"
    if fs.exists(shellPath) then
        shell = dofile(shellPath) -- Load and execute the shell script
    else
        print("Shell not found!")
    end

    -- Restore the original terminal environment after the shell exits
    term.redirect(originalTerm)
end

