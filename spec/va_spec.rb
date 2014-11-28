require "./spec/spec_helper"

scope do
  class Login < Va::Model
    attribute :email
    attribute :pass
  end

  scope "init" do
    let(:va) { Login.new({"email" => "fede@example.com", pass: "123456"}) }

    it { va.email == "fede@example.com" }
    it { va.pass == "123456" }
  end

  scope "#attributes" do
    spec "all" do
      @va = Login.new(email: "fede@example.com", pass: "123456")
      @va.attributes == { email: "fede@example.com", pass: "123456" }
    end

    spec "some" do
      @va = Login.new(email: "fede@example.com")
      @va.attributes == { email: "fede@example.com" }
    end

    spec "spureous" do
      @va = Login.new(email: "fede@example.com", i_dont_belong_here: "HELLO!")
      @va.attributes == { email: "fede@example.com" }
    end
  end
end

scope "custom validations" do
  spec "basic passing validation" do
    class VeryValid < Va::Model
      validate do
        true
      end
    end

    @va = VeryValid.new
    @va.valid?
  end

  spec "basic passing validation" do
    class VeryInvalid < Va::Model
      validate do
        false
      end
    end

    @va = VeryInvalid.new
    ! @va.valid?
  end

  scope "A range validation" do
    class MyRange < Va::Model
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
      begin
        class FaceValidator < Va::Model
          attribute :face

          validate(:leg) do |leg|
            true
          end
        end
      rescue Object => e
        e.class == Va::UnknownAttribute
      end
    end
  end
end
