# Deployment und Wiederherstellung

Diese Anleitung beschreibt, wie die API-Management-Artefakte des Workshops neu aufgebaut, deployt und getestet werden.

Das Repository enthält exportierte Versionen des API Proxys. API Provider, API Product und Application müssen anhand der Dokumentation manuell angelegt werden.

## Enthaltene Artefakte

```text
api-management/
├── README.md
│── SalesOrderAPI_1.zip
│── SalesOrderAPI_2.zip
│── SalesOrderAPI_3.zip
│── SalesOrderAPI_4.zip
│── SalesOrderAPI_5.zip
│── SalesOrderAPI_6.zip
├── docs/
    ├── api-provider.md
    ├── api-product.md
    ├── application.md
    └── deployment.md
```
## Voraussetzungen

Für den Neuaufbau werden benötigt:

- SAP-BTP-Subaccount mit SAP Integration Suite
- eingerichtetes API Management
- erforderliche Rollen und Role Collections
- erreichbares SAP BTP ABAP Environment
- ABAP Platform 2023 mit GWSAMPLE_BASIC OData Service
- technischer Kommunikationsbenutzer
- exportierte ZIP-Datei des gewünschten API-Proxy-Stands
- Postman oder ein vergleichbarer HTTP-Client

## Empfohlene Reihenfolge

```text
1. Backend prüfen
2. API Provider anlegen
3. API Proxy importieren
4. Proxy konfigurieren
5. Proxy deployen
6. API Product anlegen
7. Application anlegen
8. Postman konfigurieren
9. API testen
10. Analytics prüfen
```

## 1. Backend prüfen

Vor der Konfiguration von API Management sollte der OData-Service direkt getestet werden.

### Metadaten abrufen

```http
GET https://<ABAP_HOST>/<ODATA_SERVICE_PATH>/$metadata
Authorization: Basic <credentials>
Accept: application/xml
```

### Service aufrufen

```http
GET https://<ABAP_HOST>/<ODATA_SERVICE_PATH>/
Authorization: Basic <credentials>
Accept: application/json
```

Prüfen:

- Service ist veröffentlicht
- Kommunikationsbenutzer ist berechtigt
- Hostname und Servicepfad sind korrekt
- Backend liefert die erwartete Antwort

## 2. API Provider anlegen

Den API Provider anhand von `api-provider.md` anlegen.

Beispielwerte:

| Feld | Wert |
|---|---|
| Name | `A4H` |
| Protokoll | HTTP |
| Host | `<ABAP_HOST>` |
| Port | `50000` |
| Authentifizierung | Basic Authentication |
| Benutzer | `<COMMUNICATION_USER>` |
| Kennwort | `<PASSWORD>` |

Anschließend die Verbindung testen.

Zugangsdaten dürfen nicht in das Repository übernommen werden.

## 3. API Proxy importieren

1. SAP Integration Suite öffnen.
2. Den API-Management-Bereich aufrufen.
3. Zur API-Verwaltung wechseln.
4. Importfunktion für API Proxys öffnen.
5. ZIP-Datei der gewünschten Workshopstufe auswählen.
6. Import bestätigen.
7. Importierten API Proxy öffnen.
8. Konfiguration prüfen.

Beispiel:

```text
api-proxy/v4-traffic-management/SalesOrderAPI.zip
```

Für eine vollständige Workshopumgebung wird normalerweise die letzte Entwicklungsstufe importiert.

Für einzelne Live-Demos kann mit einer früheren Stufe begonnen werden.

## 4. Importierte Konfiguration prüfen

Nach dem Import müssen umgebungsspezifische Einstellungen kontrolliert werden.

Dazu gehören:

- Name des API Providers
- TargetEndpoint
- Backend-URL
- OData-Servicepfad
- Proxy-Basispfad
- verwendete Policies
- Policy-Reihenfolge
- Headernamen
- Credential- oder Key-Value-Map-Referenzen
- Quota-Werte
- Spike-Arrest-Werte

Ein exportierter Proxy kann Referenzen enthalten, die im Ziel-Tenant noch nicht existieren.

## 5. ProxyEndpoint prüfen

Der ProxyEndpoint definiert den öffentlich erreichbaren API-Endpunkt.

Zu prüfen sind:

- Base Path
- erlaubte HTTP-Methoden
- PreFlow und PostFlow
- bedingte Flows
- API-Key-Prüfung
- Quota
- Spike Arrest
- Fehlerbehandlung

