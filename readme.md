# Demo av terraform for studenter på HiØ

Studenter som skriver oppgave sammen med Capgemini


## Kjøre terraform
### Enkelt oppsett
For å kjøre terraform, gå inn i mappen "enkelt_oppsett". 

Verifiser at du er logget inn med riktig bruker og har tilganger. 

```
az account show
az login # Om du ikke logget inn i riktig tenant. 
```

Finn og fyll ut tenant_id og subscription_id i backend.tf, samt azurerm_key_vault. 

Kjør terraform koden med lokal statefil

```
terraform init
terraform plan
terraform apply 
```

Se hvilke ressurser som er opprettet i azure portalen. 


### Deploy en enkel app 
For å deployere en enkel .net applikasjon, bruker vi Zip deploy. Det er allerede zippet en fil `Hello-world.zip`. Kjør kommandoen under for å deploye til appen: 

```
az webapp deploy --resource-group root --name demo-terraform-app --src-path hello-world.zip
```

