
local xShaftId = 'left'
local yShaftId = 'right'
local powerId = 'top'
local directionId = 'back'


function setPower(value)
  redstone.setOutput(powerId, value)
end

function setDirection(value)
  -- passing redstone signal reverses direction
  redstone.setOutput(directionId, not value)
end

function switchToYShaft(value)
  -- passing redstone to parent shaft
  -- causes it to convery rotation to carriage
  redstone.setOutput(xShaftId, value)
end

function switchToDrill(value)
  -- passing redstone to both shafts
  -- causes power transfer to the pulley
  redstone.setOutput(xShaftId, value)
  redstone.setOutput(yShaftId, value)
end

function reset()
  setPower(false)
  setDirection(false)
  redstone.setOutput(xShaftId, false)
  redstone.setOutput(yShaftId, false)
end

function getTimeToCoverDistance(distance)
  local rpm = 32
  local ticks_in_second = 20
  local linear_to_rpm = 512
  return math.abs(distance) * linear_to_rpm / (rpm * ticks_in_second)
end

function move(distance)
  setPower(true)
  setDirection(distance > 0)
  sleep(getTimeToCoverDistance(distance))
  setPower(false)
end

function moveZ(isDown)
  switchToDrill(true)
  setDirection(isDown)
  setPower(true)
end

function moveX(distance)
  move(distance)
end

function moveY(distance)
  switchToYShaft(true)
  move(distance)
  switchToYShaft(false)
end

local args = {...}
local command = args[1]

print('command:', command)
if (command == 'move') then
  local x = tonumber(args[2])
  local y = tonumber(args[3])
  print('moving vector = ['..x..', '..y..']')
  reset()
  moveX(x)
  moveY(y)
elseif (command == 'down') then
  moveZ(true)
elseif (command == 'up') then
  moveZ(false)
end

print('done')
