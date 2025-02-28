export PATH := local/bin:$(PATH)

install:
	d restore up

.PHONY: install

sync:
	d paru
	d flatpak

.PHONY: sync
