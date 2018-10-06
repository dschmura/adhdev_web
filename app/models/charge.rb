class Charge < ApplicationRecord
  include Pay::Chargeable

  scope :sorted, ->{ order(created_at: :desc) }
  default_scope ->{ sorted }

  def filename
    "receipt-#{created_at.strftime("%Y-%m-%d")}.pdf"
  end

  def receipt
    Receipts::Receipt.new(
      id: id,
      product: Jumpstart.config.application_name,
      company: {
        name: Jumpstart.config.business_name,
        address: Jumpstart.config.business_address,
        email: Jumpstart.config.support_email,
        #logo: Rails.root.join("app/assets/images/logo.png")
      },
      line_items: line_items,
    )
  end

  def line_items
    line_items = [
      ["Date",           created_at.to_s],
      ["Account Billed", "#{owner.name} (#{owner.email})"],
      ["Product",        Jumpstart.config.application_name],
      ["Amount",         ActionController::Base.helpers.number_to_currency(amount / 100.0)],
      ["Charged to",     "#{card_type} (**** **** **** #{card_last4})"],
    ]
    line_items << ["Additional Info", owner.extra_billing_info] if owner.extra_billing_info?
    line_items
  end
end
