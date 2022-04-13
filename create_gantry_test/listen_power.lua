peripheral.find("modem", rednet.open)

local host = 'power_switch'
local protocol = 'gantry_test'
rednet.host(protocol, 'power_switch')

print('init '..host)

function send_done(recipient_id)
  rednet.send(recipient_id, { type = 'done' }, protocol)
end

function switch(value) 
  redstone.setOutput('back', not value)
end

local message_handlers = {
  turn_on_for_time = function(payload) 
    switch(true)
    print('sleep for'..payload)
    sleep(payload)
    switch(false)
  end,
}

while true do
  sender_id, message = rednet.receive(protocol)

  handler = message_handlers[message.type]
  if (handler) then
    handler(message.payload)
    send_done(sender_id)
  end 
end