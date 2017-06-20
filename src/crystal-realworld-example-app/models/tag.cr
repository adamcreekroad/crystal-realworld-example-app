class Tag < ActiveRecord::Model
  adapter mysql
  
  primary id : Int

  field name           : String
  field taggings_count : Int
end
