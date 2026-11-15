import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function piMemoryConfig(_pi: ExtensionAPI) {
	process.env.PI_MEMORY_EXIT_SUMMARY_MODEL ??= "github-copilot/claude-haiku-5.5";
}
