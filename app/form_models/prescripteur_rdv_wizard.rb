# frozen_string_literal: true

class PrescripteurRdvWizard < UserRdvWizard::Base
  attr_accessor :prescripteur

  def initialize(user, attributes)
    super
    @prescripteur = Prescripteur.new(attributes[:prescripteur]) if attributes[:prescripteur].present?
    @user = User.new(attributes[:user]) if attributes[:user].present?
  end

  def create_rdv!
    rdv.assign_attributes(
      lieu: lieu,
      organisation: motif.organisation,
      agents: [creneau.agent],
      users: [@user]
    )
    rdv.save!
  end
end
