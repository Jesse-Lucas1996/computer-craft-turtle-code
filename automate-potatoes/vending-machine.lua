function Main()
    KeepSucking()
 if turtle.getItemCount(1) == 0 then
    return
 end
 local howManyBlocks = turtle.getItemCount(1)
 if howManyBlocks > 1 then
    DispenseItemsBasedOnNumberOfItems(howManyBlocks)
 else
    DispenseSingleItem()
 end
end


function DispenseItemsBasedOnNumberOfItems(numberOfBlocks)
 for i = 1, numberOfBlocks do
    turtle.drop(numberOfBlocks * 2)
 end
end

function DispenseSingleItem()
    turtle.drop()
end

function KeepSucking()
    if turtle.getItemCount(1) > 0 then
        turtle.suck()
    end
end

while true do
    Main()
end