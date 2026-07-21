# Application

Eine Application repräsentiert in SAP API Management einen Konsumenten beziehungsweise eine konsumierende Anwendung.

Im Workshop wird eine Application angelegt, dem SalesOrder API Product zugeordnet und anschließend über ihren API Key identifiziert.

## Aufgabe der Application

Die Application verbindet einen konkreten Konsumenten mit den für ihn freigegebenen API Products.

```text
Konsument
    │
    ▼
Application
    │
    │ API Key
    ▼
API Product
    │
    ▼
API Proxy
```

Der API Key wird von der Application bereitgestellt und beim Aufruf des API Proxys übergeben.

Die Policy `Verify API Key` prüft, ob der übergebene Schlüssel gültig ist und Zugriff auf die API gewährt.

## Workshopkonfiguration

| Eigenschaft | Beispielwert |
|---|---|
| Name | `SalesOrderClient` |
| Beschreibung | `Client für den API-Management-Workshop` |
| Zugeordnetes Product | `SalesOrderProduct` |
| Konsument | Workshopteilnehmer beziehungsweise Postman |
| Authentifizierung | API Key |

Die konkreten Feldbezeichnungen können sich abhängig von der verwendeten Oberfläche unterscheiden.

## Voraussetzungen

Vor dem Anlegen der Application müssen folgende Artefakte vorhanden sein:

- ein deployter API Proxy
- ein veröffentlichtes API Product
- die Zuordnung des API Proxys zum Product
- die erforderlichen Berechtigungen zum Verwalten von Applications

## Application anlegen

1. SAP Integration Suite öffnen.
2. Den Bereich für API Management aufrufen.
3. Zur Verwaltung der Applications wechseln.
4. Eine neue Application anlegen.
5. Namen und Beschreibung eintragen.
6. Das API Product `SalesOrderProduct` auswählen beziehungsweise abonnieren.
7. Application speichern.
8. Generierten API Key anzeigen.
9. API Key in das lokale Postman Environment übernehmen.
10. API-Aufruf testen.

## API Product zuordnen

Der Application wird das veröffentlichte Product zugeordnet.

Beispiel:

```text
SalesOrderClient
└── SalesOrderProduct
    └── SalesOrderAPI
```

Je nach Tenant kann die Zuordnung auch als Abonnement oder Zugriff auf ein Product bezeichnet werden.

Nach der Zuordnung sollte geprüft werden:

- das richtige Product wurde ausgewählt
- das Product enthält die gewünschte API
- das Product ist veröffentlicht
- die Zuordnung ist aktiv

## API Key verwenden

Der API Key wird beim Aufruf des API Proxys an API Management übertragen.

Empfohlene Variante für den Workshop:

```http
GET https://<API_MANAGEMENT_HOST>/<PROXY_BASE_PATH>
apikey: <API_KEY>
Accept: application/json
```

Die Policy `Verify API Key` muss denselben Header auslesen.

Beispiel für die relevante Policy-Konfiguration:

```xml
<APIKey ref="request.header.apikey"/>
```

Wenn die Policy einen anderen Variablennamen verwendet, muss der Postman-Request entsprechend angepasst werden.

## Postman Environment

Der API Key wird nicht direkt in der Collection gespeichert. Stattdessen wird eine lokale Environment-Variable verwendet.

Beispiel:

| Variable | Initial Value | Current Value |
|---|---|---|
| `apiBaseUrl` | `<API_BASE_URL>` | tenantabhängiger Wert |
| `apiKey` | leer | tatsächlicher API Key |
| `externalOrderId` | `0815` | frei wählbarer Testwert |

Der Request verwendet anschließend:

```text
{{apiBaseUrl}}
```

und den Header:

```text
apikey: {{apiKey}}
```

Das lokale Environment mit dem echten API Key darf nicht in das Repository eingecheckt werden.

Im Repository befindet sich nur eine Beispieldatei ohne geheime Werte.

## Zugriff testen

### Test ohne API Key

```http
GET https://<API_MANAGEMENT_HOST>/<PROXY_BASE_PATH>
```

Erwartetes Ergebnis:

- Request wird von der Policy abgewiesen
- Backend wird nicht aufgerufen
- Fehlerantwort weist auf einen fehlenden API Key hin

### Test mit ungültigem API Key

```http
GET https://<API_MANAGEMENT_HOST>/<PROXY_BASE_PATH>
apikey: invalid
```

Erwartetes Ergebnis:

- Request wird abgewiesen
- Backend-Zugangsdaten werden nicht verwendet
- Fehler wird in API Management erzeugt

### Test mit gültigem API Key

```http
GET https://<API_MANAGEMENT_HOST>/<PROXY_BASE_PATH>
apikey: <VALID_API_KEY>
Accept: application/json
```

Erwartetes Ergebnis:

- API Key wird akzeptiert
- Request wird an das Backend weitergeleitet
- Antwort des RAP-OData-Service wird zurückgegeben

## Abgrenzung zur Backend-Authentifizierung

Der API Key authentifiziert die konsumierende Application gegenüber API Management.

Er ist nicht identisch mit den Zugangsdaten zum ABAP-Backend.

```text
Postman
   │
   │ API Key
   ▼
API Management
   │
   │ Backend-Authentifizierung
   ▼
ABAP Environment
```

