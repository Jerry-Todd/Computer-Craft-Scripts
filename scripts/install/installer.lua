function Write_File(path, data)
    fs.delete(path)

    local file = fs.open(path, "w")

    if file then
        file.write(data) -- Write content to the file
        file.close() -- Close the file
        -- print("File created")
    else
        print("File failed to create")
    end
end

function Github_Download(path, githubPath)
    local url = "https://raw.githubusercontent.com/Jerry-Todd/Computer-Craft-Scripts/main/"
    local cacheBuster = os.epoch("utc") -- Get the current timestamp
    local file = http.get(url .. githubPath .. "?t=" .. cacheBuster)
    if file then
        file = file.readAll()
        -- print("Github / Got file: " .. githubPath)
        Write_File(path, file)
        print(" - " .. path)
    else
        print("Github / Cant get file: " .. githubPath)
    end
end

term.clear()
term.setCursorPos(1, 1)

fs.delete("scripts")

print("Creating shortcuts")

Write_File("scripts/options/Update.lua", "shell.run(\"scripts/install/installer.lua\")")
Write_File("scripts/options/Exit.lua", "term.clear()\nterm.setCursorPos(1,1)\nprint(\"Terminal\")")
Write_File("startup.lua", "shell.run(\"launch.lua\")")

print("Downloading Scripts")

Github_Download("scripts/install/installer.lua", "scripts/install/installer.lua")

-- indev 
Github_Download("scripts/dev/wcon.lua", "scripts/dev/wcon.lua")

-- production
Github_Download("scripts/Quary.lua", "scripts/quary.lua")
Github_Download("scripts/Digarea.lua", "scripts/digarea.lua")
Github_Download("scripts/Treefarm.lua", "scripts/treefarm.lua")

Github_Download("launch.lua", "scripts/launch.lua")

term.clear()
term.setCursorPos(1, 1)

print("Download complete.")
print("Update shortcut created.")
os.reboot()