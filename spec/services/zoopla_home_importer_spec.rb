# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ZooplaHomeImporter do
  describe '#parse' do
    let(:zoopla_1_file) { IO.read('spec/fixtures/zoopla/example_1.html') }
    let(:zoopla_1_data) { described_class.parse(zoopla_1_file) }

    context 'from example 1' do
      it 'parses basic data' do
        expect(zoopla_1_data).to include(
          zoopla_url: 'https://www.zoopla.co.uk/for-sale/details/56623705',
          title: '1 bed flat',
          price: 950_000,
          latitude: 51.520254,
          longitude: -0.159889,
          postcode: 'W1H 1PW',
          address_street: 'York Street',
          address_locality: 'London',
          address_region: 'London',
          description: /Central Marylebone luxury 1 bedroom apartment/,
        )
      end
    end
  end
end
