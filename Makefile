MAKEFLAGS += --always-make

all: install update-latest

install:
	pip3 install --upgrade cloudflare-radar

uninstall:
	pip3 uninstall -y cloudflare-radar

reinstall: uninstall install

switch-latest:
	git fetch origin
	git switch latest
	git reset --hard origin/latest

update-rankings:
	cloudflare-radar update-rankings --dir . --retries 500 --stdout --debug --log "logs/$$(date '+%F %T').log" && git add domains.csv latest/ && git commit --message="update rankings $$(date '+%F %T')"

update-latest: switch-latest update-rankings
	git push origin latest

archive-latest:
	git fetch origin
	git switch master
	git checkout origin/latest -- latest domains.csv
	git commit --message="archive latest $$(date '+%F %T')"
	git push origin master
