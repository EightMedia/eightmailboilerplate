# eightmailboilerplate
### Kickstart the development of emailtemplates.

## Getting started
This set of Grunt tasks removes a little bit of hassle from the tedious process of crafting e-mail templates.

---
## Features
* Responsive
* Automatic css inlining
* Jade templates (with some smart mixins)
* SASS stylesheets
* Grunt tasks for exporting
* Command line testmail

---

### Responsive
Yeah it's responsive, as your mailings very well should be nowadays.


## Automatic css inlining
Write your css in an external file and get all those pretty styles automatically inlined. 

responsive.css will automatically be included in the head of the file so your media queries will work nicely.

### Clean Jade templates (with some smart mixins)
Nest tables the smart way. Write:

```jade
+table#content(bgcolor='#ffffff')
    +text-row 
        .title My Fantastic Email

    +text-row 
        .p.
          Collaboratively administrate empowered markets via plug-and-play networks. Dynamically 
          procrastinate B2C users after installed base benefits. Dramatically visualize customer 
          directed convergence without revolutionary ROI.

    +text-row 
        .p.
          Efficiently unleash cross-media information without cross-media value. Quickly maximize 
          timely deliverables for real-time schemas. Dramatically maintain clicks-and-mortar 
          solutions without functional solutions.
```

instead of

```html
<table id="content" width="100%" bgcolor="#ffffff" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <td width="20" class="spacer"></td>
        <td> <div class="title">My Fantastic Email</div></td>
        <td width="20" class="spacer"></td>
        </tr>
    …
    <tr>
        <td width="20" class="spacer"></td>
        <td> <div class="p">
            Collaboratively administrate empowered markets via plug-and-play networks. Dynamically 
            procrastinate B2C users after installed base benefits. Dramatically visualize customer 
            directed convergence without revolutionary ROI.
            </div>
        </td>
        <td width="20" class="spacer"></td>
      </tr>
    …
```

This will make your emailtemplate creating life a lot easier.

### SASS stylesheets
Keep your styles in an external file and use clever mixins, variables to keep your code clean.

### Grunt tasks for exporting
`grunt export` generates a zip file with images and html to send to your clients and an html file with img.zip to import into Campaign Monitor.

### External data
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

### Command line testmails
You can test your mailing from the command line. Before you can send a test mail, run `grunt setup` and answer some questions about your smtp login and the addresses you wish to send the testmail to. This will generate a json file (which you can edit later if you wish). From now on you can send the testmail with `grunt mail`. 

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
            "name": "foo@gmail.com",
            "email": "foo@gmail.com"
        },
        {
            "name": "foo@gmail.com",
            "email": "foo@gmail.com"
        },
    ]
}
```




---

TODO
* clean up jade files
* add examples

