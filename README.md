![](https://raw.github.com/EightMedia/eightmailboilerplate/master/github/header.jpg)

This set of Grunt tasks removes a little bit of hassle from the tedious process of crafting e-mail templates.

---
## Features
* Jade templates (with some smart mixins)
* Automatic css inlining and SASS stylesheets
* Grunt tasks for exporting and testing

---
#### Clean Jade templates (with some smart mixins)
Nest those pretty tables the smart and readable way using jade mixins. This will make your emailtemplate creating life a lot easier.

![](https://raw.github.com/EightMedia/eightmailboilerplate/master/github/jade.jpg)

---

#### SASS and automatic CSS inlining
Write your css in an external file and get all those pretty styles automatically inlined. Stylesheets will also be automatically included in the head of the file so your media queries will work nicely.

Keep your styles in an external SASS file and use clever variables to keep your code clean.

![](https://raw.github.com/EightMedia/eightmailboilerplate/master/github/css.jpg)


---
#### Grunt tasks for exporting
`grunt export` generates a zip file with images and html to send to your clients and an html file with img.zip to import into Campaign Monitor.

![](https://raw.github.com/EightMedia/eightmailboilerplate/master/github/export.jpg)


---
#### External data
It's easiest to work with one file for all the links and text contents. So edit all links, or any other data, in data.json and they will be placed inside your html. Access the contents of this file in your .jade files like `data.website.title`.

```json
{
    "title": "My Fantastic Email",
    "website": {
        "title": "google.nl",
        "href": "http://www.google.com/"
    },
    "unsubscribe": "http://www.google.com/unsubscribe",
    "webversion": "http://www.google.com/webversion",
    "facebook_url": "https://www.facebook.com/",
    "twitter_url": "https://twitter.com/"
}
```

---
#### Command line testmails
You can test your mailing from the command line. Before you can send a test mail, run `grunt config` and answer some questions about your smtp login and the addresses you wish to send the testmail to. This will generate a json file (which you can edit later if you wish). 

![](https://raw.github.com/EightMedia/eightmailboilerplate/master/github/config.jpg)

This will create config.json which you can edit at any time you want.

```json
{
    "transport": {
        "type": "smtp",
        "service": "gmail"
    },
    "auth": {
        "user": "foo@gmail.com",
        "pass": "dsfs8as78dasda3dd2324kasd"
    },
    "recipients": [
        {
            "name": "foo@hotmail.com",
            "email": "foo@hotmail.com"
        },
        {
            "name": "foo@gmail.com",
            "email": "foo@gmail.com"
        },
    ]
}
```

From now on you can send testmails with `grunt mail`. 

![](https://raw.github.com/EightMedia/eightmailboilerplate/master/github/mail.jpg)


---
#### Responsive
Yeah it's responsive, as your mailings very well should be nowadays.

---
# Getting started
1. `git clone git@github.com:EightMedia/eightmailboilerplate.git`
2. `npm install`
3. `grunt`

Head to `http://localhost:8000/` to view your generated html files.

Open up your text editor and start editing files in `src/`. This is where all jade, scss and image files can be found.

4. Optionally run `grunt config` if you want to send testmails from the command line.

