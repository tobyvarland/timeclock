class ReasonCodesController < ApplicationController

  # Require admin privileges.
  before_action :authorized_as_admin
  
  before_action :set_reason_code, only: [:show, :edit, :update, :destroy]

  # GET /reason_codes
  # GET /reason_codes.json
  def index
    @reason_codes = ReasonCode.order(:code)
  end

  # GET /reason_codes/1
  # GET /reason_codes/1.json
  def show
  end

  # GET /reason_codes/new
  def new
    @reason_code = ReasonCode.new
  end

  # GET /reason_codes/1/edit
  def edit
  end

  # POST /reason_codes
  # POST /reason_codes.json
  def create
    @reason_code = ReasonCode.new(reason_code_params)

    respond_to do |format|
      if @reason_code.save
        format.html { redirect_to action: :index, flash: { notice: "Successfully added <code>#{@reason_code.code}</code>." } }
        format.json { render :show, status: :created, location: @reason_code }
      else
        format.html { render :new }
        format.json { render json: @reason_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reason_codes/1
  # PATCH/PUT /reason_codes/1.json
  def update
    respond_to do |format|
      if @reason_code.update(reason_code_params)
        format.html { redirect_back fallback_location: @reason_code, notice: "Successfully updated <code>#{@reason_code.code}</code>." }
        format.json { render :show, status: :ok, location: @reason_code }
      else
        format.html { render :edit }
        format.json { render json: @reason_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reason_codes/1
  # DELETE /reason_codes/1.json
  def destroy
    @reason_code.destroy
    respond_to do |format|
      format.html { redirect_to reason_codes_url, notice: 'Reason code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reason_code
      @reason_code = ReasonCode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reason_code_params
      params.require(:reason_code).permit(:code, :requires_notes)
    end
end
