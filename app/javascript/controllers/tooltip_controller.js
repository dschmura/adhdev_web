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
