import { Controller } from "stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = ["badge", "list", "placeholder", "notification"]

  connect() {
    this.subscription = consumer.subscriptions.create({ channel: "Noticed::NotificationChannel" }, {
      connected: this._connected.bind(this),
      disconnected: this._disconnected.bind(this),
      received: this._received.bind(this)
    })

    if (this.hasUnread()) this.showUnreadBadge()
    if (this.empty()) this.showPlaceholder()
  }

  _connected() {
  }

  _disconnected() {
  }

  _received(data) {
    // Regular notifications get added to the navbar
    if (data.html) {
      this.removePlaceholder()
      this.listTarget.insertAdjacentHTML('afterbegin', data.html)
      this.showUnreadBadge()
    }

    // Native notifications trigger a browser notification
    if (data.browser) {
      this.checkPermissionAndNotify(data.browser)
    }
  }

  // Called when the notifications view opens
  open() {
    this.hideUnreadBadge()
    this.markAsRead()
  }

  hasUnread() {
    return this.notificationTargets.some((target) => target.dataset.readAt == undefined)
  }

  showUnreadBadge() {
    this.badgeTarget.classList.remove("hidden")
  }

  hideUnreadBadge() {
    this.badgeTarget.classList.add("hidden")
  }

  markAsRead() {
    let ids = this.notificationTargets.map((target) => target.dataset.id)
    this.subscription.perform("mark_as_read", {ids: ids})
  }

  empty() {
    return this.notificationTargets.length == 0
  }

  removePlaceholder() {
    if (this.hasPlaceholderTarget) this.placeholderTarget.remove()
  }

  // Browser notifications
  checkPermissionAndNotify(data) {
    // Return if not supported
    if (!("Notification" in window)) return

    if (Notification.permission === "granted") {
      this.browserNotification(data)

    } else if (Notification.permission !== "denied") {
      Notification.requestPermission().then((permission) => {
        if (permission === "granted") {
          this.browserNotification(data)
        }
      })
    }
  }

  browserNotification(data) {
    new Notification(data.title, data.options)
  }
}
