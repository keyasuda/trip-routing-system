# frozen_string_literal: true

class DaysController < ApplicationController
  before_action :set_trip
  before_action :set_day, only: %i[show edit update destroy order_waypoints optimize_waypoints]

  # GET /days or /days.json
  def index
    @days = @trip.days.all
  end

  # GET /days/1 or /days/1.json
  def show
  end

  # GET /days/new
  def new
    lastday = @trip.days.last
    start_at =
      if lastday&.start_at
        1.day.since(lastday.start_at)
      else
        Time.zone.now
      end
    @day = @trip.days.build(start_at:)
  end

  # GET /days/1/edit
  def edit
  end

  # POST /days or /days.json
  def create
    @day = @trip.days.build(day_params)

    respond_to do |format|
      if @day.save
        format.html { redirect_to @trip, notice: I18n.t('view.toast.added', name: @day.name) }
        format.json { render :show, status: :created, location: @day }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @day.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /days/1 or /days/1.json
  def update
    respond_to do |format|
      if @day.update(day_params)
        format.html { redirect_to [@trip, @day], notice: I18n.t('view.toast.updated', name: @day.name) }
        format.json { render :show, status: :ok, location: @day }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @day.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /days/1 or /days/1.json
  def destroy
    @day.destroy
    respond_to do |format|
      format.html { redirect_to @trip, notice: I18n.t('view.toast.destroyed', name: @day.name) }
      format.json { head :no_content }
    end
  end

  def order_waypoints
    src = JSON.parse(params[:waypoints_order])
    @from = @trip.days.find(src['from']['day_id']) if src['from']
    @to = @trip.days.find(src['to']['day_id']) if src['to']

    if @from
      waypoints = src['from']['waypoints'].map(&:to_i)
      moved = @from.waypoints.reject { |w| waypoints.include?(w.id) }
      moved.each { |w| @to.waypoints << w }

      waypoints.each_with_index do |id, i|
        @from.waypoints.find { |w| w.id == id }.update(index: i)
      end
    end

    src['to']['waypoints'].map(&:to_i).each_with_index do |id, i|
      @to.waypoints.find { |w| w.id == id }.update(index: i)
    end

    if @from
      redirect_to [@trip, @day]
    else
      render layout: false, content_type: 'text/vnd.turbo-stream.html'
    end
  end

  def optimize_waypoints
    @day.optimize!
    @to = @day
    render :order_waypoints, layout: false, content_type: 'text/vnd.turbo-stream.html'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trip
    @trip = user_trips.find(params[:trip_id])
  end

  def set_day
    @day = @trip.days.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def day_params
    params.require(:day).permit(:name, :description, :start_waypoint_id, :end_waypoint_id, :start_at, :trip_id)
  end
end
