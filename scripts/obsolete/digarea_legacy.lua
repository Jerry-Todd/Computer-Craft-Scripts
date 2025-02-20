
local depth = 0
local width = 0
local height = 0
local total = 0
local progress = 0
local layersLeft = 0

local function progressUpdate()
    progress = progress + 1
    term.clear()
    term.setCursorPos(1,2)
    write('Operation progress: ')
    write(math.floor((progress/total)*1000)/10)
    write('%\nLayers left to mine: ')
    write(layersLeft)
    write('\nBlocks left to mine: ')
    write(total-progress)
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

local function Excavate()
    local atTop = false
    local atRight = false
    for z = 1, depth, 1 do
        layersLeft = depth - z
        dig("forward")
        turtle.forward()
        if atRight then
            turtle.turnLeft()
        else
            turtle.turnRight()
        end
        for y = 1, height, 1 do
            for x = 1, width - 1, 1 do
                dig("forward")
                turtle.forward()
            end
            height = height + 0
            if y < height then
                if atTop then
                    dig("down")
                    turtle.down()
                else
                    dig("up")
                    turtle.up()
                end
                turtle.turnRight()
                turtle.turnRight()
            end
            atRight = not atRight
        end
        if atRight then
            turtle.turnLeft()
        else
            turtle.turnRight()
        end
        atTop = not atTop
    end
end

term.clear()
term.setCursorPos(1,2)
print('[EXCAVATOR] <Outdated method>')
print('! Support for this script may be limited !')
write('Depth: ')
depth = read()
write('Width: ')
width = read()
write('Height: ')
height = read()
write('Total blocks to mine: ')
total = width*height*depth
print(total)
write('Type "yes" to confirm: ')
local confirm = read()
term.clear()
term.setCursorPos(1,2)
if confirm == "yes" then
    Excavate()
    term.clear()
    term.setCursorPos(1,2)
    write('Operation complete.\n')
else
    write('Operation canceled\n')
end
