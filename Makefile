UDEV_RULES_DIR := /usr/lib/udev/rules.d
INSTALL_DIR := /opt/jack-the-ripper

.PHONY: build
build:
	shellcheck src/*.sh

.PHONY: install
install:
	install udev/51-jack-the-ripper.rules $(UDEV_RULES_DIR)
	udevadm control --reload
	mkdir -p $(INSTALL_DIR)
	install src/jack-the-ripper.sh $(INSTALL_DIR)
