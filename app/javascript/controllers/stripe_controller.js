import { Controller } from "stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = [ "card", "name", "error", "form" ]

  connect() {
    let stripeMeta = document.querySelector('meta[name="stripe-key"]')
    if (stripeMeta === null) { return }

    let stripeKey = stripeMeta.getAttribute("content")
    this.stripe   = Stripe(stripeKey)
    let elements  = this.stripe.elements()

    // Setup Intents are used for adding new cards to be charged in the future
    this.setup_intent = this.data.get("setup-intent")

    // Payment intents are for processing payments that require action
    this.payment_intent = this.data.get("payment-intent")

    // Setup regular payments
    this.card = elements.create("card")
    this.card.mount(this.cardTarget)
    this.card.addEventListener("change", this.changed.bind(this))
  }

  changed(event) {
    if (event.error) {
      this.errorTarget.textContent = event.error.message
    } else {
      this.errorTarget.textContent = ""
    }
  }

  keydown(event) {
    if (event.keyCode == 13) {
      // Catch Enter key's form submission and process as submit
      event.preventDefault()
      this.submit(event)
    }
  }

  submit(event) {
    event.preventDefault()

    if (this.nameTarget.value == "") {
      this.errorTarget.textContent = "Name on card is required."
      return
    }

    // One time payments
    if (this.payment_intent) {
      this.handleCardPayment()

      // Updating card with setup intent
    } else if (this.setup_intent) {
      this.setupNewCard()

    // Subscriptions simply tokenize the payment method and redirect to payment page if SCA required
    } else {
      this.stripe.createPaymentMethod({
        type: 'card',
        card: this.card,
        billing_details: {
          name: this.nameTarget.value
        },
      }).then((result) => this.handlePaymentMethod(result.paymentMethod.id))
    }
  }

  setupNewCard() {
    let data = {
      payment_method: {
        card: this.card,
        billing_details: {
          name: this.nameTarget.value
        }
      }
    }

    this.stripe.confirmCardSetup(this.setup_intent, data).then((result) => {
      if (result.error) {
        this.errorTarget.textContent = result.error.message
      } else {
        this.handlePaymentMethod(result.setupIntent.payment_method)
      }
    })
  }

  handlePaymentMethod(payment_method_id) {
    this.addHiddenField("account[processor]", "stripe")
    this.addHiddenField("account[card_token]", payment_method_id)

    Rails.fire(this.formTarget, "submit")
  }

  addHiddenField(name, value) {
    let hiddenInput = document.createElement("input")
    hiddenInput.setAttribute("type", "hidden")
    hiddenInput.setAttribute("name", name)
    hiddenInput.setAttribute("value", value)
    this.formTarget.appendChild(hiddenInput)
  }

  handleCardPayment() {
    // Handle an existing payment that needs confirmation
    this.stripe.confirmCardPayment(this.payment_intent).then((result) => {
      if (result.error) {
        this.errorTarget.textContent = result.error.message

      } else if (result.paymentIntent && result.paymentIntent.status === 'succeeded') {
        Turbo.clearCache()
        Turbo.visit("/")
      }
    })
  }
}
