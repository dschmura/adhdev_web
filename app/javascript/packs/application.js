/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import 'core-js/stable'
import 'regenerator-runtime/runtime'

// Rails functionality
import Rails from "@rails/ujs"
import { Turbo } from "@hotwired/turbo-rails"

// Make accessible for Electron and Mobile adapters
window.Rails = Rails
window.Turbo = Turbo

require("@rails/activestorage").start()
require("channels")
require("trix")
require("@rails/actiontext")

// Stimulus controllers
import "controllers"

// Jumpstart Pro & other Functionality
const components = require.context("src", true)
components.keys().forEach(components)

import LocalTime from "local-time"
LocalTime.start()

// ADD YOUR JAVACSRIPT HERE

// Start Rails UJS
Rails.start()

// Styles
// These are imported separately for faster Webpack recompilation
// https://rubyyagi.com/solve-slow-webpack-compilation/
import "stylesheets/base.scss"
import "stylesheets/components.scss"
import "stylesheets/utilities.scss"
