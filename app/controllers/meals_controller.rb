class MealsController < ApplicationController
  include ApplicationHelper
  before_action :set_meal, only: [:show, :edit, :update, :destroy]

  # GET /meals
  # GET /meals.json
  def index
    @meals = Meal.all.paginate(:page => params[:page], :per_page => 3)
  end

  # GET /meals/1
  # GET /meals/1.json
  def show
    # @meal = Meal.find(params[:id])
    @order = Order.new
    @order.meal = set_meal
  end

  def search
    @meals = Meal.search(params[:q])
    # if request.xhr?
    #   # binding.pry
    #   meals = @meals.to_json
    #   return meals
    # end

    results = {}
    @meals.each do |meal|
      results["#{meal.name}"] = {}
      results["#{meal.name}"][:chef] = meal.chef.first_name
      results["#{meal.name}"][:coordinates] = meal.chef.geocode
    end
    if request.xhr?
      render json: results
    end
    # respond_to do |format|
    #   format.html  # index.html.erb
    #   format.json  { render :json => @meals }
    # end
  end

  def category
    @meals = Meal.where(cuisine: params[:category])
    render "search"
  end

  # GET /meals/new
  def new
    @meal = Meal.new
  end

  # GET /meals/1/edit
  def edit
  end

  # POST /meals
  # POST /meals.json
  def create
    @chef = current_user
    @meal = Meal.new(meal_params)

    respond_to do |format|
      if @meal.save
        format.html { redirect_to @meal, notice: 'Meal was successfully created.' }
        format.json { render :show, status: :created, location: @meal }
      else
        format.html { render :new }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meals/1
  # PATCH/PUT /meals/1.json
  def update
    respond_to do |format|
      if @meal.update(meal_params)
        format.html { redirect_to @meal, notice: 'Meal was successfully updated.' }
        format.json { render :show, status: :ok, location: @meal }
      else
        format.html { render :edit }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meals/1
  # DELETE /meals/1.json
  def destroy
    @meal.destroy
    respond_to do |format|
      format.html { redirect_to meals_url, notice: 'Meal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meal
      @meal = Meal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meal_params
      params.require(:meal).permit(:name, :description, :cuisine, :chef_id, :price, :image)
    end
end
