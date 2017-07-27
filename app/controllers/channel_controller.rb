class ChannelController < ApplicationController
	skip_before_action :verify_authenticity_token
  
  def index
    @channels = Channel.order(guide_server_id: :asc)
  end
  
  def live
    @channel = Channel.where(id: params[:id]).first
    
    respond_to do |format|
      format.html
      format.json { render json: @channel.stream_instruction }
    end
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
  
  def render_instruction
    instruction_arg = params[:instruction]
    if String === instruction_arg
      instructions = [StreamInstruction.new(instruction_arg)]
    elsif Array === instruction_arg
      instructions = instruction_arg.map { |i| StreamInstruction.new(i) }
    else
      return render plain: "huh", status: 400
    end
    keys = instructions.map { |si| si.args["key"] }
    @playlists = keys.map { |k| Playlist.where(key: k).first }
    return render partial: "playlist", collection: @playlists if @playlists
    render plain: "huh", status: 400
  end
end
