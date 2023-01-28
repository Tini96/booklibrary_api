class PaginationSerializer < ActiveModelSerializers::SerializableResource
    def meta_key
      :pagination
    end
  
    def pagination
      {
        page: object.current_page,
        per_page: object.per_page,
        total_pages: object.total_pages,
        total_count: object.total_entries
      }
    end
end

ActiveModelSerializers.config.default_paginator = PaginationSerializer