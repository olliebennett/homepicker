# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RightmoveHomeImporter do
  describe '#parse' do
    let(:rm_1_file) { IO.read('spec/fixtures/rightmove/example_1.html') }
    let(:rm_1) { described_class.new(rm_1_file).parse }

    context 'with example 1' do
      it 'parses canonical url' do
        expect(rm_1[:rightmove_url]).to eq 'https://www.rightmove.co.uk/properties/83401585'
      end

      it 'parses address fields' do
        expect(rm_1).to include(
          address_street: 'South Bank Tower',
          address_locality: '55 Upper Ground',
          address_region: 'Bankside'
        )
      end

      it 'parses postcode' do
        expect(rm_1[:postcode]).to eq 'SE1 9RB'
      end

      it 'parses location data' do
        expect(rm_1).to include(
          latitude: 51.507649,
          longitude: -0.107771
        )
      end

      it 'parses title' do
        expect(rm_1[:title]).to eq '2 bedroom apartment for sale'
      end

      it 'parses description' do
        expect(rm_1[:description]).to include 'a 20m indoor swimming pool'
      end

      it 'parses key features (and prepends to desc in list format)' do
        expect(rm_1[:description]).to include '- example key feature two'
      end

      it 'parses price' do
        expect(rm_1[:price]).to eq 1_875_000
      end

      it 'parses image data' do
        expect(rm_1[:images]).to include 'https://media.rightmove.co.uk/121k/120835/83401585/120835_SNE190293_IMG_21_0000.jpg'
      end

      it 'parses floorplan image url' do
        # Note: floorplans are simply stored (last) in the images array
        expect(rm_1[:images].last).to eq 'https://media.rightmove.co.uk/121k/120835/83401585/120835_SNE190293_FLP_01_0000.jpg'
      end
    end
  end
end
