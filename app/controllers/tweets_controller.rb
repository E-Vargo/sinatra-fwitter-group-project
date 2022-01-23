class TweetsController < ApplicationController

    get '/tweets' do 
       if logged_in?
         erb :'tweets/tweets'
       else
         redirect to '/login'
       end
    end

    get '/tweets/new' do 
        if logged_in?
            erb :'tweets/new'
        else
            redirect to '/login'
        end
    end

    post '/tweets' do 
        if params[:content] != ""
        Tweet.create(content: params[:content], user_id: current_user.id)
        else 
            redirect to '/tweets/new'
        end
    end

    get '/tweets/:id' do 
        if logged_in?
            @tweet = Tweet.find(params[:id])
            erb :'tweets/show_tweet'
        else
            redirect to '/login'
        end
    end

    get '/tweets/:id/edit' do 
        if logged_in?
        @tweet = Tweet.find(params[:id])
        if @tweet && @tweet.user == current_user && @tweet.content != ""
            erb :'tweets/edit_tweet'
          else
            redirect to '/tweets'
          end
        else 
        redirect to '/login'
        end
    end

    patch '/tweets/:id' do 
        @tweet = Tweet.find(params[:id])
        if logged_in?
            if  @tweet.content != "" && params[:content] != ""
            @tweet.update(content: params[:content])
            @tweet.save
            else 
                redirect to "/tweets/#{@tweet.id}/edit"
            end
        else
            redirect to '/login'
        end
    end

    delete '/tweets/:id/delete' do 
        @tweet = Tweet.find(params[:id])
        if logged_in? 
            if @tweet.user_id == current_user.id
            @tweet.delete 
            else 
                redirect to "/tweets/#{@tweet.id}/edit"
            end
        else
            redirect to '/login'
        end
    end
end
