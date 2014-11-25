require "./spec/spec_helper"

scope "basic validations" do
  scope "non-blank" do
    class ANonBlankAttribute < Va::Model
      attribute :name
      attribute :age
      validate_present(:name, :age)
    end
    test "passing" do
      va = ANonBlankAttribute.new(name: "Fede", age: :of_ultron)
      assert_equal va.valid?, true
    end

    test "one empty string" do
      va = ANonBlankAttribute.new(name: "", age: :of_ultron)
      assert_equal va.valid?, false
    end

    test "one nil" do
      va = ANonBlankAttribute.new(name: "Fede", age: nil)
      assert_equal va.valid?, false
    end

    test "both empty" do
      va = ANonBlankAttribute.new(name: nil, age: "")
      assert_equal va.valid?, false
    end
  end
end
