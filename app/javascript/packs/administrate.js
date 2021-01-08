// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Rails functionality
window.Rails = require("@rails/ujs")
require("@hotwired/turbo-rails")
require("@rails/activestorage").start()
require("channels")
require("trix")
require("@rails/actiontext")

// Administrate specific functionality
require("../administrate/index")

// Stimulus controllers
import "controllers"

// Jumpstart Pro & other Functionality
import "src/actiontext"
//import "src/confirm" // We don't really care about fancy confirm modals in the admin
import "src/direct_uploads"
import "src/forms"
import "src/timezone"

import LocalTime from "local-time"
LocalTime.start()

// ADD YOUR JAVACSRIPT HERE

// Start Rails UJS
Rails.start()
