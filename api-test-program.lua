


if _G.Unity then
    print(_G.Unity.active)
    _G.Unity.setStatus("API test Success")
    print("API test failed")
    return
end
print("API test failed")