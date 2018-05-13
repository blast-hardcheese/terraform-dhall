root=./
target=$(root)/target/

default: render

DHALL ?= dhall-to-json

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(dir $(mkfile_path))
export LIB := $(current_dir)/terraform/lib.dhall
export TERRAFORM := $(current_dir)/terraform.dhall

clean-target:
	rm -rf $(target)

render: clean-target
	@echo "Rendering dhall"
	@mkdir -p $(target)
	@"$(DHALL)" --explain <<< "$(root)/test.tf.dhall" > "$(target)/test.tf.json"
	@echo "Running terraform"
	@terraform plan \
		$(target)

watch:
	while true; do \
		find $(root) -name '*.dhall' -type f | entr -cd make; \
		sleep 1; \
	done
