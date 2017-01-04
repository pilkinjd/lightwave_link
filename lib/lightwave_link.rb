require "lightwave_link/version"
require 'lightwave_link/response'
require 'socket'
require 'timeout'

module LightwaveLink
  class Api
    TIMEOUT=5

    def initialize
      BasicSocket.do_not_reverse_lookup = true
      @sn = rand(1..9999)
      @client_socket = UDPSocket.new
      @server_socket = UDPSocket.new
    end

    def connect
      @client_socket.connect("<broadcast>", 9760)
      @client_socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
      my_ip = Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3]
      @server_socket.bind(my_ip, 9761)
      yield self
      close
    end

    def send_and_wait_for message
      send_out message
      wait_for_response
    end

    private

    def send_out message
      sending = "#{next_sequence!},#{message}"
      @client_socket.send sending, 0
      puts "Sent: #{sending}"
    end

    def wait_for_response
      begin
        Timeout::timeout(TIMEOUT) do
          get_reponses
        end
      rescue Timeout::Error
      end
    end

    def get_reponses
      responses = []
      while(true) do
        this_response = @server_socket.recvfrom( 1024 )
        puts this_response.inspect

        responses << LightwaveLink::Response.new(this_response)
        return responses if responses.last.message.start_with?("#{@sn},")
      end
    end

    def close
      @client_socket.close
      @server_socket.close
    end

    def next_sequence!
      @sn = @sn + 1
    end
  end
end
