jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  user.setupForm()

user =
  setupForm: ->
    $('.edit_user').submit ->
        $('input[type=submit]').attr('disabled', true)
        Stripe.bankAccount.createToken($('.edit_user'), user.handleStripeResponse)
        false

  handleStripeResponse: (status, response) ->
    if status == 200
      $('.edit_user').append($('<input type="hidden" name="stripeToken" />').val(response.id))
      $('.edit_user')[0].submit()
    else
      $('#stripe_error').text(response.error.message).show()
      $('input[type=submit]').attr('disabled', false)