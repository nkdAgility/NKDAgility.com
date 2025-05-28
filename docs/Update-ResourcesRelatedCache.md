# Update-ResourcesRelatedCache.ps1 - Documentation

This script builds and updates the related content cache for the NKDAgility.com website, enabling fast and intelligent related content suggestions.

**High-level overview:**

- Compares embeddings of all content items using cosine similarity to determine how similar two pieces of content are.
- For each content item, builds a list of the most related (similar) items and saves this as a cache file (`data.index.related.json`) alongside the content.
- Enables the website to quickly display relevant "related content" suggestions to users, improving navigation, discovery, and user engagement.

## Key Features

### Embedding Cache Building

- **Build-AllEmbeddingCache**:

  - For each HugoMarkdown object, calculates the top N (default 50) most similar content items using cosine similarity of embeddings.
  - Stores the related items in a `data.index.related.json` file in the same folder as the markdown file.
  - Progress is logged every 10% of completion.

- **Build-EmbeddingCache**:
  - For a single HugoMarkdown object, calculates and stores its related items as above.

### Related Items Retrieval

- **Get-RelatedItems**:
  - Reads the `data.index.related.json` cache for a given HugoMarkdown object and returns the related items.

### Utility Functions

- **Get-CosineSimilarity**: Calculates cosine similarity between two embedding vectors.
- **Get-RelatedItemsForPost**: (Legacy) Finds related items for a post by comparing embeddings in the blob store.

## Usage

1. **Ensure embeddings are up to date and available locally.**
2. **Run the script:**
   - The script will:
     - Build related item caches for all content.
3. **Monitor progress** via log output, which includes percentage complete for cache building.

## Example Workflow

```powershell
$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\" -YearsBack 10
Build-AllEmbeddingCache -HugoMarkdownObjects $hugoMarkdownObjects -LocalPath ".data/content-embeddings/" -TopN 50
```

## Requirements

- PowerShell 7+
- Embedding JSON files for each markdown content in `.data/content-embeddings/`

## Output

- Related items cache as `data.index.related.json` in each content folder.

## Logging

- Progress and actions are logged to the console, including percentage complete every 10%.

---

This script is intended for use in the NKDAgility.com content pipeline to keep search and recommendation features up to date and performant.
