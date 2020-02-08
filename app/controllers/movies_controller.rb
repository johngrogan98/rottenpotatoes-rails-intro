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
    #set checked ratings to all
		@all_ratings = Movie.all_ratings
		@checked_ratings = @all_ratings
		
    #checks if a sort has been selected
		if params.key?(:sort_by)
			session[:sort_by] = params[:sort_by]
			sort_by = session[:sort_by]
		  @hilite = sort_by
		elsif session.key?(:sort_by)
			params[:sort_by] = session[:sort_by]
			redirect_to movies_path(params) and return
		end

		
		#check the ratings that have been selected
		if params.key?(:ratings)
			session[:ratings] = params[:ratings]
			#change the checked ratings if necessary
			@checked_ratings = params[:ratings].keys
		elsif session.key?(:ratings)
			params[:ratings] = session[:ratings]
			redirect_to movies_path(params) and return
		end
		
		#get a list of movies in the selected ratings
		movie = Movie.with_ratings(@checked_ratings)
		
		#sort that list based on if user pressed sort
    @movies = movie.order(sort_by)
    
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