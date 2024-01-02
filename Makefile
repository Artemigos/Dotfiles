has_rcm_config:
	@stat ~/.rcrc >/dev/null 2>/dev/null

.PHONY: has_rcm_config

install: has_rcm_config
	rcup -v

.PHONY: install

uninstall: has_rcm_config
	rcdn -v

.PHONY: uninstall
