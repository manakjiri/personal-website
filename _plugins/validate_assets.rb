Jekyll::Hooks.register :site, :post_write do |site|
    asset_references = []

    # Collect asset references from all HTML files
    site.posts.docs.each do |page|
        next unless page.extname == ".html" or page.extname == ".md"
        asset_references += page.content.scan(/assets\/([^"]+)/).flatten
    end

    # Check if each asset reference exists in the assets directory
    missing_assets = asset_references.reject do |asset|
        File.exist?(File.join(site.source, "assets", asset.strip))
    end

    # Save missing assets
    if missing_assets.any?
        missing_assets_file = File.join(site.dest, "missing_assets.txt")
        File.write(missing_assets_file, missing_assets.join("\n"))
    end
end