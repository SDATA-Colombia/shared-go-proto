# shared-go-proto

# Verificar versión:
protoc --version
protoc-gen-go-grpc --version

# Instalar protoc-gen-go y protoc-gen-go-grpc y configurar path:
/shared-go-proto/

# Instalar el repositorio de googleapis
mkdir -p third_party
git clone https://github.com/googleapis/googleapis.git third_party/googleapis

# En vez de get usar install sino se encuentra los paquetes en el sistema
go get google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
go get google.golang.org/protobuf/cmd/protoc-gen-go@latest

export PATH=$PATH:$HOME/go/bin

echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc

go get google.golang.org/protobuf/cmd/protoc-gen-go
go get google.golang.org/grpc/cmd/protoc-gen-go-grpc
# source ~/.bashrc

cd ~/Documentos/ms-sdata/shared-go-proto

# Generar los proto (base):
protoc \
  --go_out=. \
  --go_opt=paths=source_relative \
  --go-grpc_out=. \
  --go-grpc_opt=paths=source_relative \
  base/v1/base.proto

# Generar los proto con las anotaciones de transcoding - grpc (base)
protoc \
  -I=. \
  -I=./third_party/googleapis \
  --go_out=. \
  --go_opt=paths=source_relative \
  --go-grpc_out=. \
  --go-grpc_opt=paths=source_relative \
  admin/v1/admin.proto

# Forzar a Go a ignorar el proxy y buscar directo en el repositorio git
GOPROXY=direct GOSUMDB=off go get github.com/SDATA-Colombia/shared-go-proto@v0.1.34

# Sincronizar dependencias
go mod tidy

go mod tidy

# Versionar
git add .
git commit -m "Add base proto"

# git tag v0.1.41 
# IR CAMBIANDO 
git tag -f v0.1.41 Forza al tag para apuntar al commit actual
git push origin v0.1.41 --force Se sube el tag actualizado obligando al remoto a sobrescribirlo 

# Tabla de equivalencias: MongoDB <-> Protobuf

| MongoDB       | Protobuf                                         |
| ------------- | ------------------------------------------------ |
| String        | `string`                                         |
| Boolean       | `bool`                                           |
| Number entero | `int32` o `int64`                                |
| Decimal       | `double`                                         |
| Fecha         | `string` (ISO8601) o `google.protobuf.Timestamp` |
| Array         | `repeated`                                       |
| Object        |  otro `message`                                  |
| Map           | `map<string,string>`                             |
| ObjectId      | `string`                                         |# shared-go-proto

kubectl exec -i mongodb-0 -- mongosh admins --eval "db.dropDatabase()"