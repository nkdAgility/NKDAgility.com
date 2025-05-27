# GenerateAndStoreEmbeddings.ps1 - Documentation

This script enables intelligent content comparison and automatic creation of "related content" lists for the NKDAgility.com website.

**High-level overview:**

- The script processes all markdown content on the site, generating vector embeddings (numerical representations) for each piece of content using an AI model.
- These embeddings are stored and synchronized with Azure Blob Storage for scalability and persistence.
- The script then compares the embeddings of all content items to each other using cosine similarity, which measures how similar two pieces of content are.
- For each content item, it builds a list of the most related (similar) items and saves this as a cache file (`data.index.related.json`) alongside the content.
- This enables the website to quickly display relevant "related content" suggestions to users, improving navigation, discovery, and user engagement.

In summary:
**The script automates the process of comparing all site content, finding similarities, and generating fast-access related content lists for use in the website’s UI.**

## Key Features

### 1. Embedding Generation and Synchronization

- **Rebuild-EmbeddingRepository**:
  - Downloads all embedding blobs from Azure Blob Storage to a local cache using `azcopy`.
  - Iterates through all HugoMarkdown content objects, regenerating embeddings for any content that has changed or is missing an embedding.
  - Progress is logged every 10% of completion.
  - Syncs updated embeddings back to Azure Blob Storage.

### 2. Embedding Cache Building

- **Build-AllEmbeddingCache**:

  - For each HugoMarkdown object, calculates the top N (default 50) most similar content items using cosine similarity of embeddings.
  - Stores the related items in a `data.index.related.json` file in the same folder as the markdown file.
  - Progress is logged every 10% of completion.

- **Build-EmbeddingCache**:
  - For a single HugoMarkdown object, calculates and stores its related items as above.

### 3. Related Items Retrieval

- **Get-RelatedItems**:
  - Reads the `data.index.related.json` cache for a given HugoMarkdown object and returns the related items.

### 4. Utility Functions

- **Get-CosineSimilarity**: Calculates cosine similarity between two embedding vectors.
- **Generate-AndStoreEmbedding**: Generates an embedding for a single markdown file and stores it in Azure Blob Storage if the content has changed.
- **Get-RelatedItemsForPost**: (Legacy) Finds related items for a post by comparing embeddings in the blob store.

## Usage

1. **Set up environment variables and authentication for Azure Blob Storage.**
2. **Run the script:**
   - The script will:
     - Download all embeddings from Azure Blob Storage.
     - Regenerate embeddings for changed/new content.
     - Sync updates back to Azure.
     - Build related item caches for all content.
3. **Monitor progress** via log output, which includes percentage complete for both embedding generation and cache building.

## Example Workflow

```powershell
$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\" -YearsBack 10
Rebuild-EmbeddingRepository -HugoMarkdownObjects $hugoMarkdownObjects -ContainerName "content-embeddings" -LocalPath ".data/content-embeddings/"
Build-AllEmbeddingCache -HugoMarkdownObjects $hugoMarkdownObjects -LocalPath ".data/content-embeddings/" -TopN 50
```

## Requirements

- PowerShell 7+
- Az.Storage PowerShell module
- azcopy CLI
- Azure Blob Storage account and SAS token
- OpenAI API access for embedding generation

## Output

- Embedding JSON files for each markdown content in `.data/content-embeddings/` and Azure Blob Storage.
- Related items cache as `data.index.related.json` in each content folder.

## Logging

- Progress and actions are logged to the console, including percentage complete every 10%.

---

This script is intended for use in the NKDAgility.com content pipeline to keep search and recommendation features up to date and performant.
