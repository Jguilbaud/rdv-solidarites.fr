class Admin::UserInWaitingRoomsController < AgentAuthController
	def create
		rdv = Rdv.find(params[:rdv_id])
		authorize(rdv)
		puts "waiting room controller => create"

	end
end