

term.clear()
term.setCursorPos(1, 2)
print('[STRIP DIG]')
print('Will dig a 1 wide 3 tall tunnel forward')
write('Distance: ')
local distance = read()

function DigVertical()
    while turtle.detectUp() do
        turtle.digUp()
    end
    while turtle.detectDown() do
        turtle.digDown()
    end
end

function DigForward()
    while turtle.detect() do
        turtle.dig()
    end
end

for i = 1, distance do
    DigForward()
    turtle.forward()
    DigVertical()
end