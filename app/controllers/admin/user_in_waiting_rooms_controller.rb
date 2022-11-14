# frozen_string_literal: true

class Admin::UserInWaitingRoomsController < AgentAuthController
  def create
    rdv = Rdv.includes(:agents).find(params[:rdv_id])
    authorize(rdv)






    #TODO

    if current_organisation.territory.enable_waiting_room_mail_field
      rdv.agents.map do |agent|
        puts "*" *100
        puts "envoi d'un mail à l'agent => #{agent.first_name}"
        Agents::WaitingRoomMailer.with(agent: @agent, rdv: @rdv).user_in_waiting_room.deliver_later
      end
    end

    if current_organisation.territory.enable_waiting_room_color_field
		# change la couleur du rdv
	end
  end
end
