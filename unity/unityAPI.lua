

local API = {}

function API.load()
    if not _G.Unity then
        _G.Unity = {}
    end
    
    local Unity = _G.Unity -- Shortcut for convenience
    Unity.active = true
    Unity.barText = ""
end

-- Cleanup Function
function API.unload()
    _G.Unity = nil -- Remove Unity from the global scope
end

return API