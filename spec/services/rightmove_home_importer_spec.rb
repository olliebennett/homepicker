# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RightmoveHomeImporter do
  describe '#parse' do
    let(:rightmove_1_file) { IO.read('spec/fixtures/rightmove/example_1.html') }
    let(:rightmove_1_data) { described_class.new(rightmove_1_file).parse }

    context 'with example 1' do
      it 'parses canonical url' do
        expect(rightmove_1_data).to include(
          rightmove_url: 'https://www.rightmove.co.uk/properties/83401585'
        )
      end

      it 'parses address fields' do
        expect(rightmove_1_data).to include(
          address_street: 'South Bank Tower',
          address_locality: '55 Upper Ground',
          address_region: 'Bankside, SE1'
        )
      end

      it 'parses postcode' do
        expect(rightmove_1_data).to include(
          postcode: 'SE1 9RB'
        )
      end

      it 'parses location data' do
        expect(rightmove_1_data).to include(
          latitude: 51.507649,
          longitude: -0.107771
        )
      end

      it 'parses title and description' do
        expect(rightmove_1_data).to include(
          title: '2 bedroom apartment for sale in South Bank Tower, 55 Upper Ground, Bankside, SE1',
          description: /a 20m indoor swimming pool/
        )
      end

      it 'parses price' do
        expect(rightmove_1_data).to include(
          price: 1_875_000
        )
      end
    end
  end
end
