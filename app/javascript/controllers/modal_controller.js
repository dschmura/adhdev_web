// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
//<div data-controller="modal">
  //<button data-action="click->modal#open">Open Modal</button>

  //<div data-target="modal.container" class="hidden">
    //<div class="fixed z-50 pin-t pin-l w-full h-full table" style="background-color: rgba(0, 0, 0, .5);">
      //<div data-target="modal.background" data-action="click->modal#closeBackground" class="table-cell align-middle">

        //<div class="bg-white w-64 mx-auto rounded shadow p-8">
          //<h2>Content</h2>
          //<button>Does nothing</button>
          //<button data-action="click->modal#close">Close</button>
        //</div>

      //</div>
    //</div>
  //</div>
//</div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "background", "container" ]

  connect() {
    this.toggleClass = this.data.get("class") || "hidden"
  }

  open() {
    this.containerTarget.classList.remove(this.toggleClass)
  }

  close() {
    this.containerTarget.classList.add(this.toggleClass)
  }

  closeBackground(e) {
    console.log(e.target)
    console.log(this.backgroundTarget)

    if (e.target == this.backgroundTarget) { this.close() }
  }
}
