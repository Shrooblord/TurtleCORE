args = {...}
local revolutions = args[1] or 8

if turtle.getFuelLevel() < 1 then return end

for i=1, revolutions do
  turtle.digDown()
  if not turtle.down() then return end
  turtle.turnLeft()
  turtle.dig()
  if not turtle.forward() then return end
  turtle.digUp()
end
