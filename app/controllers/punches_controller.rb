class PunchesController < ApplicationController

  # Require supervisor privileges.
  before_action :authorized_as_supervisor,
                only: [:index, :new, :edit]

  before_action :set_punch, only: [:show, :edit, :update, :destroy]

  # Set up has_scope gem for filtering.
  has_scope :in_period,
            only: :index
  has_scope :for_user,
            only: :index
  has_scope :with_reason_code,
            only: :index

  # GET /punches
  # GET /punches.json
  def index
    filters_to_cookies([:in_period, :for_user, :with_reason_code])
    @punches = apply_scopes(Punch).includes(:user).reverse_chronological.in_open_period
    @unscoped_punches = Punch.in_open_period
    @filterable_periods = Period.where(id: @unscoped_punches.pluck(:period_id).uniq).reverse_chronological.map {|p| [p.description, p.id]}
    @filterable_users = User.where(id: @unscoped_punches.pluck(:user_id).uniq).by_number.map {|u| ["#{u.employee_number} – #{u.name}", u.id]}
    @filterable_codes = ReasonCode.where(id: @unscoped_punches.pluck(:reason_code_id).uniq).order(:code).map {|r| [r.code, r.id]}
    @punch = Punch.new
  end

  # GET /punches/1
  # GET /punches/1.json
  def show
  end

  # GET /punches/new
  def new
    @punch = Punch.new
  end

  # GET /punches/1/edit
  def edit
  end

  # POST /punches
  # POST /punches.json
  def create
    @punch = Punch.new(punch_params)

    if params[:source].present? && params[:source] == "ipad"
      if @punch.save
        redirect_to ipad_card_url, notice: @punch.description
      else
        msg = "There was an error processing your request. Contact IT for help."
        if @punch.errors.count > 0
          msg = @punch.errors.full_messages[0]
          if msg[-1] != "."
            msg += "."
          end
        end
        redirect_to ipad_url, flash: { error: msg }
      end
      return
    end

    if params[:source].present? && params[:source] == "phone"
      if @punch.save
        redirect_to phone_card_url, notice: @punch.description
      else
        msg = "There was an error processing your request. Contact IT for help."
        if @punch.errors.count > 0
          msg = @punch.errors.full_messages[0]
          if msg[-1] != "."
            msg += "."
          end
        end
        redirect_to phone_url, flash: { error: msg }
      end
      return
    end

    respond_to do |format|
      if @punch.save
        format.html { redirect_to punches_url, notice: 'Successfully added record' }
        format.json { render :show, status: :created, location: @punch }
      else
        format.html { render :new }
        format.json { render json: @punch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /punches/1
  # PATCH/PUT /punches/1.json
  def update
    respond_to do |format|
      if @punch.update(punch_params)
        format.html { redirect_to punches_url, notice: 'Successfully updated record.' }
        format.json { render :show, status: :ok, location: @punch }
      else
        format.html { render :edit }
        format.json { render json: @punch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /punches/1
  # DELETE /punches/1.json
  def destroy
    @punch.destroy
    respond_to do |format|
      format.html { redirect_to punches_url, notice: 'Punch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_punch
      @punch = Punch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def punch_params
      params.require(:punch).permit(:user_id, :punch_type, :punch_at, :edited_by_id, :reason_code_id, :notes)
    end

end