class SnippetsController < ApplicationController

  def index
    @snippets_JS = Snippet.where(language: 'javascript')
    @attempts_JS = Attempt.joins(:snippet).where(snippets: {language: :javascript }).order(score: :desc).limit(10)

    @snippets_rb = Snippet.where(language: 'ruby')
    @attempts_rb = Attempt.joins(:snippet).where(snippets: {language: :ruby }).order(score: :desc).limit(10)

  end


  def show
    @snippet = Snippet.find(params[:id])
    body = @snippet.body.delete("\r")
    @array = body.split("").push(" ")
    # raise
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
      redirect_to "/snippets"
    else
      render :new
    end
  end

  def edit
    @snippet = Snippet.find(params[:id])


  end

  def update
    @snippet = Snippet.find(params[:id])
    @snippet.description = params[:description]
    @snippet.name = params[:name]
    @snippet.user_id = session[:user_id]
    @snippet.body = params[:body]
    @snippet.language = params[:language]
    @snippet.word_count = params[:word_count]
    if @snippet.save
      redirect_to "/snippets"
    else
      render :edit
    end
  end

  def destroy
    snippet = Snippet.find(params[:id])
    snippet.destroy
    redirect_to "/snippets"
  end
end
