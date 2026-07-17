// Community up/down votes backed by Vercel KV (Upstash-compatible REST).
// No npm deps — uses raw REST + global fetch so the static/no-build project still works.
// Env (auto-injected when you create a Vercel KV store and link it to the project):
//   KV_REST_API_URL, KV_REST_API_TOKEN

const URL = process.env.KV_REST_API_URL;
const TOK = process.env.KV_REST_API_TOKEN;
const ID_RE = /^[a-z0-9][a-z0-9-]{1,48}$/;

async function kv(path) {
  const r = await fetch(URL + "/" + path, { headers: { Authorization: "Bearer " + TOK } });
  if (!r.ok) throw new Error("kv " + r.status);
  return (await r.json()).result;
}
function toObj(arr) {
  const o = {};
  if (Array.isArray(arr)) for (let i = 0; i < arr.length; i += 2) o[arr[i]] = Number(arr[i + 1]) || 0;
  return o;
}
function ipHash(ip, id) {
  let h = 5381;
  const s = ip + ":" + id;
  for (let i = 0; i < s.length; i++) h = ((h << 5) + h + s.charCodeAt(i)) | 0;
  return "rl:" + (h >>> 0).toString(36);
}

export default async function handler(req, res) {
  res.setHeader("Cache-Control", "no-store");
  if (!URL || !TOK) {
    res.status(200).json({ ok: false, reason: "kv-not-configured", up: {}, down: {} });
    return;
  }
  try {
    if (req.method === "GET") {
      const [up, down] = await Promise.all([kv("hgetall/votes:up"), kv("hgetall/votes:down")]);
      res.status(200).json({ ok: true, up: toObj(up), down: toObj(down) });
      return;
    }
    if (req.method === "POST") {
      let body = req.body;
      if (typeof body === "string") { try { body = JSON.parse(body); } catch { body = {}; } }
      const id = (body && body.id || "").toString();
      const dir = (body && body.dir) === "down" ? "down" : "up";
      if (!ID_RE.test(id)) { res.status(400).json({ ok: false, reason: "bad-id" }); return; }
      const ip = ((req.headers["x-forwarded-for"] || "").split(",")[0] || "0").trim();
      // one vote per (ip, skill) per 24h
      const set = await kv("set/" + ipHash(ip, id) + "/1/nx/ex/86400");
      if (set === null) { res.status(429).json({ ok: false, reason: "already-voted" }); return; }
      const n = await kv("hincrby/votes:" + dir + "/" + id + "/1");
      res.status(200).json({ ok: true, dir, count: Number(n) || 0 });
      return;
    }
    res.status(405).json({ ok: false, reason: "method" });
  } catch (e) {
    res.status(200).json({ ok: false, reason: "kv-error", up: {}, down: {} });
  }
}
