local boxes = require "entities.boxes"
local press_functions = {
  down = function()
  end,
  s = function()
  end,
  up = function()
  end,
  q = function()
  end,
  r = function()
    boxes:load()
  end,
  space = function()
  end,
  escape = function()
    love.event.quit()
  end,
  right = function()
  end,
  c = function()
  end,
  b = function()
  end
}

local release_functions = {
}



return {
  press = function(pressed_key)
    if press_functions[pressed_key] then
      press_functions[pressed_key]()
    end
  end,

  release = function(released_key)
    if release_functions[released_key] then
      release_functions[released_key]()
    end
  end,
}
