



function loadAPI()
    if not _G.Unity then
        _G.Unity = {}
    end
    
    local Unity = _G.Unity -- Shortcut for convenience
    Unity.active = true
    Unity.barText = ""
end

-- Cleanup Function
function unloadAPI()
    _G.Unity = nil -- Remove Unity from the global scope
end