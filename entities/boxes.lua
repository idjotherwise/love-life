local boxes = {}

function boxes:load()
  local entities = {}
  local x_pad, y_pad = 40, 40
  self.persistent = {}
  Scribble_image_data = love.image.newImageData('assets/scribble.png')
  Scribble_image = love.graphics.newImage(Scribble_image_data)

  local num_cols, num_rows = Scribble_image_data:getDimensions();
  for i = 1, num_rows - 1, 1 do
    for j = 1, num_cols - 1, 1 do
      local r, g, b, _ = Scribble_image_data:getPixel(i, j)
      if r == 1 and g == 1 and b == 1 then
      else
        table.insert(self.persistent, { x = i, y = j })
      end
    end
  end

  for i = 1, NUM_BOXES, 1 do
    table.insert(entities,
      { index = i, x = { math.random(x_pad, GameWidth - x_pad) }, y = { math.random(0, y_pad) }, momentum = { det_x = 0, pos_x = 0.1, neg_x = -0.1, pos_y = 1, neg_y = -1, det_y = 1 } })
  end
  self.entities = entities
  -- for _, v in pairs(self.persistent) do
  --   print(v.x, v.y)
  -- end
  self.is_creating = false
end

-- local smiles = {
--   left_eye = { x = GameWidth * 0.30, width = GameWidth * 0.05, y = GameHeight * 0.1, height = GameHeight * 0.05 },
--   right_eye = { x = GameWidth * 0.75, width = GameWidth * 0.05, y = GameHeight * 0.1, height = GameHeight * 0.05 },
--   left_nose = { x = GameWidth * 0.45, width = GameWidth * 0.01, y = GameHeight * 0.5, height = GameHeight * 0.05 },
--   right_nose = { x = GameWidth * 0.55, width = GameWidth * 0.01, y = GameHeight * 0.5, height = GameHeight * 0.05 },
--   left_mouth = { x = GameWidth * 0.20, width = GameWidth * 0.05, y = GameHeight * 0.7, height = GameHeight * 0.05 },
--   middle_mouth = { x = GameWidth * 0.25, width = GameWidth * 0.6, y = GameHeight * 0.75, height = GameHeight * 0.05 },
--   right_mouth = { x = GameWidth * 0.85, width = GameWidth * 0.05, y = GameHeight * 0.7, height = GameHeight * 0.05 },
-- }

-- local function is_val_in_ent_x(val, ent)
--   return (val > ent.x and val < ent.x + ent.width)
-- end

-- local function is_val_in_ent_y(val, ent)
--   return (val > ent.y and val < ent.y + ent.height)
-- end
-- local function is_smiles(x_val, y_val)
--   for k, ent in pairs(smiles) do
--     if is_val_in_ent_x(x_val, ent) and is_val_in_ent_y(y_val, ent) then
--       return true
--     end
--   end
--   return false
-- end

function boxes:draw()
  -- love.graphics.draw(Scribble_image)
  for _, value in ipairs(self.entities) do
    for i = 1, math.min(#value.x, 20), 1 do
      love.graphics.setColor(1, 1 - 0.1 * value.momentum.pos_x, 1 - 0.1 * value.momentum.pos_y,
        1 - (i - 1) * 0.05)
      local x_val, y_val = value.x[#value.x - i + 1], value.y[#value.y - i + 1]
      -- if is_smiles(x_val, y_val) then
      --   table.insert(self.persistent, { x = value.x[#value.x - i + 1], y = value.y[#value.y - i + 1] })
      -- else
      love.graphics.rectangle("line", value.x[#value.x - i + 1], value.y[#value.y - i + 1], 1, 1)
      -- end
    end
  end
  love.graphics.setColor(1, 1, 0)
  for _, value in ipairs(self.persistent) do
    love.graphics.rectangle("line", value.x, value.y, 1, 1)
  end
  love.graphics.setColor(1, 1, 1)
end

function boxes:update()
  local history = 50
  for _, value in ipairs(self.entities) do
    local old_x = value.x[#value.x]
    local old_y = value.y[#value.y]
    -- local new_x = old_x + math.random(-value.momentum.neg_x, value.momentum.pos_x)
    local new_x = old_x + value.momentum.det_x
    -- local new_y = old_y + math.random(-value.momentum.neg_y, value.momentum.pos_y)
    local new_y = old_y + value.momentum.det_y
    if new_x > GameWidth then
      value.momentum.neg_x = 1
      value.momentum.pos_x = 0
      new_x = GameWidth
    end
    if new_x < 0 then
      value.momentum.pos_x = value.momentum.pos_x
      new_x = 0
    end
    for _, val in ipairs(self.persistent) do
      if new_x == val.x and new_y == val.y then
        value.momentum.det_y = 0
        value.momentum.pos_y = 10
      end
    end
    table.insert(value.x, new_x)
    if #value.x > history then
      value.x = { (unpack or table.unpack)(value.x, history / 2, history) }
    end
    if new_y > GameHeight then
      value.momentum.neg_y = value.momentum.neg_y
      new_y = GameHeight
    end
    if new_y < 0 then
      value.momentum.pos_y = value.momentum.pos_y
      new_y = 0
    end
    table.insert(value.y, new_y)

    if #value.y > history then
      value.y = { (unpack or table.unpack)(value.y, history / 2, history) }
    end
  end

  if love.mouse.isDown(1) then
    local mouse_x, mouse_y = love.mouse.getPosition()
    table.insert(boxes.persistent, { x = mouse_x, y = mouse_y })
  end
end

return boxes
