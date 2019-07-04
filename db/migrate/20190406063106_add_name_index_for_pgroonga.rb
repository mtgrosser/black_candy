class AddNameIndexForPgroonga < ActiveRecord::Migration[5.2]
  def change
    add_index 'songs', 'name', name: 'pgroonga_index_songs_on_name', **pg_opts(:songs)
    add_index 'albums', 'name', name: 'pgroonga_index_albums_on_name', **pg_opts(:albums)
    add_index 'artists', 'name', name: 'pgroonga_index_artists_on_name', **pg_opts(:artists)
  end
  
  private
  
  def pg_opts(table_name)
    return Hash.new unless ActiveRecord::Base.connection.adapter_name =~ /postgres/i
    { using: :pgroonga, order: { name: :pgroonga_varchar_full_text_search_ops_v2 } }
  end
end
