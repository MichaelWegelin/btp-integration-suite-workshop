# API Product

Ein API Product fasst eine oder mehrere veröffentlichte APIs für Konsumenten zusammen.

Im Workshop wird der SalesOrder API Proxy einem API Product zugeordnet. Anschließend erhält eine Application Zugriff auf dieses Product.

## Aufgabe des API Products

Das API Product bildet die Verbindung zwischen der technisch bereitgestellten API und der konsumierenden Application.

```text
API Proxy
    │
    ▼
API Product
    │
    ▼
Application
    │
    ▼
API Key
```

Der API Proxy definiert den Endpunkt und die Verarbeitung. Das API Product legt fest, welche APIs gemeinsam für Konsumenten bereitgestellt werden.

## Workshopkonfiguration

| Eigenschaft | Beispielwert |
|---|---|
| Name | `SalesOrderProduct` |
| Anzeigename | `Sales Order API` |
| Beschreibung | `API Product für den SalesOrder-Service des Workshops` |
| Zugeordnete API | `SalesOrderAPI` |
| Sichtbarkeit | entsprechend der Workshopumgebung |
| Freigabe | veröffentlicht |

Die tatsächlich verfügbaren Felder und Bezeichnungen können von der Tenant-Oberfläche abhängen.

## Voraussetzungen

Vor dem Anlegen des API Products müssen folgende Voraussetzungen erfüllt sein:

- der API Proxy ist angelegt
- der API Proxy ist vollständig konfiguriert
- der API Proxy wurde erfolgreich deployt
- der Proxy-Endpunkt ist bekannt
- erforderliche Policies sind gespeichert und deployt

## API Product anlegen

1. SAP Integration Suite öffnen.
2. Den Bereich für API Management aufrufen.
3. Zur Verwaltung der API Products wechseln.
4. Ein neues API Product anlegen.
5. Namen und Beschreibung eintragen.
6. Den SalesOrder API Proxy zuordnen.
7. Weitere erforderliche Angaben ergänzen.
8. API Product speichern.
9. API Product veröffentlichen.

## API Proxy zuordnen

Dem Product wird die im Workshop erstellte API zugeordnet.

Beispiel:

```text
SalesOrderProduct
└── SalesOrderAPI
```

Je nach Oberfläche kann die Zuordnung über eine API-Auswahl innerhalb des Products oder über einen separaten Zuordnungsdialog erfolgen.

Vor der Zuordnung sollte geprüft werden:

- Ist die richtige Proxy-Version deployt?
- Stimmt der öffentliche Basispfad?
- Sind alle erforderlichen Policies enthalten?
- Ist die Backend-Verbindung funktionsfähig?

## Product veröffentlichen

Ein neu angelegtes Product ist nicht in jedem Fall sofort für Applications verfügbar. Es muss gespeichert und gegebenenfalls veröffentlicht werden.

Nach der Veröffentlichung sollte geprüft werden:

- das Product wird in der Product-Liste angezeigt
- die zugeordnete API ist sichtbar
- das Product kann einer Application zugeordnet werden
- der Status zeigt die erfolgreiche Veröffentlichung

## Application zuordnen

Die konsumierende Application erhält Zugriff auf das API Product.

Beispiel:

```text
SalesOrderClient
└── SalesOrderProduct
    └── SalesOrderAPI
```

Nach der Zuordnung kann der API Key der Application für den Aufruf des API Proxys verwendet werden.

Die genaue Bedienreihenfolge kann von der Oberfläche abhängen:

- Product innerhalb der Application auswählen
- Application innerhalb des Products zuordnen
- Product abonnieren oder freigeben

Entscheidend ist, dass die Application anschließend Zugriff auf das veröffentlichte Product besitzt.

## Zugriff testen

Nach dem Anlegen von Product und Application wird der API Proxy mit dem API Key der Application aufgerufen.

Beispiel:

```http
GET https://<API_MANAGEMENT_HOST>/<PROXY_BASE_PATH>
apikey: <API_KEY>
Accept: application/json
```

