# frozen_string_literal: true

class Api::V1::PurposesController < Api::V1::BaseController
  def index
    render_collection(scope, root: :purposes, blueprint_klass: PurposeBlueprint)
  end

  private

  def scope
    # TODO: SEB filtre par departement_number
    scope = Motif
    scope = scope.where(organisation_id: params[:organization_id]) if params[:organization_id].present?
    scope = scope.joins(:organisation).where(organisations: { territory_id: params[:group_id] }) if params[:group_id].present?
    scope
  end
end
