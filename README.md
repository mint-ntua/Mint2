# Usage
- Build the dockerfile
- Run with
```
docker run -dt \
    -p 8080:8080 \
    -e "CATALINA_OPTS=-DPOSTGRES_HOST=<DATABASEHOST> -DPOSTGRES_PORT=<DATABASEPORT> -DPOSTGRES_DATABASE=<DATABASE> -DPOSTGRES_USERNAME=<DATABASEUSERNAME> -DPOSTGRES_PASSWORD=<DATABASEPASSWORD>" \
    <IMAGENAME>
```
## Updating the XSD
To update the XSD, update the schema located in schemas/VIAA. Once updated, the docker image must be rebuilt with the above command and pushed again to OS to deploy the new version

After the new image was deployed, MINT must register this new XSD. You can do this by logging in with a user with enough rights and clicking on 'Manage XSDs' -> 'Setup new schema' -> filling in a name and choosing the XSD that you updated in the previous step.

*Note:* All mappings are tied to an XSD. If a new XSD is added, any mappings are still tied to the older version of the XSD and migrating a mapping to a new version is not possible, thus the mapping must be made again from scratch.
