function Write_File(path, data)
    fs.delete(path)

    local file = fs.open(path, "w")

    if file then
        file.write(data) -- Write content to the file
        file.close()     -- Close the file
        print(" - " .. path)
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
        -- print(" - " .. path)
    else
        print("Github / Cant get file: " .. githubPath)
    end
end

term.clear()
term.setCursorPos(1, 1)

fs.delete("chestman")

print("Downloading chestman...")

-- files
Github_Download("chestman/chestman.lua", "chestman/chestman.lua")
Github_Download("chestman/test.lua", "chestman/test.lua")
Github_Download("chestman/modules/chests.lua", "chestman/modules/chests.lua")
Github_Download("chestman/modules/deposit.lua", "chestman/modules/deposit.lua")
Github_Download("chestman/modules/gui-util.lua", "chestman/modules/gui-util.lua")
Github_Download("chestman/modules/search.lua", "chestman/modules/search.lua")

print("Installing chestman...")

Write_File("update.lua", "shell.run(\"pastebin run S8Le2YvJ\")")

sleep(1)

term.clear()
term.setCursorPos(1, 1)

print("Download complete.")
print("Update shortcut created.")
print("Rebooting...")
sleep(2)
os.reboot()
