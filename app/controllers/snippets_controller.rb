class SnippetsController < ApplicationController

  def show
    @snippet = Snippet.find(params[:id])
    body = @snippet.body.delete("\r")
    @array = body.split("").push(" ")

    if !!session[:user_id]
      @history = Attempt.where('user_id' => User.find(session[:user_id]).id, 'snippet_id' => @snippet.id).limit(3)
    end

    @leaderboard = Attempt.where('snippet_id' => @snippet.id).order('score DESC').limit(10)

  end

  def new

  end

  def create
    snippet = Snippet.new
    snippet.description = params[:description]
    snippet.name = params[:name]
    snippet.user_id = session[:user_id]
    snippet.body = params[:body].strip
    snippet.language = params[:language]
    snippet.word_count = snippet.body.scan(/[[:alpha:]]+/).count

    if snippet.save
      redirect_to "/snippets/#{snippet.id}"
    else
      render :new
    end
  end

  def edit
    @snippet = Snippet.find(params[:id])

    if session[:user_id] != @snippet.user_id
      redirect_to '/'
    end

  end

  def update
    @snippet = Snippet.find(params[:id])

    if session[:user_id] != @snippet.user_id
      redirect_to '/'
    end

    @snippet.description = params[:description]
    @snippet.name = params[:name]
    @snippet.user_id = session[:user_id]
    @snippet.body = params[:body]
    @snippet.language = params[:language]
    @snippet.word_count = @snippet.body.scan(/[[:alpha:]]+/).count
    if @snippet.save
      redirect_to "/snippets/#{@snippet.id}"
    else
      render :edit
    end
  end

  def destroy
    snippet = Snippet.find(params[:id])
    if session[:user_id] != @snippet.user_id
      redirect_to '/'
    end
    snippet.destroy
    redirect_to "/snippets"
  end

  def languages
    @snippets = Snippet.all
    @attempts = Attempt.order(score: :desc).limit(10)
  end

  def javascript
    @snippets_JS = Snippet.where(language: 'javascript')
    @snippets_pop = Snippet.joins(:attempts).group(:id).order("count(*) desc")
    @attempts_JS = Attempt.joins(:snippet).where(snippets: {language: :javascript }).order(score: :desc).limit(10)
  end

  def ruby
    @snippets_rb = Snippet.where(language: 'ruby')
    @attempts_rb = Attempt.joins(:snippet).where(snippets: {language: :ruby }).order(score: :desc).limit(10)
  end

  def others
    @snippets_other = Snippet.where(language: 'other')
    @attempts_other = Attempt.joins(:snippet).where(snippets: {language: :other }).order(score: :desc).limit(10)
  end
end
