# Sicherheitskonzept

Die Demo verwendet drei voneinander unabhängige Sicherheitskontexte.

| Verbindung | Identität |
|---|---|
| Entwickler → Integration Suite | persönlicher BTP-Benutzer |
| Postman → Integration Flow | technischer Client der Process Integration Runtime |
| Integration Flow → ABAP-System | ABAP Communication User |

## Zugriff auf die Designoberfläche

Der persönliche Benutzer benötigt Rollen für Entwicklung, Deployment und Monitoring.

Diese Rollen berechtigen nicht automatisch zum Aufruf eines HTTPS-Endpunkts.

## Eingehender Aufruf des Integration Flow

Postman verwendet die Client-ID und das Client-Secret eines Service Key.

Der technische Client benötigt die im HTTPS-Senderadapter konfigurierte Rolle.

## Aufruf des ABAP-Systems

Der OData-Receiver verwendet ein Security Material vom Typ User Credentials.

Die Zugangsdaten gehören zu einem Communication User, der über Communication System und Communication Arrangement für den OData-Service autorisiert ist.

## Geheimnisse

Folgende Informationen dürfen nicht in Git gespeichert werden:

- Passwörter
- Client Secrets
- OAuth-Token
- Service Keys
- private Schlüssel
- produktive Zertifikate
