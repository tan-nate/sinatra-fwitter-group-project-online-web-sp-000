class TweetsController < ApplicationController
  get '/tweets' do
    if logged_in?
      @user = current_user
      @tweets = Tweet.all
      # binding.pry
      erb :'tweets/index'
    else
      redirect "/login"
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'tweets/new'
    else
      redirect "/login"
    end
  end

  post '/tweets' do
    tweet = Tweet.new(params)
    if tweet.content?
      tweet.user_id = current_user.id
      tweet.save
    else
      redirect "/tweets/new"
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      erb :'tweets/show'
    else
      redirect "/login"
    end
  end

  get '/tweets/:id/edit' do
    if !logged_in?
      redirect "/login"
    end
    @tweet = Tweet.find(params[:id])
    if @tweet.user_id == current_user.id
      erb :'tweets/edit'
    else
      redirect "/login"
    end
  end

  patch '/tweets/:id' do
    tweet = Tweet.find(params[:id])
    if params[:content] == ""
      redirect "/tweets/#{tweet.id}/edit"
    else
      tweet.update(content: params[:content])
      redirect "/tweets/#{tweet.id}"
    end
  end

  delete '/tweets/:id' do
    tweet = Tweet.find(params[:id])
    if tweet.user_id == current_user.id
      tweet.destroy
    else
      redirect "/tweets"
    end
  end
end
