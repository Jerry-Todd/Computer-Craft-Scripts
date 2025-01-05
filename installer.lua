function Write_File(path, data)
    fs.delete(path)

    local file = fs.open(path, "w")

    if file then
        file.write(data) -- Write content to the file
        file.close() -- Close the file
        print("File created successfully!")
    else
        print("Failed to create the file.")
    end
end

function Github_Download(path, filename)
    local url = "https://raw.githubusercontent.com/Jerry-Todd/Computer-Craft-Scripts/main/"
    local cacheBuster = os.epoch("utc") -- Get the current timestamp
    local file = http.get(url .. filename .. "?t=" .. cacheBuster)
                     .readAll()
    Write_File(path, file)
    print(" - " .. path)
end

term.clear()
term.setCursorPos(1, 1)
print("Downloading assets. test")
Write_File("update.lua", 'shell.run("pastebin run myiZqrq6")')
print(" - " .. "update.lua")
Github_Download("unity.lua", "unity.lua")
Github_Download("wss-checker.lua", "wss-checker.lua")
Github_Download("api-test.lua", "api-test-program.lua")
print("Download complete.")