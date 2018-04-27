PREFIX ?= /usr/local
BUILDDIR = build
ICONDIR = $(PREFIX)/share/pixmaps

APPS = office word excel onenote outlook powerpoint skype
APPS2 = office2 word2 excel2 onenote2 outlook2 powerpoint2 skype2
OFFICEDOMAINS = \"https://office.live.com\", \"https://www.office.com\"
CATEGORY ?= Office

all: build

$(APPS):
	mkdir -p $(BUILDDIR)/$@
	sed "s|@APPNAME@|\u$@|; \
	     s|@APPNAMELOWER@|\L$@|; \
	     s|@CATEGORY@|$(CATEGORY)|" launcher.desktop.in > $(BUILDDIR)/$@/$@.desktop
	sed "s|@ICON@|$(ICONDIR)/ms-$@.png|; \
	     s|@URL@|$(URL)|; \
	     s|@DOMAINS@|$(DOMAINS)|; \
	     s|@UA@|$(UA)|" settings.json.in > $(BUILDDIR)/$@/settings.json
	sed "s|@PREFIX@|$(PREFIX)|; \
	     s|@APPNAMELOWER@|\L$@|" launcher.sh.in > $(BUILDDIR)/$@/ms-$@

office2: URL = https://www.office.com/login?es=Click\&ru=%2F
office2: DOMAINS = $(OFFICEDOMAINS)
office2: office

word2: URL = https://office.live.com/start/Word.aspx
word2: DOMAINS = $(OFFICEDOMAINS)
word2: word

excel2: URL = https://office.live.com/start/Excel.aspx
excel2: DOMAINS = $(OFFICEDOMAINS)
excel2: excel

onenote2: URL = https://www.onenote.com/notebooks
onenote2: onenote

outlook2: URL = https://outlook.live.com/owa
outlook2: DOMAINS = \"https://people.live.com\", \"https://calendar.live.com\"
outlook2: UA = Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/602.2.14 (KHTML, like Gecko) Version/10.0.1 Safari/602.2.14
outlook2: outlook

powerpoint2: URL = https://office.live.com/start/PowerPoint.aspx
powerpoint2: DOMAINS = $(OFFICEDOMAINS)
powerpoint2: powerpoint

skype2: URL = https://web.skype.com
skype2: CATEGORY = Network
skype2: skype

build: $(APPS2)
	sed "s|@PREFIX@|$(PREFIX)|" ms-office-online.in > $(BUILDDIR)/ms-office-online

install: build
	for app in $(APPS); do \
		install -Dm644 icons/$$app.png \
			$(DESTDIR)$(ICONDIR)/ms-$$app.png ; \
		install -Dm755 $(BUILDDIR)/ms-office-online \
			$(DESTDIR)$(PREFIX)/share/ms-office-online/$$app/ms-$$app-online ; \
		install -Dm755 $(BUILDDIR)/$$app/ms-$$app \
			$(DESTDIR)$(PREFIX)/bin/ms-$$app ; \
		install -Dm644 $(BUILDDIR)/$$app/settings.json \
			$(DESTDIR)$(PREFIX)/share/ms-office-online/$$app/settings.json ; \
		install -Dm644 $(BUILDDIR)/$$app/$$app.desktop \
			$(DESTDIR)$(PREFIX)/share/applications/ms-$$app.desktop ; \
	done

clean:
	rm -fr $(BUILDDIR)

.PHONY: build install clean $(APPS) $(APPS2)
