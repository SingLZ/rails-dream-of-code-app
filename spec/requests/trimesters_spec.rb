require "rails_helper"

RSpec.describe "Trimesters", type: :request do
  let!(:trimester) do
  Trimester.create!(
    term: "Fall",
    year: 2025,
    application_deadline: Date.today,
    start_date: Date.new(2025, 9, 1),
    end_date: Date.new(2025, 12, 15)
      )
    end


  describe "GET /trimesters/:id/edit" do
    it "renders the edit form with application deadline field" do
      get edit_trimester_path(trimester)
      expect(response.body).to include("Application deadline")
    end
  end

  describe "PUT /trimesters/:id" do
    it "updates with valid application deadline" do
      put trimester_path(trimester), params: { trimester: { application_deadline: "2025-12-01" } }
      expect(response).to redirect_to(trimester_path(trimester))
      expect(trimester.reload.application_deadline).to eq(Date.new(2025, 12, 1))
    end

    it "returns 400 when deadline is missing" do
      put trimester_path(trimester), params: { trimester: { } }
      expect(response).to have_http_status(:bad_request)
    end

    it "returns 400 when deadline is invalid" do
      put trimester_path(trimester), params: { trimester: { application_deadline: "invalid-date" } }
      expect(response).to have_http_status(:bad_request)
    end

    it "returns 404 when trimester does not exist" do
      put "/trimesters/9999", params: { trimester: { application_deadline: "2025-12-01" } }
      expect(response).to have_http_status(:not_found)
    end
  end
end
