// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
const application = Application.start()

// Register each controller with Stimulus
import * as controllers from "./**/*_controller.js"
for (let i=0; i < controllers.filenames.length; i++) {
  const name = controllers.filenames[i].replace("./", "").replace("_controller.js", "").replace(/\//g, "--").replace(/_/g, '-')
  application.register(name, controllers.default[i].default)
}

import { Dropdown, Modal, Tabs, Popover, Toggle, Slideover } from "tailwindcss-stimulus-components"
application.register('dropdown', Dropdown)
application.register('modal', Modal)
application.register('tabs', Tabs)
application.register('popover', Popover)
application.register('toggle', Toggle)
application.register('slideover', Slideover)

import Flatpickr from 'stimulus-flatpickr'
application.register('flatpickr', Flatpickr)
