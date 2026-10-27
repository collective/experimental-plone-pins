.DEFAULT_GOAL := help

.PHONY: build
build: ## Generate dependency pins and audit reports
	./build-plone-pins.sh

.PHONY: clean
clean: ## Clean up build artifacts
	rm -rf plone*/.venv plone*/constraints.txt

##

.PHONY: help
help: ## Show this help message
	@gawk -vG=$$(tput setaf 2) -vR=$$(tput sgr0) ' \
	  match($$0, "^(([^#:]*[^ :]) *:)?([^#]*)##([^#].+|)$$",a) { \
	    if (a[2] != "") { printf "    make %s%-18s%s %s\n", G, a[2], R, a[4]; next }\
	    if (a[3] == "") { print a[4]; next }\
	    printf "\n%-36s %s\n","",a[4]\
	  }' $(MAKEFILE_LIST)
