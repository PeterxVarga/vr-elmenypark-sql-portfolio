#!/usr/bin/env python3
"""Portable, offline SQLite adaptation of the original SQL Server assignment."""
from __future__ import annotations

import csv
from html import escape
from hashlib import sha256
import json
from pathlib import Path
import sqlite3
import sys

BASE = Path(__file__).resolve().parent
SQL = BASE / 'sql' / 'sqlite'
RESULTS = BASE / 'demo_output'


def connect_demo() -> sqlite3.Connection:
    """Create an isolated in-memory schema and only synthetic test data."""
    con = sqlite3.connect(':memory:')
    con.row_factory = sqlite3.Row
    con.execute('PRAGMA foreign_keys = ON')
    con.executescript((SQL / '01_schema.sql').read_text(encoding='utf-8'))
    con.executescript((SQL / '02_synthetic_seed.sql').read_text(encoding='utf-8'))
    return con


def run_queries(con: sqlite3.Connection) -> dict[str, list[dict]]:
    report = {}
    for number in range(1, 19):
        name = f'q{number:02d}'
        args = {'guest_id': 3} if number == 18 else {}
        rows = con.execute((SQL / f'{name}.sql').read_text(encoding='utf-8'), args).fetchall()
        report[name] = [dict(row) for row in rows]
    return report


def _table(records: list[dict], limit: int = 12) -> str:
    if not records:
        return '<p class="muted">Nincs találat.</p>'
    keys = list(records[0])
    head = '<tr>' + ''.join(f'<th>{escape(k.replace("_", " ").capitalize())}</th>' for k in keys) + '</tr>'
    body = ''.join('<tr>' + ''.join(f'<td>{escape(str(row[k]) if row[k] is not None else "—")}</td>' for k in keys) + '</tr>' for row in records[:limit])
    return '<div class="table-wrap"><table><thead>'+head+'</thead><tbody>'+body+'</tbody></table></div>'


def make_html(data: dict[str, list[dict]], table_counts: dict[str, int]) -> str:
    def v(n, key=None):
        r = data[f'q{n:02d}']
        return r[0][key or list(r[0])[0]] if r else 0
    income = sum(int(r['sikeres_befizetes_osszesen']) for r in data['q13'])
    raw_total = sum(int(r['amount_paid']) for r in data['q11'])
    tables = ''.join(f'<section id="q{n:02d}"><div class="eyebrow">Q{n:02d}</div><h2>{escape(TITLES[n])}</h2>{_table(data[f"q{n:02d}"])}</section>' for n in [13,12,6,10,15,4,9,18])
    return f'''<!doctype html><html lang="hu"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>VR Élménypark – offline SQL-esettanulmány</title><style>
:root{{--bg:#f5f6f8;--fg:#172431;--muted:#657484;--line:#dce4ea;--navy:#173d62;--white:#fff}}*{{box-sizing:border-box}}body{{background:var(--bg);color:var(--fg);font-family:Inter,ui-sans-serif,system-ui,-apple-system,'Segoe UI',sans-serif;margin:0;line-height:1.5}}.shell{{max-width:1120px;margin:0 auto;padding:42px 24px 96px}}header{{padding:34px 38px;border-radius:18px;background:var(--navy);color:white}}header h1{{font-size:clamp(27px,4vw,45px);line-height:1.12;margin:10px 0}}header p{{max-width:700px;color:#e0e9f0}}.eyebrow{{font-size:12px;letter-spacing:.14em;text-transform:uppercase;font-weight:750}}.ribbon{{display:inline-block;border:1px solid #bfd0df;padding:4px 10px;border-radius:999px;font-size:12px;color:#dbe8f4}}.metrics{{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:16px;margin:24px 0}}.metric{{background:var(--white);border:1px solid var(--line);padding:20px;border-radius:14px;min-width:0}}.metric strong{{font-size:29px;line-height:1.1;display:block;margin:5px 0;overflow-wrap:anywhere}}.muted,.metric small{{color:var(--muted)}}section{{background:var(--white);border:1px solid var(--line);padding:26px 28px;margin:18px 0;border-radius:14px}}h2{{font-size:21px;letter-spacing:-.02em;margin:6px 0 17px}}.table-wrap{{overflow-x:auto}}table{{border-collapse:collapse;width:100%;font-size:13px}}th{{font-size:11px;letter-spacing:.025em;text-transform:uppercase;background:#f0f4f8;text-align:left;color:#46596b}}td,th{{padding:10px 13px;border-bottom:1px solid var(--line);white-space:nowrap}}tr:last-child td{{border-bottom:0}}.note{{border-left:4px solid #527ea2;background:#edf4fa;padding:16px 18px;margin:20px 0;border-radius:4px}}footer{{margin-top:26px;font-size:13px;color:var(--muted)}}@media(max-width:760px){{.metrics{{grid-template-columns:repeat(2,minmax(0,1fr))}}header{{padding:26px}}section{{padding:20px 16px}}}}@media(max-width:420px){{.metrics{{grid-template-columns:1fr 1fr}}.metric{{padding:13px}}.metric strong{{font-size:23px}}}}
</style></head><body><main class="shell"><header><span class="ribbon">FIKTÍV ADATOK · SQLITE PORTFÓLIÓ DEMÓ</span><div class="eyebrow" style="margin-top:28px;color:#c6dce9">Egyetemi SQL-projekt · 2025–2026</div><h1>VR Élménypark<br>Adatbázis és elemzés</h1><p>Az eredeti Microsoft SQL Server adatbázis beadandó alapján készített hordozható demonstráció. Reprodukálható lekérdezések, relációs modell és üzletileg megkülönböztetett fizetési státuszok.</p></header>
<div class="metrics"><div class="metric"><small>Táblák</small><strong>{len(table_counts)}</strong><small>7 fő + 6 kódtábla</small></div><div class="metric"><small>SQL-feladatok</small><strong>17 + 1</strong><small>paraméterezett eljárásmodell</small></div><div class="metric"><small>Foglalások</small><strong>{sum(1 for _ in data['q09'])}</strong><small>kizárólag fiktív adatok</small></div><div class="metric"><small>Sikeres befizetések</small><strong>{income:,.0f}</strong><small>demó-egység · nem könyvelés</small></div></div>
<div class="note"><strong>Miért fontos a státusz?</strong> Az összes <code>PAYMENTS</code> sor összege {raw_total:,.0f}, de ebből csak {income:,.0f} <em>Completed</em>. A különbség a függő/sikertelen tételekből ered. A beadandó eredeti összegzései nem mindig szűrték ki ezeket.</div>
{tables}<footer>Forrás: 2025-ös Adatbázis-kezelés 1 és 2026-os Adatbázis-kezelés 2 beadandó. Az eredeti SQL Server-dokumentációtól eltérő megvalósítást és korlátait a docs/CHANGES.md részletezi. Ez nem éles foglalási rendszer.</footer></main></body></html>'''

