# Postman Collection

Dieser Ordner enthält die Postman Collection und eine Environment-Vorlage für den SAP-Integration-Suite-Workshop.

## Dateien

```text
Integration-Suite-Workshop.postman_collection.json
Integration-Suite-Workshop.postman_environment.json
```

## Import
1. Postman öffnen.
1. Import wählen.
1. Collection und Environment importieren.
1. Das Environment Integration Suite Workshop aktivieren.
1. Die benötigten Variablen eintragen.

| Variable        | Bedeutung                                 |
| --------------- | ----------------------------------------- |
| `runtime_url`   | Basis-URL der Cloud-Integration-Runtime   |
| `sender_path`   | HTTPS-Pfad des deployten Integration Flow |
| `client_id`     | Client-ID aus dem Service Key             |
| `client_secret` | Client-Secret aus dem Service Key         |


## Sicherheit

Die bereitgestellte Environment-Datei enthält keine Zugangsdaten.

Client-ID und Client-Secret müssen nach dem Import lokal eingetragen werden und dürfen nicht in das Git-Repository eingecheckt werden.

## Requests

Die Collection enthält Requests für:

1. einen Standardauftrag,
1. einen hochwertigen Auftrag,

Vor dem Senden muss der passende Integration Flow konfiguriert und deployt sein.
