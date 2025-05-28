# EmbeddingRepository.ps1 - Documentation

This script manages the generation and synchronization of vector embeddings for all markdown content on the NKDAgility.com website.

**High-level overview:**

- Processes all markdown content, generating vector embeddings (numerical representations) for each piece of content using an AI model.
- Embeddings are stored and synchronized with Azure Blob Storage for scalability and persistence.
- Automates the process of keeping embeddings up to date for use in content comparison and related content features.

## Key Features

### Embedding Generation and Synchronization

- **Rebuild-EmbeddingRepository**:

  - Downloads all embedding blobs from Azure Blob Storage to a local cache using `azcopy`.
  - Iterates through all HugoMarkdown content objects, regenerating embeddings for any content that has changed or is missing an embedding.
  - Progress is logged every 10% of completion.
  - Syncs updated embeddings back to Azure Blob Storage.

- **Generate-AndStoreEmbedding**: Generates an embedding for a single markdown file and stores it in Azure Blob Storage if the content has changed.

## Usage

1. **Set up environment variables and authentication for Azure Blob Storage.**
2. **Run the script:**
   - The script will:
     - Download all embeddings from Azure Blob Storage.
     - Regenerate embeddings for changed/new content.
     - Sync updates back to Azure.
3. **Monitor progress** via log output, which includes percentage complete for embedding generation.

## Example Workflow

```powershell
$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\" -YearsBack 10
Rebuild-EmbeddingRepository -HugoMarkdownObjects $hugoMarkdownObjects -ContainerName "content-embeddings" -LocalPath ".data/content-embeddings/"
```

## Requirements

- PowerShell 7+
- Az.Storage PowerShell module
- azcopy CLI
- Azure Blob Storage account and SAS token
- OpenAI API access for embedding generation

## Output

- Embedding JSON files for each markdown content in `.data/content-embeddings/` and Azure Blob Storage.

## Logging

- Progress and actions are logged to the console, including percentage complete every 10%.

---

This script is intended for use in the NKDAgility.com content pipeline to keep search and recommendation features up to date and performant.
