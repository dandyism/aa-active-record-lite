require_relative '03_searchable'
require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    self.model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      :foreign_key => "#{name.to_s.underscore}_id".to_sym,
      :class_name => name.to_s.camelcase,
      :primary_key => "id".to_sym
    }

    defaults.merge!(options)
    defaults.each { |k, v| self.send("#{k}=", v) }
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      :foreign_key => "#{self_class_name.underscore}_id".to_sym,
      :class_name => name.to_s.camelcase.singularize,
      :primary_key => "id".to_sym
    }

    defaults.merge!(options)
    defaults.each { |k, v| self.send("#{k}=", v) }
  end
end

module Associatable
  # Phase IVb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)

    define_method(name) do
      foreign_key = self.send(options.foreign_key)
      klass = options.model_class

      klass.find(foreign_key)
    end
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase V. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
