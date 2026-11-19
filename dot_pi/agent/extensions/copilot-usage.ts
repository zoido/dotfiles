import { readFile } from "node:fs/promises";
import { join } from "node:path";
import { type ExtensionAPI, type ExtensionContext, getAgentDir } from "@earendil-works/pi-coding-agent";

const PROVIDER = "github-copilot";
const STATUS_KEY = "copilot-usage";
const USAGE_URL = "https://api.github.com/copilot_internal/user";
const REFRESH_MS = 5 * 60 * 1000;
const TIMEOUT_MS = 10 * 1000;
const BLOCKS = "▁▂▃▄▅▆▇█";

interface Usage {
	used: number;
	total: number;
}

async function readGitHubToken(): Promise<string | undefined> {
	const auth = JSON.parse(await readFile(join(getAgentDir(), "auth.json"), "utf8"));
	return auth[PROVIDER]?.refresh;
}

async function fetchUsage(): Promise<Usage | undefined> {
	const token = await readGitHubToken();
	if (!token) return undefined;
	const response = await fetch(USAGE_URL, {
		headers: { Authorization: `token ${token}`, Accept: "application/json" },
		signal: AbortSignal.timeout(TIMEOUT_MS),
	});
	if (!response.ok) return undefined;
	const premium = (await response.json()).quota_snapshots?.premium_interactions;
	if (!premium || premium.unlimited || !premium.entitlement) return undefined;
	return { used: premium.entitlement - premium.remaining, total: premium.entitlement };
}

function thousands(value: number): string {
	return `${(value / 1000).toFixed(1).replace(/\.0$/, "")}k`;
}

function format(usage: Usage): string {
	const ratio = Math.min(Math.max(usage.used / usage.total, 0), 1);
	const block = BLOCKS[Math.min(BLOCKS.length - 1, Math.floor(ratio * BLOCKS.length))];
	return `copilot ${block} ${thousands(usage.used)}/${thousands(usage.total)}`;
}

export default function copilotUsageExtension(pi: ExtensionAPI) {
	let usage: Usage | undefined;
	let fetchedAt = 0;

	function render(ctx: ExtensionContext) {
		const text = ctx.model?.provider === PROVIDER && usage ? ctx.ui.theme.fg("dim", format(usage)) : undefined;
		ctx.ui.setStatus(STATUS_KEY, text);
	}

	async function refresh(ctx: ExtensionContext) {
		if (!ctx.hasUI || ctx.model?.provider !== PROVIDER) return render(ctx);
		if (Date.now() - fetchedAt >= REFRESH_MS) {
			fetchedAt = Date.now();
			usage = (await fetchUsage().catch(() => undefined)) ?? usage;
		}
		render(ctx);
	}

	pi.on("session_start", async (_event, ctx) => refresh(ctx));
	pi.on("model_select", async (_event, ctx) => refresh(ctx));
	pi.on("agent_settled", async (_event, ctx) => refresh(ctx));
}
