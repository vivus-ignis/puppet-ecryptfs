default:
	bundle exec rake validate
	vagrant provision

installdeps:
	mkdir -p modules
	bundle exec librarian-puppet install --path=./modules

debug:
	VAGRANT_LOG=DEBUG vagrant provision

.PHONY: default install debug
