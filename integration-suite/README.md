# SAP Integration Suite – Sales-Order-Integration

Dieser Ordner enthält die Artefakte für den ersten Teil der Workshop-Reihe:

> Entwicklung von Integration Flows mit der SAP Integration Suite

Das Beispiel empfängt einen Auftrag als JSON-Nachricht, konvertiert und transformiert ihn und legt anschließend über einen OData-V4-Service einen Auftrag im SAP BTP ABAP Environment an.

## Architektur

```text
Postman
   │ HTTPS / JSON
   ▼
SAP Integration Suite
   │
   ├── JSON-to-XML Converter
   ├── Router
   ├── Content Modifier
   └── Message Mapping
   │ OData V4 / XML
   ▼
SAP BTP ABAP Environment
