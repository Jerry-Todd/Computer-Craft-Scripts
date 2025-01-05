


if _G.Unity ~= nil then
    print(_G.Unity.active)
    _G.Unity.setText("API test Success")
    print("API test failed")
    return
end
print("API test failed")