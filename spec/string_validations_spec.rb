require "./spec/spec_helper"

require "va/string_validations"

scope "string validations" do
  scope "is string" do
    class Person < Va::Validator
      include StringValidations
      attribute :name

      validate_string(:name)
    end

    spec "is a string" do
      @p = Person.new(name: "Fede")
      @p.valid?
    end

    spec "not a string" do
      @p = Person.new(name: 5)
      ! @p.valid?
    end

    spec "accepts nils" do
      @p = Person.new
      @p.valid?
    end
  end

  scope "string is not empty" do
    class Person < Va::Validator
      include StringValidations
      attribute :name

      validate_string_not_empty(:name)
    end

    spec "not empty" do
      @p = Person.new(name: "Fede")
      @p.valid?
    end

    spec "empty" do
      @p = Person.new(name: "")
      ! @p.valid?
    end
  end
end
