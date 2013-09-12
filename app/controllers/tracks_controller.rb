class TracksController < ApplicationController

  before_filter :load_library

    def index
      @tracks = current_user.library.tracks
      respond_to do |format|
      format.html # index.html.erb
      format.json { render json: TracksDatatable.new(view_context) }
      # format.json { render json: @tracks }
    end
  end



  # def index
  #   respond_to do |format|
  #     format.html
  #     format.json { render json: ProductsDatatable.new(view_context) }
  #   end
  # end



  def new
    # binding.pry
    @track = Track.new
    # @artist = Artist.new
    # respond_to do |format|
    #   format.html # new.html.erb
    #   format.json { render json: @track }
    # end
  end


  def create
    # binding.pry
    p_attr = params[:track]
    p_attr[:file] = params[:track][:track_location].first if params[:track][:track_location].class == Array
      @track = Track.new(p_attr)
      @track.library = @library
      @track.user = current_user
      @track.parse_id3(@track)
      if @track.save
        respond_to do |format|
          format.html {  
            render :json => [@track.to_jq_upload].to_json, 
            :content_type => 'text/html',
            :layout => false
          }
          format.json {  
            render :json => { :files => [@track.to_jq_upload], :status => :done }     
          }
        end
      else 
        render :json => [{:error => "custom_failure"}], :status => 304
      end
    end

  def destroy
    @track = Track.find(params[:id])
    @track.destroy
    render :json => true
  end
# end

  # def create
  #   # binding.pry
  #   @track = Track.new(params[:track])
  #   # binding.pry
  #   @track.library = @library
  #   @track.user = current_user
  #   @track.parse_id3(@track)
  #   respond_to do |format|
  #     if @track.save
  #       format.json { render json: { :files => [@track.to_jq_upload]}, status: :created }
  #       # format.js do
  #       #   flash[:notice] = "Track was successfully uploaded"
  #       # end
  #       # format.html { redirect_to library_track_path(@library, @track), notice: Track was successfully created. }
  #    #    format.json do
  #    #      render :json => { 
  #    #         :status => :ok, 
  #    #         :message => "Success!",
  #    #         :html => "<b>congrats</b>"
  #    #      }.to_json
  #    # end  
  #       # format.json { render json: @library_track, status: :created, location: @track }
  #     else
  #       format.html { render action: "new" }
  #       # format.json do
  #       #   render json: 'Track was successfully created.'
  #       # end
  #     end
  #   end
  # end

  def show
    @track = Track.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @track }
    end
  end

  # def destroy
  #   # binding.pry
  #   @track = Track.find(params[:id])
  #   @track.destroy

  #   respond_to do |format|
  #     format.html { redirect_to library_tracks_url }
  #     format.json { redirect_to library_tracks_url }
  #   end
  # end

  def update
    @track = Track.new(params[:track])
    @track.libraries << @library
    @track.parse_id3(@track)

    respond_to do |format|
      if @track.save

        format.html { redirect_to library_track_path(@library, @track), notice: 'Track was successfully created.' }
        format.json { render json: @library_track, status: :created, location: @track }
      else
        format.html { render action: "new" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  def land
  end





  protected
  def load_library
    @library = Library.find(current_user.library.id)
  end


end
