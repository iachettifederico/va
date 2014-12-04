require "./spec/spec_helper"

scope "basic validations" do
  scope "non-blank" do
    class ANonBlankAttribute < Va::Validator
      attribute :name
      attribute :age
      validate_present(:name, :age)
    end

    spec "passing" do
      @va = ANonBlankAttribute.new(name: "Fede", age: :of_ultron)
      @va.valid?
    end

    spec "one empty string" do
      @va = ANonBlankAttribute.new(name: "", age: :of_ultron)
      ! @va.valid?
    end

    spec "one nil" do
      @va = ANonBlankAttribute.new(name: "Fede", age: nil)
      ! @va.valid?
    end

    spec "both empty" do
      @va = ANonBlankAttribute.new(name: nil, age: "")
      ! @va.valid?
    end
  end

  scope "non-nil" do
    class ANotNilAttribute < Va::Validator
      attribute :name
      attribute :age
      validate_not_nil(:name, :age)
    end

    spec "passing" do
      @va = ANotNilAttribute.new(name: "Fede", age: :of_ultron)
      @va.valid?
    end

    spec "one empty string" do
      @va = ANotNilAttribute.new(name: "", age: :of_ultron)
      @va.valid?
    end

    spec "one nil" do
      @va = ANotNilAttribute.new(name: "Fede", age: nil)
      ! @va.valid?
    end

    spec "both empty" do
      @va = ANotNilAttribute.new(name: nil, age: "")
      ! @va.valid?
    end

    spec "both nil" do
      @va = ANotNilAttribute.new(name: nil, age: nil)
      ! @va.valid?
    end
  end

end
