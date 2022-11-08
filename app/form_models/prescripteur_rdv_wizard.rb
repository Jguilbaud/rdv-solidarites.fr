# frozen_string_literal: true

class PrescripteurRdvWizard < UserRdvWizard::Base
  attr_accessor :prescripteur

  def initialize(user, attributes)
    super
    @prescripteur = attributes[:prescripteur].presence && Prescripteur.new(attributes[:prescripteur])
  end
end
