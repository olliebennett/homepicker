# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HtmlStripper do
  describe '#to_plaintext' do
    context 'with div outer wrapper' do
      subject(:stripper) { described_class.new(container_node) }

      let(:html) { '<div><b>Some text</b></div>' }
      let(:container_node) { Nokogiri::HTML.fragment(html) }

      it 'returns the text' do
        expect(stripper.to_plaintext).to eq('Some text')
      end
    end

    context 'with unordered list' do
      subject(:stripper) { described_class.new(container_node) }

      let(:html) { '<div><ul><li>one</li><li>two</li></ul></div>' }
      let(:container_node) { Nokogiri::HTML.fragment(html) }

      it 'returns a bullet-style list' do
        expect(stripper.to_plaintext).to eq("\n- one\n- two")
      end
    end

    context 'with paragraph' do
      subject(:stripper) { described_class.new(container_node) }

      let(:html) { '<p>Some text</p>' }
      let(:container_node) { Nokogiri::HTML.fragment(html) }

      it 'returns the text on a new line' do
        expect(stripper.to_plaintext).to eq("\nSome text")
      end
    end
  end
end
