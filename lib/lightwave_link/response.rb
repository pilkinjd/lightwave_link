require 'json'

module LightwaveLink
  class Response
    attr_reader :item, :message, :server
    def initialize response
      @message = response[0].chomp
      @server  = response[1]
      @item    = extract_elements
    end

    private

    def extract_elements
      if @message.start_with?('*!')
        string = @message.sub('*!','')
        elements = JSON.parse(string)
        Hash[elements.map{ |k, v| [k.to_sym, v] }]
      else
        elements = @message.split(',')
        {trans: elements[0].to_i, status: elements[1] }
      end
    end
  end
end
