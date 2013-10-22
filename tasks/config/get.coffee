if require('fs').existsSync('./config.json')
    config = require('./../../config.json')
else
    config = {}


# ---
# type

type = ->
    if config.transport?.type
        return config.transport.type



# ---
# service

service = ->
    if config.transport?.service
        return config.transport.service



# ---
# user

user = ->
    if config.auth?.user
        return config.auth.user



# ---
# password

password = ->

    # check for auth
    if config.auth?.pass
        crypto = require('crypto')

        decipher = crypto.createDecipher('aes256', 'eightmailboilerplate')
        decrypted = decipher.update(config.auth.pass, 'hex', 'utf8') + decipher.final('utf8')

        return decrypted


    # no auth given
    return null



# ---
# recipients

recipients = ->
    if config.recipients
        return config.recipients



# --
module.exports = {
    type: type()
    service: service()
    user: user()
    password: password()
    recipients: recipients()
}