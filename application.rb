require 'rubygems'
require 'sinatra'
require 'pusher'
require 'haml'
require 'sinatra/activerecord'
require 'rack-flash'
require 'digest/sha1'

configure do
  Pusher.app_id = '1786'
  Pusher.key = '09435da909450e9b4b6e'
  Pusher.secret = '6112f12f27007eaab27d'

  APP_ID = Pusher.app_id
  API_KEY = Pusher.key
  SECRET = Pusher.secret

  APP_ENVIRONMENT = Sinatra::Application.environment

  if APP_ENVIRONMENT == :development
    set :database, 'sqlite://postbim.db'
  end

end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

class Post < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title
end

get '/' do
  haml :index
end

post '/create' do
  @post = Post.new(:title => params[:title])
  if @post.save
    redirect "/#{@post.title}"
  else
    redirect '/'
  end
end

get '/:title' do
  @post.title
  @post.body
end

post '/:title' do
  @post = Post.find_by_title(params[:title])
  @post.body = params
  if @post.save
    status 201
    "Created: #{@post.title}"
  else
    status 400
    "Error: Bad request."
  end
end

