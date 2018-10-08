Sequel.migration do 
  up do
    create_table(:events) do
      primary_key :id
      foreign_key :user_id, :users
      DateTime :created
      DateTime :modified

      DateTime :start
      DateTime :end
      Boolean :active
      String :name
      String :description
      String :externalLink
    end
  end

  down do
    drop_table(:events)
  end
end
