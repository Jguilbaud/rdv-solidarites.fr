# frozen_string_literal: true

describe PlageOuverturesHelper do
  let(:now) { Time.zone.parse("2021-12-23 09:00") }

  before do
    travel_to(now)
  end

  describe "#time_collections_for_plage_ouverture" do
    it "goes from 7:00 to 20:00, so that it's possible to create a plage_ouverture that allows booking a rdv at 19:00" do
      expect(time_collections_for_plage_ouverture.count).to eq(157)
      expect(time_collections_for_plage_ouverture.first).to eq("07:00")
      expect(time_collections_for_plage_ouverture.last).to eq("20:00")
    end
  end

  describe "#time_collections_for_absence" do
    it "return 288 entries" do
      expect(time_collections_for_absence.count).to eq(288)
      expect(time_collections_for_absence.first).to eq("00:00")
      expect(time_collections_for_absence.last).to eq("23:55")
    end
  end

  describe "#time_collections_for_hours" do
    it "return 24 parts" do
      start_time = 12
      end_time = 13
      expect(time_collections_for_hours(start_time..end_time).count).to eq(24)
    end
  end

  describe "#display_recurrence" do
    it "with a weekly recurrence" do
      plage_ouverture = build(:plage_ouverture, recurrence: Montrose.every(:week))
      expect(display_recurrence(plage_ouverture)).to eq(["Toutes les  semaines, le mardi", "de 08:00 à 12:00", "à partir du mardi 28 décembre 2021"])
    end

    it "with a weekly recurrence on wednesday" do
      plage_ouverture = build(:plage_ouverture, recurrence: Montrose.every(:week, on: ["wednesday"]))
      expect(display_recurrence(plage_ouverture)).to eq(["Toutes les  semaines, les mercredis", "de 08:00 à 12:00", "à partir du mardi 28 décembre 2021"])
    end

    it "with a monthly recurrence" do
      plage_ouverture = build(:plage_ouverture, recurrence: Montrose.every(:month, day: { 3 => [2] }))
      expect(display_recurrence(plage_ouverture)).to eq(["Tous les  mois, le 2ème mercredi", "de 08:00 à 12:00", "à partir du mardi 28 décembre 2021"])
    end
  end

  describe "#plage_ouverture_occurrence_text" do
    it "returns occurrence text" do
      plage_ouverture = build(:plage_ouverture, recurrence: Montrose.every(:week))
      expect(plage_ouverture_occurrence_text(plage_ouverture)).to eq("Toutes les  semaines, le mardi de 08:00 à 12:00 à partir du mardi 28 décembre 2021")
    end

    it "returns" do
      plage_ouverture = build(:plage_ouverture)
      expect(plage_ouverture_occurrence_text(plage_ouverture)).to eq("mardi 28 décembre 2021de 08:00 à 12:00")
    end
  end

  describe "#po_exceptionnelle_tag" do
    it "return exceptionnelle badge without recurrence" do
      plage_ouverture = build(:plage_ouverture)
      expect(po_exceptionnelle_tag(plage_ouverture)).to eq("<span class=\"badge badge-info\">Exceptionnelle</span>")
    end

    it "return nil with recurrence" do
      plage_ouverture = build(:plage_ouverture, recurrence: Montrose.every(:week))
      expect(po_exceptionnelle_tag(plage_ouverture)).to be_nil
    end
  end
end
