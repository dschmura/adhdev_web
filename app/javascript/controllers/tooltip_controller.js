// Example usage:
// <div data-controller="tippy" data-tippy-content="Hello world"></div>

import { Controller } from "stimulus";
import tippy from "tippy.js";

export default class extends Controller {
  connect() {
    this.tippy = tippy(this.element);
  }

  disconnect() {
    this.tippy.destroy();
  }
}
