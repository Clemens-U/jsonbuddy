# JSONBuddy Agent Plugin Marketplace

This repository is the first-party marketplace and authoritative source for the `valbuddy-cli` Agent Plugin. GitHub Copilot supports public, vendor-owned GitHub repositories as marketplaces, so a separate repository would add maintenance without improving isolation: the marketplace entry points only to `plugins/valbuddy-cli`.

The marketplace metadata and this guide do not change the license of unrelated repository content. Only the files under `plugins/valbuddy-cli` are covered by that directory's MIT `LICENSE`; the separately installed `valbuddy.exe` remains proprietary.

## 30-second installation

### GitHub Copilot CLI

```powershell
copilot plugin marketplace add Clemens-U/jsonbuddy
copilot plugin marketplace browse jsonbuddy
copilot plugin install valbuddy-cli@jsonbuddy
copilot plugin list
```

Try this prompt after replacing the paths:

```text
Use valbuddy-cli to validate C:\path\data.json against C:\path\schema.json.
```

Update or remove it with:

```powershell
copilot plugin marketplace update jsonbuddy
copilot plugin update valbuddy-cli
copilot plugin uninstall valbuddy-cli
copilot plugin marketplace remove jsonbuddy
```

### Visual Studio Code

1. Enable the `chat.plugins.enabled` setting.
2. Add `"Clemens-U/jsonbuddy"` to the `chat.plugins.marketplaces` array in Settings JSON.
3. Open Extensions, search for `@agentPlugins valbuddy-cli`, select the plugin, and choose **Install**. Accept the marketplace trust prompt after reviewing the source.
4. Confirm it under **Agent Plugins - Installed**, then try the validation prompt above in Chat.
5. To update, run **Extensions: Check for Extension Updates** from the Command Palette. VS Code also checks every 24 hours when `extensions.autoUpdate` is enabled.
6. To remove it, find it under **Agent Plugins - Installed** and choose **Uninstall**.

VS Code also discovers plugins installed by Copilot CLI under `~/.copilot/installed-plugins/`.

### GitHub Copilot app

1. Open **Customize**, choose **Plugins**, select the add-marketplace icon beside the marketplace list, and enter `Clemens-U/jsonbuddy`.
2. Select the JSONBuddy marketplace, find `valbuddy-cli`, choose **Install**, and confirm it in the **Installed** view.
3. Try the validation prompt above.

GitHub's current Copilot app documentation confirms marketplace addition, installation, and the Installed view. It does not document explicit plugin update or uninstall actions, so this guide does not claim those controls.

## Enterprise deployment and security

Identity and source:

- Plugin identifier: `valbuddy-cli@jsonbuddy`.
- Publisher and marketplace owner: Clemens Uhlenhut / JSONBuddy.
- Repository and authoritative plugin source: `https://github.com/Clemens-U/jsonbuddy`, directory `plugins/valbuddy-cli`.
- The marketplace entry uses the immutable-by-convention release tag `valbuddy-cli-v1.0.1`. Published tags must never be moved. A full 40-character commit SHA provides stronger immutability and should be used for a controlled enterprise approval when available.

Recommended managed settings for automatic marketplace and plugin updates:

```json
{
  "enabledPlugins": {
    "valbuddy-cli@jsonbuddy": true
  },
  "extraKnownMarketplaces": {
    "jsonbuddy": {
      "source": {
        "source": "github",
        "repo": "Clemens-U/jsonbuddy"
      },
      "autoUpdate": true
    }
  },
  "strictKnownMarketplaces": [
    {
      "source": "github",
      "repo": "Clemens-U/jsonbuddy"
    }
  ]
}
```

`strictKnownMarketplaces` is an allowlist. Administrators must include every other marketplace they intend to permit; an empty array blocks all marketplaces. Managed `autoUpdate: true` periodically refreshes the marketplace and updates installed plugins. For controlled rollout, pin the marketplace source with `ref` set to an approved full commit SHA and set `autoUpdate` to `false`.

Security review:

