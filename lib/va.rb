require "va/version"

module Va
  class Model
    attr_reader :attributes

    def initialize(**args)
      @attributes = {}
      args.each do |k, v|
        key = k.to_sym
        @attributes[key] = v if self.class.keys.include?(key)
      end
    end

    def valid?
      self.class.validations.all? { |attrs, validation|
        validation.call(attrs.map { |attr| self.send(attr)})
      }
    end

    private
    def self.validations
      @validations ||= []
    end

    def self.validate(*attrs, &block)
      attrs.each do |attr|
        raise UnknownAttribute unless keys.include?(attr)
      end
      validations << [attrs, block]
    end

    def self.keys
      @keys ||= []
    end

    def self.attribute(attr_name)
      name = attr_name.to_sym

      self.keys << name

      define_method "#{name}=" do |value|
        attributes[name] = value
      end

      define_method "#{name}" do
        attributes[name]
      end
    end
  end
  class UnknownAttribute < Exception; end
end


