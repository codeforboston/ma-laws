all: browser put

compile:
	coffee -o js coffee/templates.coffee

put:
	erica push law

browser: compile
	browserify -o js/bundle.js --require ./bower_components/jquery/jquery.js:jquery js/script.js --require ./js/spin.min.js:spin --require ./js/bootstrap.js:bootstrap
