DB = Sequel.connect(CONFIG[:database_url])

DB.create_table(:pastes) do
  primary_key :id
  String      :handle
  String      :type
  Text        :contents
end unless DB.table_exists?(:pastes)
