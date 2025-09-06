local myURL = "ws s://192.168.0.124:8080"
local ws = http.websocket(myURL)

if ws then
    print("Connected to " .. myURL)
    while true do
        local event, url, message = os.pullEvent()
        if event == "websocket_message" and url == myURL then
            print("Received: " .. message)
            if peripheral.isPresent("top") then
                peripheral.call("top", "write", ImageDataToMonitorString(message))
            end
        elseif event == "websocket_closed" and url == myURL then
            print("Connection closed by server.")
            break
        elseif event == "key" then
            print("Closing connection...")
            ws.close()
            break
        end
    end
else
    print("Failed to connect to " .. myURL)
end

function ImageDataToMonitorString(imageData)
    local colorChars = "0123456789abcdef"
    local result = ""
    for i = 1, #imageData do
        local colorIndex = imageData[i] % 16
        result = result .. colorChars:sub(colorIndex + 1, colorIndex + 1)
    end
    return result
end
