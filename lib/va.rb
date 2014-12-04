require "va/version"

module Va
  class Validator
    attr_reader :attributes
    attr_reader :errors

    def initialize(args={})
      @attributes ||= self.class.defaults.dup
      args.each do |k, v|
        key = k.to_sym
        @attributes[key] = v if self.class.keys.include?(key)
      end
      @errors = {}
      @valid = validate
    end

    def validate
      invalid_validations = self.class.validations.select { |attrs, msg, validation|
        is_invalid = !validation.call(*attrs.map { |attr| self.send(attr)})
        key = attrs.count == 1 ? attrs.first : attrs
        errors[key] = msg || "is invalid" if is_invalid
        is_invalid
      }
      invalid_validations.empty?
    end

    def message(msg="", *attrs)
      raise __callee__.inspect
    end

    def valid?
      @valid
    end

    private
    def self.validations
      @validations ||= []
    end

    def self.validate(*attrs, &block)
      msg = if attrs.last.is_a? String
              attrs.pop
            end
      attrs.each do |attr|
        raise UnknownAttribute unless keys.include?(attr)
      end
      validations << [attrs, msg, block]
    end

    def self.validate_multiple(*attrs, &block)
      attrs.each do |attr|
        validate(attr, &block)
      end
    end

    def self.validate_present(*attrs)
      validate_multiple(*attrs) do |attr|
        attr && attr != ""
      end
    end

    def self.validate_not_nil(*attrs)
      validate_multiple(*attrs) do |attr|
          attr != nil
      end
    end

    def self.keys
      @keys ||= []
    end

    def self.defaults
      @defaults ||= {}
    end

    def self.attribute(attr_name, options={})
      name = attr_name.to_sym

      self.keys << name

      default = options.fetch(:default) { NotSpecified }
      self.defaults[name] = default unless default == NotSpecified

      define_method "#{name}=" do |value|
        attributes[name] = value
      end

      define_method "#{name}" do
        attributes[name]
      end
    end
  end
  class UnknownAttribute < Exception; end
  class NotSpecified ; end
end
