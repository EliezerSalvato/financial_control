module ApplicationHelper
  def required?(field)
    resource.class.validators_on(field).any? { |v| v.class == ActiveRecord::Validations::PresenceValidator }
  end
end
