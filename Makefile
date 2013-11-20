all: browser put

put:
	./erica push law

browser:
	browserify -o js/bundle.js -t hbsfy --require ./bower_components/jquery/jquery.js:jquery js/script.js --require ./js/spin.min.js:spin --require ./js/bootstrap.js:bootstrap
