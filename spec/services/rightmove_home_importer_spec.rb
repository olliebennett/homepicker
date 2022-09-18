# frozen_string_literal: true

require 'rails_helper'

RSpec.fdescribe RightmoveHomeImporter do
  describe '#parse' do
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

    context 'with example 3' do
      let(:rm3_file) { File.read('spec/fixtures/rightmove/example_3.html') }
      let(:rm3) { described_class.new(rm3_file).parse }

      it 'parses canonical url' do
        expect(rm3[:rightmove_url]).to eq 'https://www.rightmove.co.uk/properties/85417833'
      end

      it 'parses address fields' do
        expect(rm3).to include(
          address_street: 'Shaftesbury Road',
          address_locality: 'Leicester',
          address_region: nil
        )
      end

      it 'parses postcode' do
        expect(rm3[:postcode]).to eq 'LE3 0QN'
      end

      it 'parses location data' do
        expect(rm3).to include(
          latitude: 52.62928,
          longitude: -1.15176
        )
      end

      it 'parses title' do
        expect(rm3[:title]).to eq '1 bedroom flat for sale'
      end

      it 'parses description' do
        expect(rm3[:description]).to include 'currently tenanted so ideal as an investment'
      end

      it 'parses key features (and prepends to desc in list format)' do
        expect(rm3[:description]).to include '- Well Presented One Bedroom First Floor Flat'
      end

      it 'parses price' do
        expect(rm3[:price]).to eq 120_000
      end

      it 'parses image data' do
        expect(rm3[:images]).to include 'https://media.rightmove.co.uk/30k/29340/85417833/29340_100656005504_IMG_00_0000.jpeg'
      end
    end
  end
end
