local termWidth, termHeight = term.getSize() -- Get terminal size
-- Create a window for multishell (all lines except the bottom one)
local multishellWindow = window.create(term.current(), 1, 1, termWidth, termHeight - 1)
term.redirect(multishellWindow)

local unityWindow = window.create(term.current)
function SetUnityStatus(text)
    unityWindow.term.setBackroundColor(colors.gray)
    unityWindow.term.clear()
    unityWindow.term.setCursorPos(1, 1)
    unityWindow.term.write("Unity - ")
    unityWindow.term.write("text")
end
SetUnityStatus("Attempting Connection")

local url = "ws://localhost:3000"
print("Connecting to WebSocket:", url)

local ws, err = http.websocket(url)
if not ws then
    SetUnityStatus("Unity failed to connect")
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
        print("Received:", message)
        if message == "exit" then
            break
        end
    end
end

-- Close the connection
ws.close()
print("Disconnected!")