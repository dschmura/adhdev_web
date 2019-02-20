import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "card", "error", "form" ]

  connect() {
    let stripeMeta = document.querySelector('meta[name="stripe-key"]')
    if (stripeMeta === null) { return }

    let stripeKey = stripeMeta.getAttribute("content")
    this.stripe   = Stripe(stripeKey)
    let elements  = this.stripe.elements()

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

  submit(event) {
    event.preventDefault()

    this.stripe.createToken(this.card).then((result) => {
      if (result.error) {
        this.errorTarget.textContent = result.error.message
      } else {
        this.handleToken(result.token)
      }
    })
  }

  handleToken(token) {
    this.addHiddenField("team[processor]", "stripe")
    this.addHiddenField("team[card_token]", token.id)

    Rails.fire(this.formTarget, "submit")
  }

  addHiddenField(name, value) {
    let hiddenInput = document.createElement("input")
    hiddenInput.setAttribute("type", "hidden")
    hiddenInput.setAttribute("name", name)
    hiddenInput.setAttribute("value", value)
    this.formTarget.appendChild(hiddenInput)
  }
}
