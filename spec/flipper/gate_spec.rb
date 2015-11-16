require 'helper'

RSpec.describe Flipper::Gate do
  let(:feature_name) { :stats }

  subject {
    described_class.new
  }

  describe "#inspect" do
    context "for subclass" do
      let(:subclass) {
        Class.new(described_class) {
          def name
            :name
          end

          def key
            :key
          end

          def data_type
            :set
          end
        }
      }

      subject {
        subclass.new
      }

      it "includes attributes" do
        string = subject.inspect
        expect(string).to include(subject.object_id.to_s)
        expect(string).to include('name=:name')
        expect(string).to include('key=:key')
        expect(string).to include('data_type=:set')
      end
    end
  end
end
