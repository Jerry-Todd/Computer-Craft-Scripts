
local monitor = peripheral.find("monitor")
monitor.setTextScale(0.5)
monitor.clear()
monitor.setCursorPos(1, 1)
function Log(m)
    local og = term.current()
    term.redirect(monitor)
    print(m)
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
    for i, chest in pairs(Chests) do
        local chest_data = textutils.serialiseJSON(chest.list())
        local cache_data = ""
        if ChestCache[i] then
            cache_data = textutils.serialiseJSON(ChestCache[i])
        end
        if chest_data ~= cache_data then
            -- print("Chest "..i.." changed")
            GetChestItemData(chest, i)
            ChestCache[i] = chest.list()
            if onChange then onChange() end -- Call the callback
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

    -- Loop through chests that contain this item
    for chestID, slots in pairs(itemData.chests) do
        Log(chestID)
        if takenAmount >= targetAmount then
            Log('enough')
            break -- We've taken enough
        end

        local chest = Chests[chestID]
        if chest then
            Log('chest exists')
            -- Loop through slots in this chest
            for slot, count in pairs(slots) do
                Log('slot '..slot)
                if takenAmount >= targetAmount then
                    Log('Done with chest early')
                    break
                end

                local needed = targetAmount - takenAmount
                local toTake = math.min(needed, count)

                -- Attempt to take items from this slot
                local taken = chest.pushItems(Interface, slot, toTake)
                Log(taken)
                if taken > 0 then
                    Log('Items taken successfully')
                    takenAmount = takenAmount + taken
                end
            end
        end
    end
    Log(takenAmount)
    -- Let WatchChests() handle updating the Items array when it detects the changes
    return takenAmount
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

function M.GetChests()
    return Chests
end

return M