- Executable: the plugin contains no binary and does not download one. An administrator or user separately obtains and installs/extracts `valbuddy.exe` from the [official JSONBuddy download](https://www.json-buddy.com/json-editor-download.htm). The wrapper searches an explicit `-ValBuddyPath`, `VALBUDDY_EXE`, `PATH`, and standard JSONBuddy/XML ValidatorBuddy locations under Program Files.
- Authenticity and integrity: the official download page publishes a SHA-256 checksum for the portable ZIP. The current executable is reported there as unsigned, so Authenticode publisher verification is unavailable. Record and approve the checksum for each deployed release; verification of a signed release artifact needs verification.
- Permissions: the plugin contains one skill and no MCP server, hook, custom agent, or background service. It needs permission to read the selected executable, schemas, catalogs, and input documents; create or replace explicitly requested output files; and execute its PowerShell wrappers and `valbuddy.exe`. Its wrappers do not request elevation.
- Child processes: the PowerShell wrappers invoke only the resolved `valbuddy.exe`, forwarding the documented command arguments. Copilot or the hosting shell starts PowerShell when a wrapper is used.
- Network: the wrappers contain no network or download commands. Their opt-in `-Offline` parameter forwards native `-offline`, which allows local reference graphs but rejects remote inputs and dependencies before connection with exit code `12`. Settings-XML batches (including XSLT), configured schema tests, official suite runs, and signature verification are disabled in this mode. Without `-Offline`, validation retains its existing ability to resolve document-controlled HTTP/HTTPS references.
- Offline boundary: the wrappers are not the security boundary; `valbuddy.exe` enforces offline policy in its native loaders and resolvers. Host sandboxing, outbound firewall rules, and isolated runners remain useful defense in depth.
- Data locality: local inputs are passed to the local executable, not uploaded by the plugin. With offline mode absent, documents or referenced schemas may leave the machine if a chosen workflow or document causes a network fetch. The AI client itself may transmit prompt/context according to the organization's Copilot policy and is outside this plugin's behavior.
- Temporary files: documentation output is first written beside the requested output as `<output>.jsonbuddy-<process>-<tick>-<attempt>.tmp`, then atomically replaces the target; failures attempt cleanup. Large streaming/formatting operations may create a GUID-named `.tmp` file in the output/input directory before rename. Broader temporary-file behavior of all executable code paths needs verification.
- Telemetry: no telemetry is implemented by the plugin wrappers. The audited CLI entry point contains no telemetry or update check, and native offline mode blocks the network-capable loaders reachable from CLI operations.
- Licensing: `plugins/valbuddy-cli/LICENSE` applies MIT only to the plugin files in that directory. It explicitly excludes JSONBuddy, XML ValidatorBuddy, `valbuddy.exe`, and other separately distributed appsystems software, which retain their proprietary licenses. No root MIT license is used.
- Free and paid functionality: local JSON, JSON Schema, and XML validation and well-formedness checks are permanently free for commercial and personal use. Optional operations are secondary: settings XML, JSON Patch, JSON Schema linting, pretty-print, JSON Schema tests, and JSON-to-CSV require a paid license after evaluation; `-jsdoc` is free for schemas smaller than 50 KB after evaluation; streaming `-jsv` requires a JSONBuddy Large Data license. Confirm contractual licensing terms against the license presented with the deployed executable.
- Removal and rollback: uninstall the plugin and remove the marketplace using the CLI commands above, or uninstall it from VS Code. Removing the plugin does not remove `valbuddy.exe`; remove that separately through the organization's software process. To roll back, pin `extraKnownMarketplaces` to an approved repository commit and disable automatic updates, or publish a new higher patch release containing the revert. Do not move an existing release tag.

## Solo-vendor release and rollback

1. Make plugin changes and increment `plugins/valbuddy-cli/plugin.json` using semantic versioning.
2. Set the same plugin `version` in `.github/plugin/marketplace.json`; update its `source.ref` to `valbuddy-cli-v<version>`. Increment marketplace `metadata.version` only when the marketplace catalog itself changes in a way worth versioning.
3. Run the validation and isolated installation checks below. Review the diff and commit it.
4. Create the matching tag on that exact commit, for example `git tag -a valbuddy-cli-v1.0.1 -m "ValBuddy CLI Agent Plugin 1.0.1"`. Prefer a signed tag when signing is configured. Push the commit and tag only after review.
5. Confirm the public tag resolves and repeat installation from `Clemens-U/jsonbuddy` in a clean Copilot profile.

Copilot CLI refreshes a self-added marketplace only when user settings or managed enterprise settings enable `autoUpdate`; repository-level `autoUpdate` is ignored. VS Code checks for plugin updates every 24 hours when extension auto-update is enabled, and users can request a check manually.

Before publishing, validate the plugin manifest against the Agent Plugins 1.0 schema, validate `marketplace.json` by adding it to an isolated Copilot CLI profile, lint the skill, parse every PowerShell wrapper, and run one successful and one deliberately failing validation with the intended `valbuddy.exe` release.

For a defective release, revert the defect, bump to a higher patch version, update the marketplace entry and publish a new immutable tag. Enterprise administrators can immediately pin the last approved commit and set `autoUpdate: false`. Do not delete, retarget, or reuse a published version tag because installed clients and audit records may already refer to it.
