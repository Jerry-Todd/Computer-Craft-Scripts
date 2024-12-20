-- pastebin run QyUNCc93
term.clear()
local termWidth, termHeight = term.getSize() -- Get terminal size
-- Create a window for multishell (all lines except the bottom one)
local multishellWindow = window.create(term.native(), 1, 1, termWidth, termHeight - 1)
term.redirect(multishellWindow)

local unityWindow = window.create(term.native(), 1, termHeight, termWidth, 1)
function SetUnityStatus(text)
    local previousTerm = term.redirect(unityWindow)
    term.setBackgroundColor(colors.gray)
    term.clear()
    term.setCursorPos(1, 1)
    term.write("Unity - ")
    term.write(text)
    term.redirect(multishellWindow)
end
SetUnityStatus("Attempting connection")
term.setBackgroundColor(colors.red)
term.setCursorPos(1,1)

local url = "ws://localhost:3000"
print("Connecting to WebSocket:", url)

local ws, err = http.websocket(url)
if not ws then
    term.clear()
    print("Unity failed to connect:", err)
    return
end

SetUnityStatus("Connected")

-- Send a message
ws.send("Turtle connected")

-- Listen for messages
while true do
    local event, url, message = os.pullEvent("websocket_message")
    if message then
        local data = textutils.unserializeJSON(message)
        print(data.message)
        if message == "exit" then
            break
        end
    end
end

-- Close the connection
ws.close()
print("Disconnected!")