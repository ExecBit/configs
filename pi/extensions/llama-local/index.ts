import type { ExtensionAPI, ProviderModelConfig } from "@earendil-works/pi-coding-agent";

const BASE_URL = "http://127.0.0.1:7080/v1";
const PROVIDER_ID = "llama-local";
const MAX_TOKENS = 32768;

interface LlamaCppModel {
  id: string;
  meta?: { n_ctx?: number; n_ctx_train?: number };
}

function mapModels(models: LlamaCppModel[]): ProviderModelConfig[] {
  return models
    .filter((m) => typeof m.id === "string" && m.id.length > 0)
    .map((m) => ({
      id: m.id,
      name: m.id,
      reasoning: false,
      input: ["text"],
      cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
      contextWindow: m.meta?.n_ctx ?? 100000,
      maxTokens: MAX_TOKENS,
    }));
}

async function fetchModels(): Promise<ProviderModelConfig[]> {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 5000);
  try {
    const response = await fetch(`${BASE_URL}/models`, { signal: controller.signal });
    if (!response.ok) throw new Error(`llama.cpp HTTP status: ${response.status}`);
    const data = (await response.json()) as { data?: LlamaCppModel[] };
    return mapModels(data.data ?? []);
  } finally {
    clearTimeout(timeoutId);
  }
}

export default async function (pi: ExtensionAPI) {
  let registered = false;
  let fetchedThisCycle = false;

  async function sync() {
    let models: ProviderModelConfig[];
    try {
      models = await fetchModels();
    } catch {
      if (registered) pi.unregisterProvider(PROVIDER_ID);
      registered = false;
      return;
    }
    if (models.length === 0) {
      if (registered) pi.unregisterProvider(PROVIDER_ID);
      registered = false;
      return;
    }
    pi.registerProvider(PROVIDER_ID, {
      name: "llama.cpp local",
      baseUrl: BASE_URL,
      apiKey: "llama-local",
      api: "openai-completions",
      models,
    });
    registered = true;
  }

  await sync();

  pi.on("agent_start", () => {
    fetchedThisCycle = false;
  });

  pi.on("message_end", async (event) => {
    if (event.message.role === "assistant" && !fetchedThisCycle) {
      fetchedThisCycle = true;
      await sync();
    }
  });
}
