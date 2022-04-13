peripheral.find("modem", rednet.open)

local args = {...}
local rpm = 256
-- 20 blocks with 32 rotation and 15 sec
-- distance = k * rpm * t
-- t = distance / rpm / k
-- k = distance / rpm / t
-- 16 rpm 16 sec = 11 block
-- 16 rpm 20 sec = 13 blocks
-- 16 rpm 50 sec = 32 blocks
-- 64 rpm 5 sec = 13 blocks
-- 64 rpm 10 sec = 26 blocks
-- 64 rpm 15 sec = 38 blocks
-- 64 rpm 20 sec = 51 block
local speed_per_rpm = 0.035
local distance = tonumber(args[1])
local time = distance -- / rpm / speed_per_rpm
if (time < 0) then time = -time end

local protocol = 'gantry_test'

function wait_done(from_id)
  repeat
    id, message = rednet.receive(protocol)
  until id == from_id and message.type == 'done'
end

function send_and_wait(recipient_host, message_type, payload)
  recipient_id = rednet.lookup(protocol, recipient_host)
  success = rednet.send(recipient_id, {
    type = message_type,
    payload = payload,
  }, protocol)

  print(recipient_host, message_type, recipient_id, success)

  wait_done(recipient_id)
end

send_and_wait('direction_switch', 'set_direction', distance > 0)

send_and_wait('power_switch', 'turn_on_for_time', time)

