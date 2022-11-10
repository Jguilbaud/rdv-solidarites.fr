# frozen_string_literal: true

RSpec.describe "Prendre Rdv Sans Résultat", type: :request do
  include Rails.application.routes.url_helpers

  describe "GET /" do
    context "no motif available" do
      let(:organisation) { create(:organisation) }
      let(:agent) { create(:agent, organisations: [organisation]) }
      let(:motif) { create(:motif, service: agent.service, reservable_online: false) }
      let!(:plage_ouverture) { create(:plage_ouverture, agent: agent, motifs: [motif]) }

      it "redirect to root" do
        get root_path(departement: "75", city_code: "75056", latitude: "48.859", longitude: "2.347", address: "Paris 75001")
        expect(response).to render_template(:nothing_to_show)
      end

      it "show error message" do
        get root_path(departement: "75", city_code: "75056", latitude: "48.859", longitude: "2.347", address: "Paris 75001")
        expect(response.body).to include("La prise de rendez-vous n&#39;est pas disponible pour ce département.")
      end
    end

    context "inviation token error" do
      let(:organisation) { create(:organisation) }
      let(:agent) { create(:agent, organisations: [organisation]) }
      let(:motif) { create(:motif, service: agent.service, reservable_online: true) }
      let!(:plage_ouverture) { create(:plage_ouverture, agent: agent, motifs: [motif]) }

      it "render nothing_to_show" do
        get root_path(invitation_token: "AZESD5456")
        expect(response).to redirect_to(root_path)
      end

      it "show error message" do
        get root_path(invitation_token: "AZESD5456")
        expect(flash[:error]).to eq("Votre invitation n'est pas valide.")
      end
    end

    context "follower agents not found" do
      let(:organisation) { create(:organisation) }
      let(:agent) { create(:agent, organisations: [organisation]) }
      let(:motif) { create(:motif, service: agent.service, reservable_online: true, follow_up: true) }
      let!(:plage_ouverture) { create(:plage_ouverture, agent: agent, motifs: [motif]) }
      let(:user) { create(:user, organisations: [organisation], agents: []) }

      before do
        login_as(user)
      end

      it "render nothing_to_show" do
        get root_path(suivi: "1")
        expect(response).to render_template(:nothing_to_show)
      end

      it "show error message" do
        get root_path(suivi: "1")
        expect(response.body).to include("Nous n&#39;avons pas retrouvé d&#39;agent qui vous suit, vous ne pouvez donc pas prendre un RDV de suivi.")
      end
    end
  end
end
