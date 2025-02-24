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

fs.delete("wcon")

-- wcon 
Github_Download("wcon/client.lua", "scripts/wcon/wcon-client.lua")
Github_Download("wcon/remote.lua", "scripts/wcon/wcon-remote.lua")

term.clear()
term.setCursorPos(1, 1)

print("Download complete.")
