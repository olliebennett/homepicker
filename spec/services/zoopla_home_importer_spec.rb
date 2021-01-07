# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ZooplaHomeImporter do
  describe '#parse' do
    let(:zoopla_1_file) { IO.read('spec/fixtures/zoopla/example_1.html') }
    let(:zoopla_1_data) { described_class.new(zoopla_1_file).parse }

    context 'with example 1' do
      it 'parses canonical url' do
        expect(zoopla_1_data).to include(
          zoopla_url: 'https://www.zoopla.co.uk/for-sale/details/56623705'
        )
      end

      it 'parses title' do
        expect(zoopla_1_data[:title]).to eq '1 bed flat'
      end

      it 'parses description' do
        expect(zoopla_1_data[:description]).to include 'Central Marylebone luxury 1 bedroom apartment'
      end

      it 'parses address fields' do
        expect(zoopla_1_data).to include(
          address_street: 'York Street',
          address_locality: 'London',
          address_region: 'London'
        )
      end

      it 'parses postcode' do
        expect(zoopla_1_data[:postcode]).to eq 'W1H 1PW'
      end

      it 'parses location data' do
        expect(zoopla_1_data).to include(
          latitude: 51.520254,
          longitude: -0.159889
        )
      end

      it 'parses price' do
        expect(zoopla_1_data).to include(
          price: 950_000
        )
      end
    end
  end
end
