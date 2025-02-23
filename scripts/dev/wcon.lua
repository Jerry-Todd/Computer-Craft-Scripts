local inputs = { "Steve", "18", "Blue" } -- Inputs to simulate
local inputIndex = 1

local function inputHandler()
    sleep(1) -- Ensure `read()` is fully active
    while inputIndex <= #inputs do
            sleep(1) -- Ensure `read()` is fully active

            -- Queue characters for the current input
            for char in inputs[inputIndex] do
                os.queueEvent("char", char)
            end
            os.queueEvent("key", keys.enter) -- Simulate pressing Enter

            inputIndex = inputIndex + 1 -- Move to the next input
    end
end

-- Run the script and handle input simultaneously
parallel.waitForAny(
    function() shell.run("scripts/digarea.lua") end, -- Run the script
    inputHandler -- Handle inputs dynamically
)
