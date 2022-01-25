# frozen_string_literal: true

class WaypointsController < ApplicationController
  before_action :set_trip_day
  before_action :set_waypoint, only: %i[show edit update destroy]

  # GET /waypoints or /waypoints.json
  def index
    @waypoints = @day.waypoints.all
  end

  # GET /waypoints/1 or /waypoints/1.json
  def show
  end

  # GET /waypoints/new
  def new
    @waypoint = @day.waypoints.build(latitude: 35, longitude: 135, stop_min: 30)
  end

  # GET /waypoints/1/edit
  def edit
  end

  # POST /waypoints or /waypoints.json
  def create
    @waypoint = @day.waypoints.build(waypoint_params)
    @waypoint.index = @day.waypoints.size

    respond_to do |format|
      if @waypoint.save
        format.html { redirect_to [@trip, @day] }
        format.json { render :show, status: :created, location: @waypoint }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @waypoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /waypoints/1 or /waypoints/1.json
  def update
    respond_to do |format|
      if @waypoint.update(waypoint_params)
        format.html { redirect_to [@trip, @day] }
        format.json { render :show, status: :ok, location: @waypoint }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @waypoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /waypoints/1 or /waypoints/1.json
  def destroy
    @waypoint.destroy
    respond_to do |format|
      format.html { redirect_to trip_day_url(@trip, @day), notice: I18n.t('view.toast.destroyed', name: @waypoint.name) }
      format.json { head :no_content }
    end
  end

  def search_poi
    @pois = Waypoint.search_poi(params[:q])
    render layout: false, content_type: 'text/vnd.turbo-stream.html'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trip_day
    @trip = Trip.find(params[:trip_id])
    @day = @trip.days.find(params[:day_id])
  end

  def set_waypoint
    @waypoint = @day.waypoints.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def waypoint_params
    params.require(:waypoint).permit(:name, :description, :longitude, :latitude, :stop_min, :index, :day_id)
  end
end
