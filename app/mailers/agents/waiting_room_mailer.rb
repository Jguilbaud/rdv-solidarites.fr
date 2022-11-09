# frozen_string_literal: true

class Agents::WaitingRoomMailer < ApplicationMailer

  before_action do
    @agent = params[:agent]
    @rdv = params[:rdv]
  end

  def user_in_waiting_room
    puts "*" *100
    puts "waiting room mailer, RDV: #{@rdv.inspect}, age: #{@agent.inspect}"
    mail(subject: t("agent.waiting_room_mailer.title", domain_name: domain.name))
  end
end
