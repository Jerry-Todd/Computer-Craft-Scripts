-- local termWidth, termHeight = term.getSize() -- Get terminal size
-- local statusBar = window.create(term.native(), 1, termHeight, termWidth, 1)
-- local terminal = window.create(term.native(), 1, 1, termWidth, termHeight - 2)

-- term.redirect(terminal)

-- Unity = coroutine.create(function()
--     while true do
--         local previousTerm = term.redirect(statusBar)
--         term.setBackgroundColor(colors.white)
--         term.clear()
--         term.redirect(previousTerm)
--     end
-- end)

-- coroutine.resume(Unity)



-- Get terminal size
local termWidth, termHeight = term.getSize()

-- Create a status bar at the bottom of the terminal
local statusBar = window.create(term.native(), 1, termHeight, termWidth, 1)

-- Create a terminal window that excludes the last line for the status bar
local terminal = window.create(term.native(), 1, 1, termWidth, termHeight - 1)

-- Redirect the main terminal to this smaller window
term.redirect(terminal)

-- Define the Unity coroutine to manage the status bar
Unity = coroutine.create(function()
    while true do
        local previousTerm = term.redirect(statusBar)
        term.setBackgroundColor(colors.white) -- Status bar background color
        term.setTextColor(colors.black)       -- Status bar text color
        term.clear()

        -- Draw some content on the status bar (e.g., time, status message)
        term.setCursorPos(1, 1)
        term.write("Status: Everything is OK")
        
        term.redirect(previousTerm)

        -- Yield for a short time to prevent excessive CPU usage
        sleep(0.1)
    end
end)

-- Start the Unity coroutine
coroutine.resume(Unity)

-- Example usage in the main terminal
print("This is the main terminal.")
for i = 1, 50 do
    print("Line " .. i)
    sleep(0.1) -- Simulate slow output
end
