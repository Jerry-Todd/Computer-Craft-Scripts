
local path = fs.getDir(shell.getRunningProgram())

local file = dofile(path.."/otherfile.lua")

file.hello()

