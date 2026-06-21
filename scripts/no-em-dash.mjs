#!/usr/bin/env node
// Orive Creative Studio: enforce the strict no em dash house rule.
//
// This is the teeth behind the rule. Prose in a skill does not bind the model
// or a subagent, a hook does. It runs on two events:
//
//   PostToolUse (Write, Edit, MultiEdit): read the file that was just written
//   and auto fix every em dash, so no generated document, from any agent or
//   tool, ever ships with one.
//
//   Stop: if the assistant's last message still contains an em dash, block the
//   turn and tell the model to rewrite it. This catches chat replies, not just
//   files.
//
// No external dependencies. Node is installed by setup and runs on every OS.

import fs from 'node:fs';

// Em dash (U+2014), horizontal bar (U+2015), and their HTML entities.
const EM_SRC = '[\\u2014\\u2015]|&mdash;|&#8212;|&#x2014;|&#x2015;|&#8213;';
const EM_ONE = new RegExp(EM_SRC);
const EM_ALL = new RegExp(EM_SRC, 'g');

function readStdin() {
  try { return fs.readFileSync(0, 'utf8'); } catch { return ''; }
}

// Replace em dashes with house-rule-safe punctuation. The rule is: a comma, a
// full stop, or a reworded sentence. A deterministic pass cannot reword, so it
// picks the safest faithful substitute per context.
function fixText(text) {
  let out = text;
  // A range between digits becomes a hyphen, so a dashed 10 to 20 reads 10-20.
  out = out.replace(new RegExp('(\\d)\\s*(?:' + EM_SRC + ')\\s*(\\d)', 'g'), '$1-$2');
  // A dash that is the whole content of an HTML element (a placeholder cell)
  // becomes a plain hyphen, for example <td>&mdash;</td> to <td>-</td>.
  out = out.replace(new RegExp('>(\\s*)(?:' + EM_SRC + ')(\\s*)<', 'g'), '>$1-$2<');
  // A spaced em dash (the parenthetical use) becomes a comma.
  out = out.replace(new RegExp(' +(?:' + EM_SRC + ') +', 'g'), ', ');
  // Anything left becomes a comma and a space.
  out = out.replace(EM_ALL, ', ');
  // Tidy a space that now sits just before a comma.
  out = out.replace(/ +,/g, ',');
  return out;
}

// Extensions we never rewrite, to avoid corrupting a binary or a real document.
const SKIP_EXT = new Set([
  '.pdf', '.png', '.jpg', '.jpeg', '.gif', '.webp', '.ico', '.svgz',
  '.zip', '.gz', '.tar', '.woff', '.woff2', '.ttf', '.otf', '.eot',
  '.mp4', '.mp3', '.mov', '.wav', '.bin', '.exe', '.docx', '.pptx', '.xlsx'
]);

function ext(p) {
  const i = p.lastIndexOf('.');
  return i < 0 ? '' : p.slice(i).toLowerCase();
}

function lastAssistantText(transcriptPath) {
  if (!transcriptPath || !fs.existsSync(transcriptPath)) return '';
  let lines;
  try { lines = fs.readFileSync(transcriptPath, 'utf8').split(/\r?\n/).filter(Boolean); }
  catch { return ''; }
  for (let i = lines.length - 1; i >= 0; i--) {
    let obj;
    try { obj = JSON.parse(lines[i]); } catch { continue; }
    const msg = obj.message || obj;
    const role = msg.role || obj.type;
    if (role !== 'assistant') continue;
    const c = msg.content;
    if (Array.isArray(c)) return c.filter(x => x && x.type === 'text').map(x => x.text).join('\n');
    if (typeof c === 'string') return c;
    return '';
  }
  return '';
}

function main() {
  let input = {};
  try { input = JSON.parse(readStdin() || '{}'); } catch { input = {}; }
  const event = input.hook_event_name || '';

  if (event === 'Stop' || event === 'SubagentStop') {
    const text = lastAssistantText(input.transcript_path);
    if (EM_ONE.test(text)) {
      console.log(JSON.stringify({
        decision: 'block',
        reason: 'Your last message contains an em dash, which breaks the studio strict no em dash rule. Rewrite the message and replace every em dash with a comma, a full stop, or a reworded sentence, then finish. Do not use em dashes anywhere.'
      }));
    }
    process.exit(0);
  }

  if (event === 'PostToolUse') {
    const fp = input.tool_input && input.tool_input.file_path;
    if (!fp || SKIP_EXT.has(ext(fp)) || !fs.existsSync(fp)) process.exit(0);
    let text;
    try { text = fs.readFileSync(fp, 'utf8'); } catch { process.exit(0); }
    if (!EM_ONE.test(text)) process.exit(0);
    const count = (text.match(EM_ALL) || []).length;
    try { fs.writeFileSync(fp, fixText(text)); } catch { process.exit(0); }
    console.log(JSON.stringify({
      systemMessage: 'Orive: removed ' + count + ' em dash' + (count === 1 ? '' : 'es') +
        ' from ' + fp + ' per the no em dash house rule. Check the replacements read naturally.'
    }));
    process.exit(0);
  }

  process.exit(0);
}

main();