Beispiel für einen Basispfad:

```text
/salesorders
```

Beispielaufruf:

```text
https://<API_MANAGEMENT_HOST>/salesorders
```

## 6. TargetEndpoint prüfen

Der TargetEndpoint definiert die Weiterleitung zum Backend.

Zu prüfen sind:

- Referenz auf den API Provider
- Backend-Pfad
- Authentifizierung
- Header-Manipulation
- Timeouts
- Fehlerbehandlung

Die öffentliche Proxy-URL und die interne Backend-URL sind voneinander zu unterscheiden.

```text
Konsument
    │
    │ öffentliche Proxy-URL
    ▼
API Management
    │
    │ interne Backend-Verbindung
    ▼
ABAP Environment
```

## 7. Policies prüfen

Je nach importierter Entwicklungsstufe sind unterschiedliche Policies enthalten.

### Verify API Key

Prüft den API Key der konsumierenden Application.

Beispiel:

```xml
<APIKey ref="request.header.apikey"/>
```

Der Headername muss mit dem Postman-Request übereinstimmen.

### Backend-Authentifizierung

Ergänzt beziehungsweise verwendet die erforderlichen Zugangsdaten für den Backend-Aufruf.

Dabei dürfen keine Passwörter im Klartext im exportierten Proxy gespeichert werden.

### Quota

Begrenzt die Anzahl der zulässigen Requests in einem definierten Zeitraum.

Für eine Live-Demo können kleine Grenzwerte verwendet werden. Für produktive APIs müssen Quotas anhand von Nutzung und Backend-Kapazität festgelegt werden.

### Spike Arrest

Glättet kurzfristige Lastspitzen.

Quota und Spike Arrest erfüllen unterschiedliche Aufgaben:

| Policy | Aufgabe |
|---|---|
| Quota | Gesamtzahl der Aufrufe in einem Zeitraum begrenzen |
| Spike Arrest | kurzfristige Aufrufspitzen glätten |

## 8. API Proxy deployen

Nach Abschluss der Konfiguration:

1. Änderungen speichern.
2. Konfiguration auf Fehler prüfen.
3. API Proxy deployen.
4. Warten, bis der Deployment-Vorgang abgeschlossen ist.
5. Status in der API-Verwaltung prüfen.
6. Proxy-Endpunkt kopieren beziehungsweise notieren.

In der verwendeten Tenant-Oberfläche wird der Status direkt in der API-Verwaltung geprüft. Der Bereich `Monitor → Integrations and APIs` wird nicht für das API-Management-Monitoring verwendet.

## 9. Ersten Proxy-Aufruf testen

Vor dem Anlegen von Product und Application kann – abhängig vom Entwicklungsstand – zunächst der grundlegende Proxy-Aufruf geprüft werden.

Beispiel:

```http
GET https://<API_MANAGEMENT_HOST>/<PROXY_BASE_PATH>
Accept: application/json
```

Bei einer bereits aktiven `Verify API Key`-Policy wird der Request ohne gültigen Schlüssel erwartungsgemäß abgewiesen.

## 10. API Product anlegen

Das API Product anhand von `api-product.md` anlegen.

Beispiel:

| Feld | Wert |
|---|---|
| Name | `SalesOrderProduct` |
| Beschreibung | `API Product für den SalesOrder-Workshop` |
| API | `SalesOrderAPI` |

Anschließend:

1. API Proxy zuordnen.
2. Product speichern.
3. Product veröffentlichen.
4. Status prüfen.

## 11. Application anlegen

Die Application anhand von `application.md` anlegen.

Beispiel:

| Feld | Wert |
|---|---|
| Name | `SalesOrderClient` |
| Beschreibung | `Postman-Client für den Workshop` |
| Product | `SalesOrderProduct` |

Anschließend:

1. Product zuordnen beziehungsweise abonnieren.
2. Application speichern.
3. API Key anzeigen.
4. API Key ausschließlich lokal speichern.

## 12. API-Key-Prüfung testen

### Ohne API Key

Request ohne `apikey`-Header senden.

Erwartung:

- Request wird abgewiesen
- Backend wird nicht aufgerufen

### Mit ungültigem API Key

```http
apikey: invalid
```

Erwartung:

- Request wird abgewiesen
- Fehlermeldung wird von API Management erzeugt

### Mit gültigem API Key

```http
apikey: {{apiKey}}
```

Erwartung:

