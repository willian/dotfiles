// Tells Rex when an opencode turn finishes, with the Program Status Protocol
// (OSC 7501, https://www.superlogical.com/rex/docs/build/program-status).
// opencode reports working and blocked itself but goes straight to idle, so
// Rex never sees done and neither notifies nor plays its sound. A TUI plugin
// because server plugins run in opencode's shared background service, away
// from the pane's terminal.
import type { Context } from '@opencode/plugin/tui';
import { openSync, writeSync } from 'node:fs';

export default {
  id: 'rex-status',
  setup(ctx: Context) {
    if (!process.env.REX_SESSION) return;

    let tty: number;
    try {
      tty = openSync('/dev/tty', 'w');
    } catch {
      return;
    }
    // On the root record, which Rex notifies for. opencode sets it to idle as
    // the turn ends, so wait for that before replacing it.
    const report = (state: string) =>
      setTimeout(() => {
        try {
          writeSync(tty, `\x1b]7501;state=${state}:app=opencode\x1b\\`);
        } catch {}
      }, 250);

    // Root sessions this TUI shows (open or in a tab); subagents run inside
    // their parent's turn.
    const root = (id: string) => ctx.data.session.root(id);
    const top = (id: string) => {
      if (id !== root(id)) return false;
      const route = ctx.ui.router.current();
      return (
        (route.type === 'session' && root(route.sessionID) === id) ||
        ctx.ui.tabs.list().some((t) => t.sessionID === id)
      );
    };

    const off = [
      ctx.data.on('session.execution.succeeded', (e) => top(e.data.sessionID) && report('done')),
      ctx.data.on('session.execution.failed', (e) => top(e.data.sessionID) && report('error')),
    ];
    return () => off.forEach((f) => f());
  },
};
