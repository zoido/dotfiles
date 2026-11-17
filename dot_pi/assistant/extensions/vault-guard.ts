import { realpathSync } from "node:fs";
import { homedir } from "node:os";
import { isAbsolute, resolve, sep } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// Limits the file tools to the Obsidian vault. jai keeps the vault read-only.
// This guard keeps the tools away from the other files in the jail, for
// example the Kagi session link.
const VAULT_DIR = resolve(homedir(), "Obsidian/Default");
const GUARDED_TOOLS = new Set(["read", "grep", "find", "ls"]);

function expandPath(path: string): string {
	const withoutAt = path.startsWith("@") ? path.slice(1) : path;
	const withHome = withoutAt.replace(/^~(?=\/|$)/, homedir());
	return isAbsolute(withHome) ? withHome : resolve(VAULT_DIR, withHome);
}

function isInside(path: string, dir: string): boolean {
	return path === dir || path.startsWith(dir + sep);
}

export default function vaultGuard(pi: ExtensionAPI) {
	pi.on("tool_call", async (event) => {
		if (!GUARDED_TOOLS.has(event.toolName)) {
			return undefined;
		}

		let vault: string;
		try {
			vault = realpathSync(VAULT_DIR);
		} catch {
			return { block: true, reason: `The Obsidian vault ${VAULT_DIR} is not available.` };
		}

		const input = event.input as { path?: string };
		if (!input.path) {
			input.path = vault;
			return undefined;
		}

		let target: string;
		try {
			target = realpathSync(expandPath(input.path));
		} catch {
			return { block: true, reason: `Path not found: ${input.path}. Paths are relative to the vault ${vault}.` };
		}

		if (!isInside(target, vault)) {
			return { block: true, reason: `Only files in the Obsidian vault ${vault} can be read.` };
		}

		input.path = target;
		return undefined;
	});
}
