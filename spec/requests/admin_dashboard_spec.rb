# spec/requests/admin_dashboard_spec.rb
require "rails_helper"

RSpec.describe "Dashboard", type: :request do
  # simple in-file helper that logs in through SessionsController#create
  def login_as(user, password:)
    post "/login", params: { username: user.username, password: password }
    follow_redirect! if response.redirect?
  end

  describe "GET /dashboard" do
    before do
      # seed data used by the dashboard
      @current_trimester = Trimester.create!(
        term: "Current term",
        year: Date.today.year.to_s,
        start_date: Date.today - 1.day,
        end_date: Date.today + 2.months,
        application_deadline: Date.today - 16.days
      )

      @past_trimester = Trimester.create!(
        term: "Past term",
        year: (Date.today.year - 1).to_s,
        start_date: Date.today - 3.months,
        end_date: Date.today - 1.day,
        application_deadline: Date.today - 4.months
      )

      @upcoming_trimester = Trimester.create!(
        term: "Upcoming term",
        year: Date.today.year.to_s,
        start_date: Date.today + 3.months,
        end_date: Date.today + 5.months,
        application_deadline: Date.today + 2.months
      )

      # create an admin and log in via the real controller so session[:role] is set
      admin_password = "secret123"
      @admin = User.create!(
        username: "admin_user",
        role: "admin",
        password: admin_password,
        password_confirmation: admin_password
      )
      login_as(@admin, password: admin_password)
    end

    it "returns a 200 OK status" do
      get dashboard_path # or: get "/dashboard"
      expect(response).to have_http_status(:ok)
    end

    it "displays the current trimester" do
      get dashboard_path
      expect(response.body).to include("#{@current_trimester.term} - #{@current_trimester.year}")
    end

    it "displays the upcoming trimester" do
      get dashboard_path
      expect(response.body).to include("#{@upcoming_trimester.term} - #{@upcoming_trimester.year}")
    end

    # placeholders if you later assert course links, etc.
    it "displays links to the courses in the current trimester" do
      get dashboard_path
      # expect(response.body).to include("...") # add your expectation here
    end

    it "displays links to the courses in the upcoming trimester" do
      get dashboard_path
      # expect(response.body).to include("...") # add your expectation here
    end
  end
end
