Sequel.migration do
  up do 
    create_table(:comments) do
      primary_key :id
      foreign_key :user_id, :users
      String :text
    end
  end

  down do
    drop_table(:comments)
  end
end
