dc=docker-compose -f docker-compose.yml $(1)
dc-run=$(call dc, run --rm web $(1))

usage:
	@echo "Available targets:"
	@echo "  * setup        		  - Initiates everything (building images, installing gems)"
	@echo "  * setup-db        		  - Initiates everything (building images, installing gems, creating db and migrating)"
	@echo "  * build        		  - Build image"
	@echo "  * bundle       		  - Install missing gems"
	@echo "  * db-migrate   		  - Runs the migrations for dev database"
	@echo "  * db-test-migrate    	  - Runs the migrations for test database"
	@echo "  * dev          		  - Fires a shell inside your container"
	@echo "  * up           		  - Runs the development server"
	@echo "  * tear-down    		  - Removes all the containers and tears down the setup"
	@echo "  * stop         		  - Stops the server"
	@echo "  * rspec         		  - Runs rspec"
	@echo "  * console         		  - Rails console"
	@echo "  * rubocop-auto-correct	  - Send a file by argument to Rubocop to correct"

# Without db
setup: build bundle

# With db
setup-db: build bundle db-create db-migrate db-test-migrate

build:
	$(call dc, build)
bundle:
	$(call dc-run, bundle install)
dev:
	$(call dc-run, ash)
up:
	$(call dc, up)
tear-down:
	$(call dc, down)
stop:
	$(call dc, stop)

# For rails projects uncomment this
console:
	$(call dc-run, bundle exec rails console)

# For projects with databases and
db-create:
	$(call dc-run, bundle exec rake db:create)
db-migrate:
	$(call dc-run, bundle exec rake db:migrate)
db-test-migrate:
	$(call dc-run, bundle exec rake db:migrate RAILS_ENV=test)
rspec:
	$(call dc-run, bundle exec rspec)

rubocop-auto-correct:
	$(call dc-run, bundle exec rubocop -a $(FILE))

# .PHONY: test
# test:
# 	$(call dc-run, bundle exec rspec)