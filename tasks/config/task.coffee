module.exports = (grunt) ->

  grunt.registerTask 'config', 'Configure boilerplate', ->

    done = this.async()

    prompt = require('../../node_modules/prompt')
    prompt.start()


    # ---
    # check for config file

    # overwrite if it exists
    if grunt.file.exists('config.json')
        config = grunt.file.readJSON('config.json')

    # or else create one from template
    else
        config = require('./config-template.json')

        

    # ---
    # email config

    grunt.log.writeln grunt.log.wordlist(['Setup your SMTP settings'], { color: 'cyan' })
    grunt.log.writeln grunt.log.wordlist(['These will be saved in config.json\nwhich you can edit anytime you want.'], { color: 'cyan' })

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
            config.auth.user = email


        # ---
        # password obfuscation
        if password
            crypto = require('crypto')

            cipher = crypto.createCipher('aes256', 'eightmailboilerplate')
            password = cipher.update(password, 'utf8', 'hex') + cipher.final('hex')

            config.auth.pass = password


        # ---
        # recipients
        if recipients
            recipients = ({ 'name': r, 'email': r } for r in recipients.split(','))
            config.recipients = recipients
        
    

        # ---
        # create config file

        grunt.file.write('config.json', JSON.stringify(config, null, 4))

        done()
