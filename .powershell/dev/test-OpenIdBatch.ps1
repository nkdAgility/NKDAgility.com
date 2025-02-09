
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1



# $hugoMarkdown = Get-HugoMarkdown -Path "site\content\resources\blog\2011\2011-02-04-do-you-know-about-the-visual-studio-alm-rangers-guidance\index.md"
# $cacheFolder = "site\content\resources\blog\2011\2011-02-04-do-you-know-about-the-visual-studio-alm-rangers-guidance\"

# $classification = "tags"
# $catalogHash = Get-CatalogHashtable -Classification $classification
# $class = Get-BatchCategoryConfidenceWithChecksum -ClassificationType "$classification" -Catalog $catalogHash -CacheFolder $cacheFolder -ResourceContent $hugoMarkdown.BodyContent -ResourceTitle $hugoMarkdown.FrontMatter.title


# $class.Count
# $class

# Write-InfoLog "OpenAI.ps1 loaded"