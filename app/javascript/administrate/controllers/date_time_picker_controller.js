import { Controller } from "stimulus";
import flatpickr from 'flatpickr'

export default class extends Controller {
  static values = {
    type: String
  }

  connect() {
    this.picker = flatpickr(this.element, this.options)
  }

  disconnect() {
    this.picker.destroy()
  }

  get options() {
    if (this.typeValue == "time") {
      return {
        enableTime: true,
        enableSeconds: true,
        noCalendar: true,
        altInput: true,
        altFormat: ' h:i:S K',
        dateFormat: 'H:i:S' // H:i
      }
    } else {
      // Default to DateTime support
      return {
        enableTime: true,
        altInput: true,
        altFormat: 'F J (D), Y - h:i:S K',
        dateFormat: 'Z' // Y-m-d H:i
      }
    }
  }
}
