# Copyright 2019 Alejandro "HiPhish" Sanchez
#
# This file is part of The Workshop.
#
# The Workshop is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# The Workshop is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with The Workshop.  If not, see <https://www.gnu.org/licenses/>.

# ===[ Public variables ]======================================================
GUILE = guile
OUT_DIR = output
PUBLISH_URL = "https://hiphish.github.io"
LOCAL_URL = "http://localhost:8080"


# ===[ Phony targets ]=========================================================
.PHONY: local publish serve clean

local:
	@$(GUILE) -L . -e main -s workshop.scm --url $(LOCAL_URL)

publish:
	@$(GUILE) -L . -e main -s workshop.scm --url $(PUBLISH_URL)

serve: local
	@$(GUILE) -L . -e main -s server.scm

help:
	@echo 'Usage: make (local|publish|serve|help|clean)'
	@echo ''
	@echo '  local    Build everything for local testing'
	@echo '  publish  Build everything setup for publishing'
	@echo '  serve    Run the local web server'
	@echo '  help     Display this message'
	@echo '  clean    Remove all build products'

clean:
	@rm -rf $(OUT_DIR)
