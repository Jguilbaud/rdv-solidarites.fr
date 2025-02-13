# frozen_string_literal: true

describe Agents::ExportMailer do
  describe "#rdv_export" do
    it "has an attachment file name which contains the current date without org ID when more than one orga" do
      organisation = create(:organisation)
      agent = create(:agent, admin_role_in_organisations: [organisation])
      other_organisation = create(:organisation)
      travel_to(Time.zone.parse("2022-09-14 09:00:00"))

      rdv_export = described_class.rdv_export(agent, [organisation.id, other_organisation.id], {})

      expect(rdv_export.attachments.first.filename).to eq("export-rdv-2022-09-14.xls")
    end

    it "has an attachment which contains the current date and org ID" do
      # Le département du Var se base sur la position de chaque caractère du nom
      # de fichier pour extraire la date et l'ID d'organisation, donc
      # si on modifie le fichier il faut soit les prévenir soit ajouter à la fin.

      organisation = create(:organisation)
      agent = create(:agent, admin_role_in_organisations: [organisation])
      travel_to(Time.zone.parse("2022-09-14 09:00:00"))

      rdv_export = described_class.rdv_export(agent, [organisation.id], {})

      expect(rdv_export.attachments.first.filename).to eq("export-rdv-2022-09-14-org-#{organisation.id.to_s.rjust(6, '0')}.xls")
    end
  end

  describe "#rdvs_users_export" do
    it "has an attachment which contains the current date" do
      organisation = create(:organisation)
      agent = create(:agent, admin_role_in_organisations: [organisation])
      travel_to(Time.zone.parse("2022-09-14 09:00:00"))

      rdvs_users_export = described_class.rdvs_users_export(agent, [organisation.id], {})

      expect(rdvs_users_export.attachments.first.filename).to eq("export-rdvs-user-2022-09-14.xls")
    end
  end
end
