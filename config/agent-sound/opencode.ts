// Plays agent sounds via config/bin/agent-sound (silent when the tmux pane is focused).
import { Plugin } from '@opencode/plugin';
import { execFile } from 'node:child_process';
import { promisify } from 'node:util';

const exec = promisify(execFile);

export default Plugin.define({
  id: 'agent-sound',
  setup(ctx) {
  const child = new Map<string, boolean>();
  const busy = new Set<string>();
  const play = (sound: string) => exec('agent-sound', [sound]).catch(() => {});

  const controller = new AbortController();
  void (async () => {
    for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
      if (event.location && (event.location.directory !== ctx.location.directory ||
        event.location.workspaceID !== ctx.location.workspaceID)) continue;
      switch (event.type) {
        case 'session.created':
          child.set(event.data.sessionID, Boolean(event.data.parentID));
          break;
        case 'session.status':
          if (event.data.status.type === 'busy') busy.add(event.data.sessionID);
          if (event.data.status.type === 'idle') await done(event.data.sessionID);
          break;
        case 'session.idle':
          await done(event.data.sessionID);
          break;
        case 'permission.asked':
          if (!await isChild(event.data.sessionID)) await play('request');
          break;
        case 'form.created':
          if (!await isChild(event.data.form.sessionID)) await play('request');
          break;
      }
    }
  })().catch((error) => {
    if (!controller.signal.aborted) console.error('[agent-sound]', error);
  });
  return () => controller.abort();

  async function isChild(id: string) {
    if (!child.has(id)) {
      try {
        const session = await ctx.session.get({ sessionID: id });
        child.set(id, Boolean(session.parentID));
      } catch {
        return true;
      }
    }
    return child.get(id);
  }

  // session.status idle and session.idle both fire; only the first after a busy turn rings.
  async function done(id: string) {
    if (!busy.delete(id) || await isChild(id)) return;
    await play('done');
  }
  },
});
