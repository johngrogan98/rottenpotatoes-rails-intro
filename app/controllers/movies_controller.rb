class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
		if params.key?(:sort_by)
			session[:sort_by] = params[:sort_by]
		elsif session.key?(:sort_by)
			params[:sort_by] = session[:sort_by]
			redirect_to movies_path(params) and return
		end
		
		sort_by = session[:sort_by]
		@hilite = sort_by
		@all_ratings = Movie.all_ratings
		@checked_ratings = @all_ratings
		
		if params.key?(:ratings)
			session[:ratings] = params[:ratings]
			@checked_ratings = params[:ratings].keys
		elsif session.key?(:ratings)
			params[:ratings] = session[:ratings]
			redirect_to movies_path(params) and return
		end
		
    @movies = Movie.order(sort_by).where(rating: @checked_ratings)
    
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