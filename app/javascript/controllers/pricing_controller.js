// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
//<div class="relative" data-controller="dropdown">
  //<div data-action="click->dropdown#toggle" role="button" class="inline-block select-none">
    //Open Dropdown
  //</div>
  //<div data-target="dropdown.menu" class="absolute pin-r mt-2 hidden">
    //<div class="bg-white shadow rounded border overflow-hidden">
      //Content
    //</div>
  //</div>
//</div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "monthlyFrequency", "yearlyFrequency", "monthlyPlans", "yearlyPlans" ]

  connect() {
    this.plansClass     = (this.data.get("plansClass") || "hidden").split(" ")
    this.frequencyClass = (this.data.get("frequency-class") || "bg-white text-black").split(" ")
  }

  switch(event) {
    event.preventDefault()
    this._toggle(event.target.dataset.show)
  }

  _toggle(frequency) {
    if (frequency == "monthly") {
      this.monthlyFrequencyTarget.classList.add(...this.frequencyClass)
      this.yearlyFrequencyTarget.classList.remove(...this.frequencyClass)

    } else {
      this.monthlyFrequencyTarget.classList.remove(...this.frequencyClass)
      this.yearlyFrequencyTarget.classList.add(...this.frequencyClass)
    }

    this.plansClass.forEach(klass => {
      this.monthlyPlansTarget.classList.toggle(klass)
      this.yearlyPlansTarget.classList.toggle(klass)
    })
  }
}
