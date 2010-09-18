#!/usr/bin/env ruby

Rails.root = File.dirname(__FILE__) + '../../..'

require 'rubygems'
gem 'revent', '>= 0.6'
require 'revent/as_r'
require "#{Rails.root}/config/config"

# ------------------------------------------------------------------------------

NUM_CHAT_MSGS = 100
GUEST_NAME_PREFIX = 'guest'

MSG_ENTER = 0
MSG_CHAT  = 1
MSG_LEAVE = 2

class Server
  include Revent::ASRServer

  def initialize(remote_host, remote_port, localhost, local_port)
    @clients = []
    @chat_msgs = []
    @session_id_to_user_name = {}
    @next_guest_id = 1

    self.logger = LOGGER
    self.policy = <<EOF
<cross-domain-policy>
<allow-access-from domain="#{remote_host}" to-ports="#{remote_port}" />
</cross-domain-policy>
EOF

    start_server(local_host, local_port)
  end

  def on_connect(client)
    client.session = {:user_name => nil}
  end

  def on_close(client)
    return if client.session[:user_name].nil?

    @clients.synchronize do
      @clients.delete(client)

      # There can be multiple clients with the same user name. Only broadcast
      # MSG_ON_LEAVE if there is no client with this user name.
      unless @clients.any? { |c| c.session[:user_name] == client.session[:user_name] }
        @clients.each { |c| c.send_message([MSG_ON_LEAVE, client.session[:user_name]]) }
      end
    end
  rescue
    LOGGER.debug($!)
  end

  def on_message(client, message)
    type, value = message
    if type == MSG_ENTER
      on_message_enter(client, value)
    elsif type == MSG_ENQUEUE_CHAT
      on_message_chat(client, value)
    else
      client.close_connection
    end
  rescue
    LOGGER.debug($!)
    LOGGER.debug($!.backtrace.join("\n"))
    begin
      client.close_connection
    rescue
    end
  end

  private

  def on_message_enter(client, value)
    if value.is_a?(Array)
      user_name, ecnrypted_key = value
      user_name = user_name_when_enter_with_user_name(user_name, ecnrypted_key)
      if user_name.nil?
        client.close_connection
        return
      end
    else
      session_id = value
      user_name = user_name_when_enter_with_guest_name(session_id)
    end
    client.session[:user_name] = user_name

    @clients.synchronize do
      existed = @clients.any? { |c| c.session[:user_name] == client.session[:user_name] }
      @clients << client

      user_name = client.session[:user_name]
      user_names = @clients.map { |c| c.session[:user_name] }
      user_names.compact!
      user_names.uniq!
      client.send_message([MSG_ENTER, [user_name, user_names, @chat_msgs]])

      unless existed
        @clients.each { |c| c.send_message([MSG_ENTER, user_name]) unless c == client }
      end
    end
  end

  def on_message_chat(client, value)
    if client.session[:user_name].nil?
      client.close_connection
      return
    end

    chat_item = [client.session[:user_name], value]
    @chat_msgs << chat_item
    if @chat_msgs.size > NUM_CHAT_MSGS
      @chat_msgs.synchronize { @chat_msgs.slice!(0, @chat_msgs.size - NUM_CHAT_MSGS) }
    end

    @clients.synchronize do
      @clients.each { |c| c.send_message([MSG_CHAT, chat_item]) }
    end
  end

  def user_name_when_enter_with_user_name(user_name, ecnrypted_key)
    salt = CONF[:session][:secret]
    true_ecnrypted_key = MD5.hexdigest(salt + user_name)
    (true_ecnrypted_key == ecnrypted_key)? user_name : nil
  end

  def user_name_when_enter_with_guest_name(session_id)
    @session_id_to_user_name.synchronize do
      user_name_and_created_at = @session_id_to_user_name[session_id]
      if user_name_and_created_at.nil?
        ret = "#{GUEST_NAME_PREFIX}#{@next_guest_id}"
        @next_guest_id += 1
        @session_id_to_user_name[session_id] = {:user_name => ret, :updated_at => Time.now}
      else
        ret = user_name_and_created_at[:usr_name]
        user_name_and_created_at[:updated_at] = Time.now
      end

      return ret
    end
  end
end

#-------------------------------------------------------------------------------

EventMachine::run do
  abort "Usage: #{__FILE__} <remote host> <remote port> [development]" unless ARGV.size < 2

  if ARGV.size == 3
    LOGGER = Logger.new("#{Rails.root}/log/chat.log", 'daily')
    LOGGER.level = Logger::INFO
  else
    LOGGER = Logger.new(STDOUT)
  end

  remote_host, remote_port, localhost, local_port = ARGV[0], ARGV[1], '0.0.0.0', ARGV[1]

  Server.new(remote_host, remote_port, localhost, local_port)
  LOGGER.info('Server started')
end
