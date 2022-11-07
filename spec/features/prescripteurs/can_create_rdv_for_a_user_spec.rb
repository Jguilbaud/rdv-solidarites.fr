
RSpec.describe "prescripteur can create RDV for a user" do
  let!(:organisation) { create(:organisation) }
  let!(:agent) { create(:agent, :cnfs, admin_role_in_organisations: [organisation]) }
  let!(:motif) { create(:motif, organisation: organisation, service: agent.service, reservable_online: true) }
  let(:prescripteur) { build(:prescripteur) }

  before do
    travel_to(Time.zone.parse("2022-11-07 15:00"))
    create(:plage_ouverture, organisation: organisation, agent: agent, motifs: [motif])
  end

  it "works" do
    visit public_link_to_org_path(organisation_id: organisation.id)

    click_on "Prochaine disponibilité le"
    click_on "08:00"
    click_on "Je suis un prescripteur qui oriente un bénéficiaire"

    fill_in "Votre prénom", with: prescripteur.first_name
    fill_in "Votre nom", with: prescripteur.last_name
    fill_in "Votre email professionnel", with: prescripteur.email
    fill_in "Votre numéro de téléphone", with: prescripteur.phone_number
    click_on "Continuer"

    expect(page).to have_content("Prescripteur : #{prescripteur.full_name}")
    fill_in "Prénom", with: "Patricia"
    fill_in "Nom", with: "Duroy"
    fill_in "Téléphone", with: "0623456789"
    fill_in "E-mail", with: "patricia_duroy@exemple.fr"
    expect { click_on "Confirmer le rendez-vous" }.to change(Rdv, :count).by(1)

    created_rdv = Rdv.last
    expect(created_rdv.users.map(&:full_name)).to eq(["Patricia Duroy"])
    expect(created_rdv.agents).to eq([agent])
  end
end
