require "./spec/spec_helper"

scope "errors" do
  class Truthy < Va::Validator
    attribute :t
    validate(:t, "not truthy") do |t|
      t
    end
  end

  spec do
    va = Truthy.new(t: false)
    @errors = va.errors
    @errors == { t: "not truthy"}
  end

  class Falsey < Va::Validator
    attribute :f1
    attribute :f2
    validate(:f1, :f2, "not falsey") do |f1, f2|
      !f1 && !f2
    end
  end

  spec do
    va = Falsey.new(f1: false, f2: true)
    @errors = va.errors
    @errors == { [:f1, :f2] => "not falsey"}
  end

  class WithoutMessages < Va::Validator
    attribute :a
    attribute :b

    validate(:a) do |a|
      false
    end

    validate(:a, :b) do |a, b|
      false
    end
  end

  spec do
    va = WithoutMessages.new
    @errors = va.errors
    @errors == { :a => "is invalid", [:a, :b] => "is invalid" }
  end

end
