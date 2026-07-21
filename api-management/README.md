# API Management

Dieses Verzeichnis enthält die Artefakte und Dokumentationen für den Workshop  
**API Management mit der SAP Integration Suite**.

Im Workshop wird der OData-Service GWSAMPLE_BASIC auf einer ABAP Platform 2023 schrittweise als verwaltete API bereitgestellt, abgesichert und überwacht.

## API-Proxy-Versionen

Die zip-Dateien enthalten exportierte Entwicklungsstände des API Proxys.

| Version | Inhalt |
|---|---|
| `SalesOrderAPI_1.zip` | Grundlegender API Proxy für den OData-Service |
| `SalesOrderAPI_2.zip` | Sichere Authentifizierung gegenüber dem SAP-Backend |
| `SalesOrderAPI_3.zip` | CSRF-Handling |
| `SalesOrderAPI_4.zip` | Zugriffsschutz mit der Policy `Verify API Key` |
| `SalesOrderAPI_5.zip` | Begrenzung der Nutzung mit Quota |
| `SalesOrderAPI_6.zip` | Begrenzung der Nutzung mit Spike Arrest |

Die Versionen dienen als:

- Sicherung der einzelnen Workshopstufen
- Ausgangspunkt für die Live-Demos
- Vergleichsmöglichkeit zwischen den Entwicklungsständen
- Wiederherstellungshilfe bei Konfigurationsproblemen

Die ZIP-Dateien können in SAP API Management über die Importfunktion für API Proxys eingespielt werden.

## Nicht exportierbare Artefakte

Nicht alle im Workshop verwendeten Artefakte können aus der verwendeten Oberfläche als Dateien exportiert werden.

Dazu gehören insbesondere:

- API Provider
- API Product
- Application
- umgebungsspezifische Zugangsdaten
- API Keys und Client Secrets

Die erforderlichen Einstellungen werden deshalb im Verzeichnis `docs` beschrieben und müssen im jeweiligen Tenant manuell angelegt werden.

## Dokumentation

Das Verzeichnis `docs` enthält Anleitungen für die nicht exportierbaren beziehungsweise manuell anzulegenden Artefakte.

Dazu gehören beispielsweise:

- Konfiguration des API Providers
- Anlage des API Products
- Anlage der konsumierenden Application
- Zuordnung von API Product und Application
- Deployment und Test des API Proxys
- Konfiguration der Backend-Authentifizierung
- sichere Ablage von Zugangsdaten

Hostnamen, Benutzerkennungen, Passwörter, API Keys und andere geheime oder umgebungsspezifische Werte werden nicht im Repository gespeichert.

## Wiederherstellung der Workshopumgebung

Für den Neuaufbau der Umgebung werden folgende Schritte durchgeführt:

1. API Provider anhand der Dokumentation anlegen.
2. Gewünschte Version des API Proxys importieren.
3. ProxyEndpoint und TargetEndpoint an den Tenant anpassen.
4. Benötigte Backend-Zugangsdaten sicher hinterlegen.
5. API Proxy deployen.
6. API Product anlegen und den API Proxy zuordnen.
7. Application anlegen und das API Product zuordnen.
8. API Key der Application ermitteln.
9. API-Aufruf.

## Sicherheitshinweise

Folgende Inhalte dürfen nicht im Repository gespeichert werden:

- Passwörter
- API Keys
- Client Secrets
- Access Tokens
- private Schlüssel
- private Zertifikate
- vollständige Service Keys
- produktive Backend-Adressen, sofern diese nicht veröffentlicht werden sollen

Beispiel- und Konfigurationsdateien enthalten deshalb ausschließlich Platzhalter.

## Hinweis zum Transport

Dieses Repository ist kein vollständiges Backup des API-Management-Tenants.

Es enthält:

- die exportierbaren Versionen des API Proxys
- die Dokumentation zum Wiederaufbau der Umgebung

API Provider, API Product, Application und umgebungsspezifische Zugangsdaten müssen anhand der Dokumentation neu angelegt werden.

Für den geregelten Transport von Artefakten zwischen verschiedenen SAP-BTP-Landschaften können zusätzliche SAP-Transportmechanismen eingesetzt werden.
