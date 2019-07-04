class InstallPgroongaExtension < ActiveRecord::Migration[5.2]
  def up
    if ActiveRecord::Base.connection.adapter_name =~ /postgres/i
      execute "CREATE EXTENSION IF NOT EXISTS pgroonga;"
    end
  end

  def down
    if ActiveRecord::Base.connection.adapter_name =~ /postgres/i
      execute "DROP EXTENSION IF EXISTS pgroonga;"
    end
  end
end
