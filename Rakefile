# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

require "bundler"

Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'SW Community'
  app.icons << "icon.png"

  app.frameworks += [
    'QuartzCore'
  ]

  app.pods do
    pod "ViewDeck"
  end
end
