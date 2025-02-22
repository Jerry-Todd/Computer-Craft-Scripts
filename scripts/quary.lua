local depth = 0
local width = 0
local length = 0
local total = 0
local progress = 0
local layersLeft = 0

local function progressUpdate()
    progress = progress + 1
    term.clear()
    term.setCursorPos(1, 2)
    write('Operation progress: ')
    write(math.floor((progress / total) * 1000) / 10)
    write('\nBlocks left to mine: ')
    write(total - progress)
end

local function isFallingBlock(direction)
    local success = false
    if direction == "forward" then success = turtle.detect() end
    if direction == "up" then success = turtle.detectUp() end
    if direction == "down" then success = turtle.detectDown() end
    if success then
        return true
    end
    return false
end

local function dig(direction)
    if direction == "forward" then turtle.dig() end
    if direction == "up" then turtle.digUp() end
    if direction == "down" then turtle.digDown() end
    while isFallingBlock(direction) do
        if direction == "forward" then turtle.dig() end
        if direction == "up" then turtle.digUp() end
        if direction == "down" then turtle.digDown() end
    end
    progressUpdate()
end

local function Quary()
    local going_forward = true
    local y_pos = 1
    turtle.forward()
    dig("down")
    for y = 1, depth, 1 do
        turtle.down()
        dig("down")
        turtle.down()
        dig("down")
        for x = 1, width, 1 do
            for z = 1, length - 1, 1 do
                dig("forward")
                turtle.forward()
                dig("up")
                dig("down")
            end
            width = width + 0
            if x < width then
                if going_forward then
                    turtle.turnRight()
                else
                    turtle.turnLeft()
                end
                dig("forward")
                turtle.forward()
                dig("up")
                dig("down")
                if going_forward then
                    turtle.turnRight()
                else
                    turtle.turnLeft()
                end
                if going_forward then
                    going_forward = false
                else
                    going_forward = true
                end
            end
        end
        turtle.turnRight()
        turtle.turnRight()
        turtle.down()
        y_pos = y_pos + 3
        if y % 2 == 0 then
            for g = 1, y_pos, 1 do
                turtle.up()
            end
            turtle.back()
            turtle.turnLeft()
            for slot = 1, 16 do
                turtle.select(slot)
                turtle.drop()
            end
            turtle.turnRight()
            turtle.forward()
            for g = 1, y_pos, 1 do
                turtle.down()
            end
        end
    end
end

term.clear()
term.setCursorPos(1, 2)
print('[QUARY]')
write('Depth (multplied by 3): ')
depth = read()
write('Width: ')
width = read()
write('Length: ')
length = read()
write('Total blocks to mine: ')
total = width * length * (depth * 3)
print(total)
write('Type "yes" to confirm: ')
local confirm = read()
term.clear()
term.setCursorPos(1, 2)
if confirm == "yes" then
    Quary()
    term.clear()
    term.setCursorPos(1, 2)
    write('Operation complete.\n')
else
    write('Operation canceled\n')
end
