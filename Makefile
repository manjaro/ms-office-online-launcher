PREFIX ?= /usr/local
ICONDIR = $(PREFIX)/share/icons/hicolor/1024/apps
APPS = office word excel onenote outlook powerpoint skype

build: $(APPS)
$(APPS): $(addprefix settings.json-,$(APPS))

settings.json-office: settings.json
	sed -e "s|_icon_|$(ICONDIR)/ms-office.png|" \
	    -e "s|_URL_|https://www.office.com/login?es=Click&ru=%2F|" \
	    $< > $@

settings.json-word: settings.json
	sed -e "s|_icon_|$(ICONDIR)/ms-word.png|" \
	    -e "s|_URL_|https://office.live.com/start/Word.aspx|" \
	    $< > $@

settings.json-excel: settings.json
	sed -e "s|_icon_|$(ICONDIR)/ms-excel.png|" \
	    -e "s|_URL_|https://office.live.com/start/Excel.aspx|" \
	    $< > $@

settings.json-onenote: settings.json
	sed -e "s|_icon_|$(ICONDIR)/ms-onenote.png|" \
	    -e "s|_URL_|https://www.onenote.com/notebooks|" \
	    $< > $@

settings.json-outlook: settings.json
	sed -e "s|_icon_|$(ICONDIR)/ms-outlook.png|" \
	    -e "s|_URL_|https://outlook.live.com/owa|" \
	    $< > $@

settings.json-powerpoint: settings.json
	sed -e "s|_icon_|$(ICONDIR)/ms-powerpoint.png|" \
	    -e "s|_URL_|https://office.live.com/start/PowerPoint.aspx|" \
	    $< > $@

settings.json-skype: settings.json
	sed -e "s|_icon_|$(ICONDIR)/ms-skype.png|" \
	    -e "s|_URL_|https://web.skype.com|" \
	    $< > $@


install: build
	install -dm755 $(DESTDIR)$(PREFIX)/bin
	install -Dm644 -t $(DESTDIR)$(PREFIX)/share/applications/ desktop-files/*.desktop
	for app in $(APPS); do \
	    install -Dm644 ms-office-online \
	        $(DESTDIR)$(PREFIX)/share/ms-office/$$app/ms-office-online ; \
	    install -Dm644 settings.json-$$app \
	        $(DESTDIR)$(PREFIX)/share/ms-office/$$app/settings.json ; \
	    install -Dm644 icons/$$app.png \
	        $(DESTDIR)$(PREFIX)/share/icons/hicolor/1024x1024/apps/ms-$$app.png ; \
	    ln -sf $(PREFIX)/share/ms-office/$$app/ms-office-online $(DESTDIR)$(PREFIX)/bin/ms-$$app ; \
	done

clean:
	rm -f settings.json-*

.PHONY: build install clean $(APPS)
