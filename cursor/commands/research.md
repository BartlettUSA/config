# /research — Deep research on a topic using available MCP tools

You are running the /research workflow.

## Inputs
Use the user's message as the research TOPIC.

## MCP Integration
- **Context7**: Library/framework documentation lookup
- **Perplexity**: Web search for current information
- **GitHub MCP**: Search repos, issues, discussions
- **Hugging Face**: ML model and dataset discovery

## Hard constraints
- Prefer sources from the last 3 months when possible
- Cite sources with URLs
- Distinguish between official docs vs community content

## Process
1. Parse the research topic
2. Query relevant MCP tools based on topic type:
   - Library/API → use context7
   - Current events/trends → Perplexity
   - Code examples → GitHub search
   - ML/AI topics → Hugging Face
3. Synthesize findings
4. Provide actionable recommendations

## Output format
```
### Summary (2-4 sentences)
### Key findings (with sources)
### Recommendations
### Further reading
```
