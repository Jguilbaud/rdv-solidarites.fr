# frozen_string_literal: true

class PrescripteurRdvWizardController < ApplicationController
  before_action lambda {
                  @step_titles = ["Choix du rendez-vous", "Prescripteur", "Bénéficiaire", "Confirmation"]
                }

  def new_prescripteur; end

  def save_prescripteur; end
end
