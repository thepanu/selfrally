require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "#index" do
    before do
      @user = FactoryBot.create(:user)
      @user.confirm
    end
    context "as an authenticated user" do
      it "responds successfully" do
        sign_in @user
        get :index
        expect(response).to be_success
      end
      it "returns a 200 response" do
        get :index
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#new" do
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
        @user.confirm
      end
      it "returns a 200 response" do
        sign_in @user
        get :new
        expect(response).to have_http_status "200"
      end
    end
    context "as a guest" do
      it "redirects to the root" do
        get :index
        get :new
        expect(response).to redirect_to "/"
      end
    end
  end
end
