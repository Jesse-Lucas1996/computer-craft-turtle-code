local modem = peripheral.find("modem") or error("No modem attached")
modem.open(1)

local activeTurtles = {}
local miningQueue = {}

function Main()
    print("Mining Control Client Started")
    print("Commands: 'add <x> <y> <z>' to add mining location, 'status' for turtle status, 'quit' to exit")
    
    while true do
        write("> ")
        local input = read()
        local command = string.match(input, "^(%w+)")
        
        if command == "add" then
            local x, y, z = string.match(input, "add (%S+) (%S+) (%S+)")
            if x and y and z then
                AddMiningLocation(tonumber(x), tonumber(y), tonumber(z))
            else
                print("Usage: add <x> <y> <z>")
            end
        elseif command == "status" then
            ShowTurtleStatus()
        elseif command == "quit" then
            print("Shutting down mining operations...")
            break
        else
            print("Unknown command. Use 'add', 'status', or 'quit'")
        end
        
        CheckForTurtleResponses()
        AssignMiningJobs()
        sleep(0.1)
    end
end

function AddMiningLocation(x, y, z)
    table.insert(miningQueue, {x = x, y = y, z = z})
    print("Added mining location: X:" .. x .. " Y:" .. y .. " Z:" .. z)
    print("Queue size: " .. #miningQueue)
end

function AssignMiningJobs()
    if #miningQueue == 0 then return end
    
    local availableTurtles = {}
    for id, turtle in pairs(activeTurtles) do
        if turtle.status == "idle" then
            table.insert(availableTurtles, id)
        end
    end
    
    for i = 1, math.min(#availableTurtles, #miningQueue) do
        local turtleId = availableTurtles[i]
        local location = table.remove(miningQueue, 1)
        
        SendMiningCommand(turtleId, location)
        activeTurtles[turtleId].status = "mining"
        activeTurtles[turtleId].target = location
        print("Assigned turtle " .. turtleId .. " to mine at X:" .. location.x .. " Y:" .. location.y .. " Z:" .. location.z)
    end
end

function SendMiningCommand(turtleId, location)
    modem.transmit(1, 1, {
        command = "mine",
        target = turtleId,
        location = location
    })
end

function CheckForTurtleResponses()
    local event, side, channel, replyChannel, message = os.pullEvent("modem_message")
    
    if type(message) == "table" then
        if message.type == "register" then
            activeTurtles[message.id] = {
                status = "idle",
                lastSeen = os.clock()
            }
            print("Turtle " .. message.id .. " registered")
            
        elseif message.type == "status" then
            if activeTurtles[message.id] then
                activeTurtles[message.id].status = message.status
                activeTurtles[message.id].lastSeen = os.clock()
                
                if message.status == "completed" then
                    print("Turtle " .. message.id .. " completed mining job")
                elseif message.status == "error" then
                    print("Turtle " .. message.id .. " reported error: " .. (message.error or "unknown"))
                end
            end
        end
    end
end

function ShowTurtleStatus()
    print("=== Turtle Status ===")
    print("Active turtles: " .. table.getn(activeTurtles))
    for id, turtle in pairs(activeTurtles) do
        local status = turtle.status
        if turtle.target then
            status = status .. " (X:" .. turtle.target.x .. " Y:" .. turtle.target.y .. " Z:" .. turtle.target.z .. ")"
        end
        print("Turtle " .. id .. ": " .. status)
    end
    print("Mining queue: " .. #miningQueue .. " locations")
    print("==================")
end

Main()