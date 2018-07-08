$(document).on("turbolinks:load", function() {
  $('#checkout_use_billing').click(function() {
    $('#checkout_shipping_address').toggleClass('hidden');
  });
});