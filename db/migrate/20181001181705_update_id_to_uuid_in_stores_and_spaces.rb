require 'webdack/uuid_migration/helpers'

class UpdateIdToUuidInStoresAndSpaces < ActiveRecord::Migration[5.2]
  def up
    enable_extension 'pgcrypto'

    primary_key_to_uuid :spaces
    primary_key_and_all_references_to_uuid :stores
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
