# Gordon MCP Profiles - MOVED

> ⚠️ **This folder is deprecated.** The canonical location is now:
>
> **[P:\dev\repos\Dockers\gordon-mcp-profiles](../../Dockers/gordon-mcp-profiles/)**

## Architecture Note

**Gordon's config is separate from the Docker MCP Gateway.**

- Gateway: 35 servers for all AI platforms (`~/.docker/mcp/registry.yaml`)
- Gordon: Limited to 4 servers (50 tool max)
- Secrets: Managed via [Infisical](https://app.infisical.com)

## Quick Reference

Gordon has **native Docker tools** (~20). Only add essential MCP servers:

```powershell
# Optimal configuration (~27 tools total)
docker mcp server enable context7           # Library docs
docker mcp server enable perplexity-ask     # Deep research
docker mcp server enable duckduckgo         # Free web search
docker mcp server enable sequentialthinking # Problem breakdown

# Verify
docker mcp server ls
```

See [Dockers/gordon-mcp-profiles/README.md](../../Dockers/gordon-mcp-profiles/README.md) for full documentation.
