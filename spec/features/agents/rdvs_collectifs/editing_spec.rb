# frozen_string_literal: true

describe "Agent can edit a Rdv collectif" do
  let!(:organisation) { create(:organisation) }
  let!(:service) { create(:service) }
  let!(:agent) { create(:agent, service: service, admin_role_in_organisations: [organisation]) }
  let!(:motif) { create(:motif, :collectif, service: service, organisation: organisation, name: "Atelier Collectif") }

  let(:user) do
    create(:user, phone_number: "+33611223344", email: "test@exemple.fr")
  end
  let(:rdv) do
    create(:rdv, motif: motif, organisation: organisation, agents: [agent], users: [],
                 lieu: create(:lieu, organisation: organisation))
  end

  before do
    rdv.rdvs_users.create(user: create(:user), send_lifecycle_notifications: true)
  end

  # js: true is necessary for the lieu selection
  it "doesn't send a cancellation notification if the notifications for the participant are removed", js: true do
    login_as(agent, scope: :agent)
    visit edit_admin_organisation_rdv_path(organisation, rdv)
    find(:label, text: "Notifications de création et modification").click

    expect do
      click_button "Enregistrer"
      expect(page).to have_content("Atelier Collectif") # to wait for the request to complete before checking sent emails
    end.not_to change { ActionMailer::Base.deliveries.size }

    expect(rdv.reload.rdvs_users.first.send_lifecycle_notifications).to be false
  end
end
