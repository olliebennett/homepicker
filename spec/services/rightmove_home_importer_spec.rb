# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RightmoveHomeImporter do
  describe '#parse' do
    context 'with example 1' do
      let(:rm1_file) { File.read('spec/fixtures/rightmove/example_1.html') }
      let(:rm1) { described_class.new(rm1_file).parse }

      it 'parses canonical url' do
        expect(rm1[:rightmove_url]).to eq 'https://www.rightmove.co.uk/properties/83401585'
      end

      it 'parses address fields' do
        expect(rm1).to include(
          address_street: 'South Bank Tower',
          address_locality: '55 Upper Ground',
          address_region: 'Bankside'
        )
      end

      it 'parses postcode' do
        expect(rm1[:postcode]).to eq 'SE1 9RB'
      end

      it 'parses location data' do
        expect(rm1).to include(
          latitude: 51.507649,
          longitude: -0.107771
        )
      end

      it 'parses title' do
        expect(rm1[:title]).to eq '2 bedroom apartment for sale'
      end

      it 'parses description' do
        expect(rm1[:description]).to include 'a 20m indoor swimming pool'
      end

      it 'parses key features (and prepends to desc in list format)' do
        expect(rm1[:description]).to include '- example key feature two'
      end

      it 'parses price' do
        expect(rm1[:price]).to eq 1_875_000
      end

      it 'parses image data' do
        expect(rm1[:images]).to include 'https://media.rightmove.co.uk/121k/120835/83401585/120835_SNE190293_IMG_21_0000.jpg'
      end

      it 'parses floorplan image url' do
        # NOTE: floorplans are simply stored (last) in the images array
        expect(rm1[:images].last).to eq 'https://media.rightmove.co.uk/121k/120835/83401585/120835_SNE190293_FLP_01_0000.jpg'
      end

      it 'ignores floorplan links' do
        expect(rm1[:images]).not_to include 'https://www.example.com/floorplan_link'
      end
    end

    context 'with example 2' do
      let(:rm2_file) { File.read('spec/fixtures/rightmove/example_2.html') }
      let(:rm2) { described_class.new(rm2_file).parse }

      it 'parses canonical url' do
        expect(rm2[:rightmove_url]).to eq 'https://www.rightmove.co.uk/properties/77665544'
      end

      it 'parses address fields' do
        expect(rm2).to include(
          address_street: 'Example Court',
          address_locality: 'London',
          address_region: ''
        )
      end

      it 'parses postcode' do
        expect(rm2[:postcode]).to eq 'E14 1AA'
      end

      it 'parses location data' do
        expect(rm2).to include(
          latitude: 51.1234,
          longitude: -0.012345
        )
      end

      it 'parses title' do
        expect(rm2[:title]).to eq '2 bedroom flat for rent'
      end

      it 'parses description' do
        expect(rm2[:description]).to include 'split over two levels'
      end

      it 'parses key features (and prepends to desc in list format)' do
        expect(rm2[:description]).to include '- Owner occupied, so it is very well maintained.'
      end

      it 'parses price' do
        expect(rm2[:price]).to eq 1_599
      end

      it 'parses image data' do
        expect(rm2[:images]).to include 'https://media.rightmove.co.uk/97k/96668/77665544/96668_9988776655443322_IMG_00_0000.jpeg'
      end
    end
  end
end
