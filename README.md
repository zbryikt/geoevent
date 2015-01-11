template
========

a web template, for simple frontend. it contains a simple webserver, watch daemon, and a makefile for offline building. It uses jade, sass and livescript to build a web page.


Usage
========

Simply edit index.jade, index.sass and index.ls, and type 'make' to build these into index.html, index.css and index.js.

You can also watch all your changes and build them automatically. To do so, run

    npm i

once (for installing all dependencies), then run

    npm start

It will start watching all sass, jade and livescript changes, and also run a simple web server listening on localhost:9999.


Configuration
========

by default, some javascript libraries are included. Config to use them or cdn by editing following code in index.jade:

    - var usecdn = false
    - var lib = { jquery: true, d3js: true, angular: true, bootstrap: false, semantic: true }
    - var assets = "/assets"

