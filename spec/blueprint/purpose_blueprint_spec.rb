# frozen_string_literal: true

RSpec.describe PurposeBlueprint do
  describe "render" do
    it "contains the motif data" do
      motif = build_stubbed(:motif)
      parsed_group = JSON.parse(described_class.render(motif, root: :motif)).with_indifferent_access
      expect(parsed_group[:motif]).to match(
        {
          id: motif.id,
          label: motif.name,
          organization_id: motif.organisation_id,
          group_id: motif.organisation.territory_id,
        }
      )
    end
  end
end
