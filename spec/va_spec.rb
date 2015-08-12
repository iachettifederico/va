require "./spec/spec_helper"

scope do
  class Login < Va::Validator
    attribute :email
    attribute :pass
  end

  scope "init" do
    let(:va) { Login.new({"email" => "fede@example.com", pass: "123456"}) }

    spec { va.email == "fede@example.com" }
    spec { va.pass == "123456" }
  end

  scope "#attributes" do
    spec "all" do
      @attributes = Login.new(email: "fede@example.com", pass: "123456").attributes
      @attributes == { email: "fede@example.com", pass: "123456" }
    end

    spec "some" do
      @va = Login.new(email: "fede@example.com")
      @va.attributes == { email: "fede@example.com" }
    end
  end
end

scope "custom validations" do
  spec "basic passing validation" do
    class VeryValid < Va::Validator
      validate do
        true
      end
    end

    @va = VeryValid.new
    @va.valid?
  end

  spec "basic passing validation" do
    class VeryInvalid < Va::Validator
      validate do
        false
      end
    end

    @va = VeryInvalid.new
    ! @va.valid?
  end

  scope "A range validation" do
    class MyRange < Va::Validator
      attribute :from
      attribute :to

      validate(:from, :to) do |from, to|
        from < to
      end
    end

    spec "valid" do
      @r = MyRange.new(from: 1, to: 5)
      @r.valid?
    end

    spec do
      @r = MyRange.new(from: 10, to: 5)
      ! @r.valid?
    end
  end

  scope "can't validate" do
    spec "invalid arguments" do
      @ex = capture_exception(Va::UnknownAttribute) do
        class FaceLidator < Va::Validator
          attribute :face

          validate(:leg) do |leg|
            true
          end
        end

        presenter.to_whatever
      end

      @ex.is_a?(Va::UnknownAttribute)
    end
  end
end

scope "raising UnauthorizedAttribute on initialization" do
  class NonRaiser < Va::Validator
    ignore_unauthorized_attributes
    attribute :yes
  end

  class Raiser < Va::Validator
    attribute :yes
  end

  spec "raising when passing one attribute" do
    @ex = capture_exception(Va::UnauthorizedAttribute) do
      @va = Raiser.new(no: :something)
    end

    @ex.is_a?(Va::UnauthorizedAttribute)
  end

  spec "raising when passing more than one attribute" do
    @ex = capture_exception(Va::UnauthorizedAttribute) do
      @va = Raiser.new(yes: :something, no: :something_else)
    end

    @ex.is_a?(Va::UnauthorizedAttribute)
  end

  spec "names the attribute name on the message" do
    @ex = capture_exception(Va::UnauthorizedAttribute) do
      @va = Raiser.new(attr_name: :something_else)
    end

    !! (@ex.message =~ /'attr_name'/)
  end

  spec "names the validator name on the message" do
    @ex = capture_exception(Va::UnauthorizedAttribute) do
      @va = Raiser.new(attr_name: :something_else)
    end

    !! (@ex.message =~ /'Raiser'/)
  end

  spec "not raising when passing one attribute" do
    @va = NonRaiser.new(no: :something)
    @va.valid?
  end

  spec "raising when passing more than one attribute" do
    @va = NonRaiser.new(yes: :something, no: :something_else)

    @va.valid?
  end
end

scope "validate multiple" do
  class Name < Va::Validator
    attribute :first
    attribute :last

    validate_multiple(:first, :last) do |attr|
      attr.size > 0
    end
  end

  spec "passing" do
    @va = Name.new(first: "Federico", last: "Iachetti")
    @va.valid?
  end

  spec "all failing" do
    @va = Name.new(first: "", last: "")
    ! @va.valid?
  end

  spec "one failing" do
    @va = Name.new(first: "Federico", last: "")
    ! @va.valid?
  end
end

scope "default values" do
  class MyDefaults < Va::Validator
    attribute :name, default: "N/A"
    attribute :age
  end

  spec do
    @attributes = MyDefaults.new(age: 30).attributes
    @attributes == {name: "N/A", age: 30}
  end

  class BooleanDefaults < Va::Validator
    attribute :me_true,  default: true
    attribute :me_false, default: false
    attribute :not_me
  end

  spec do
    @attributes = BooleanDefaults.new.attributes
    @attributes == {me_true: true, me_false: false}
  end
end
