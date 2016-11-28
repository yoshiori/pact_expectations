require "spec_helper"

RSpec.describe PactExpectations do
  it "has a version number" do
    expect(PactExpectations::VERSION).not_to be nil
  end

  before do
    PactExpectations.reset!
  end

  describe ".add_response_body_for" do
    context "duplicate registration" do
      before do
        PactExpectations.add_response_body_for("foo")
      end
      it do
        expect { PactExpectations.add_response_body_for("foo") }.to(
          raise_error(PactExpectations::DuplicatedKey)
        )
      end
    end
  end

  describe ".response_body_for" do
    before do
      PactExpectations.add_response_body_for("foo", Pact.like(name: "pen"))
    end

    it "return response body" do
      expect(PactExpectations.response_body_for("foo")).to eq Pact.like(name: "pen")
    end

    context "key not found" do
      it do
        expect { PactExpectations.response_body_for("bar") }.to(
          raise_error(PactExpectations::NotFound)
        )
      end
    end
  end

  describe ".reified_body_for" do
    before do
      PactExpectations.add_response_body_for("foo", Pact.like(name: "pen"))
    end

    it "return reified body" do
      expect(PactExpectations.reified_body_for("foo")).to eq(name: "pen")
    end

    context "key not found" do
      it do
        expect { PactExpectations.reified_body_for("bar") }.to(
          raise_error(PactExpectations::NotFound)
        )
      end
    end
  end

  describe ".verify" do
    before do
      PactExpectations.add_response_body_for("foo", Pact.like(name: "pen"))
    end

    context "call response_body_for and reified_body_for" do
      before do
        PactExpectations.response_body_for("foo")
        PactExpectations.reified_body_for("foo")
      end
      it "do nothing" do
        expect(PactExpectations.verify).to be_nil
      end
    end

    context "not call response_body_for" do
      before { PactExpectations.reified_body_for("foo") }
      it do
        expect { PactExpectations.verify }.to(
          raise_error(PactExpectations::VerifyError)
        )
      end
    end

    context "not call reified_body_for" do
      before { PactExpectations.response_body_for("foo") }
      it do
        expect { PactExpectations.verify }.to(
          raise_error(PactExpectations::VerifyError)
        )
      end
    end

    context "not call response_body_for and reified_body_for" do
      it do
        expect { PactExpectations.verify }.to(
          raise_error(PactExpectations::VerifyError)
        )
      end
    end
  end
end
