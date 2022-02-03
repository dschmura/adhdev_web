import { Controller } from "@hotwired/stimulus"
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
    this.card = elements.create("card", {
      style: {
        base: {
          fontFamily: 'Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif',
          fontSize: '16px',
          fontSmoothing: 'antialiased',
        }
      }
    })
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

  submit(event) {
    event.preventDefault()
    Rails.disableElement(this.formTarget)

    if (this.nameTarget.value == "") {
      this.showError("Name on card is required.")
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
        this.showError(result.error.message)
      } else {
        this.handlePaymentMethod(result.setupIntent.payment_method)
      }
    })
  }

  handlePaymentMethod(payment_method_id) {
    this.addHiddenField("processor", "stripe")
    this.addHiddenField("payment_method_token", payment_method_id)
    this.formTarget.submit()
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
        this.showError(result.error.message)
      } else if (result.paymentIntent && result.paymentIntent.status === 'succeeded') {
        Turbo.clearCache()
        Turbo.visit("/")
      }
    })
  }

  showError(message) {
    this.errorTarget.textContent = message
    setTimeout(() => {
      Rails.enableElement(this.formTarget)
    }, 100)
  }
}
