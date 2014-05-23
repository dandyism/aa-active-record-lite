require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'

class MassObject
  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
  end
end

class SQLObject < MassObject
  def self.columns
    sql = "SELECT * FROM #{self.table_name} LIMIT 0"
    
    cols = DBConnection.execute2(sql).flatten
    cols.map!(&:to_sym)
    
    # define attr_accessors
    cols.each do |col|
      define_method("#{col}") do
        self.attributes[col]
      end
    
      define_method("#{col}=") do |val|
        self.attributes[col] = val
      end
    end
    
    cols
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= class_name_to_table
  end

  def self.all
    sql = "SELECT #{self.table_name}.* FROM #{self.table_name}"
    
    DBConnection.execute(sql)
  end

  def self.find(id)
    # ...
  end

  def attributes
    @attributes ||= {}
  end

  def insert
    # ...
  end

  def initialize(params = {})
    columns = self.class.columns
    
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      
      unless columns.include?(attr_name)
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def save
    # ...
  end

  def update
    # ...
  end

  def attribute_values
    # ...
  end
  
  protected
  def self.class_name_to_table
    self.name.gsub(/([a-z])([A-Z])/, '\1_\2')
             .downcase
             .pluralize
  end
end
