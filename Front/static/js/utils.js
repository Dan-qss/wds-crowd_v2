// static/js/utils.js
export function formatNumber(n) {
  if (n === null || n === undefined || Number.isNaN(n)) return '--';
  return Number(n).toLocaleString();
}

export function clampPct(n) {
  const x = Number(n);
  if (Number.isNaN(x)) return 0;
  return Math.max(0, Math.min(100, x));
}

export async function fetchJson(url, { signal } = {}) {
  const res = await fetch(url, { signal });
  if (!res.ok) throw new Error(`HTTP ${res.status} - ${url}`);
  return res.json();
}

export function hourLabelFromIso(isoString) {
  // isoString like "2026-02-03T10:00:00" from FastAPI datetime serialization
  const d = new Date(isoString);
  const hh = String(d.getHours()).padStart(2, '0');
  return `${hh}:00`;
}
