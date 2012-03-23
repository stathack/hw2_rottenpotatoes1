class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','NC-17','R'] 
    @list = params[:ratings] || session[:ratings] || {}
    active = params[:active] || session[:active]
    if(params[:active] == 'title')
      @title_header='hilite'
#        @movies = Movie.find(:all,:order=>'title')
    end
    if(params[:active] == 'release_date')
        @release_date='hilite'
    end
    if params[:active] != session[:active]
      session[:active] = active
      redirect_to :active => active, :ratings=> @list and return
    end
    if params[:ratings] != session[:ratings]  and @list != {}
      session[:active]=  active
      session[:ratings] = @list
      redirect_to :active => active , :ratings => @list and return
    end
    
    @movies = Movie.find_all_by_rating(@list.keys,{:order => params[:active]})
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
