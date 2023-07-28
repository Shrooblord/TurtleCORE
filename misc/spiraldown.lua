args = {...}
local revolutions = args[1] or 8

function outOfFuel()
  print("[E]: Out of fuel")
  return false
end

if turtle.getFuelLevel() < 1 then return outOfFuel() end

for i=1, revolutions do
  turtle.digDown()
  if not turtle.down() then return outOfFuel() end
  turtle.turnLeft()
  turtle.dig()
  if not turtle.forward() then return outOfFuel() end
  turtle.digUp()
end
