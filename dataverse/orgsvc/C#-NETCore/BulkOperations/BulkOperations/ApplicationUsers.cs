using Azure.Identity;
using Azure.Security.KeyVault.Secrets;

using System;
using System.Threading.Tasks;

namespace Microsoft.Support.Dataverse.Samples.BulkDataImporter
{
    public class ApplicationUsers
    {
        private string _vaultUrl = Environment.GetConfigurationSetting("KeyVaultUrl");
        private SecretClient secretClient;

        public ApplicationUsers()
        {
            this.secretClient = new SecretClient(new System.Uri(_vaultUrl), new DefaultAzureCredential());
        }

        public async Task<ApplicationUser> GetUserAsync(string applicationUserId, string applicationUserKey)
        {
            var applicationUser = await GetSecretValueAsync(applicationUserKey);
            return new ApplicationUser(applicationUserId, applicationUser?.Value);
        }

        /// <summary>
        /// Retrieve Secret
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        private async Task<KeyVaultSecret> GetSecretValueAsync(string key)
        {
            return (await this.secretClient.GetSecretAsync(key)).Value;
        }
    }

    public class ApplicationUser
    {
        public ApplicationUser(string id, string clientSecret)
        {
            this.Id = id;
            this.ClientSecret = clientSecret;
        }

        public string Id { get; }

        public string ClientSecret { get; }
    }
}
