# frozen_string_literal: true

require 'kaminari-bootstrap'

Kaminari.configure do |config|
  config.default_per_page = 12
  config.window = 2
  config.outer_window = 1
  config.left = 1
  config.right = 1
end 