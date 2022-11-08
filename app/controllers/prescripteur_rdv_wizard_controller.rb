# frozen_string_literal: true

class PrescripteurRdvWizardController < ApplicationController
  before_action lambda {
                  @step_titles = ["Choix du rendez-vous", "Prescripteur", "Bénéficiaire", "Confirmation"]
                }

  def new_prescripteur
    @step_title = @step_titles[1]
    session[:rdv_wizard_attributes] = query_params

    @prescripteur = Prescripteur.new(session[:prescripteur_attributes])

    set_rdv_wizard
  end

  def save_prescripteur
    prescripteur_attributes = params[:prescripteur].permit(:first_name, :last_name, :email, :phone_number)

    session[:prescripteur_attributes] = prescripteur_attributes

    save_prescripteur_to_rdv_in_session(prescripteur_attributes)

    redirect_to prescripteur_new_user_path
  end

  def new_user
    @step_title = @step_titles[2]
    set_rdv_wizard
  end

  def create_rdv
    redirect_to prescripteur_confirmation_path
  end

  def confirmation
    @step_title = @step_titles[3]
  end

  private

  def save_prescripteur_to_rdv_in_session(prescripteur_attributes)
    new_rdv_wizard_params = session[:rdv_wizard_attributes]
    new_rdv_wizard_params[:prescripteur] = prescripteur_attributes
    session[:rdv_wizard_attributes] = new_rdv_wizard_params
  end

  def set_rdv_wizard
    @rdv_wizard = UserRdvWizard::Base.new(nil, session[:rdv_wizard_attributes])
  end

  def query_params
    params.permit(
      *Users::RdvWizardStepsController::RDV_PERMITTED_PARAMS,
      *Users::RdvWizardStepsController::EXTRA_PERMITTED_PARAMS
    )
  end
end
