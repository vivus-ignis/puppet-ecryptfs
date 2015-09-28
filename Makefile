default:
	bundle exec rake validate
	vagrant provision

installdeps:
	mkdir -p modules
	bundle exec librarian-puppet install --path=./modules

pkg:
	puppet module build

debug:
	VAGRANT_LOG=DEBUG vagrant provision

.PHONY: default install debug pkg
