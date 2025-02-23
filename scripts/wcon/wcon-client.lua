while true do
    local modem = peripheral.find("modem") or error("No modem attached", 0)
    modem.open(16)
    print("Waiting for command...")
    repeat
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 16

    local inputs = textutils.unserialise(message) -- Inputs to simulate
    local inputIndex = 2

    local function inputHandler()
        sleep(0.2)     -- Ensure `read()` is fully active
        while inputIndex <= #inputs do
            sleep(0.2) -- Ensure `read()` is fully active

            -- Queue characters for the current input
            for char in inputs[inputIndex]:gmatch(".") do
                os.queueEvent("char", char)
            end
            os.queueEvent("key", keys.enter) -- Simulate pressing Enter

            inputIndex = inputIndex + 1      -- Move to the next input
        end
    end

    -- Run the script and handle input simultaneously
    parallel.waitForAll(
        function() shell.run(inputs[1]) end, -- Run the script
        inputHandler                     -- Handle inputs dynamically
    )
end
