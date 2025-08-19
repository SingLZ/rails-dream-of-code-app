require "rails_helper"

RSpec.describe "Mentors", type: :request do
  describe "GET /mentors" do
    context "when mentors exist" do
      before do
        Mentor.create!(first_name: "Alice", last_name: "Smith")
        Mentor.create!(first_name: "Bob", last_name: "Brown")
      end

      it "returns a page containing names of all mentors" do
        get "/mentors"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Alice")
        expect(response.body).to include("Bob")
      end
    end

    context "when no mentors exist" do
      it "returns a page with header but no list items" do
        get "/mentors"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Mentors")
        expect(response.body).not_to include("<li>")
      end
    end
  end

  describe "GET /mentors/:id" do
    context "when the mentor exists" do
      let!(:mentor) { Mentor.create!(first_name: "Alice", last_name: "Smith") }

      it "returns a page showing the mentor details" do
        get "/mentors/#{mentor.id}"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Alice")
        expect(response.body).to include("Smith")
      end
    end

  end
end
