# frozen_string_literal: true

require "swagger_helper"

describe "Place API", swagger_doc: "v1/api.json" do
  with_examples

  path "/api/v1/places" do
    get "Lister les places" do
      with_pagination

      tags "Place"
      produces "application/json"
      operationId "getPlaces"
      description "Renvoie toutes les places, de manière paginée"

      parameter name: :organization_id, in: :query, type: :integer, description: "ID de l'organisation sur lequel filtrer les places", example: 1, required: false

      response 200, "Retourne les Lieux sous la forme Places" do
        let!(:places) { create_list(:lieu, 5) }

        schema "$ref" => "#/components/schemas/places"

        run_test!

        it { expect(parsed_response_body[:meta]).to match(current_page: 1, next_page: nil, prev_page: nil, total_count: 5, total_pages: 1) }
        it { expect(parsed_response_body[:places]).to match(PlaceBlueprint.render_as_hash(places)) }
      end

      response 200, "Filtre par rapport à une organisation", document: false do
        let!(:matching) { create(:lieu) }
        let!(:unmatching) { create(:lieu) }
        let!(:organization_id) { matching.organisation_id }

        run_test!

        it { expect(parsed_response_body[:places]).to include(PlaceBlueprint.render_as_hash(matching)) }
        it { expect(parsed_response_body[:places]).not_to include(PlaceBlueprint.render_as_hash(unmatching)) }
      end

      response 200, "Renvoie une liste vide s'il n'y a pas d'organisations", document: false do
        run_test!

        it { expect(parsed_response_body[:places]).to match([]) }
      end
    end
  end
end
