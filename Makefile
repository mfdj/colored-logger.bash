BIN ?= colored-logger
PREFIX ?= /usr/local

install:
	cp colored-logger.bash $(PREFIX)/bin/$(BIN)
	chmod +x $(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)
