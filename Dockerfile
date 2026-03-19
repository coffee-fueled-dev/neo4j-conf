FROM graphstack/dozerdb:5.26.3.0

# Bundle the startup extension script used to hydrate optional plugins.
COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENV NEO4J_PLUGINS='["apoc", "genai", "apoc-extended"]' \
    EXTENSION_SCRIPT=/entrypoint.sh \
    ENABLE_OPENGDS=true \
    OPENGDS_VERSION=2.12.0 \
    NEO4J_apoc_export_file_enabled=true \
    NEO4J_apoc_import_file_enabled=true \
    NEO4J_dbms_security_procedures_unrestricted='apoc.*,gds.*,genai.*'

EXPOSE 7474 7687

CMD ["neo4j", "console"]