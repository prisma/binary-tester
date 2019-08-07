run:
	docker build -f main.dockerfile --build-arg IMAGE=$(IMAGE) -t test-$(IMAGE) .
	docker run test-$(IMAGE)
