using Azure.Core;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Configure Key Vault client
var keyVaultUrl = "https://demoappkeyvault2024.vault.azure.net/"; // E.g., https://<your-keyvault-name>.vault.azure.net/
var secretName = "secret-sauce"; // The name of the secret you want to fetch

// Determine the environment and set the correct credential
TokenCredential credential = Environment.GetEnvironmentVariable("WEBSITE_INSTANCE_ID") != null
    ? new ManagedIdentityCredential() // Use Managed Identity in Azure
    : new AzureCliCredential(); // Use Azure CLI credentials locally

// Create a secret client using the appropriate credential
var client = new SecretClient(new Uri(keyVaultUrl), credential);

// Fetch the secret
KeyVaultSecret secret = await client.GetSecretAsync(secretName);

// Map the endpoint
app.MapGet("/", () => $"Hello World! The secret value is: {secret.Value}");

app.Run();
