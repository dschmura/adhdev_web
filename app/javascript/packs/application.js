/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import "stylesheets/application";

import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";

const application = Application.start();
const context = require.context("controllers", true, /.js$/);
application.load(definitionsFromContext(context));

document.addEventListener("turbolinks:load", () => {
  const stripeKey = document
    .querySelector('meta[name="stripe-key"]')
    .getAttribute("content");
  let stripe = Stripe(stripeKey);
  let elements = stripe.elements();

  // Create an instance of the card Element
  let card = elements.create("card");
  card.mount("#card-element");

  // Listen for Card Errors
  card.addEventListener("change", function(event) {
    let displayError = document.getElementById("card-errors");
    if (event.error) {
      displayError.textContent = event.error.message;
    } else {
      displayError.textContent = "";
    }
  });

  let form = document.getElementById("payment_form");

  form.addEventListener("submit", function(event) {
    event.preventDefault();

    stripe.createToken(card).then(function(result) {
      if (result.error) {
        // Inform the user if there was an error
        let errorElement = document.getElementById("card-errors");
        errorElement.textContent = result.error.message;
      } else {
        // Send the token to your server
        stripeTokenHandler(result.token);
      }
    });
  });
});

function stripeTokenHandler(token) {
  let form = document.getElementById("payment_form");

  addHiddenField(form, "user[card_token]", token.id);
  addHiddenField(form, "user[processor]", "stripe");

  form.submit();
}

function addHiddenField(form, name, value) {
  let hiddenInput = document.createElement("input");
  hiddenInput.setAttribute("type", "hidden");
  hiddenInput.setAttribute("name", name);
  hiddenInput.setAttribute("value", value);
  form.appendChild(hiddenInput);
}
