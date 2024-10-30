using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace nkdAgility.Website
{
    public class GitHubAuthFunctions
    {
        private readonly ILogger<GitHubAuthFunctions> _logger;

        public GitHubAuthFunctions(ILogger<GitHubAuthFunctions> logger)
        {
            _logger = logger;
        }

        [Function("GitHubAuthFunctions")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");
            return new OkObjectResult("Welcome to Azure Functions!");
        }
    }
}
