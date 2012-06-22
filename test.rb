require 'rubygems'
require 'bundler/setup'

require 'sinatra'

get '/:name?' do |f|
  f = 'index.html' unless f
  send_file File.join('client', f)
end
