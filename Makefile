MAKEFLAGS += --always-make

all: install update

install:
	pip3 install --upgrade cloudflare-radar

uninstall:
	pip3 uninstall -y cloudflare-radar

reinstall: uninstall install

update-branch:
	git checkout master
	git fetch origin
	git reset --hard origin/master

update-rankings:
	cloudflare-radar update-rankings --dir . --retries 500 --stdout --debug --log "logs/$$(date '+%F %T').log" && git add domains.csv latest/ && git commit --message="update rankings $$(date '+%F %T')"

update: update-branch update-rankings
	git push origin master
