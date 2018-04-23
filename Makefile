PREFIX ?= /usr/local
BUILDDIR = build
ICONDIR = $(PREFIX)/share/pixmaps
APPS = office word excel onenote outlook powerpoint skype

all: build

$(APPS):
	mkdir -p $(BUILDDIR)/$@
	sed -e "s|@APPNAME@|\u$@|" \
	    -e "s|@APPNAMELOWER@|\L$@|" \
	    -e "s|@CATEGORIES@|Office|" launcher.desktop.in > $(BUILDDIR)/$@/$@.desktop
	sed -e "s|@ICON@|$(ICONDIR)/ms-$@.png|" settings.json.in > $(BUILDDIR)/$@/settings.json
	sed -i "s|@PREFIX@|$(PREFIX)|" ms-office-online.in > $(BUILDDIR)/$@/ms-office-online

build: $(APPS)
	sed -i "s|@URL@|https://www.office.com/login?es=Click\&ru=%2F|" $(BUILDDIR)/office/settings.json
	sed -i "s|@URL@|https://office.live.com/start/Word.aspx|" $(BUILDDIR)/word/settings.json
	sed -i "s|@URL@|https://office.live.com/start/Excel.aspx|" $(BUILDDIR)/excel/settings.json
	sed -i "s|@URL@|https://www.onenote.com/notebooks|" $(BUILDDIR)/onenote/settings.json
	sed -i "s|@URL@|https://outlook.live.com/owa|" $(BUILDDIR)/outlook/settings.json
	sed -i "s|@URL@|https://office.live.com/start/PowerPoint.aspx|" $(BUILDDIR)/powerpoint/settings.json
	sed -i "s|@URL@|https://web.skype.com|" $(BUILDDIR)/skype/settings.json
	sed -i "s|Categories=Office|Categories=Network|" $(BUILDDIR)/skype/skype.desktop

install: build
	install -dm755 $(DESTDIR)$(PREFIX)/bin $(DESTDIR)$(PREFIX)/share/ms-office
	for app in $(APPS); do \
		install -Dm644 icons/$$app.png \
			$(DESTDIR)$(ICONDIR)/ms-$$app.png ; \
		install -Dm755 $(BUILDDIR)/$$app/ms-office-online \
			$(DESTDIR)$(PREFIX)/share/ms-office/$$app/ms-office-online ; \
		echo "#!/bin/sh" > "$(DESTDIR)$(PREFIX)/bin/ms-$$app" ; \
		echo "cd $(PREFIX)/share/ms-office/$$app" >> "$(DESTDIR)$(PREFIX)/bin/ms-$$app" ; \
		echo "./ms-office-online" >> "$(DESTDIR)$(PREFIX)/bin/ms-$$app" ; \
		install -Dm644 $(BUILDDIR)/$$app/settings.json \
			$(DESTDIR)$(PREFIX)/share/ms-office/$$app/settings.json ; \
		install -Dm644 $(BUILDDIR)/$$app/$$app.desktop \
			$(DESTDIR)$(PREFIX)/share/applications/ms-$$app.desktop ; \
	done

clean:
	rm -fr $(BUILDDIR)

.PHONY: build install clean $(APPS)
