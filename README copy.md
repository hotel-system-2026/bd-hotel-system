1. Levanta PostgreSQL:

```bash
docker compose -p hotel_system_container up -d postgres
```

2. Construye la imagen de tooling de Liquibase solo la primera vez:

```bash
docker compose -p hotel_system_container --profile tooling build liquibase
```

3. Valida el changelog:

```bash
docker compose -p hotel_system_container --profile tooling run --rm liquibase validate
```

4. Revisa el estado:

```bash
docker compose -p hotel_system_container --profile tooling run --rm liquibase status
```

5. Aplica la estructura base:

```bash
docker compose -p hotel_system_container --profile tooling run --rm liquibase update
```

### Usuarios 

## administrador bootstrap
socket local
```
docker exec -it hotel_system_container-postgres-1 psql -U hotel_system_user -d hotel_system
```
## ariel5253
tcp/ip
dbaver
