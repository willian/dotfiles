import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  function run(command: string, ...args: string[]) {
    return pi.exec(command, args).catch(() => {});
  }

  pi.on("agent_settled", async () => {
    await run("workmux-notify", "done");
  });

  pi.on("ui_prompt_start", async () => {
    await Promise.all([
      run("workmux", "set-window-status", "waiting"),
      run("workmux-notify", "waiting"),
    ]);
  });

  pi.on("ui_prompt_end", async (_event, ctx) => {
    await run("workmux", "set-window-status", ctx.isIdle() ? "clear" : "working");
  });
}
