class ChannelController < ApplicationController
	skip_before_action :verify_authenticity_token
  
  def index
    @channels = Channel.order(guide_server_id: :asc)
  end
  
  def live
    @channel = Channel.where(id: params[:id]).first
  end
  
  def update_instruction
    @channel = Channel.where(id: params[:id]).first
    return render plain: "channel not found", status: 404 if @channel.nil?
    
    instruction = params[:instruction]
    reset_channel = params[:reset] =~ /true/i
    
    if instruction.blank? && reset_channel
      resp = @channel.restart_channel!
    elsif !instruction.blank?
      @channel.instruction = instruction
      it_worked = @channel.save
      return render plain: "error saving channel" unless it_worked
      
      if reset_channel
        resp = @channel.run_instruction!
      else
        resp = @channel.queue_instruction
      end
      
      render plain: "ayy lmao #{resp.body}"
    else
      render plain: "no instruction provided"
    end
  end
end
