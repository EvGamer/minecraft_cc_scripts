peripheral.find("modem", rednet.open)
local host = 'direction_switch'


local protocol = 'gantry_test'
rednet.host(protocol, host)

print(host..' init')

function send_done(recipient_id)
  rednet.send(recipient_id, { type = 'done' }, protocol)
end

function switch(value) 
  redstone.setOutput('back', not value)
end

local message_handlers = {
  set_direction = function(payload) 
    print(payload)
    switch(payload)
  end,
}

while true do
  local sender_id, message, protocol = rednet.receive(protocol)
  print(protocol..': '..sender_id)

  handler = message_handlers[message.type]

  if (handler) then

    handler(message.payload)
    send_done(sender_id)
  end 
end