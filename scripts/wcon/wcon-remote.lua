

args = {...}

local modem = peripheral.find("modem") or error("No modem attached", 0)

modem.transmit(16, 17, textutils.serialise(args)) -- Send the inputs to the server