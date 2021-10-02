import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    window.TurboNativeBridge.postMessage("registerForPushNotifications")
  }
}
