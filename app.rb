require "sinatra"
require "sinatra/reloader"
require "sinatra/json"
require "twitter"
require "dotenv"

Dotenv.load
client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV["CONSUMER_KEY"]
  config.consumer_secret = ENV["CONSUMER_SECRET"]
  config.access_token = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
end

configure do
	use Rack::Session::Cookie
end

get '/' do
  erb :index
end

get '/twitterid' do
  redirect "/"+params[:twitterid]
end

get '/additionalload' do
  user_tweets = client.user_timeline(session[:twitterid], { count: 200, max_id: session[:last_tweet] - 1} )
  session[:last_tweet] = user_tweets.last.id
  image_urls = user_tweets.flat_map { |s| s.media}.map { |m| m.media_url.to_s}
  image_tweet_urls = user_tweets.flat_map{ |s| s.media}.map { |m| m.uri.to_s}
  json image_tweet_urls.zip(image_urls)
end

get '/:name' do |name|
  session[:twitterid] = name
  user_tweets = client.user_timeline(session[:twitterid], { count: 200 } )
  session[:last_tweet] = user_tweets.last.id
  image_urls = user_tweets.flat_map { |s| s.media}.map { |m| m.media_url.to_s}
  image_tweet_urls = user_tweets.flat_map{ |s| s.media}.map { |m| m.uri.to_s}
  @image_tweets = image_tweet_urls.zip(image_urls)
  erb :result
end