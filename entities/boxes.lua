local boxes = {}

function boxes:load()
  local entities = {}
  local x_pad, y_pad = 40, 40
  for i = 1, NUM_BOXES, 1 do
    table.insert(entities,
      { index = i, x = { math.random(x_pad, GameWidth - x_pad) }, y = { math.random(y_pad, GameHeight - y_pad) } })
  end
  self.entities = entities
end

function boxes:draw()
  for _, value in ipairs(self.entities) do
    for i = 1, #value.x, 1 do
      love.graphics.rectangle("line", value.x[i], value.y[i], 2, 2)
    end
  end
end

function boxes:update()
  local history = 1000
  for _, value in ipairs(self.entities) do
    local new_x = value.x[#value.x] + math.random(-1, 1)
    local new_y = value.y[#value.y] + math.random(-1, 1)
    if new_x > GameWidth then new_x = GameWidth end
    if new_x < 0 then new_x = 0 end
    table.insert(value.x, new_x)
    if #value.x > history then
      value.x = { (unpack or table.unpack)(value.x, history / 10, history) }
    end
    if new_y > GameHeight then new_y = GameHeight end
    if new_y < 0 then new_y = 0 end
    table.insert(value.y, new_y)

    if #value.y > history then
      value.y = { (unpack or table.unpack)(value.y, history / 10, history) }
    end
  end
end

return boxes
