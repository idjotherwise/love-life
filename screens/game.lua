local boxes = require "entities.boxes"
local game = {}

function game:enter()
  boxes:load()
end

function game:draw()
  boxes:draw()
end

function game:update()
  boxes:update()
end

return game
