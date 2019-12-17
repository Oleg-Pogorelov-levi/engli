require 'rails_helper'

RSpec.describe Phrase, type: :model do
  context 'validation test' do
    it "phrase is valid" do
      phrase = Phrase.new(phrase: '')
      phrase.valid?
      phrase.errors[:phrase].should_not be_empty
    end
  end
end
