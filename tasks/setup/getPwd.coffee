# ---
# decrypt password from setup file

module.exports = ->
  fs = require('fs')


  setup = require('./../../setup.json')

  # check for auth
  if setup?.auth
    crypto = require('crypto')

    decipher = crypto.createDecipher('aes256', 'eightmailboilerplate')
    decrypted = decipher.update(setup.auth.pass, 'hex', 'utf8') + decipher.final('utf8')

    return decrypted

  # no auth given
  else
    return null