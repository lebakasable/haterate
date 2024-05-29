.PHONY: all
all: haterate test

haterate: haterate.ha
	hare build -o haterate haterate.ha

.PHONY: test
test: haterate
	cp haterate test/
	make -C test
