document.addEventListener("turbolinks:load", () => {
  const stripeMeta = document.querySelector('meta[name="stripe-key"]')
  if (stripeMeta === null) { return }

  const stripeKey = stripeMeta.getAttribute("content");
  let stripe = Stripe(stripeKey);
  let elements = stripe.elements();
  let card = elements.create("card");
  let form = document.getElementById("payment_form");

  card.mount("#card-element");

  card.addEventListener("change", function(event) {
    let displayError = document.getElementById("card-errors");
    if (event.error) {
      displayError.textContent = event.error.message;
    } else {
      displayError.textContent = "";
    }
  });

  form.addEventListener("submit", function(event) {
    event.preventDefault();

    stripe.createToken(card).then(function(result) {
      if (result.error) {
        let errorElement = document.getElementById("card-errors");
        errorElement.textContent = result.error.message;
      } else {
        stripeTokenHandler(result.token);
      }
    });
  });
});

function stripeTokenHandler(token) {
  let form = document.getElementById("payment_form");

  addHiddenField(form, "user[card_token]", token.id);
  addHiddenField(form, "user[processor]", "stripe");

  Rails.fire('submit', form)
}

function addHiddenField(form, name, value) {
  let hiddenInput = document.createElement("input");
  hiddenInput.setAttribute("type", "hidden");
  hiddenInput.setAttribute("name", name);
  hiddenInput.setAttribute("value", value);
  form.appendChild(hiddenInput);
}
