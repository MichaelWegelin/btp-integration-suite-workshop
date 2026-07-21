# API Provider

Der API Provider stellt in SAP API Management die Verbindung zum Backend-System her.

Im Workshop wird ein der OData-Service GWSAMPLE_BASIC auf einer ABAP Platform 2023 verwendet. Der API Provider enthält die technische Adresse und die Verbindungseinstellungen für dieses System.

## Verwendetes Backend

| Eigenschaft | Wert |
|---|---|
| Backend-System | ABAP Platform 2023 |
| Service | GWSAMPLE_BASIC |
| Service Binding | OData V2 |
| Service-Alias | `SalesOrder` |
| Protokoll | HTTP |
| Port | `50000` |
| Authentifizierung | Basic Authentication |
| Verwendung | Backend des SalesOrder API Proxys |

## Voraussetzungen

Vor dem Anlegen des API Providers müssen folgende Informationen vorliegen:

- Hostname der ABAP PLatform 2023
- Port des Backend-Systems
- Pfad des veröffentlichten OData-Service
- technischer Kommunikationsbenutzer
- Kennwort des Kommunikationsbenutzers
- gültiges Communication Arrangement im ABAP Environment
- erreichbarer und veröffentlichter RAP-Service

Die Backend-Verbindung sollte vor der Konfiguration in API Management beispielsweise mit Postman getestet werden.

## API Provider anlegen

1. SAP Integration Suite öffnen.
2. Den Bereich für API Management aufrufen.
3. Zur Verwaltung der API Provider wechseln.
4. Einen neuen API Provider anlegen.
5. Namen "A4H" und Beschreibung eintragen.
6. Verbindungstyp und Backend-Adresse konfigurieren.
7. Authentifizierung festlegen.
8. Verbindung speichern.
9. Verbindung testen.

## Allgemeine Angaben

Beispielkonfiguration:

| Feld | Beispielwert |
|---|---|
| Name | `ABAPEnvironment` |
| Beschreibung | `ABAP Platfrom für den SalesOrder-Service` |
| Typ | Internet |
| Protokoll | HTTP |
| Host | `<ABAP_HOST>` |
| Port | `50000` |

Der Hostname wird ohne Protokoll und ohne Servicepfad eingetragen.

Beispiel:

```text
abap.eu10.hana.ondemand.com
```

Nicht verwenden:

```text
https://abap.eu10.hana.ondemand.com/sap/opu/odata2/...
```

Der konkrete Servicepfad wird beim API Proxy beziehungsweise bei der Auswahl des Backend-Service berücksichtigt.

## Authentifizierung

Für die Workshopumgebung wird Basic Authentication verwendet.

Dazu werden die Zugangsdaten des im Communication Arrangement verwendeten Kommunikationsbenutzers im API Provider hinterlegt.

Benötigte Angaben:

| Feld | Inhalt |
|---|---|
| Authentifizierungstyp | Basic Authentication |
| Benutzername | `<COMMUNICATION_USER>` |
| Kennwort | `<PASSWORD>` |

Die Bezeichnungen der Felder können je nach Oberfläche geringfügig abweichen.

## Verbindung testen

Nach dem Speichern sollte die Verbindung über die Testfunktion des API Providers geprüft werden.

Ein erfolgreicher Verbindungstest bestätigt:

- der Backend-Host ist erreichbar
- die HTTPS-Verbindung funktioniert
- Benutzername und Kennwort werden akzeptiert
- API Management kann das Backend grundsätzlich aufrufen

Ein erfolgreicher Verbindungstest bestätigt noch nicht zwangsläufig, dass jeder OData-Service erreichbar ist. Der konkrete Servicepfad und die Berechtigungen müssen zusätzlich beim Aufruf des API Proxys geprüft werden.

## OData-Service prüfen

Der verwendete OData-Service sollte direkt gegen das ABAP Environment getestet werden.

Beispiel für den Zugriff auf das Servicedokument:

```http
GET https://<ABAP_HOST>/<ODATA_SERVICE_PATH>/
Authorization: Basic <credentials>
Accept: application/json
```

Beispiel für den Abruf der Metadaten:

```http
GET https://<ABAP_HOST>/<ODATA_SERVICE_PATH>/$metadata
Authorization: Basic <credentials>
Accept: application/xml
```

## Typische Fehler

### Backend ist nicht erreichbar

Mögliche Ursachen:

- falscher Hostname
- falscher Port
- Protokoll nicht auf HTTPS eingestellt
- Backend-System nicht verfügbar
- fehlerhafte Netzwerk- oder Trust-Konfiguration

### HTTP 401 Unauthorized

Mögliche Ursachen:

- falscher Benutzername
- falsches Kennwort
- Kommunikationsbenutzer nicht korrekt zugeordnet
- falsches Authentifizierungsverfahren

### HTTP 403 Forbidden

Mögliche Ursachen:

- Benutzer ist authentifiziert, aber nicht berechtigt
- Communication Arrangement ist unvollständig
- Service ist dem Communication Scenario nicht korrekt zugeordnet

### HTTP 404 Not Found

Mögliche Ursachen:

- falscher Servicepfad
- falsche Serviceversion
- Service Binding nicht veröffentlicht
- Proxy leitet auf einen falschen Backend-Pfad weiter

### Fehler beim Abruf der Metadaten

Mögliche Ursachen:

- falsche OData-URL
- falscher Hostname
- Authentifizierung funktioniert nicht
- Service ist nicht veröffentlicht
- angeforderte OData-Version stimmt nicht mit dem Service überein

## Sicherheitshinweise

Folgende Werte dürfen nicht in das Repository eingecheckt werden:

- Kennwort des Kommunikationsbenutzers
- Authorization-Header
- Access Tokens
- Service Keys
- private Schlüssel
- Client Secrets

Im Repository werden ausschließlich Platzhalter verwendet.

## Abhängige Artefakte

Der API Provider wird beim Anlegen oder Konfigurieren des API Proxys verwendet.

```text
API Provider
      │
      ▼
API Proxy
      │
      ▼
API Product
      │
      ▼
Application
```

Änderungen am API Provider können alle API Proxys betreffen, die diesen Provider verwenden.

## Wiederherstellung

Da der API Provider in der verwendeten Oberfläche nicht als Datei exportiert werden kann, muss er beim Neuaufbau eines Tenants manuell angelegt werden.

Erforderliche Schritte:

1. Backend-Host ermitteln.
2. Communication Arrangement im ABAP Environment prüfen.
3. API Provider anhand dieser Dokumentation anlegen.
4. Zugangsdaten sicher hinterlegen.
5. Verbindung testen.
6. OData-Service über den API Proxy aufrufen.

## Checkliste

```text
□ OData-Service ist veröffentlicht
□ Kommunikationsbenutzer ist vorhanden
□ Backend-Host ist korrekt
□ Protokoll ist HTTPS
□ Port ist 443
□ Authentifizierung ist konfiguriert
□ Verbindungstest ist erfolgreich
□ Zugangsdaten stehen nicht im Repository
```
