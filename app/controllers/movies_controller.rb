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
    @all_ratings = Movie.fetch_ratings

    # case when all setting are unchecked
    if (( !params[:select] and !params[:ratings] and !params[:orderby]) and (session[:select] or session[:ratings] or session[:orderby]))
      if ( !params[:select] and session[:select] )
        params[:select] = session[:select]
      end
      if ( !params[:orderby] and session[:orderby] )
        params[:orderby] = session[:orderby]
      end

      redirect_to movies_path(:select => params[:select], :orderby => params[:orderby], :ratings => params[:ratings]) 

    else

      if (params[:select])
        @picked = params[:select].scan(/[\w-]+/)
        session[:select] = params[:select]
      else
        @picked = params[:ratings] ? params[:ratings].keys : []
        session[:select] = params[:ratings] ? params[:ratings].keys.to_s : nil
      end
      
      session[:orderby] = params[:orderby]
      session[:ratings] = params[:ratings]

      if (params[:orderby] == "title")  #sort by title
          if (params[:ratings] or params[:select])
            @movies = Movie.where("rating" => (@picked==[] ? @all_ratings : @picked)).order("title")
          else
            @movies = Movie.order("title")
          end
      elsif (params[:orderby] == "release_date")  # sort by date
          if (params[:ratings] or params[:select]) 
            @movies = Movie.where("rating" => (@picked==[] ? @all_ratings : @picked)).order("release_date")
          else
            @movies = Movie.order("release_date")
          end
      elsif (params[:orderby] == nil) 
          if (params[:ratings] or params[:select]) 
            @movies = Movie.where("rating" => @picked)
          else
            @movies = Movie.all
          end
      end

    end
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
