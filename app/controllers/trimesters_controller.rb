class TrimestersController < ApplicationController
  before_action :set_trimester, only: [:show, :edit, :update]

  def index
    @trimesters = Trimester.all
  end

  def show
  end

  def edit
  end

  def update
    if params[:trimester].blank? || params[:trimester][:application_deadline].blank?
      render plain: "Application deadline missing", status: :bad_request
    elsif @trimester.update(trimester_params)
      redirect_to @trimester, notice: "Trimester updated successfully."
    else
      render plain: "Invalid data", status: :bad_request
    end
  end

  private

    def set_trimester
      @trimester = Trimester.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render plain: "Trimester not found", status: :not_found
    end

    def trimester_params
      params.require(:trimester).permit(:application_deadline)
    end

    def not_found
      render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
    end
end
