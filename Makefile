.PHONY: test
test:
	@nvim --headless --noplugin -u tests/setup.lua -c "PlenaryBustedDirectory tests/ {nvim_cmd = 'nvim', minimal_init = 'tests/setup.lua'}"
