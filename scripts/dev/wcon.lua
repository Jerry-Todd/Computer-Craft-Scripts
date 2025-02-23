local inputs = { "Steve", "18", "Blue" } -- Inputs to simulate
local inputIndex = 1

local function inputHandler()
    while inputIndex <= #inputs do
        local event, data = os.pullEvent() -- Wait for any event

        if event == "term_write" then -- Detect when `read()` is waiting
            sleep(0.1) -- Ensure `read()` is fully active

            -- Queue characters for the current input
            for char in inputs[inputIndex]:gmatch(".") do
                os.queueEvent("char", char)
            end
            os.queueEvent("key", keys.enter) -- Simulate pressing Enter

            inputIndex = inputIndex + 1 -- Move to the next input
        end
    end
end

-- Run the script and handle input simultaneously
parallel.waitForAny(
    function() shell.run("scripts/digarea.lua") end, -- Run the script
    inputHandler -- Handle inputs dynamically
)
