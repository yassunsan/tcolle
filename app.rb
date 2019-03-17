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

get '/twitterid' do
  redirect "/"+params[:twitterid]
end

get '/:name' do |name|
  user_tweets = client.user_timeline(name, { count: 100 } )
  image_urls = user_tweets.flat_map { |s| s.media}.map { |m| m.media_url.to_s}
  image_tweet_urls = user_tweets.flat_map{ |s| s.media}.map { |m| m.uri.to_s}
  @image_tweets = image_tweet_urls.zip(image_urls)
  erb :result
end