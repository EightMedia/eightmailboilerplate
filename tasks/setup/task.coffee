module.exports = (grunt) ->

  grunt.registerTask 'setup', 'setup boilerplate', ->

    done = this.async()

    prompt = require('../../node_modules/prompt')
    prompt.start()


    # ---
    # check for setup file

    if grunt.file.exists('setup.json')
        setup = grunt.file.readJSON('setup.json')
    else
        setup = require('./setup-template.json')

        

    # ---
    # email setup

    grunt.log.writeln grunt.log.wordlist(['Setup your SMTP settings'], { color: 'cyan' })
    grunt.log.writeln grunt.log.wordlist(['These will be saved in setup.json\nwhich you can edit anytime you want.'], { color: 'cyan' })

    prompts = [
        {
            name: 'email'
            description: 'your SMTP login emailaddress'
        }
        {
            name: 'password'
            hidden: true
            description: 'your SMTP login password'
        }
        {
            name: 'recipients'
            description: 'comma separated list of email addresses - foo@foo.com, foo2@foo.com'
        }
    ]

    
    # ---
    # read template

    prompt.get prompts, (err, result) ->

        # get results
        email = result.email
        password = result.password
        recipients = result.recipients

        # ---
        # user
        if email
            setup.auth.user = email


        # ---
        # password obfuscation
        if password
            crypto = require('crypto')

            cipher = crypto.createCipher('aes256', 'eightmailboilerplate')
            password = cipher.update(password, 'utf8', 'hex') + cipher.final('hex')

            setup.auth.pass = password

            #decipher = crypto.createDecipher('aes256', 'eightmailboilerplate');
            #decrypted = decipher.update(password, 'hex', 'utf8') + decipher.final('utf8');


        # ---
        # recipients
        if recipients
            recipients = ({ 'name': r, 'email': r } for r in recipients.split(','))
            setup.recipients = recipients
        
    

        # ---
        # create setup file

        grunt.file.write('setup.json', JSON.stringify(setup, null, 4))

        done()
