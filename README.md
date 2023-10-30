# Crear contenedor

## Compilar Dokerfile:
```
docker image build -t sdk-develop-image:v1.0.0 .
docker run -it --entrypoint /bin/zsh sdk-develop-image:v1.0.0
```
## Tag image
```
git tag v1.0.2 -m "XXXXXXXXXX"
git push --tags
```

## Publicar
```
docker login ghcr.io -u XXXXXXXX --password-stdin
docker push ghcr.io/cpcready/sdk-develop-image:v1.0.1
```