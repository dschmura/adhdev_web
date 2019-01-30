import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "monthlyToggle", "yearlyToggle", "monthlyPlans", "yearlyPlans" ]

  connect() {
    this.plansClass     = (this.data.get("plansClass") || "hidden").split(" ")
    this.frequencyClass = (this.data.get("frequency-class") || "bg-white text-black").split(" ")
  }

  switch(event) {
    event.preventDefault()
    this._toggle(event.target.dataset.show)
  }

  _toggle(frequency) {
    if (frequency === this.data.get("current")) {
      return
    }

    this.data.set("current", frequency)

    if (frequency == "monthly") {
      this.monthlyToggleTarget.classList.add(...this.frequencyClass)
      this.yearlyToggleTarget.classList.remove(...this.frequencyClass)

    } else {
      this.monthlyToggleTarget.classList.remove(...this.frequencyClass)
      this.yearlyToggleTarget.classList.add(...this.frequencyClass)
    }

    this.plansClass.forEach(klass => {
      this.monthlyPlansTarget.classList.toggle(klass)
      this.yearlyPlansTarget.classList.toggle(klass)
    })
  }
}
