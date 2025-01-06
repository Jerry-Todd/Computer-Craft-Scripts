
local path = fs.getDir(shell.getRunningProgram())

print(fs.list(""))

print(path)

print(fs.exists("otherfile.lua"))

local file = dofile("testing.otherfile.lua")

file.hello()

