# frozen_string_literal: true

class SearchController < ApplicationController
  include TokenInvitable

  # utilisé par le Pas-de-Calais pour prendre rdv depuis leur site : https://www.pasdecalais.fr/Solidarite-Sante/Enfance-et-famille/La-Protection-Maternelle-et-Infantile/Prendre-rendez-vous-en-ligne-en-MDS-PMI-ou-service-social
  after_action :allow_iframe

  def search_rdv
    authenticate_user! if search_params[:suivi] == "1"
    @context = SearchContext.new(current_user, search_params.to_h)
    if search_params.keys.any? && @context.unique_motifs_by_name_and_location_type.empty?
      @error_message_key = if @context.invitation?
                             :invitation_html
                           elsif @context.suivi && current_user.agents.empty?
                             :no_follower_agents
                           else
                             :default
                           end
      render :nothing_to_show
    end
  end

  def public_link_with_internal_organisation_id
    organisation = Organisation.find(params[:organisation_id])
    redirect_to_organisation_search(organisation)
  end

  def public_link_with_external_organisation_id
    territory = Territory.find_by!(departement_number: params[:territory])
    organisation = territory.organisations.find_by!(external_id: params[:organisation_external_id])
    redirect_to_organisation_search(organisation)
  end

  private

  def redirect_to_organisation_search(organisation)
    if organisation
      redirect_to root_path(organisation_id: organisation.id, departement: organisation.territory.departement_number)
    else
      flash[:alert] = "Organisation non trouvée"
      redirect_to root_path
    end
  end

  def search_params
    params.permit(
      :latitude, :longitude, :address, :city_code, :departement, :street_ban_id,
      :service_id, :lieu_id, :date, :motif_search_terms, :motif_name_with_location_type, :motif_category, :suivi,
      :invitation_token, :organisation_id, organisation_ids: []
    )
  end
end
