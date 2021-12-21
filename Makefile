PHP_BIN             := php
COMPOSER_BIN        := composer
NPM_BIN				:= npm

.PHONY: list
list:
	@echo ""
	@echo "Useful targets:"
	@echo ""
	@echo "  install      > install everything to run the project"
	@echo "  update       > update grav and plugins to latest stable version"
	@echo "  clear        > clear grav cache"
	@echo ""
	@echo "  lint         > check frontend code for errors and bad style"
	@echo "  watch        > start watching frontend code"
	@echo "  build        > build frontend"
	@echo "  cssmin       > quick frontend CSS minifing"
	@echo "  jsmin        > quick frontend JS minifing"
	@echo ""

.PHONY: install
install: is_installed grav_prepare update
	@echo "$(C_GREEN)Installation complete.$(C_NC)"

is_installed:
ifneq (,$(wildcard ./index.php))
	@echo "$(C_RED)Already installed.$(C_NC)"
	@exit 1
endif
	@echo "$(C_GREEN)Here we go.$(C_NC)"

grav_prepare:
	@echo ""
	@echo "$(C_CYAN)Downloading and preparing grav CMS$(C_NC)"
	@curl -o grav.zip -SL https://getgrav.org/download/core/grav/latest
	@unzip grav.zip -d ./ > /dev/null
	@rm grav.zip
	@rm -rf grav/user/
	@rm -rf grav/.github/
	@rm grav/README.md grav/LICENSE.txt grav/CONTRIBUTING.md grav/CODE_OF_CONDUCT.md grav/CHANGELOG.md
	@mv -n grav/* ./
	@mv -n grav/.[!.]* ./
	@rm -rf grav/
	@mkdir -p user/data/flex-objects

.PHONY: update
update:
	@echo ""
	@echo "$(C_CYAN)Installing and updating dependencies$(C_NC)"
	@mv robots.txt robots.txt.bak
	@./bin/grav install
	@./bin/gpm selfupgrade
	@./bin/gpm update
	@mv robots.txt.bak robots.txt
	@git checkout readme.md

.PHONY: clear
clear:
	@./bin/grav cache

.PHONY: lint
lint:
	@npm run lint --prefix $(THEME_PATH)

.PHONY: watch
watch:
	@npm run watch --prefix $(THEME_PATH)

.PHONY: build
build:
	@npm run build --prefix $(THEME_PATH)

.PHONY: jsmin
jsmin:
	@npm run jsmin --prefix $(THEME_PATH)

.PHONY: cssmin
cssmin:
	@npm run cssmin --prefix $(THEME_PATH)