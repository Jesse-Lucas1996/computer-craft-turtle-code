function FarmPotatoes()
    local _, block = turtle.inspect()
    if block.name == "minecraft:potatoes" then
        if(block.state.age == 7) then
            turtle.dig()
            turtle.suck()
            turtle.suck()
            turtle.suck()
            turtle.suck()
            turtle.place()
            turtle.suck()
            turtle.suck()
        else
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
        turtle.turnRight()
    end
end


function GoHome()
    turtle.turnRight()
    turtle.turnRight()
    for i = 1, 8, 1 do
        turtle.forward()
    end
    turtle.turnLeft()
    CheckFuel()
    local potatoFound = GetItemIndex("minecraft:potatoes")
    if not potatoFound then
        print("Warning: No potatoes found in inventory!")
    end
    sleep(60)
end

function CheckFuel()
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel < 40 then
        local coalFound = GetItemIndex("minecraft:coal")
        if coalFound then
            turtle.refuel()
            print("Refueled! New fuel level: " .. turtle.getFuelLevel())
        else
            print("Warning: No coal found for refueling!")
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