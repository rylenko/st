# st - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC = st.c x.c
OBJ = $(SRC:.c=.o)

all: options st

options:
	@echo st build options:
	@echo "CFLAGS  = $(STCFLAGS)"
	@echo "LDFLAGS = $(STLDFLAGS)"
	@echo "CC      = $(CC)"

.c.o:
	$(CC) $(STCFLAGS) -c $<

st.o: config.h st.h win.h
x.o: arg.h config.h st.h win.h

$(OBJ): config.h config.mk

st-256color: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f st-256color $(OBJ)

install: st-256color
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f st-256color $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st-256color
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < st-256color.1 > $(DESTDIR)$(MANPREFIX)/man1/st-256color.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/st-256color.1
	tic -sx st-git.info
	@echo Please see the README file regarding the terminfo entry of st.

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/st-256color
	rm -f $(DESTDIR)$(MANPREFIX)/man1/st-256color.1

.PHONY: all options clean install uninstall
