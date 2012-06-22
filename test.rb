require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'rest_client'
require 'json'
require 'SocketIO'

enable :sessions

AUTHENTICATED_USER = "username"
AUTHENTICATED_CHANNEL = "channelname"

def assert
  raise "Assertion failed!" unless yield
end

def assert_session
  assert { session[:user] == AUTHENTICATED_USER }
  assert { session[:channel] == AUTHENTICATED_CHANNEL }
end

def init_session
  session[:user] = AUTHENTICATED_USER
  session[:channel] = AUTHENTICATED_CHANNEL
end

def from_node?
  params[:silent]
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
  1 => { id: 1, msg: "one" },
  2 => { id: 2, msg: "two" },
  3 => { id: 3, msg: "three" }
}

$SEQ = ($TODOS.keys.max_by { |k,v| k }) + 1

def create_todo(params)
  id = $SEQ
  $SEQ+=1
  todo = { id: id, msg: params[:msg] }
  $TODOS[todo[:id]] = todo
  p $TODOS
  todo
end

def update_todo(params)
  todo = $TODOS[params[:id]]
  assert todo
  todo[:msg] = params[:msg]
end

before do
  p session
end

post '/todo' do
  assert_session
  todo = create_todo(params)
  unless from_node?
    # notify node.js
  end
  redirect '/'
end

put '/todo' do
  assert_session
  update_todo(params)
  unless from_node?
    # notify node.js
  end
  redirect '/'
end

delete '/todo/:id' do
  assert_session
  unless from_node?
    # notify node.js
  end
  redirect '/'
end

get '/todo/:id' do
  assert_session
  $TODOS[params[:id]].to_json
end

get '/:name?' do |f|
  init_session
  #f = 'index.html' unless f
  if f
    send_file File.join('client', f)
  end
  erb :todos
end
