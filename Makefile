.PHONY: build dev stop run data clear_containers

data:

	@echo prepare data volume
	@if [ $(shell docker volume ls | grep -ci mogilefs_storedata1) -eq 0 ]; then \
        docker volume create --name mogilefs_storedata1; \
	fi
	
	@if [ $(shell docker volume ls | grep -ci mogilefs_storedata2) -eq 0 ]; then \
		docker volume create --name mogilefs_storedata2; \
	fi
	
	@if [ $(shell docker volume ls | grep -ci mogilefs_storedata3) -eq 0 ]; then \
		docker volume create --name mogilefs_storedata3; \
	fi
	
	@if [ $(shell docker volume ls | grep -ci mogilefs_mysqldata) -eq 0 ]; then \
		docker volume create --name mogilefs_mysqldata; \
	fi
	
build: data

	@echo build happy_base
	docker build -t stf  .

	@echo remove containers
	@if [ $(shell cd dev && docker-compose ps -q | wc -l) -ne 0 ]; then \
		docker rm -f $$(docker-compose ps -q); \
	fi

run: data

	@echo start containers
	@if [ $(shell docker ps | grep -ci stf) -eq 0 ]; then \
		docker-compose up -d ; \
	fi

stop: data

	@echo stop containers
	cd dev && docker-compose stop

