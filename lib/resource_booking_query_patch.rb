module ResourceBookingQueryPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method :initialize_available_filters_without_patch, :initialize_available_filters
      alias_method :initialize_available_filters, :initialize_available_filters_with_patch
    end
  end

  module InstanceMethods

    def team_possible_values
      custom_field = CustomField.find_by_id(TEAM_CUSTOM_FIELD_ID)
      if custom_field.blank?
        custom_field = CustomField.where(type: "UserCustomField", name: "Team").first
        return [] unless custom_field.present? 
      end
      return custom_field.enumerations.pluck(:name, :id) if custom_field.field_format == 'enumeration'
      custom_field.possible_values
    end

    def sql_for_team_id_field(field, operator, value)
      case operator
      when "=", "!"
        e = (operator == "=" ? "=" : "<>")
        "#{ResourceBooking.table_name}.assigned_to_id IN (SELECT customized_id FROM #{CustomValue.table_name} team_ids WHERE team_ids.customized_type = 'User' AND team_ids.custom_field_id = #{TEAM_CUSTOM_FIELD_ID} AND team_ids.value #{e} '#{value.first}')"
      when "~", "!~"
        e = (operator == "~" ? "LIKE" : "NOT LIKE")
        "#{ResourceBooking.table_name}.assigned_to_id IN (SELECT customized_id FROM #{CustomValue.table_name} team_ids WHERE team_ids.customized_type = 'User' AND team_ids.custom_field_id = #{TEAM_CUSTOM_FIELD_ID} AND team_ids.value #{e} '%#{value.first}%')"
      end
    end

    def initialize_available_filters_with_patch
      if project.nil?
        add_available_filter 'team_id', type: :list_optional, values: team_possible_values
      end
      initialize_available_filters_without_patch
    end      
  end # module InstanceMethods
end # module ResourceBookingQueryPatch
# Add module to ResourceBookingQuery class
ResourceBookingQuery.send(:include, ResourceBookingQueryPatch)