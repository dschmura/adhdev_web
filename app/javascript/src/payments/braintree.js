document.addEventListener("turbolinks:load", () => {
  let dropin = document.querySelector("#dropin-container")
  if (dropin) { initializeBraintree(dropin) }

  let paypal = document.querySelector("#paypal-button")
  if (paypal) { initializePayPal(paypal) }
})

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

function initializeBraintree(dropin) {
  let button = document.querySelector("#submit-button")

  braintree.dropin.create(
    {
      authorization: dropin.dataset.clientToken,
      container: "#dropin-container",
      paypal: {
        flow: "vault"
      },
      // Uncomment this to only display PayPal in the Drop-in UI
      //paymentOptionPriority: ['paypal']
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
}

// This provides a custom PayPal button that uses Braintree as the backend
function initializePayPal(button) {
  console.log("INIT PAYPAL")

  // Create a client.
  braintree.client.create({
    authorization: button.dataset.clientToken,
  }, function (clientErr, clientInstance) {

    // Stop if there was a problem creating the client.
    // This could happen if there is a network error or if the authorization
    // is invalid.
    if (clientErr) {
      console.error('Error creating client:', clientErr);
      return;
    }

    // Create a PayPal Checkout component.
    braintree.paypalCheckout.create({
      client: clientInstance
    }, function (paypalCheckoutErr, paypalCheckoutInstance) {

      // Stop if there was a problem creating PayPal Checkout.
      // This could happen if there was a network error or if it's incorrectly
      // configured.
      if (paypalCheckoutErr) {
        console.error('Error creating PayPal Checkout:', paypalCheckoutErr);
        return;
      }

      // Set up PayPal with the checkout.js library
      paypal.Button.render({
        env: button.dataset.env, // or 'sandbox'

        // https://developer.paypal.com/docs/checkout/how-to/customize-button/#
        style: {
          color: 'blue',  // gold blue silver black
          shape: 'pill',  // shape: pill rect
          size: 'medium', // size: small medium large responsive
          label: 'pay',   // label: checkout credit pay buynow paypal installment
          tagline: false, // tagline: true false
        },

        payment: function () {
          return paypalCheckoutInstance.createPayment({
            // Your PayPal options here. For available options, see
            // http://braintree.github.io/braintree-web/current/PayPalCheckout.html#createPayment
            flow: 'vault',
          });
        },

        onAuthorize: function (data, actions) {
          return paypalCheckoutInstance.tokenizePayment(data, function (err, payload) {
            // Submit `payload.nonce` to your server.
            braintreeTokenHandler(payload.nonce)
          });
        },

        onCancel: function (data) {
          console.log('checkout.js payment cancelled', JSON.stringify(data, 0, 2));
        },

        onError: function (err) {
          console.error('checkout.js error', err);
        }
      }, '#paypal-button').then(function () {
        // The PayPal button will be rendered in an html element with the id
        // `paypal-button`. This function will be called when the PayPal button
        // is set up and ready to be used.
      });
    });
  });
}
