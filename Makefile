all: compile put

compile:
	coffee -m -o js coffee/script.coffee

put:
	erica push law

