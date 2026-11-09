import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const INTERACTIVE_MODES = new Set(["tui", "rpc"]);

export default function exitCodeExtension(pi: ExtensionAPI) {
	pi.registerTool({
		name: "set_exit_code",
		label: "Set Exit Code",
		description:
			"Set the exit code of the pi process for a non-interactive run (print or JSON mode). The last call wins. Ignored in interactive sessions.",
		promptSnippet: "Set the exit code of the pi process in non-interactive runs",
		promptGuidelines: ["Call set_exit_code only when the user or a prompt template asks for a specific exit code."],
		parameters: Type.Object({
			code: Type.Integer({ minimum: 0, maximum: 255, description: "Exit code, 0 for success" }),
		}),
		defaultActive: false,
		async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
			if (INTERACTIVE_MODES.has(ctx.mode)) {
				return {
					content: [{ type: "text", text: `Ignored: pi runs in ${ctx.mode} mode.` }],
					details: { code: params.code, applied: false },
				};
			}
			process.exitCode = params.code;
			return {
				content: [{ type: "text", text: `Exit code set to ${params.code}.` }],
				details: { code: params.code, applied: true },
			};
		},
	});
}
