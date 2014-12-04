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
end
