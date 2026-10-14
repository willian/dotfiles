// Plays agent sounds via config/bin/agent-sound (silent when the tmux pane is focused).
import type { Plugin } from '@opencode-ai/plugin';

export const AgentSoundPlugin: Plugin = async ({ $ }) => {
  const child = new Map<string, boolean>();
  const busy = new Set<string>();
  const play = (sound: string) => $`agent-sound ${sound}`.quiet().nothrow();

  return {
    event: async ({ event }) => {
      switch (event.type) {
        case 'session.created':
          child.set(event.properties.info.id, Boolean(event.properties.info.parentID));
          break;
        case 'session.status':
          if (event.properties.status.type === 'busy') busy.add(event.properties.sessionID);
          if (event.properties.status.type === 'idle') await done(event.properties.sessionID);
          break;
        case 'session.idle':
          await done(event.properties.sessionID);
          break;
        case 'permission.asked':
        case 'question.asked':
          if (!child.get(event.properties.sessionID)) await play('request');
          break;
      }
    },
  };

  // session.status idle and session.idle both fire; only the first after a busy turn rings.
  async function done(id: string) {
    if (!busy.delete(id) || child.get(id)) return;
    await play('done');
  }
};
