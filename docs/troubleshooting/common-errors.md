# Troubleshooting

| Symptom | Ursache | Lösung |
|---|---|---|
| `401 Unauthorized` | Zugangsdaten fehlen oder sind falsch | Service Key kontrollieren |
| `403 Forbidden` am HTTPS-Endpunkt | Senderrolle fehlt | Rolle des technischen Clients prüfen |
| `403 Forbidden` beim OData-Aufruf | ABAP-Berechtigung oder CSRF | Communication Arrangement und Adapter prüfen |
| `Unexpected End-of-input in prolog` | XML erwartet, JSON geliefert | JSON-to-XML Converter ergänzen |
| Value Mapping nicht gefunden | Artefakt nicht deployt | Value Mapping separat deployen |
| `NoWorkerInstanceAvailable` | Runtime temporär nicht verfügbar | später erneut deployen |
| Trace bleibt leer | Trace zu spät aktiviert oder Laufzeitproblem | Trace vor dem Aufruf aktivieren |
