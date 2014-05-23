require_relative '04_associatable'

# Phase V
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)

    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name
      foreign_key = through_options.foreign_key
      source_table = source_options.table_name
      source_foreign_key = source_options.foreign_key

      sql = <<-SQL
        SELECT
          "#{source_table}".*
        FROM
          "#{through_table}"
        INNER JOIN
          "#{source_table}"
        ON
          "#{source_table}".id = "#{through_table}"."#{source_foreign_key}"
        WHERE
          "#{through_table}".id = #{self.send(foreign_key)}
      SQL

      result = DBConnection.execute(sql)
      source_options.model_class.parse_all(result).first
    end
  end
end