- API Key wird akzeptiert
- Request wird an das Backend weitergeleitet
- Backend-Antwort wird an Postman zurückgegeben

## 14. Backend-Authentifizierung testen

Ein erfolgreicher API-Key-Test bedeutet noch nicht, dass die Backend-Authentifizierung funktioniert.

Bei einem HTTP-Fehler sind die Schichten getrennt zu prüfen:

| Ergebnis | Wahrscheinlicher Bereich |
|---|---|
| API Key fehlt oder ist ungültig | Application oder Verify-API-Key-Policy |
| HTTP 401 vom Backend | Backend-Zugangsdaten |
| HTTP 403 vom Backend | Backend-Berechtigung |
| HTTP 404 | Target-Pfad oder OData-Servicepfad |
| HTTP 429 | Quota oder Spike Arrest |
| HTTP 5xx | Backend, Policy oder API-Management-Laufzeit |

## 15. Quota testen

Für die Live-Demo kann eine kleine Quota konfiguriert werden.

Beispiel:

```text
5 Requests pro Minute
```

Test:

1. mehrere Requests nacheinander senden
2. erfolgreiche Aufrufe zählen
3. Grenzwert überschreiten
4. Fehlerantwort untersuchen
5. nach Ablauf des Zeitfensters erneut testen

Nach der Demo sollte geprüft werden, ob der Grenzwert für weitere Workshopteile wieder angepasst werden muss.

## 16. Spike Arrest testen

Für eine sichtbare Live-Demo kann eine niedrige Rate verwendet werden.

Test:

1. mehrere Requests sehr schnell absenden
2. erfolgreiche und abgewiesene Requests vergleichen
3. zeitlichen Unterschied zur Quota erläutern

Eine manuelle Folge einzelner Requests ist unter Umständen nicht schnell genug. Bei Bedarf kann der Postman Collection Runner verwendet werden.

## 17. Einzelnen Request debuggen

Der Debugger dient zur Analyse eines konkreten API-Aufrufs.

Vorgehen:

1. API Proxy öffnen.
2. Debug-Sitzung starten.
3. Request aus Postman absenden.
4. ausgeführte Policies untersuchen.
5. Request- und Response-Variablen prüfen.
6. Fehlerstelle identifizieren.
7. Debug-Sitzung beenden.

Typische Fragestellungen:

- Wurde der API Key gefunden?
- Welche Policy hat den Request abgewiesen?
- Welche Backend-URL wurde aufgerufen?
- Welche Header wurden gesetzt oder entfernt?
- Welcher Statuscode kam vom Backend?

## 18. Analytics prüfen

Die aktuelle Analytics-Oberfläche wird über `Analyze` geöffnet.

Verfügbare Bereiche:

| Ansicht | Schwerpunkt |
|---|---|
| `Overview` | Gesamtüberblick über API-Aufrufe |
| `Health` | Fehler, Statuscodes und Performance |
| `Usage` | Nutzung nach APIs, Products und Applications |

Nach den Testaufrufen kann es eine Verzögerung geben, bis Daten in Analytics erscheinen.

Prüfen:

- Anzahl der Aufrufe
- erfolgreiche und fehlerhafte Requests
- Antwortzeiten
- verwendete API
- verwendete Application
- Zeitfilter

## 19. Änderungen erneut deployen

Änderungen an einem bereits deployten API Proxy werden nicht zwangsläufig sofort wirksam.

Nach einer Änderung:

1. Policy oder Endpoint speichern.
2. Konfiguration validieren.
3. neue Revision beziehungsweise aktuellen Stand deployen.
4. Status prüfen.
5. Request erneut ausführen.
6. Ergebnis im Debugger kontrollieren.

Es sollte immer geprüft werden, ob tatsächlich die erwartete Revision aktiv ist.

## 20. Entwicklungsstand exportieren

Nach einer abgeschlossenen Workshopstufe kann der API Proxy erneut exportiert werden.

Empfohlenes Vorgehen:

1. funktionsfähigen Stand testen
2. API Proxy exportieren
3. ZIP-Datei eindeutig benennen
4. Datei in das passende Versionsverzeichnis legen
5. README bei Änderungen aktualisieren
6. prüfen, dass keine Secrets enthalten sind
7. Änderung in Git committen

Beispiel:

```text
api-proxy/v4-traffic-management/SalesOrderAPI.zip
```

Vor dem Einchecken muss geprüft werden, ob der Export umgebungsspezifische oder geheime Werte enthält.

## Vollständiger Testablauf

