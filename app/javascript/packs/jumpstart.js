/* eslint no-console:0 */
// DO NOT REMOVE THIS FILE
// Removing this file can/will break the Jumpstart admin interface
// in development mode.

window.Rails = require("@rails/ujs")

require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("trix")
require("@rails/actiontext")

import tippy from 'tippy.js'
document.addEventListener("turbolinks:load", () => {
  tippy(document.querySelectorAll('[data-tippy-content]'))
})

Rails.start()