TITLES = {
    4:'Kategóriánkénti átlagár', 6:'Vendégek és foglalásaik',
    9:'Foglalások áttekintése', 10:'Legtöbbet befizető vendég',
    12:'Élmények népszerűsége', 13:'Sikeres befizetések kategóriánként',
    15:'Sikeres befizetések szobánként', 18:'Paraméterezett vendégösszegzés'
}


def main() -> None:
    con = connect_demo()
    try:
        tables = {x['name']: con.execute('SELECT COUNT(*) FROM "'+x['name']+'"').fetchone()[0]
                  for x in con.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name")}
        data = run_queries(con)
    finally:
        con.close()
    assert len(tables) == 13
    assert len(data) == 18
    output = RESULTS
    output.mkdir(exist_ok=True)
    (output/'report.html').write_text(make_html(data,tables),encoding='utf-8')
    (output/'all_queries.json').write_text(json.dumps(data,ensure_ascii=False,indent=2,sort_keys=True)+'\n',encoding='utf-8')
    for key, records in data.items():
        with (output/f'{key}.csv').open('w',encoding='utf-8',newline='') as file:
            fieldnames=list(records[0]) if records else ['no_results']
            writer=csv.DictWriter(file,fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(records)
    paid=int(sum(row['sikeres_befizetes_osszesen'] for row in data['q13']))
    receipts={
        'mode':'SQLITE_OFFLINE_SYNTHETIC_ONLY',
        'sqlserver_native_e2e':'NOT_TESTED',
        'original_project_data':'NOT_IMPORTED',
        'table_count':len(tables),
        'table_rows':tables,
        'queries_executed':len(data),
        'paid_completed_synthetic':paid,
        'synthetic_payment_total_all_statuses':sum(row['amount_paid'] for row in data['q11']),
        'sql_files':{p.name:sha256(p.read_bytes()).hexdigest() for p in sorted(SQL.glob('*.sql'))},
        'report_sha256':sha256((output/'report.html').read_bytes()).hexdigest(),
    }
    (output/'VERIFICATION.json').write_text(json.dumps(receipts,ensure_ascii=False,indent=2,sort_keys=True)+'\n',encoding='utf-8')
    print(json.dumps({'status':'PASS_SQLITE_OFFLINE_SYNTHETIC_ONLY','tables':len(tables),
          'queries':len(data),'completed_payments':paid,'report':str(output/'report.html')},ensure_ascii=False))

if __name__=='__main__':
    main()
