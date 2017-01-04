module LightwaveLink
  class Response
    attr_reader :message, :server
    def initialize response
      @message = response[0].chomp
      @server = response[1]
    end

    def transaction_number
      if @message.start_with?('!*')
        s = @message.sub('!*','')
        return JSON.parse(s)
      end
    end
  end
end
