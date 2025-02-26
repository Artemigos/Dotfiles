export PATH := local/bin:$(PATH)

install:
	d restore up

.PHONY: install
