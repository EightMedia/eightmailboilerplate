fs = require('fs')

if fs.existsSync('./../../setup.json')
    setup = require('./../../setup.json')


# ---
# type

type = ->

    if setup?.transport?.type
        return setup.transport.type



# ---
# service

service = ->
    if setup?.transport?.service
        return setup.transport.service



# ---
# user

user = ->
    if setup?.auth?.user
        return setup.auth.user



# ---
# password

password = ->

    # check for auth
    if setup?.auth?.pass
        crypto = require('crypto')

        decipher = crypto.createDecipher('aes256', 'eightmailboilerplate')
        decrypted = decipher.update(setup.auth.pass, 'hex', 'utf8') + decipher.final('utf8')

        return decrypted


    # no auth given
    return null



# ---
# recipients

recipients = (grunt)->
    if setup?.recipients
        return setup.recipients



# --
module.exports = {
    type
    service
    user
    password
    recipients
}