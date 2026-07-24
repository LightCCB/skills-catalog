#!/usr/bin/env python3
"""Strip Claude Code session .jsonl transcripts down to analyzable text.

Keeps: user-authored turns, assistant text, error strings.
Drops: tool results, base64/images, thinking blocks, system noise.
Cuts 90-95% of raw size so analysis passes actually fit in context.

Every kept line is prefixed «<session-id>:L<jsonl-line>» so downstream claims
stay citable to the exact source line. User turns are tagged [USER] (the only
evidence class admissible for correction/behavior memories — injection rule),
assistant text [ASST], errors [ERR].

Usage:
  python3 strip_transcript.py session1.jsonl [session2.jsonl ...] [--out-dir DIR]
Prints per-file: stripped path, kept lines, approx tokens. Final line: total tokens.
"""
import json, sys, os, re

def txt_of(content):
    """Flatten a message content field to text, skipping non-text blocks."""
    if isinstance(content, str):
        return content
    out = []
    if isinstance(content, list):
        for blk in content:
            if not isinstance(blk, dict):
                continue
            t = blk.get("type")
            if t == "text":
                out.append(blk.get("text", ""))
            # tool_use inputs/results, images, thinking: dropped
    return "\n".join(x for x in out if x)

ERR_RX = re.compile(r"error|failed|exception|traceback|denied|refus", re.I)

def strip_file(path, out_dir):
    sid = os.path.basename(path).split(".")[0][:8]
    kept, n = [], 0
    with open(path, errors="replace") as f:
        for i, line in enumerate(f, 1):
            try:
                d = json.loads(line)
            except Exception:
                continue
            typ = d.get("type")
            msg = d.get("message") or {}
            role = msg.get("role")
            if typ == "user" and role == "user":
                # keep only human-authored text; tool_result blocks inside user
                # turns are machine content -> only salvage short error strings
                c = msg.get("content")
                human = txt_of(c)
                if human.strip():
                    kept.append(f"«{sid}:L{i}» [USER] {human.strip()[:2000]}")
                elif isinstance(c, list):
                    for blk in c:
                        if isinstance(blk, dict) and blk.get("type") == "tool_result":
                            s = txt_of(blk.get("content"))
                            for m in ERR_RX.finditer(s or ""):
                                snippet = s[max(0, m.start()-80):m.start()+160].strip()
                                kept.append(f"«{sid}:L{i}» [ERR/tool-sourced] {snippet[:240]}")
                                break  # one error snippet per tool_result
            elif typ == "assistant" and role == "assistant":
                s = txt_of(msg.get("content"))
                if s.strip():
                    kept.append(f"«{sid}:L{i}» [ASST] {s.strip()[:1500]}")
            n = i
    body = "\n".join(kept)
    out = os.path.join(out_dir, f"stripped-{sid}.txt")
    with open(out, "w") as f:
        f.write(body)
    toks = len(body) // 4  # chars/4 approximation
    print(f"{out}  kept={len(kept)}/{n} lines  ~{toks} tok")
    return toks

def main():
    args = [a for a in sys.argv[1:]]
    out_dir = "."
    if "--out-dir" in args:
        j = args.index("--out-dir")
        out_dir = args[j + 1]
        del args[j:j + 2]
    os.makedirs(out_dir, exist_ok=True)
    total = 0
    for p in args:
        try:
            total += strip_file(p, out_dir)
        except Exception as e:
            print(f"SKIP {p}: {e}", file=sys.stderr)
    print(f"TOTAL ~{total} tok")

if __name__ == "__main__":
    main()
