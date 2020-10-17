# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinkRetrieverService do
  describe '#parse_zoopla' do
    let(:zoopla_1_html) { IO.read('spec/fixtures/link_retriever_data/zoopla_1.html') }
    let(:zoopla_2_html) { IO.read('spec/fixtures/link_retriever_data/zoopla_2.html') }

    let(:zoopla_1_data) { described_class.parse_zoopla(zoopla_1_html) }
    let(:zoopla_2_data) { described_class.parse_zoopla(zoopla_2_html) }

    it 'parses zoopla canonical url' do
      expect(zoopla_1_data[:canonical_url]).to eq 'http://www.zoopla.co.uk/for-sale/details/87654321'
      expect(zoopla_2_data[:canonical_url]).to eq 'http://www.zoopla.co.uk/for-sale/details/12345678'
    end

    it 'parses price data' do
      expect(zoopla_1_data[:price]).to eq 16_000_000
      expect(zoopla_2_data[:price]).to eq 425_000
    end

    it 'parses longitude and latitude' do
      expect(zoopla_1_data[:latitude]).to eq 51.493946
      expect(zoopla_1_data[:longitude]).to eq(-0.160260)

      expect(zoopla_2_data[:latitude]).to eq 52.19005
      expect(zoopla_2_data[:longitude]).to eq 0.161242
    end

    it 'parses postcode' do
      expect(zoopla_1_data[:postcode]).to eq 'SW3 2RE'
      expect(zoopla_2_data[:postcode]).to eq 'CB1 3TB'
    end

    it 'parses street address' do
      expect(zoopla_1_data[:address]).to eq 'Fraserburgh Hill, London SW3'
      expect(zoopla_2_data[:address]).to eq 'Baldock Street, Cambridge CB1'
    end

    it 'parses description' do
      expect(zoopla_1_data[:description]).to include 'wealth of period features'
      expect(zoopla_2_data[:description]).to include 'tastefully updated by the current owner'
    end

    it 'parses images' do
      # expect(data[:price]).to eq '16000000'
      # expect(data[:price]).to eq '16000000'
      # expect(data[:price]).to eq '16000000'
      # expect(data[:price]).to eq '16000000'
      # expect(data[:price]).to eq '16000000'
    end
  end
end
