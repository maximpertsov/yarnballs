require 'chingu'
require 'matrix'

# add shell command to download chingu if user doesn't have it?
output = %x[bundle]
puts output

require_all File.join(ROOT, "src")

Game.new.show
