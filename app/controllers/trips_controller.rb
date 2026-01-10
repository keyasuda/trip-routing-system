# frozen_string_literal: true

# Controller for managing trip objects
class TripsController < ApplicationController
  before_action :set_trip, only: %i[show edit update destroy]

  # GET /trips or /trips.json
  def index
    @trips =
      user_trips.
      includes(:days).
      order(
        Arel.sql(
          '(select start_at from days where days.trip_id=trips.id order by start_at limit 1) desc',
        ),
      ).
      all
  end

  # GET /trips/1 or /trips/1.json
  def show
  end

  # GET /trips/new
  def new
    @trip = user_trips.new
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips or /trips.json
  def create
    @trip = user_trips.new(trip_params)

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: I18n.t('view.toast.added', name: @trip.name) }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1 or /trips/1.json
  def update
    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: I18n.t('view.toast.updated', name: @trip.name) }
        format.json { render :show, status: :ok, location: @trip }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1 or /trips/1.json
  def destroy
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url, notice: I18n.t('view.toast.destroyed', name: @trip.name) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trip
    @trip = user_trips.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def trip_params
    params.require(:trip).permit(:name, :description)
  end
end
