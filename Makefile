export PATH := local/bin:$(PATH)

install:
	d restore up

# has_rcm_config:
# 	@stat ~/.rcrc >/dev/null 2>/dev/null
#
# .PHONY: has_rcm_config
#
# install: has_rcm_config
# 	# `d` not guaranteed to be in PATH, so use relative repo path
# 	local/bin/d require rcup
# 	rcup -v
#
# .PHONY: install
#
# uninstall: has_rcm_config
# 	# `d` not guaranteed to be in PATH, so use relative repo path
# 	local/bin/d require rcdn
# 	rcdn -v
#
# .PHONY: uninstall
