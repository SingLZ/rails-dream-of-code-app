# spec/requests/trimesters_spec.rb
require "rails_helper"

RSpec.describe "Trimesters", type: :request do
  # helper to log in through SessionsController#create
  def login_as(user, password:)
    post "/login", params: { username: user.username, password: password }
    follow_redirect! if response.redirect?
  end

  before do
    # make an admin user and log in so session[:role] = 'admin'
    admin_password = "secret123"
    @admin = User.create!(
      username: "admin_user",
      role: "admin",
      password: admin_password,
      password_confirmation: admin_password
    )
    login_as(@admin, password: admin_password)
  end

  describe "GET /trimesters" do
    context "when trimesters exist" do
      before do
        (1..2).each do |i|
          Trimester.create!(
            term: "Term #{i}",
            year: "2025",
            start_date: "2025-01-01",
            end_date: "2025-01-01",
            application_deadline: "2025-01-01"
          )
        end
      end

      it "returns a page containing names of all trimesters" do
        get "/trimesters"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Term 1 2025")
        expect(response.body).to include("Term 2 2025")
      end
    end

    context "when trimesters do not exist" do
      it "returns a page with header but no list items" do
        get "/trimesters"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Trimesters")
        expect(response.body).not_to include("<li>")
      end
    end
  end
end
