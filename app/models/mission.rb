class Mission < ApplicationRecord
    belongs_to :user
    has_one :mission_type
end