Falls die Policy einen anderen Header oder Query-Parameter erwartet, muss der Aufruf entsprechend angepasst werden.

Beispiel als Query-Parameter:

```http
GET https://<API_MANAGEMENT_HOST>/<PROXY_BASE_PATH>?apikey=<API_KEY>
```

Für den Workshop sollte eine einheitliche Variante verwendet werden. Empfohlen ist die Übertragung in einem Request-Header.

## Product und API-Versionierung

Die Version eines API Products ist nicht automatisch identisch mit:

- der Entwicklungsstufe des exportierten API Proxys
- der Versionsnummer des OData-Service
- der fachlichen Version der veröffentlichten API
- der Git-Version des Repositorys


Bei einer inkompatiblen Änderung der öffentlichen API kann dagegen ein neues Product oder eine neue API-Version erforderlich sein.

Beispiel:

```text
SalesOrderProductV1
└── /1/salesorders

SalesOrderProductV2
└── /2/salesorders
```

## Typische Fehler

### API kann nicht zugeordnet werden

Mögliche Ursachen:

- API Proxy wurde noch nicht deployt
- falscher Status des API Proxys
- Proxy gehört zu einer anderen Umgebung
- Änderungen wurden noch nicht gespeichert
- fehlende Berechtigungen

### Product ist für die Application nicht sichtbar

Mögliche Ursachen:

- Product wurde noch nicht veröffentlicht
- Application und Product befinden sich nicht im gleichen Kontext
- fehlende Berechtigungen
- Oberfläche wurde noch nicht aktualisiert

### API Key wird abgewiesen

Mögliche Ursachen:

- Application ist dem Product nicht zugeordnet
- falscher API Key
- `Verify API Key` erwartet einen anderen Header
- falscher Proxy-Endpunkt wird aufgerufen
- Änderungen am Proxy wurden nachträglich nicht deployt

### API-Aufruf liefert einen Backend-Fehler

Das Product selbst verarbeitet keine Backend-Anfragen. In diesem Fall sind insbesondere zu prüfen:

- API Proxy
- TargetEndpoint
- API Provider
- Backend-Authentifizierung
- RAP-OData-Service

## Sicherheitshinweise

Ein API Product enthält normalerweise keine geheimen Backend-Zugangsdaten. Trotzdem sollten nur die erforderlichen APIs veröffentlicht werden.

Zu beachten:

- keine internen Test-APIs unbeabsichtigt veröffentlichen
- Product-Zuordnungen regelmäßig prüfen
- nicht mehr benötigte Applications entfernen
- API Keys nicht gemeinsam für mehrere Konsumenten verwenden
- Zugriff bei Bedarf über zusätzliche Policies einschränken

## Nicht exportierbare Konfiguration

Das API Product kann in der verwendeten Oberfläche nicht als einfache Datei für das Git-Repository exportiert werden.

Diese Dokumentation dient deshalb als Wiederherstellungsanleitung.

Beim Neuaufbau müssen mindestens folgende Angaben rekonstruiert werden:

- Name des Products
- Beschreibung
- zugeordnete APIs
- Veröffentlichungsstatus
- zugeordnete Applications
- gegebenenfalls Sichtbarkeit und Freigaberegeln

## Wiederherstellung

1. Benötigte Version des API Proxys importieren.
2. API Proxy konfigurieren und deployen.
3. API Product mit dem dokumentierten Namen anlegen.
4. SalesOrder API Proxy zuordnen.
5. Product speichern und veröffentlichen.
6. Product einer Application zuordnen.
7. API-Aufruf mit dem API Key testen.

## Checkliste

```text
□ API Proxy ist deployt
□ API Product ist angelegt
□ Name und Beschreibung sind gesetzt
□ SalesOrder API ist zugeordnet
□ Product ist veröffentlicht
□ Application besitzt Zugriff auf das Product
□ API Key wird akzeptiert
□ Product enthält nur die vorgesehenen APIs
```
