# Reading a Figma file

How **Read the design at its source** gets values out of Figma. Tool names here are the official Figma MCP server's. The server ships its own design-to-code skill, so load it before the first call and follow its calling rules. This file covers only what an iOS build needs from the answers.

## From link to node

A Figma URL carries the file key after `/design/` and the node in `node-id`. On a branch URL, `/design/<fileKey>/branch/<branchKey>/`, pass the branch key as the file key. The URL writes the node as `1-2`, and the tools take it as `1:2`. A link with no `node-id` points at no frame in particular, so list the pages with `get_metadata` and confirm which frames ship before reading any of them.

## The calls

| Tool | Gives you | Use it for |
| --- | --- | --- |
| `get_design_context` | Reference code, exact values, bound variables, component instances, asset downloads and a screenshot | Every frame in scope, one call each |
| `get_screenshot` | A render of the node, 1024 pixels on its longer edge unless `maxDimension` asks for more | The comparison target, when the design context returned none or detail is too small to read |
| `get_variable_defs` | The variables the node uses, with their names and values | Mapping design variables onto color sets, text styles and constants |
| `get_metadata` | The layer tree with ids and sizes, and no styling | Large pages, to find which child nodes to read |
| `get_code_connect_map` | The project view each mapped node stands for | Components, with `codeConnectLabel` choosing the SwiftUI mapping where a file maps several platforms |

The design context's reference code is React with Tailwind and raw values, whatever the project uses. Translate it through [mapping.md](mapping.md) and never paste it.

A design context flagged as sparse is a summary, not values. Read the visible children it names, in parallel, and build from those answers.

## What to trust

- **Variable names over raw values.** A fill bound to `Brand/Accent` maps to the project's `brandAccent` color set even where the hex drifted. A raw hex with no variable goes through the mapping table.
- **Code Connect over name matching.** A node with a mapping names the exact view and its parameters. Use that view unless it cannot express the design, and report the case where it cannot.
- **Auto layout over absolute positions.** Gap and padding on an auto layout frame are the spacing intent. The x and y of a free-floating layer are where someone dropped it.
- **Downloaded assets over Figma URLs.** Asset URLs from the server expire. Save each image into the asset catalog, and keep a vector as a vector with Preserve Vector Data turned on. Leave no Figma URL in code.
- **Symbols over exports.** A layer drawn with an SF Symbol is `Image(systemName:)` with that name, never an exported image. A custom symbol becomes a symbol image in the asset catalog.

The screenshot is the target you compare against. It is never an asset in the build.
