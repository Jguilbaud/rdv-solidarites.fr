# frozen_string_literal: true

RSpec.describe "Search", type: :request do
  include Rails.application.routes.url_helpers

  describe "GET /" do
    context "without params" do
      it "is successful" do
        get root_path
        expect(response).to be_successful
      end

      it "render adress_selection template" do
        get root_path
        expect(response).to render_template("search/address_selection/_rdv_solidarites")
      end
    end

    context "with connected user" do
      let(:organisation) { create(:organisation) }
      let(:agent) { create(:agent, organisations: [organisation]) }
      let(:user) { create(:user, organisations: [organisation], agents: [agent]) }

      before do
        login_as(user)
      end

      context "with suivi params" do
        it "render motif_selection template" do
          motif = create(:motif, service: agent.service, follow_up: true)
          create(:plage_ouverture, agent: agent, motifs: [motif])
          get root_path(suivi: "1", service_id: motif.service_id)
          expect(response).to render_template("search/_motif_selection")
        end
      end
    end
  end

  describe "GET /prendre_rdv" do
    it "is successful" do
      get prendre_rdv_path
      expect(response).to be_successful
    end
  end
end
