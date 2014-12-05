module StringValidations
  module ClassMethods

    def validate_string(*attrs)
      validate_multiple(*attrs) do |attr|
        attr.is_a?(String) || attr.nil?
      end
    end

    def validate_string_not_empty(*attrs)
      validate_multiple(*attrs) do |attr|
        attr.is_a?(String) && !attr.empty?
      end
    end

  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
