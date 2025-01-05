-- Check for ability to use websockets ---------------------------------------
term.clear()
term.setCursorPos(1, 1)
if not dofile("wss-checker.lua") then
    print("Unity aborted")
    return
end
sleep(2)
term.clear()
term.setCursorPos(1, 1)

-- Create seperate windows
local termWidth, termHeight = term.getSize() -- Get terminal size
local statusBar = window.create(term.native(), 1, termHeight, termWidth, 1)
local terminal = window.create(term.native(), 1, 1, termWidth, termHeight - 1)
term.redirect(terminal)

-- Create Unity API functions -------------------------------------------------

Unity = {}

Unity.active = true

Unity.BarText = ""

function Unity.setText(text)
    Unity.BarText = text
end

_G.Unity = Unity


-- Handle Unity Statusbar rendering -------------------------------------------

Unity = coroutine.create(function()
    while true do
        local previousTerm = term.redirect(statusBar)

        term.setBackgroundColor(colors.white)
        term.clear()
        term.setCursorPos(1, termHeight)
        term.setTextColor(colors.black)
        term.write("Unity / " .. Unity.BarText)

        term.redirect(previousTerm)

        -- Yield for a short time to prevent excessive CPU usage
        sleep(0.1)
    end
end)
coroutine.resume(Unity)



-- Initialize multishell in terminal window -----------------------------------
local function runShell()
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

-- Run the shell in the top terminal window
runShell()

-- HANDLE WEBSOCKET ------------------------------------------------------------
local url = "ws://localhost:3000"
print("Connecting to WebSocket:", url)

local ws, err = http.websocket(url)
if not ws then
    print("Failed to connect:", err)
    return
end

print("Connected!")

-- Send a message
ws.send("Turtle connected")

-- Listen for messages
while true do
    local event, url, message = os.pullEvent("websocket_message")
    if message then
        print("Received:", message)
        if message == "exit" then
            break
        end
    end
end

-- Close the connection
ws.close()
print("Disconnected!")


