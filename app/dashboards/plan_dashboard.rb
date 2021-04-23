require "administrate/base_dashboard"

class PlanDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    amount: Field::Number,
    interval: Field::Select.with_options(collection: ["month", "year"]),
    trial_period_days: Field::Number,
    details: Field::String.with_options(searchable: false),
    stripe_id: Field::String,
    braintree_id: Field::String,
    paddle_id: Field::String,
    features: ArrayField,
    hidden: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :hidden,
    :amount,
    :interval,
    :trial_period_days
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :hidden,
    :amount,
    :interval,
    :trial_period_days,
    :stripe_id,
    :braintree_id,
    :paddle_id,
    :features,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :hidden,
    :amount,
    :interval,
    :trial_period_days,
    :stripe_id,
    :braintree_id,
    :paddle_id,
    :features
  ].freeze

  # Overwrite this method to customize how plans are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(plan)
  #   "Plan ##{plan.id}"
  # end
end
