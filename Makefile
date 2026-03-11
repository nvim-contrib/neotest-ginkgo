.PHONY: test
test:
	@nvim --headless --noplugin -u spec/setup.lua -c "PlenaryBustedDirectory spec/ {nvim_cmd = 'nvim', minimal_init = 'spec/setup.lua'}"
