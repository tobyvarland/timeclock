class UsersController < ApplicationController

  # Require admin privileges.
  before_action :authorized_as_admin

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.by_number
  end

  # GET /users/1
  # GET /users/1.json
  def show
    # History to show.
    @punches0 = @user.punches.current_week.reverse_chronological
    @punches1 = @user.punches.weeks_ago(1).reverse_chronological
    @punches2 = @user.punches.weeks_ago(2).reverse_chronological
    @punches3 = @user.punches.weeks_ago(3).reverse_chronological
    @punches4 = @user.punches.weeks_ago(4).reverse_chronological
    @punches5 = @user.punches.weeks_ago(5).reverse_chronological
    @calculator0 = Calculator.calculate_hours(@punches0.reverse)
    @calculator1 = Calculator.calculate_hours(@punches1.reverse)
    @calculator2 = Calculator.calculate_hours(@punches2.reverse)
    @calculator3 = Calculator.calculate_hours(@punches3.reverse)
    @calculator4 = Calculator.calculate_hours(@punches4.reverse)
    @calculator5 = Calculator.calculate_hours(@punches5.reverse)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_back fallback_location: @user, notice: "Successfully updated #{@user.name}." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:employee_number, :name, :pin, :access_level, :username, :remote_allowed)
    end
end
