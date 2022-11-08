# frozen_string_literal: true

class PrescripteurRdvWizardController < ApplicationController
  before_action lambda {
                  @step_titles = ["Choix du rendez-vous", "Prescripteur", "Bénéficiaire", "Confirmation"]
                }

  def new_prescripteur
    session[:rdv_wizard_attributes] = query_params

    @prescripteur = Prescripteur.new(session[:prescripteur_attributes])

    @rdv_wizard = UserRdvWizard::Step1.new(nil, query_params)
  end

  def save_prescripteur
    prescripteur_attributes = params[:prescripteur].permit(:first_name, :last_name, :email, :phone_number)
    session[:prescripteur_attributes] = prescripteur_attributes

    new_rdv_wizard_params = session[:rdv_wizard_attributes]
    new_rdv_wizard_params[:prescripteur] = prescripteur_attributes
    session[:rdv_wizard_attributes] = new_rdv_wizard_params

    redirect_to prescripteur_new_user_path
  end

  def new_user
    @rdv_wizard = UserRdvWizard::Step1.new(nil, session[:rdv_wizard_attributes])
  end

  def create_rdv
    redirect_to prescripteur_confirmation_path
  end

  def confirmation; end

  private

  def query_params
    params.permit(
      *Users::RdvWizardStepsController::RDV_PERMITTED_PARAMS,
      *Users::RdvWizardStepsController::EXTRA_PERMITTED_PARAMS
    )
  end
end
