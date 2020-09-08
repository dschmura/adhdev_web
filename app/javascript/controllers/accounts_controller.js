// Reconnect ActionCable after switching accounts

import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  reconnect(event) {
    if (consumer.connection.isActive()) {
      consumer.connection.reopen()
    }
  }
}
