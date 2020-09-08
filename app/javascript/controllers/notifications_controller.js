import { Controller } from "stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = ["badge", "list", "placeholder", "notification"]

  connect() {
    this.subscription = consumer.subscriptions.create({ channel: "NotificationChannel" }, {
      connected: this._connected.bind(this),
      disconnected: this._disconnected.bind(this),
      received: this._received.bind(this)
    })

    if (this.hasUnread()) this.showUnreadBadge()
    if (this.empty()) this.showPlaceholder()
  }

  disconnect() {
    this.subscription.unsubscribe()
  }

  _connected() {
  }

  _disconnected() {
  }

  _received(data) {
    // Ignore if user is signed in to a different account
    if (data.account_id && data.account_id != this.data.get("accountId")) {
      return
    }

    // Regular notifications get added to the navbar
    if (data.html) {
      this.hidePlaceholder()
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

  markAllAsRead() {
    let ids = this.notificationTargets.map((target) => target.dataset.id)
    this.subscription.perform("mark_as_read", {ids: ids})
  }

  markAsRead(event) {
    let id = event.currentTarget.dataset.id
    if (id == null) return
    this.subscription.perform("mark_as_read", {ids: [id]})

    // Uncomment to visual mark notification read
    // event.currentTarget.dataset.readAt= new Date()
  }

  markAsInteracted(event) {
    let id = event.currentTarget.dataset.id
    if (id == null) return
    this.subscription.perform("mark_as_interacted", {ids: [id]})

    // Uncomment to visually mark notification as interacted
    // event.currentTarget.dataset.interactedAt = new Date()
  }

  empty() {
    return this.notificationTargets.length == 0
  }

  showPlaceholder() {
    if (this.hasPlaceholderTarget) this.placeholderTarget.classList.remove("hidden")
  }

  hidePlaceholder() {
    if (this.hasPlaceholderTarget) this.placeholderTarget.classList.add("hidden")
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

