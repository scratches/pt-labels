require 'rubygems'
require 'sinatra'
require 'json'
require './lib/client'

before do
  @client = Client.new(ENV['PT_PROJECT'], ENV['PT_KEY'])
end

get '/' do
  host = ENV['VMC_APP_HOST']
  port = ENV['VMC_APP_PORT']
  "<h1>Hello from the Cloud! via: #{host}:#{port}</h1>"
end

get '/update' do
  @client.update().to_json
end
