---@diagnostic disable: lowercase-global
--- for hotreloading modules
-- local lick          = require "packages.LICK.lick"
-- lick.updateAllFiles = true
-- lick.clearPackages  = true
-- lick.reset          = true

function love.load()
  NUM_BOXES             = 300
  GameWidth, GameHeight = 960, 640
  input                 = require 'input'

  local game            = require 'screens.game'

  Gamestate             = require 'packages.hump.gamestate'

  local default_font    = love.graphics.newFont(18)
  love.graphics.setFont(default_font)

  Gamestate.registerEvents()
  Gamestate.switch(game)
end

function love.keypressed(pressed_key)
  input.press(pressed_key)
end

function love.keyreleased(released_key)
  input.release(released_key)
end
