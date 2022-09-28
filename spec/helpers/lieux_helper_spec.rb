# frozen_string_literal: true

describe LieuxHelper do
  describe ".lieu_tag" do
    context "when the lieu is nil" do
      it "returns N/A" do
        expect(lieu_tag(nil)).to eq(content_tag(:span, "N/A", class: "text-muted"))
      end
    end

    context "when the lieu is present" do
      it "returns the name, unavailability_tag and address" do
        lieu = build(:lieu)
        expected_tag = content_tag(:span) do
          concat lieu.name
          concat unavailability_tag(lieu)
          concat tag.br
          concat content_tag(:small, lieu.address)
        end
        expect(lieu_tag(lieu)).to eq(expected_tag)
      end
    end
  end
end
