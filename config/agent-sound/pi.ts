// Plays the "done" sound when the agent settles (see config/bin/agent-sound).
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("agent_settled", async () => {
    await pi.exec("agent-sound", ["done"]);
  });
}
