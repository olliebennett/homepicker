# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinkRetrieverService do
  describe '#strip_url_preamble' do
    it 'removes Rightmove share prefix' do
      input = 'I found this property on the Rightmove Android app and wanted you to see it: https://www.rightmove.co.uk/properties/12345678'

      expect(described_class.strip_url_preamble(input)).to eq('https://www.rightmove.co.uk/properties/12345678')
    end
  end
end
