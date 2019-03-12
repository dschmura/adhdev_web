# Patch ActiveRecord::Store to automatically typecast attributes
# if a type is defined by the Attributes API.

module ActiveRecord
  module Store
    extend ActiveSupport::Concern

    private
      def read_store_attribute(store_attribute, key) # :doc:
        accessor = store_accessor_for(store_attribute)
        value_before_type_cast = accessor.read(self, store_attribute, key)
        type_for_attribute(key.to_s).serialize(value_before_type_cast)
      end

      def write_store_attribute(store_attribute, key, value_before_type_cast) # :doc:
        accessor = store_accessor_for(store_attribute)
        value = type_for_attribute(key.to_s).serialize(value_before_type_cast)
        accessor.write(self, store_attribute, key, value)
      end
  end
end

