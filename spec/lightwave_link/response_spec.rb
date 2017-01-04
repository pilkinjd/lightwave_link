require 'spec_helper'

describe LightwaveLink::Response do
  it 'sets the message and server when initialized' do
    response = LightwaveLink::Response.new(['message', ['server_ip','port','something','something_else']])
    expect(response.message).to eq 'message'
    expect(response.server[0]).to eq 'server_ip'
    expect(response.server[1]).to eq 'port'
  end

  context 'simple OK response' do
    it 'extracts the transaction number' do
      response = LightwaveLink::Response.new(["234,OK\r\n", ['server_ip','port','something','something_else']])
      expected = {trans: 234, fn: "OK"}
      expect(response.item).to match expected
    end
  end

  context 'complex JSON response' do
    it 'extracts the transaction number' do
      response = LightwaveLink::Response.new(['*!{"trans":1,"mac":"03:34:BC","time":1456495650,"pkt":"433T","fn":"on","room":1,"dev":1}',
                                              ['server_ip','port','something','something_else']])
      expect(response.item[:trans]).to eq 1
      expect(response.item[:mac]).to eq "03:34:BC"
      expect(response.item[:time]).to eq 1456495650
      expect(response.item[:pkt]).to eq "433T"
      expect(response.item[:fn]).to eq "on"
      expect(response.item[:room]).to eq 1
      expect(response.item[:dev]).to eq 1
    end
  end
end