```text
1. Backend direkt aufrufen
2. Verbindung des API Providers testen
3. API Proxy deployen
4. Proxy ohne API Key aufrufen
5. Proxy mit ungültigem API Key aufrufen
6. Proxy mit gültigem API Key aufrufen
7. Backend-Antwort prüfen
8. Quota überschreiten
9. Spike Arrest testen
10. einzelnen Request debuggen
11. Analyze → Overview prüfen
12. Analyze → Health prüfen
13. Analyze → Usage prüfen
```

## Fehlerdiagnose nach Schichten

| Schicht | Prüfpunkte |
|---|---|
| Postman | Environment, URL, Header, API Key, Payload |
| Application | Product-Zuordnung, gültiger API Key |
| API Product | veröffentlicht, richtige API zugeordnet |
| ProxyEndpoint | Base Path, Flows, Verify API Key, Quota |
| TargetEndpoint | Backend-Pfad, Provider, Authentifizierung |
| API Provider | Host, Port, Protokoll, Zugangsdaten |
| ABAP Environment | Communication Arrangement, Berechtigungen |
| RAP-Service | Veröffentlichung, Pfad, Geschäftslogik |

## Typische Wiederherstellungsprobleme

### Import funktioniert nicht

Mögliche Ursachen:

- ungültige oder beschädigte ZIP-Datei
- nicht unterstütztes Exportformat
- Proxy mit gleichem Namen ist bereits vorhanden
- fehlende Berechtigungen

### Deployment schlägt fehl

Mögliche Ursachen:

- fehlerhafte XML-Konfiguration
- fehlende Referenz
- nicht vorhandener API Provider
- ungültige Policy
- temporäres Laufzeitproblem

### Proxy ist deployt, aber nicht erreichbar

Mögliche Ursachen:

- falscher Hostname
- falscher Base Path
- Deployment noch nicht vollständig aktiv
- falsche Region oder falscher Tenant
- Request verwendet die Backend-URL statt der Proxy-URL

### API Key wird nicht akzeptiert

Mögliche Ursachen:

- Application ist nicht dem Product zugeordnet
- Product ist nicht veröffentlicht
- falscher API Key
- falscher Headername
- falsche Proxy-Version ist deployt

### Backend liefert HTTP 401

Mögliche Ursachen:

- falsche Backend-Zugangsdaten
- Authorization-Header fehlt
- API Provider verwendet das falsche Authentifizierungsverfahren
- Kommunikationsbenutzer ist nicht mehr gültig

### Backend liefert HTTP 404

Mögliche Ursachen:

- falscher OData-Servicepfad
- falsche Serviceversion
- falscher Backend-Host
- TargetEndpoint verändert den Pfad unerwartet

## Sicherheit

Vor einem Commit prüfen:

```text
□ keine Passwörter enthalten
□ keine API Keys enthalten
□ keine Client Secrets enthalten
□ keine Access Tokens enthalten
□ keine privaten Schlüssel enthalten
□ keine vollständigen Service Keys enthalten
□ keine lokalen Postman Environments enthalten
□ keine vertraulichen produktiven URLs enthalten
```

Falls ein Secret versehentlich in Git gespeichert wurde, muss es als kompromittiert betrachtet und ersetzt werden.

## Einschränkungen des Repositorys

Das Repository ist kein vollständiges Backup des API-Management-Tenants.

Es enthält:

- exportierte Entwicklungsstände des API Proxys
- Postman-Artefakte ohne geheime Werte
- Dokumentation zum manuellen Wiederaufbau

Nicht enthalten sind:

- API Provider
- API Product
- Application
- API Keys
- Backend-Passwörter
- tenantabhängige Berechtigungen
- Analytics-Daten
- Laufzeitstatus

## Abschließende Checkliste

```text
□ Backend-Service funktioniert direkt
□ API Provider ist angelegt und getestet
□ gewünschter API Proxy ist importiert
□ ProxyEndpoint ist angepasst
□ TargetEndpoint ist angepasst
□ Policies sind vollständig
□ API Proxy ist deployt
□ API Product ist veröffentlicht
□ Application ist zugeordnet
□ API Key ist lokal hinterlegt
□ erfolgreicher Request wurde ausgeführt
□ fehlerhafte Requests wurden getestet
□ Quota und Spike Arrest wurden geprüft
□ Debugger wurde getestet
□ Analytics-Daten sind sichtbar
□ keine Secrets wurden in Git gespeichert
```
