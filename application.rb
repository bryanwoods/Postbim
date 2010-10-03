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

  set :database, 'sqlite://postbim.db'
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
  "You are viewing Post: #{params[:title]}"
end

