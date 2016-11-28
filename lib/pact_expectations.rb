require "set"
require "pact/support"

require "pact_expectations/version"

class PactExpectations
  class Error < ::StandardError
  end
  class NotFound < Error
  end

  class DuplicatedKey < Error
  end

  class ExpectationNotCalled < Error
    def initialize(not_call_responses = [], not_call_reificated = [])
      @not_call_responses = not_call_responses
      @not_call_reificated = not_call_reificated
    end

    def message
      message = String.new("\n")
      unless @not_call_responses.empty?
        message << create_not_call_message(
          "Some expectations were defined but not used to construct the Contract",
          @not_call_responses
        )
      end
      unless @not_call_reificated.empty?
        message << create_not_call_message(
          "Some expectations were defined but not used to stub Remote Facade",
          @not_call_reificated
        )
      end
      message
    end

    private

    def create_not_call_message(title, list)
      message = String.new("#{title}:\n")
      list.each do |key|
        message << "- #{key}\n"
      end
      message << "\n"
    end
  end
  VerifyError = ExpectationNotCalled # For backward-compatibility

  class << self
    def add_response_body_for(key, expectation = {})
      raise DuplicatedKey if expectations.include?(key)
      expectations[key] = expectation
    end

    def response_body_for(key)
      raise NotFound unless expectations.include?(key)
      response_call << key
      expectations[key]
    end

    def reified_body_for(key)
      raise NotFound unless expectations.include?(key)
      reificated_call << key
      Pact::Reification.from_term(expectations[key])
    end

    def verify
      not_call_responses = response_call ^ expectations.keys
      not_call_reificated = reificated_call ^ expectations.keys

      if !not_call_responses.empty? || !not_call_reificated.empty?
        raise ExpectationNotCalled.new(not_call_responses, not_call_reificated)
      end
    end

    def reset!
      @expectations = nil
      @response_call = nil
      @reificated_call = nil
    end

    private

    def expectations
      @expectations ||= {}
    end

    def response_call
      @response_call ||= Set.new
    end

    def reificated_call
      @reificated_call ||= Set.new
    end
  end
end
