
function Test()
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

return Test()