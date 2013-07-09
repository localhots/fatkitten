DB = Sequel.connect(CONFIG[:database_url])

# DB.drop_table(:pastes) if DB.table_exists?(:pastes)

DB.create_table(:pastes) do
  primary_key :id
  String      :type
  Text        :contents
end unless DB.table_exists?(:pastes)
