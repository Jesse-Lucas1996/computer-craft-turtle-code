function FarmPotatoes()
    local hasBlock, block = turtle.inspect()
    if hasBlock and block.name == "minecraft:potatoes" then
        if(block.state.age == 7) then
            turtle.dig()
            turtle.suck()
            turtle.suck()
            turtle.suck()
            turtle.suck()
            turtle.place()
            turtle.suck()
            turtle.suck()
        end
        MoveTowardsOtherPotatoes()
    else
        if hasBlock then
            MoveTowardsOtherPotatoes()
        else
            turtle.place()
            MoveTowardsOtherPotatoes()
        end
    end
end

function MoveTowardsOtherPotatoes()
    turtle.turnLeft()
    if(turtle.detect()) then
        GoHome()
    else
        turtle.forward()
        turtle.suck()
        turtle.suck()
        turtle.suck()
        turtle.turnRight()
    end
end


function GoHome()
    turtle.turnRight()
    turtle.turnRight()
    for i = 1, 8, 1 do
        turtle.suck()
        turtle.forward()
        turtle.suck()
    end
    turtle.turnLeft()
    CheckFuel()
    GetItemIndex("minecraft:potatoes")
    turtle.dropDown()
    for i = 1, 60, 1 do
        print("Waiting... " .. i)
        sleep(1)
        return
    end
end

function CheckFuel()
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel < 40 then
        local coalFound = GetItemIndex("minecraft:coal")
        if coalFound then
            turtle.refuel()
            print("Refueled! New fuel level: " .. turtle.getFuelLevel())
        end
    end
end


function GetItemIndex(itemName)
    for slot = 1, 16, 1 do
        local item = turtle.getItemDetail(slot)
        if item and item["name"] == itemName then
            turtle.select(slot)
            return true
        end
    end
    return false
end

while true do
    FarmPotatoes()
end