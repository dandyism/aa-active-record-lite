require_relative 'db_connection'
require_relative '02_sql_object'

module Searchable
  def where(params = {})
    where_clause = params.map do |attr_name, value|
      "#{self.table_name}.#{attr_name} = :#{attr_name}"
    end.join(" AND ")
    
    sql = <<-SQL
      SELECT
        "#{self.table_name}".*
      FROM
        "#{self.table_name}"
      WHERE
        #{where_clause}
    SQL
    
    results = DBConnection.execute(sql, params)
    
    self.parse_all(results)
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end
