up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

demo:
	@echo "Starting infra + seed + services"
	docker compose up -d
	@echo "Demo ready"

clean:
	docker compose down -v