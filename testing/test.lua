


print(fs.list(""))

print(shell.dir)

print(fs.getDir(shell.dir))

print(fs.exists("otherfile.lua"))

local file = dofile("testing.otherfile.lua")

file.hello()

