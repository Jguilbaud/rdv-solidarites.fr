# frozen_string_literal: true

RSpec.describe "Admin::UserInWaitingRoom", type: :request do
  include Rails.application.routes.url_helpers

  let(:organisation) { create(:organisation) }
  let(:agent) { create(:agent, basic_role_in_organisations: [organisation]) }
  let(:rdv) {create(:rdv, agents: [agent], organisation: organisation)}

  before { sign_in agent }

  describe "POST /admin/organisations/:organisation_id/rdvs/:rdv_id/user_in_waiting_room" do
    subject(:create_request) { post admin_organisation_rdv_user_in_waiting_room_path(rdv.organisation, rdv) }

    it "is redirect" do
      create_request
      expect(response).to redirect_to admin_organisation_rdv_path(rdv.organisation, rdv)
    end

  end
end
