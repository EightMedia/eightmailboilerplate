![](https://raw.github.com/EightMedia/eightmailboilerplate/master/github/header.jpg)

This set of Gulp tasks removes a little bit of hassle from the tedious process of crafting e-mail templates.

---
## Features
* Jade templates (with some smart mixins)
* Automatic css inlining and SASS stylesheets
* Export for Campaign Monitor or package in a zip file
* Quick test emails through the command line

---
#### Clean Jade templates (with some smart mixins)
HTML tables are hard to write and hard to read. This is why you should use some form of preprocessor to make this job easier. We use jade mixins for tables, buttons and spacers so you don't have to spell those out again and again.

![](https://raw.github.com/EightMedia/eightmailboilerplate/master/github/jade.jpg)

---

#### SASS and automatic CSS inlining
Write your css in an external file and get all those styles automatically inlined. Stylesheets will also be included in the head of the file so your media queries will work nicely.

Keep your styles in an external SASS file and use clever variables to keep your code clean.

![](https://raw.github.com/EightMedia/eightmailboilerplate/master/github/css.jpg)


---
#### Gulp tasks for exporting
`gulp export` generates a version-numbered-zip-file with images and html to send to your clients and an html file with img.zip to import into Campaign Monitor. These files can be found in `export/zip` and `export/campaignmonitor`.


---
#### External data
It's easiest to work with one file for all the links and text contents. So edit all links, or any other data, in data.json and they will be placed inside your html. Access the contents of this file in your .jade files like `#{data.title}`.

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
You can test your mailing from the command line. Before you can send a test mail, create a config.json in the root of the project:

```
{
  "auth": {
    "user": "me@gmail.com",
    "pass": ""
  },
  "recipients": "me@gmail.com, me@hotmail.com"
}
```

now run `gulp testmail` to send those emails to yourself for testing.


---
#### Basic template provided
A basic example is available for you to get you started, but feel free to start from scratch. 

![](https://raw.github.com/EightMedia/eightmailboilerplate/master/github/responsive.jpg)

---
# Getting started
1. clone this repository
2. `npm install`
3. `gulp`

Head to `http://localhost:8000/` to view your generated html files.

Open up your text editor and start editing files in `src/`. This is where all jade, scss and image files can be found.