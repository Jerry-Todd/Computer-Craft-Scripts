Bar = require("UnityBar")
Shell = require("UnityShell")
API = require("UnityAPI")
WSS = require("UnityWSS")

-- Run Unity
local function main()
    term.clear()
    term.setCursorPos(1, 1)
    if not dofile("wss-checker.lua") then
        print("Unity aborted")
        return
    end
    sleep(2)
    term.clear()
    term.setCursorPos(1, 1)

    Processes = {}

    local termWidth, termHeight = term.getSize() -- Get terminal size
    local statusBar = window.create(term.native(), 1, termHeight, termWidth, 1)
    local terminal = window.create(term.native(), 1, 1, termWidth, termHeight - 1)
    term.redirect(terminal)

    loadAPI()

    Processes.UnityBar = coroutine.create(UnityBar)
    coroutine.resume(Processes.UnityBar)

    runShell()

    Processes.Websocket = coroutine.create(startWebsocket)
    coroutine.resume(Processes.Websocket)
    

end

-- Run the main function with cleanup
local ok, err = pcall(main)
if not ok then
    term.clear()
    printError("Unity encountered an error: " .. err)
end
unloadAPI()

