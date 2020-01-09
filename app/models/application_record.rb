class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # @param Array of Hash<Symbol => Any>
  def self.insert_all!(records)
    now = Time.current
    processed_records = records.map do |r|
      self.defined_enums.each do |column_name, hash|
        next unless r[column_name.to_sym]
        r[column_name.to_sym] = hash[r[column_name.to_sym]]
      end
      r.merge(created_at: now, updated_at: now)
    end
    super(processed_records)
  end
end
