# frozen_string_literal: true

require "swagger_helper"

describe "Purpose API", swagger_doc: "v1/api.json" do
  with_examples

  path "/api/v1/purposes" do
    get "Lister les motifs" do
      with_pagination

      tags "Purpose"
      produces "application/json"
      operationId "getPurposes"
      description "Renvoie les motifs, de manière paginée"

      parameter name: :organization_id, in: :query, type: :integer, description: "ID de l'organisation sur laquelle filtrer les motifs", example: "1", required: false
      parameter name: :group_id, in: :query, type: :integer, description: "ID du groupe (territoire) sur lequel filtrer les motifs", example: "1", required: false

      let(:organisation) { create(:organisation) }

      response 200, "Retourne les motifs" do
        let!(:motifs) { create_list(:motif, 5, organisation: organisation) }

        schema "$ref" => "#/components/schemas/purposes"

        run_test!

        it { expect(parsed_response_body[:meta]).to match(current_page: 1, next_page: nil, prev_page: nil, total_count: 5, total_pages: 1) }
        it { expect(parsed_response_body[:purposes]).to match(PurposeBlueprint.render_as_hash(motifs)) }
      end

      response 200, "Filtre par rapport à une organisation", document: false do
        let!(:matching) { create(:motif, organisation: organisation) }
        let!(:unmatching) { create(:motif) }
        let(:organization_id) { organisation.id }

        run_test!

        it { expect(parsed_response_body[:purposes]).to include(PurposeBlueprint.render_as_hash(matching)) }
        it { expect(parsed_response_body[:purposes]).not_to include(PurposeBlueprint.render_as_hash(unmatching)) }
      end

      response 200, "Filtre par rapport à un ID de territoire", document: false do
        let!(:matching) { create(:motif) }
        let!(:unmatching) { create(:motif) }
        let(:group_id) { matching.organisation.territory_id }

        run_test!

        it { expect(parsed_response_body[:purposes]).to include(PurposeBlueprint.render_as_hash(matching)) }
        it { expect(parsed_response_body[:purposes]).not_to include(PurposeBlueprint.render_as_hash(unmatching)) }
      end

      response 200, "Renvoie une liste vide s'il n'y a pas de motifs", document: false do
        run_test!

        it { expect(parsed_response_body[:purposes]).to match([]) }
      end

      response 429, "Limite d'appels atteinte" do
        schema "$ref" => "#/components/schemas/error_too_many_request"

        before do
          Rack::Attack.enabled = true
          Rack::Attack.reset!
          50.times do
            get api_v1_purposes_path
          end
        end

        run_test!
      end
    end
  end
end
