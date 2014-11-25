require "./spec/spec_helper"

scope do
  class Login < Va::Model
    attribute :email
    attribute :pass
  end

  test "init" do
    va = Login.new({"email" => "fede@example.com", pass: "123456"})
    assert_equal va.email, "fede@example.com"
    assert_equal va.pass,  "123456"
  end

  scope "#attributes" do
    test "all" do
      va = Login.new(email: "fede@example.com", pass: "123456")
      assert_equal va.attributes, { email: "fede@example.com", pass: "123456" }
    end

    test "some" do
      va =  Login.new(email: "fede@example.com")
      assert_equal va.attributes, { email: "fede@example.com" }
    end

    test "spureous" do
      va =  Login.new(email: "fede@example.com", i_dont_belong_here: "HELLO!")
      assert_equal va.attributes, { email: "fede@example.com" }
    end
  end
end
scope "validations" do
  test "basic passing validation" do
    class VeryValid < Va::Model
      validate do
        true
      end
    end

    va = VeryValid.new
    assert_equal va.valid?, true
  end

  test "basic passing validation" do
    class VeryInvalid < Va::Model
      validate do
        false
      end
    end

    va = VeryInvalid.new
    assert_equal va.valid?, false
  end

  scope "A range validation" do
    class MyRange < Va::Model
      attribute :from
      attribute :to

      validate(:from, :to) do |from, to|
        from < to
      end
    end

    test "valid" do
      r = MyRange.new(from: 1, to: 5)
      assert_equal r.valid?, true
    end

    test do
      r = MyRange.new(from: 10, to: 5)
      assert_equal r.valid?, false
    end
  end

  scope "can't validate" do
    test "invalid arguments" do
      begin
        class FaceValidator < Va::Model
          attribute :face

          validate(:leg) do |leg|
            true
          end
        end
        assert nil
      rescue Object => e
        assert_equal e.class, Va::UnknownAttribute
      end
    end
  end
end
