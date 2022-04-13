peripheral.find("modem", rednet.open)

local args = {...}

local distance = tonumber(args[1])

function get_time_to_cover_distance(distance)
  local rpm = 32
  local ticks_in_second = 20
  local linear_to_rpm = 512
  return math.abs(distance) * linear_to_rpm / (rpm * ticks_in_second)
end

local time = get_time_to_cover_distance(distance)
print('time: '..time)


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

