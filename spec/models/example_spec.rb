require 'rails_helper'

RSpec.describe Example, type: :model do
  context 'validation test' do
    it "example is valid" do
      example = Example.new(example: '')
      example.valid?
      example.errors[:example].should_not be_empty
    end
  end
end
