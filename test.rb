require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'rest_client'
require 'json'
require 'SocketIO'

enable :sessions

AUTHENTICATED_USER = "username"
AUTHENTICATED_CHANNEL = "channelname"

NODE_URL = "http://10.0.0.19:8080"

def assert
  raise "Assertion failed!" unless yield
end

def assert_session
  #assert { session[:user] == AUTHENTICATED_USER }
  #assert { session[:channel] == AUTHENTICATED_CHANNEL }
end

def init_session
  session[:user] = AUTHENTICATED_USER
  session[:channel] = AUTHENTICATED_CHANNEL
end

def from_node?
  params['node']
end

def emit_socketio
  #RestClient.post "http://10.0.0.19:8080/sync.json", { posted: "json" }.to_json, content_type: :json
  client = SocketIO.connect("http://10.0.0.19:8080", sync: true) do
    after_start do
      emit("sync", { msg: "sync from ruby!" })
    end
  end
  #client.emit('sync', { msg: "SECOND SYNC"})
  "done"
end

$TODOS = {
  1 => { id: 1, text: "one" },
  2 => { id: 2, text: "two" },
  3 => { id: 3, text: "three" }
}

$SEQ = ($TODOS.keys.max_by { |k,v| k }) + 1

def create_todo(params)
  id = $SEQ
  $SEQ+=1
  todo = { id: id, text: params['text'] }
  $TODOS[todo[:id]] = todo
  p $TODOS
  todo
end

def update_todo(params)
  todo = $TODOS[params['id']]
  assert todo
  todo[:text] = params['text']
  todo
end

def delete_todo(id)
  $TODOS.delete(id)
end

def notify_node(type, model)
end

before do
  puts "Session: #{session}"
  puts "Params: #{params}"
  @body = request.body.read
  puts "Body: #{@body}"
  @data = (@body ? JSON.parse(@body) : {}) rescue {} # don't care
  puts "JSON data: #{@data if @data}"
  params.merge!(@data)
  puts "Params + JSON: #{params}"
end

#def crud(action, data)
#  assert_session
#  todo = create_todo(params)
#  if from_node?
#    todo.to_json
#  else
#    notify_node('create', todo)
#    redirect '/'
#  end
#eend

post '/todo' do
  assert_session
  todo = create_todo(params)
  if from_node?
    todo.to_json
  else
    notify_node('create', todo)
    redirect '/'
  end
end

put '/todo' do
  assert_session
  todo = update_todo(params)
  if from_node?
    todo.to_json
  else
    notify_node('update', todo)
    redirect '/'
  end
end

delete '/todo/:id' do
  assert_session
  delete_todo(params['id'])
  if from_node?
    params['id']  
  else
    notify_node('delete', todo)
    redirect '/'
  end
end

get '/todo/:id' do
  assert_session
  $TODOS[params['id']].to_json
end

get '/:name?' do |f|
  init_session
  f = 'index.html' unless f
  if f
    send_file File.join('client', f)
  end
  #erb :todos
end