Damit gelten zwei getrennte Sicherheitsbeziehungen:

| Verbindung | Authentifizierung |
|---|---|
| Konsument → API Management | API Key |
| API Management → ABAP Environment | Basic Authentication oder OAuth |

Die Backend-Zugangsdaten verbleiben in API Management und werden nicht an den Konsumenten weitergegeben.

## Eine Application pro Konsument

Für unterschiedliche konsumierende Systeme sollten getrennte Applications verwendet werden.

Beispiel:

```text
SalesOrderClientPostman
SalesOrderClientPortal
SalesOrderClientPartnerA
```

Vorteile:

- Aufrufe lassen sich einem Konsumenten zuordnen
- API Keys können getrennt gesperrt oder ersetzt werden
- Quotas können konsumentenspezifisch verwaltet werden
- Analytics kann die Nutzung nach Application auswerten
- ein kompromittierter Schlüssel betrifft nicht alle Konsumenten

Ein gemeinsamer API Key für mehrere unabhängige Konsumenten sollte vermieden werden.

## Umgang mit API Keys

API Keys sind vertrauliche Zugangsdaten.

Sie dürfen nicht gespeichert werden in:

- Git-Repositorys
- öffentlichen Dokumentationen
- Screenshots für Schulungsunterlagen
- gemeinsam verwendeten Collection-Dateien
- Quellcode
- ungeschützten Textdateien

Geeignete Ablageorte sind beispielsweise:

- lokales Postman Environment
- Secret Store
- geschützte CI/CD-Variable
- Secret-Management-System der konsumierenden Anwendung

## API Key austauschen

Falls ein API Key offengelegt oder versehentlich eingecheckt wurde:

1. betroffenen Schlüssel nicht weiterverwenden
2. Schlüssel beziehungsweise Application sperren oder löschen
3. neue Zugangsdaten erzeugen
4. lokale Konfiguration aktualisieren
5. Git-Historie gegebenenfalls auf offengelegte Secrets prüfen
6. betroffene Personen informieren
7. Aufrufe in Analytics auf ungewöhnliche Nutzung prüfen

Das Entfernen des Schlüssels aus der aktuellen Datei reicht nicht aus, wenn er bereits in einer Git-Historie gespeichert wurde.

## Typische Fehler

### API Key fehlt

Mögliche Ursache:

- Header wurde in Postman nicht angelegt
- Environment ist nicht ausgewählt
- Variable `apiKey` ist leer
- Header ist deaktiviert

### API Key ist ungültig

Mögliche Ursache:

- falscher Schlüssel wurde kopiert
- Schlüssel gehört zu einer anderen Application
- Application besitzt keinen Zugriff auf das Product
- Product ist nicht veröffentlicht
- Schlüssel wurde ersetzt oder gesperrt

### Policy findet den API Key nicht

Mögliche Ursache:

- Policy erwartet einen anderen Headernamen
- API Key wird als Query-Parameter statt als Header übertragen
- Groß-/Kleinschreibung oder Variablenreferenz stimmt nicht
- Policy befindet sich im falschen Flow

### Gültiger API Key, aber Backend-Aufruf schlägt fehl

Dann funktioniert die Konsumentenauthentifizierung, aber ein nachgelagerter Schritt ist fehlerhaft.

Zu prüfen sind:

- TargetEndpoint
- API Provider
- Backend-Authentifizierung
- OData-Servicepfad
- Berechtigungen des Kommunikationsbenutzers

## Application löschen

Eine nicht mehr benötigte Application sollte entfernt oder deaktiviert werden.

Vorher sollte geprüft werden:

- Wird der API Key noch verwendet?
- Ist die Application in Analytics noch aktiv?
- Gibt es einen Ersatzkonsumenten?
- Müssen Verantwortliche informiert werden?

Nach dem Löschen oder Sperren dürfen die zugehörigen API Keys nicht mehr funktionieren.

## Nicht exportierbare Konfiguration

Die Application kann in der verwendeten Oberfläche nicht als Datei für das Git-Repository exportiert werden.

Sie muss beim Neuaufbau manuell angelegt werden.

Nicht dokumentiert beziehungsweise nicht gespeichert werden:

- echter API Key
- Client Secret
- weitere generierte Zugangsdaten

Dokumentiert werden:

- Name und Zweck der Application
- zugeordnetes Product
- erwartetes Authentifizierungsverfahren
- verwendeter Headername
- Schritte zur erneuten Anlage

## Wiederherstellung

1. API Product anlegen und veröffentlichen.
2. Application mit dem dokumentierten Namen anlegen.
3. Product der Application zuordnen.
4. API Key erzeugen beziehungsweise anzeigen.
5. Request ohne API Key testen.
6. Request mit ungültigem API Key testen.
7. Request mit gültigem API Key testen.

## Checkliste

```text
□ Application ist angelegt
□ Name und Zweck sind dokumentiert
□ SalesOrderProduct ist zugeordnet
□ API Key ist verfügbar
□ API Key steht nur im lokalen Environment
□ Verify-API-Key-Policy verwendet denselben Header
□ Aufruf ohne API Key wird abgewiesen
□ Aufruf mit gültigem API Key funktioniert
□ API Key wurde nicht in Git gespeichert
```
