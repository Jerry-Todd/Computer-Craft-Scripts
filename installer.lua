

function Write_File(path, data)
    
    fs.delete("installer.lua")

    local file = fs.open(path, "w")

    if file then
        file.write(data) -- Write content to the file
        file.close()                        -- Close the file
        print("File created successfully!")
    else
        print("Failed to create the file.")
    end
end



print("Hello World!")
