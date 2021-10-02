// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { Application } from "@hotwired/stimulus"
const application = Application.start()

// Register each controller with Stimulus
import * as controllers from "./**/*_controller.js"
controllers.namesWithModule.forEach((controller) => {
  application.register(controller.name, controller.module.default)
})

import { Dropdown, Modal, Tabs, Popover, Toggle, Slideover } from "tailwindcss-stimulus-components"
application.register('dropdown', Dropdown)
application.register('modal', Modal)
application.register('tabs', Tabs)
application.register('popover', Popover)
application.register('toggle', Toggle)
application.register('slideover', Slideover)

import Flatpickr from 'stimulus-flatpickr'
application.register('flatpickr', Flatpickr)
