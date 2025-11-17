function Write_File(path, data)
    fs.delete(path)

    local file = fs.open(path, "w")

    if file then
        file.write(data) -- Write content to the file
        file.close()     -- Close the file
        print(" - " .. path)
        return true
    end

    print("File failed to create")
    return false
end

function Github_Download(path, githubPath)
    local url = "https://raw.githubusercontent.com/Jerry-Todd/Computer-Craft-Scripts/main/"
    local cacheBuster = os.epoch("utc") -- Get the current timestamp
    local file = http.get(url .. githubPath .. "?t=" .. cacheBuster)
    if file then
        file = file.readAll()
        if not Write_File(path, file) then return false end
        return true
    else
        print("Github / Cant get file: " .. githubPath)
        return false
    end
end

if Github_Download("boxel.lua","Boxel/boxel.lua") then
    print("Boxel installed")
else
    print("Boxel failed to install")
end