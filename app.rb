require "sinatra"
require "sinatra/reloader"
require "twitter"
require "dotenv"

Dotenv.load
client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV["CONSUMER_KEY"]
  config.consumer_secret = ENV["CONSUMER_SECRET"]
  config.access_token = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
end

get '/' do
  erb :index
end

get '/twittername' do
  user_tweets = client.user_timeline(params[:twittername], { count: 100 } )
  @image_urls = user_tweets.flat_map { |s| s.media}.map { |m| m.media_url.to_s}
  erb :result
end