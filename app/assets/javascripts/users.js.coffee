jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  user.setupForm()

user =
  setupForm: ->
    $('.bankinfo').submit ->
        $('input[type=submit]').attr('disabled', true)
        Stripe.bankAccount.createToken($('.bankinfo'), user.handleStripeResponse)
        false

  handleStripeResponse: (status, response) ->
    if status == 200
      $('.bankinfo').append($('<input type="hidden" name="stripeToken" />').val(response.id))
      $('.bankinfo')[0].submit()
    else
      $('#stripe_error').text(response.error.message).show()
      $('input[type=submit]').attr('disabled', false)