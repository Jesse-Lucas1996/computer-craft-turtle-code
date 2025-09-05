function Main()
 if turtle.getItemCount(1) == 0 then
    turtle.suck()
 end
 local howManyBlocks = turtle.getItemCount(1)
 if howManyBlocks > 0 then
    if howManyBlocks > 2 then
        turtle.dropDown()
        DispenseItemsBasedOnNumberOfItems(howManyBlocks)
    else
        DispenseSingleItem()
    end
 end
end


function DispenseItemsBasedOnNumberOfItems(numberOfBlocks)
    local outputOfPotatoes = numberOfBlocks * 2
    turtle.suckDown(outputOfPotatoes)
 for i = 1, numberOfBlocks do
    turtle.drop(outputOfPotatoes * 2)
 end
end

function DispenseSingleItem()
    turtle.suckDown(1)
    turtle.drop()
end

while true do
    Main()
end