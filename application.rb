require 'rubygems'
require 'sinatra'
require 'haml'
require 'sinatra/activerecord'
require 'digest/sha1'

configure do
  APP_ENVIRONMENT = Sinatra::Application.environment

  if APP_ENVIRONMENT == :development
    set :database, 'sqlite://postbim.db'
  end
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
  @post = Post.find_by_title(params[:title])
  haml :show
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

