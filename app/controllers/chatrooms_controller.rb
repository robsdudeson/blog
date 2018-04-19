class ChatroomsController < ApplicationController

  def index
    @chatrooms = Chatroom.all
  end

  def show
    @chatroom = Chatroom.find_by(slug: params[:slug])
    @message = Message.new
  end
  
end
