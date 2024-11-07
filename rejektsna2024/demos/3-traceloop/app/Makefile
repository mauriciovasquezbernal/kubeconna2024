all:
	gcc -o main main.c -lpthread
	docker build -t ghcr.io/mauriciovasquezbernal/myapp:latest .
	docker push ghcr.io/mauriciovasquezbernal/myapp:latest
