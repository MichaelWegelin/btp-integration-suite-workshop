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
   ├── Mapping
   │ OData V4 / XML
   ▼
SAP BTP ABAP Environment
```

## Verzeichnisinhalt

```text
integration-suite/
├── packages/
│   └── WebshopSalesOrderIntegration.zip
├── schemas/
│   ├── Webshop.xsd
│   └── SalesOrderEntityPOST.xsd
├── examples/
│   ├── webshop-order-standard.json
│   ├── webshop-order-high-value.json
│   └── webshop-order-initial.json
└── README.md
```

### `packages`

Enthält das aus SAP Integration Suite exportierte Integration Package. Die ZIP-Datei kann in einen eigenen Cloud-Integration-Tenant importiert werden.

### `schemas`

Enthält die im Integration Flow verwendeten XML-Schemas:

- `WebshopOrder.xsd` beschreibt das fachliche Nachrichtenmodell des Webshops.
- `SalesOrder.xsd` beschreibt das vom OData-V4-Receiver erwartete Zielmodell.

### `examples`

Enthält Beispielnachrichten für Postman oder andere HTTP-Clients.

## Voraussetzungen

Für die Inbetriebnahme werden benötigt:

- ein SAP-BTP-Subaccount
- eine Subscription der SAP Integration Suite
- die aktivierte Capability Cloud Integration
- Berechtigungen für Design, Deployment und Monitoring
- eine technische Identität für den eingehenden HTTP-Aufruf
- ein erreichbarer OData-V4-Service im SAP BTP ABAP Environment
- ein Communication Arrangement für die eingehende ABAP-Kommunikation
- Zugangsdaten des zugehörigen Communication User

Der ABAP-Code des Zielsystems befindet sich im Verzeichnis:

```text
../src/
```

## Integration Package importieren

1. SAP Integration Suite öffnen.
2. Zu **Design → Integrations** wechseln.
3. **Import** auswählen.
4. Die Datei öffnen:

   ```text
   packages/WebshopSalesOrderIntegration.zip
   ```

5. Import bestätigen.
6. Das importierte Package öffnen.
7. Die enthaltenen Artefakte kontrollieren.

Abhängig vom Exportformat kann das Package alternativ zunächst entpackt beziehungsweise über die Importfunktion für Packages hochgeladen werden.

## Enthaltenew Artefakte

Das Package enthält den Integration Flow `Create Sales Order`, der Aufträge verarbeitet und überträgt

Die tatsächlichen Artefaktnamen können abhängig vom jeweiligen Stand des Workshop-Package leicht abweichen.

## Security Material anlegen

Zugangsdaten sind aus Sicherheitsgründen nicht im Repository und nicht im exportierten Package enthalten.

Für den OData-Empfänger muss in Cloud Integration ein Security Material vom Typ **User Credentials** angelegt werden.

Beispiel:

```text
Name:     ABAP_SALES_ORDER
User:     <Communication User>
Password: <Passwort des Communication User>
```

Vorgehen:

1. **Monitor → Integrations and APIs** öffnen.
2. **Security Material** auswählen.
3. **Create → User Credentials** wählen.
4. Namen, Benutzer und Passwort eintragen.
5. Security Material speichern.

Der Name des Security Material muss mit dem im Integration Flow konfigurierten Credential-Namen übereinstimmen.

## Integration Flow konfigurieren

Nach dem Import:

1. Im Package den Integration Flow `Create Sales Order` auswählen.
2. **Actions → Configure** öffnen.
3. Die externalisierten Parameter kontrollieren.
4. Die Werte an die eigene Umgebung anpassen.

Typische Parameter:

| Parameter | Bedeutung |
|---|---|
| `ReceiverAddress` | URL des OData-Services |
| `CredentialName` | Name des Security Material |
| `SenderAddress` | Pfad des HTTPS-Senderadapters |
| `HighValueLimit` | Grenzwert für hochwertige Aufträge |

Beispiel:

```text
ReceiverAddress = https://<abap-host>/sap/opu/odata4/...
CredentialName  = ABAP_SALES_ORDER
HighValueLimit  = 1000
```

Keine Passwörter oder Client Secrets als normale Konfigurationsparameter eintragen.

## Deployment

Die Artefakte werden nicht automatisch gemeinsam deployt.

Empfohlene Reihenfolge:

1. Integration Flow konfigurieren.
2. Integration Flow deployen.
3. Warten, bis der Status **Started** angezeigt wird.
4. Den erzeugten HTTPS-Endpunkt im Monitoring ermitteln.

Der HTTPS-Endpunkt wird unter **Manage Integration Content** beim deployten Integration Flow angezeigt.

## Eingehende Authentifizierung

Für den Aufruf des HTTPS-Senderadapters wird eine technische Identität benötigt.

In der Workshopumgebung wird dafür eine Service-Instanz der **Process Integration Runtime** mit einem Service Key verwendet.

Der Service Key enthält unter anderem:

```text
clientid
clientsecret
url
tokenurl
```

Der technischen Identität muss die vom HTTPS-Senderadapter verlangte Rolle zugeordnet sein, beispielsweise:

```text
ESBMessaging.send
```

oder die im konkreten Integration Flow konfigurierte dedizierte Rolle.

## Testnachricht

Beispiel:

```json
{
  "order": {
    "id": "0815",
    "customer": {
      "name": "Müller GmbH"
    },
    "total": {
      "amount": 1299.00,
      "currency": "EUR"
    }
  }
}
```

Die Nachricht kann mit Postman an den HTTPS-Endpunkt des Integration Flow gesendet werden.

Erforderlicher Header:

```http
Content-Type: application/json
```

## Router testen

Der Integration Flow unterscheidet Aufträge anhand des Gesamtbetrags.

Beispielhafte Verarbeitung:

```text
amount >= 1000  → HIGH_VALUE
sonst           → STANDARD
```

Die Testdateien befinden sich unter:

```text
examples/webshop-order-standard.json
examples/webshop-order-high-value.json
```

Im Trace kann kontrolliert werden, welcher Weg ausgeführt und welcher Wert im Header `OrderCategory` gesetzt wurde.

## Monitoring und Trace

Nach einem Aufruf:

1. **Monitor → Integrations and APIs** öffnen.
2. **Monitor Message Processing** auswählen.
3. Den entsprechenden Nachrichtenlauf öffnen.
4. Status und Verarbeitungsschritte kontrollieren.

Für detaillierte Payloadinformationen kann vorübergehend der Log Level **Trace** aktiviert werden.

Trace sollte nur für die Fehlersuche und nur für einen begrenzten Zeitraum verwendet werden. Nachrichten können personenbezogene oder andere sensible Daten enthalten.

## Typische Fehler

| Fehler | Mögliche Ursache |
|---|---|
| `401 Unauthorized` | falsche oder fehlende Zugangsdaten |
| `403 Forbidden` am HTTPS-Endpunkt | technische Identität besitzt nicht die benötigte Senderrolle |
| `403 Forbidden` beim OData-Aufruf | Communication User oder Communication Arrangement nicht korrekt |
| CSRF-Fehler | CSRF-Behandlung im OData-Adapter nicht aktiviert |
| `Unexpected End-of-input in prolog` | Adapter erwartet XML, erhält aber JSON oder einen leeren Body |
| Value Mapping nicht gefunden | Value Mapping wurde nicht deployt |
| Integration Flow startet nicht | Runtime momentan nicht verfügbar oder Konfiguration unvollständig |
| kein Trace sichtbar | Trace nicht rechtzeitig aktiviert oder Trace-Zeitraum abgelaufen |

## Sicherheitshinweise

Dieses Repository enthält absichtlich keine:

- Passwörter,
- Client Secrets,
- OAuth-Token,
- Service Keys,
- privaten Schlüssel,
- produktiven Zertifikate,
- exportierten Security Materials.

Vor einem Commit müssen insbesondere Postman Environments und lokale Konfigurationsdateien auf Zugangsdaten geprüft werden.

## Weiterführende Verzeichnisse

```text
../src/       ABAP-Implementierung des OData-Zielsystems
../postman/   Postman Collection und Testkonfiguration
../docs/      zusätzliche Architektur- und Einrichtungsunterlagen
```

## Verwendung

Die Inhalte dienen als Begleitmaterial für den SAP-Integration-Suite-Workshop. Vor einer Verwendung in produktiven Systemen müssen Sicherheitskonzept, Fehlerbehandlung, Monitoring und fachliche Anforderungen geprüft und angepasst werden.
