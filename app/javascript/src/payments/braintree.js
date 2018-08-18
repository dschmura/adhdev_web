document.addEventListener("turbolinks:load", () => {
  let button = document.querySelector("#submit-button");
  let clientToken = document.querySelector("#dropin-container").dataset
    .clientToken;

  braintree.dropin.create(
    {
      authorization: clientToken,
      container: "#dropin-container",
      paypal: {
        flow: "vault"
      }
    },
    function(createErr, instance) {
      button.addEventListener("click", function(event) {
        event.preventDefault();
        instance.requestPaymentMethod(function(err, payload) {
          braintreeTokenHandler(payload.nonce);
        });
      });
    }
  );
});

function braintreeTokenHandler(nonce) {
  let form = document.getElementById("payment_form");

  addHiddenField(form, "user[card_token]", nonce);
  addHiddenField(form, "user[processor]", "braintree");

  form.submit();
}

function addHiddenField(form, name, value) {
  let hiddenInput = document.createElement("input");
  hiddenInput.setAttribute("type", "hidden");
  hiddenInput.setAttribute("name", name);
  hiddenInput.setAttribute("value", value);
  form.appendChild(hiddenInput);
}
