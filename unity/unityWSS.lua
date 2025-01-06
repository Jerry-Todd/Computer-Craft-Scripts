local Websocket = {}

function Websocket.start()
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
end

function Websocket.test()
    local url = "wss://echo.websocket.org"

    print("Checking websocket permission...")
    print("Testing WebSocket connection to:", url)

    -- Attempt to open a WebSocket connection
    local ok, websocket = pcall(http.websocket, url)

    if ok and websocket then
        print("WebSocket connection successful!")
        websocket.close()
        return true
    else
        print("Failed to connect to WebSocket.")
        return false
    end
end

return Websocket