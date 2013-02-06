# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'rubygems'
require 'motion/project'
require "bundler"
require 'cgi'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'SW Community'
  app.icons << "icon.png"
  app.frameworks << "QuartzCore"

  app.pods do
    pod "NSString-HTML"
  end
end
