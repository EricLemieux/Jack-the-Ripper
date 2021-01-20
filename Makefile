UDEV_RULES_DIR := /usr/lib/udev/rules.d
INSTALL_DIR := /opt/jack-the-ripper

.PHONY: build
build:
	shellcheck src/*.sh

.PHONY: install
install:
	# Install udev rule
	install udev/51-jack-the-ripper.rules $(UDEV_RULES_DIR)
	udevadm control --reload

	# Install systemd service
	install service/jack-the-ripper.service /etc/systemd/system/

	# Install the script
	mkdir -p $(INSTALL_DIR)
	install src/jack-the-ripper.sh $(INSTALL_DIR)
