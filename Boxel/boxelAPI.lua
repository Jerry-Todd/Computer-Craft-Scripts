
local monitor = peripheral.find("monitor")
monitor.setTextScale(0.5)
monitor.clear()
monitor.setCursorPos(1, 1)
logline = 0
function Log(m)
    local og = term.current()
    term.redirect(monitor)
    logline = logline + 1
    print(logline .. ': ' .. tostring(m))
    term.redirect(og)
end



local M = {}

Items = {}
ItemsBasic = {}
ChestCache = {}
Chests = { peripheral.find('minecraft:chest') }
Log(#Chests)

local Interface = peripheral.getName(peripheral.find('minecraft:barrel'))

-- Item data template
-- {
--     ["minecraft:diamond"] = {
--         total = 35,
--         chests = {
--             [1] = {
--                 [14] = 35
--             }
--         }
--     }
-- }

-- Create basic item list
function M.ItemList()
    ItemsBasic = nil
    for i, item in ipairs(Items) do
        ItemsBasic[item] = item.count
    end
end

-- Read chest and store items
local function GetChestItemData(chest, ID)
    -- Remove all existing data for this chest from items array
    for itemName, itemData in pairs(Items) do
        if itemData.chests and itemData.chests[tostring(ID)] then
            -- Subtract this chest's contribution from the total
            for slot, count in pairs(itemData.chests[tostring(ID)]) do
                itemData.total = itemData.total - count
            end
            -- Remove this chest's data
            itemData.chests[tostring(ID)] = nil

            -- If no chests remain for this item, remove the item entirely
            if next(itemData.chests) == nil then
                Items[itemName] = nil
            end
        end
    end

    -- Loop through items in chest
    local list = chest.list()
    -- print(textutils.serialiseJSON(list))
    for slot, item in pairs(list) do
        local key = item.name
        if not Items[key] then
            Items[key] = { total = 0, chests = {} }
        end
        Items[key].total = Items[key].total + item.count
        if not Items[key].chests[tostring(ID)] then
            Items[key].chests[tostring(ID)] = {}
        end
        Items[key].chests[tostring(ID)][tostring(slot)] = item.count
    end
end

-- Watch chests for changes
function M.CheckChests(onChange)
    -- Create a copy of Chests to avoid issues if it changes during iteration
    local ChestsCopy = {}
    for i, chest in pairs(Chests) do
        ChestsCopy[i] = chest
    end
    for i, chest in pairs(ChestsCopy) do
        local chest_data = textutils.serialiseJSON(chest.list())
        local cache_data = ""
        if ChestCache[i] then
            cache_data = textutils.serialiseJSON(ChestCache[i])
        end
        if chest_data ~= cache_data then
            Log("chest update")
            GetChestItemData(chest, i)
            ChestCache[i] = chest.list()
            if onChange then onChange() end
        end
    end
end

-- Take stack
function M.TakeStack(name)
    Log('taking ' .. name)
    Log(Interface)
    -- Check if item exists in our Items array
    if not Items[name] then
        Log('none found')
        return nil, "Item not found"
    end

    local itemData = Items[name]
    local targetAmount = 64 -- Standard stack size
    local takenAmount = 0

    -- Use stored locations in Items table directly
    for chestID, slots in pairs(itemData.chests) do
        if takenAmount >= targetAmount then
            Log('enough')
            break -- We've taken enough
        end
        local chest = Chests[tonumber(chestID)]
        local chestName = peripheral.getName(chest)
        if chest and chestName then
            for slot, count in pairs(slots) do
                if takenAmount >= targetAmount then
                    Log('Done with chest early')
                    break
                end
                local needed = targetAmount - takenAmount
                local toTake = math.min(needed, count)
                -- Use peripheral.call to transfer items
                local taken = chest.pushItems(Interface, tonumber(slot), toTake)
                -- local taken = peripheral.call(chestName, "pushItems", Interface, tonumber(slot), toTake)
                Log('chest: '..chestName..' slot: '..slot..' toTake: '..toTake..' taken: '..tostring(taken))
                if taken > 0 then
                    takenAmount = takenAmount + taken
                end
            end
        end
    end
    Log('Total taken: '..takenAmount)
    -- Let WatchChests() handle updating the Items array when it detects the changes
    return takenAmount
end

-- Deposit all item
function M.DepositAll()
    local interfacePeripheral = peripheral.wrap(Interface)
    if not interfacePeripheral then
        Log('Interface not found')
        return 0
    end
    
    local totalDeposited = 0
    
    -- Keep looping until the interface is empty
    while true do
        local interfaceItems = interfacePeripheral.list()
        local hasItems = false
        
        -- Check each slot in the interface
        for slot, item in pairs(interfaceItems) do
            hasItems = true
            local itemName = item.name
            local deposited = false
            
            -- First, try to deposit in chests that already have this item
            if Items[itemName] and Items[itemName].chests then
                for chestID, chestSlots in pairs(Items[itemName].chests) do
                    local moved = interfacePeripheral.pushItems(peripheral.getName(Chests[tonumber(chestID)]), tonumber(slot))
                    if moved and moved > 0 then
                        Log('Deposited '..tostring(moved)..' '..itemName..' into chest '..tostring(chestID))
                        totalDeposited = totalDeposited + moved
                        deposited = true
                        break
                    end
                end
            end
            
            -- If not deposited yet, try any available chest
            if not deposited then
                for id, chest in ipairs(Chests) do
                    local chestName = peripheral.getName(chest)
                    if chestName then
                        local moved = interfacePeripheral.pushItems(chestName, tonumber(slot))
                        if moved and moved > 0 then
                            Log('Deposited '..tostring(moved)..' '..itemName..' into chest '..tostring(id))
                            totalDeposited = totalDeposited + moved
                            deposited = true
                            break
                        end
                    end
                end
            end
            
            -- If still couldn't deposit, the storage is full
            if not deposited then
                Log('Storage full! Could not deposit '..itemName)
            end
        end
        
        -- If no items were found in the interface, we're done
        if not hasItems then
            break
        end
    end
    
    Log('Total deposited: '..totalDeposited)
    return totalDeposited
end

-- Makes item name pretty
function M.DisplayName(name)
    -- Remove everything before the colon (:) in the item name
    local display_key = name
    local colon_pos = string.find(display_key, ":")
    if colon_pos then
        display_key = string.sub(display_key, colon_pos + 1)
    end

    -- Replace underscores with spaces
    display_key = string.gsub(display_key, "_", " ")

    -- Capitalize the first letter
    if #display_key > 0 then
        display_key = string.upper(string.sub(display_key, 1, 1)) .. string.sub(display_key, 2)
    end

    return display_key
end

-- Getter functions to access current data
function M.GetItems()
    return Items
end

function M.GetChestCache()
    return ChestCache
end

function M.ClearCache()
    ChestCache = {}
end

function M.GetChests()
    return Chests
end

return M
