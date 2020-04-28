class PeriodsController < ApplicationController

    # Require admin privileges.
    before_action :authorized_as_admin,
                  unless: :json_request?

    before_action :set_period, only: [:show, :update]

    # Set up has_scope gem for filtering.
    has_scope :for_user,
              only: :show
  
    # GET /periods
    # GET /periods.json
    def index
      @periods = Period.reverse_chronological
    end

    # GET /periods/1
    # GET /periods/1.json
    def show
      filters_to_cookies([:for_user])
      @punches = apply_scopes(@period.punches).includes(:user).reverse_chronological
      @filterable_users = User.where(id: @period.punches.pluck(:user_id).uniq).by_number.map {|u| ["#{u.employee_number} – #{u.name}", u.id]}
      @all_users = User.by_number.without_salary
    end
  
    # PATCH/PUT /periods/1
    # PATCH/PUT /periods/1.json
    def update
      respond_to do |format|
        if @period.update(period_params)
          format.html { redirect_back fallback_location: @period, notice: "Successfully updated #{@period.description}." }
          format.json { render :show, status: :ok, location: @period }
        else
          format.html { redirect_to periods_url, error: 'Period could not be updated. Contact IT for support.' }
          format.json { render json: @period.errors, status: :unprocessable_entity }
        end
      end
    end
  
    private

      def json_request?
        request.format.json?
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_period
        @period = Period.find(params[:id])
      end
  
      # Never trust parameters from the scary internet, only allow the white list through.
      def period_params
        params.require(:period).permit(:is_closed)
      end

end