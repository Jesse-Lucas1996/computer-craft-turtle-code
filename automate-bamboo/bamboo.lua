function Main()
    local isBlock, block = turtle.inspect()
    if isBlock and block.name == "minecraft:bamboo" then
        if block.state.age == 1 then
            turtle.dig()
            turtle.suck()
            turtle.suck()
            turtle.suck()
            turtle.suck()
            turtle.place()
            turtle.suck()
            turtle.suck()
            turtle.dropUp()
        end
    end
end


while true do
    Main()
end