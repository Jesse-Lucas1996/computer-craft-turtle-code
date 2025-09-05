local modem = peripheral.find("modem") or error("No modem attached")
modem.open(1)

local turtleId = os.getComputerID()
local currentStatus = "idle"

function Main()
    print("Turtle " .. turtleId .. " mining server started")
    
    RegisterWithClient()
    
    while true do
        local event, side, channel, replyChannel, message = os.pullEvent("modem_message")
        
        if type(message) == "table" and message.target == turtleId then
            if message.command == "mine" then
                currentStatus = "mining"
                SendStatus("mining")
                
                local success = MineAtLocation(message.location)
                
                if success then
                    currentStatus = "idle"
                    SendStatus("completed")
                else
                    currentStatus = "idle"
                    SendStatus("error", "Failed to complete mining")
                end
            end
        end
        
        sleep(0.1)
    end
end

function RegisterWithClient()
    modem.transmit(1, 1, {
        type = "register",
        id = turtleId
    })
    print("Registered with mining client")
end

function SendStatus(status, error)
    modem.transmit(1, 1, {
        type = "status",
        id = turtleId,
        status = status,
        error = error
    })
end

function MineAtLocation(location)
    print("Starting mining operation at X:" .. location.x .. " Y:" .. location.y .. " Z:" .. location.z)
    
    if not MoveToLocation(location) then
        print("Failed to reach mining location")
        return false
    end
    
    local blocksMinned = 0
    for dy = 0, -10, -1 do
        local mineY = location.y + dy
        
        if not MoveToLocation({x = location.x, y = mineY, z = location.z}) then
            print("Could not reach Y level " .. mineY)
            break
        end
        
        if turtle.dig() then
            blocksMinned = blocksMinned + 1
        end
        
        for dx = -1, 1 do
            for dz = -1, 1 do
                if dx ~= 0 or dz ~= 0 then
                    local targetPos = {
                        x = location.x + dx,
                        y = mineY,
                        z = location.z + dz
                    }
                    
                    if MoveToLocation(targetPos) then
                        if turtle.dig() then
                            blocksMinned = blocksMinned + 1
                        end
                    end
                end
            end
        end
    end
    
    print("Mining completed. Blocks mined: " .. blocksMinned)
    return true
end

function MoveToLocation(location)
    local targetX, targetY, targetZ = location.x, location.y, location.z
    print("Moving to coordinates: X:" .. targetX .. " Y:" .. targetY .. " Z:" .. targetZ)

    local currentX, currentY, currentZ = gps.locate()
    if not currentX then
        print("Error: Could not determine current position")
        return false
    end

    local deltaX = targetX - currentX
    local deltaY = targetY - currentY
    local deltaZ = targetZ - currentZ

    print("Distance to travel: X:" .. deltaX .. " Y:" .. deltaY .. " Z:" .. deltaZ)

    if deltaX > 0 then
        FaceDirection(1, 0)
        for i = 1, deltaX do
            while not turtle.forward() do
                turtle.dig()
            end
        end
    elseif deltaX < 0 then
        FaceDirection(-1, 0)
        for i = 1, math.abs(deltaX) do
            while not turtle.forward() do
                turtle.dig()
            end
        end
    end

    if deltaZ > 0 then
        FaceDirection(0, 1)
        for i = 1, deltaZ do
            while not turtle.forward() do
                turtle.dig()
            end
        end
    elseif deltaZ < 0 then
        FaceDirection(0, -1)
        for i = 1, math.abs(deltaZ) do
            while not turtle.forward() do
                turtle.dig()
            end
        end
    end

    if deltaY > 0 then
        for i = 1, deltaY do
            while not turtle.up() do
                turtle.digUp()
            end
        end
    elseif deltaY < 0 then
        for i = 1, math.abs(deltaY) do
            while not turtle.down() do
                turtle.digDown()
            end
        end
    end

    local finalX, finalY, finalZ = gps.locate()
    if finalX == targetX and finalY == targetY and finalZ == targetZ then
        print("Successfully arrived at target location!")
        return true
    else
        print("Warning: Did not reach exact target. Current position: X:" .. finalX .. " Y:" .. finalY .. " Z:" .. finalZ)
        return false
    end
end

function FaceDirection(dx, dz)
    local x1, _, z1 = gps.locate()
    turtle.forward()
    local x2, _, z2 = gps.locate()
    turtle.back()

    local currentDx = x2 - x1
    local currentDz = z2 - z1

    local turns = 0
    if currentDx == 1 and currentDz == 0 then
        if dx == 0 and dz == 1 then turns = 1 end
        if dx == -1 and dz == 0 then turns = 2 end
        if dx == 0 and dz == -1 then turns = 3 end
    elseif currentDx == 0 and currentDz == 1 then
        if dx == -1 and dz == 0 then turns = 1 end
        if dx == 0 and dz == -1 then turns = 2 end
        if dx == 1 and dz == 0 then turns = 3 end
    elseif currentDx == -1 and currentDz == 0 then
        if dx == 0 and dz == -1 then turns = 1 end
        if dx == 1 and dz == 0 then turns = 2 end
        if dx == 0 and dz == 1 then turns = 3 end
    elseif currentDx == 0 and currentDz == -1 then
        if dx == 1 and dz == 0 then turns = 1 end
        if dx == 0 and dz == 1 then turns = 2 end
        if dx == -1 and dz == 0 then turns = 3 end
    end

    for i = 1, turns do
        turtle.turnRight()
    end
end

Main()