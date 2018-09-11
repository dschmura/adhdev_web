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
      product: "HatchBox",
      company: {
        name: "GoRails, LLC",
        address: "4411 Vista Ave\nSt. Louis, MO 63110\nUnited States",
        email: "chris@gorails.com",
        #logo: Rails.root.join("app/assets/images/logo.png")
      },
      line_items: line_items,
    )
  end

  def line_items
    line_items = [
      ["Date",           created_at.to_s],
      ["Account Billed", "#{owner.name} (#{owner.email})"],
      ["Product",        "HatchBox"],
      ["Amount",         ActionController::Base.helpers.number_to_currency(amount / 100.0)],
      ["Charged to",     "#{card_type} (**** **** **** #{card_last4})"],
    ]
    line_items << ["Additional Info", owner.extra_billing_info] if owner.extra_billing_info?
    line_items
  end
end
