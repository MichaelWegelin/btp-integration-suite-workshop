# Architekturübersicht

## Ziel

Ein Webshop überträgt einen Auftrag über die SAP Integration Suite an eine RAP-Anwendung im SAP BTP ABAP Environment.

## Systemlandschaft

```text
Postman / Webshop
       │
       │ HTTPS, JSON
       ▼
SAP Integration Suite
       │
       │ OData V4, XML
       ▼
SAP BTP ABAP Environment
```

## Verantwortlichkeiten

| Komponente                | Aufgabe                                                   |
| ------------------------- | --------------------------------------------------------- |
| Webshop/Postman           | erzeugt den fachlichen Auftrag                            |
| Integration Suite         | authentifiziert, konvertiert, transformiert und überträgt |
| RAP-Anwendung             | validiert und speichert den Auftrag                       |
| Communication Arrangement | autorisiert die eingehende Kommunikation im ABAP-System   |

## Verarbeitungsablauf
1. Der Sender überträgt einen Auftrag als JSON.
1. Der HTTPS-Senderadapter nimmt die Nachricht entgegen.
1. Der JSON-to-XML Converter erzeugt XML im Webshop-Modell.
1. Der Router klassifiziert den Auftrag.
1. Das Message Mapping erzeugt das OData-Zielmodell.
1. Der OData-V4-Adapter ruft den RAP-Service auf.

