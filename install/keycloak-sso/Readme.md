Quick notes setting up keycloak for use with this demo:

Admin un/pw:

admin/admin

Create a realm: coolstore
Create a client id: coolstore-web-ui
Create a role: user
Create a user: appuser/coolstore
Add "*" for redirect URLs and web origins for the coolstore-web-ui client-id

For the web-nodejs deployment, you'll need ot update the SSO_URL. by default we're exposing keycloak via NodePort, but should look to change that.

See the configure dir for scripts to automate setting up the keycloak stuff; 
Make sure the at least first create a realm (this is a manual step)