class ChannelController < ApplicationController
  def index
    @channels = Channel.order(guide_server_id: :asc)
  end
  
  def live
    @channel = Channel.where(id: params[:id]).first
  end
end
