require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "#index" do
    context "as an authenticated user" do
      it "responds successfully" do
        get :index
        expect(response).to be_success
      end
      it "returns a 200 response" do
        get :index
        expect(response).to have_http_status "200"
      end
    end
  end
end
