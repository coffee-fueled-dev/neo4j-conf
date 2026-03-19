# Neo4j DozerDB Config

This package wraps [DozerDB](https://dozerdb.org) for a simple local Neo4j setup and a cleaner deployment baseline.

## Local Run

Run this from the project root:

```sh
docker compose up --build
```

Then open `http://localhost:7474` and sign in with `neo4j` / `password`.

Data, logs, imports, and plugins are persisted in Docker named volumes, so restarts do not wipe the database.

## Deploy

1. Copy `.env.example` to `.env`.
2. Change `NEO4J_AUTH` to a real password.
3. Adjust memory and port values if needed.
4. Start with `docker compose up -d --build`.

The image includes APOC, APOC Extended, and the startup hook for OpenGDS. OpenGDS is downloaded on first boot into the mounted plugins volume, so it is reused on later starts.

## Notes

- Procedure access is narrowed to `apoc.*`, `gds.*`, and `genai.*` instead of allowing everything.
- OpenGDS can be disabled with `ENABLE_OPENGDS=false`.
- The defaults are intentionally local-friendly; production deployments should set a stronger password and size memory explicitly.
