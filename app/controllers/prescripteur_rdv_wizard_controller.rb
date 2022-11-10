# frozen_string_literal: true

class PrescripteurRdvWizardController < ApplicationController
  before_action lambda {
                  @step_titles = ["Choix du rendez-vous", "Prescripteur", "Bénéficiaire", "Confirmation"]
                }

  def start
    session[:rdv_wizard_attributes] = query_params
    redirect_to prescripteur_new_prescripteur_path
  end

  def new_prescripteur
    @step_title = @step_titles[1]

    @prescripteur = Prescripteur.new(session[:autocomplete_prescripteur_attributes])

    set_rdv_wizard
  end

  def save_prescripteur
    prescripteur_attributes = params[:prescripteur].permit(:first_name, :last_name, :email, :phone_number)

    session[:autocomplete_prescripteur_attributes] = prescripteur_attributes

    save_prescripteur_to_rdv_in_session(prescripteur_attributes)

    redirect_to prescripteur_new_user_path
  end

  def new_user
    @step_title = @step_titles[2]
    @beneficiaire = BeneficiaireForm.new
    set_rdv_wizard
  end

  def create_rdv
    beneficiaire_params = params.require(:beneficiaire_form).permit(:first_name, :last_name, :email, :phone_number)

    @beneficiaire = BeneficiaireForm.new(beneficiaire_params)

    if @beneficiaire.valid?
      session[:rdv_wizard_attributes][:user] = beneficiaire_params
      set_rdv_wizard
      @rdv_wizard.create_rdv!
      redirect_to prescripteur_confirmation_path
    else
      @step_title = @step_titles[2]
      set_rdv_wizard
      render :new_user
    end
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
    @rdv_wizard = PrescripteurRdvWizard.new(nil, session[:rdv_wizard_attributes], current_domain)
  end

  def query_params
    params.permit(
      *Users::RdvWizardStepsController::RDV_PERMITTED_PARAMS,
      *Users::RdvWizardStepsController::EXTRA_PERMITTED_PARAMS
    )
  end
end
