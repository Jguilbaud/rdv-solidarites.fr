# frozen_string_literal: true

class PurposeBlueprint < Blueprinter::Base
  identifier :id

  field :name, name: :label
  field :organisation_id, name: :organization_id
  field :group_id do |motif, _|
    motif.organisation.territory_id
  end
end

# TODO: SEB public_link 	URL 	Oui 	Lien vers les résultats de recherche
