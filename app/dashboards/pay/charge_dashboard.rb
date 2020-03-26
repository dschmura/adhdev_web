require "administrate/base_dashboard"

class Pay::ChargeDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    owner: Field::BelongsTo.with_options(class_name: "User"),
    id: Field::Number,
    owner_id: Field::Number,
    processor: Field::String,
    processor_id: Field::String,
    amount: Field::Number,
    amount_refunded: Field::Number,
    card_type: Field::String,
    card_last4: Field::String,
    card_exp_month: Field::String,
    card_exp_year: Field::String,
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
    :owner,
    :processor,
    :amount,
    :card_type,
    :card_last4
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :owner,
    :owner_id,
    :processor,
    :processor_id,
    :amount,
    :amount_refunded,
    :card_type,
    :card_last4,
    :card_exp_month,
    :card_exp_year,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :owner,
    :owner_id,
    :processor,
    :processor_id,
    :amount,
    :amount_refunded,
    :card_type,
    :card_last4,
    :card_exp_month,
    :card_exp_year
  ].freeze

  # Overwrite this method to customize how charges are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(charge)
  #   "Pay::Charge ##{charge.id}"
  # end
end
