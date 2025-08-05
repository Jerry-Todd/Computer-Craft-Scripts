local M = {}

function M.getChests()
    local containers = { peripheral.find('minecraft:chest') }

    if #containers == 0 then
        error('No containers connected', 0)
    end

    return containers
end

function M.getInterface()
    local interface = peripheral.find('minecraft:barrel')

    if not interface then
        error('No interface barrel connected', 0)
    end

    return interface
end

function M.GetAllItems()
    local containers = M.getChests()
    local items = {}
    for i, c in pairs(containers) do
        local list = c.list()
        for slot, item in pairs(list) do
            local key = item.name
            if items[key] then
                items[key] = items[key] + item.count
            else
                items[key] = item.count
            end
        end
    end
    return items
end

function M.TakeItem(targetItem, quantity)
    local containers = M.getChests()
    local interface = M.getInterface()
    local interfaceName = peripheral.getName(interface)
    local totalMoved = 0
    
    quantity = quantity or 64
    
    for i, c in pairs(containers) do
        if totalMoved >= quantity then break end
        
        local list = c.list()
        for slot, item in pairs(list) do
            if totalMoved >= quantity then break end
            
            if item.name == targetItem then
                local toMove = math.min(item.count, quantity - totalMoved)
                local moved = c.pushItems(interfaceName, slot, toMove)
                totalMoved = totalMoved + moved
            end
        end
    end
    
    return totalMoved
end

return M
