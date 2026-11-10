import sys
from pathlib import Path
import sqlite3
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from run_demo import connect_demo, run_queries, make_html

class PortfolioProof(unittest.TestCase):
    def setUp(self):
        self.con=connect_demo()
        self.data=run_queries(self.con)
    def tearDown(self):
        self.con.close()

    def test_all_13_entities(self):
        tables={r[0] for r in self.con.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'")}
        self.assertEqual(len(tables), 13)
        self.assertTrue({'GUESTS','BOOKINGS','PAYMENTS','REVIEWS','BOOKING_PARTICIPANTS','EXPERIENCES','ROOMS'} <= tables)

    def test_original_17_query_topics_and_1_procedure_equivalent_execute(self):
        self.assertEqual(set(self.data),{f'q{x:02d}' for x in range(1,19)})
        self.assertEqual(len(self.data['q09']),8)
        self.assertEqual(len(self.data['q11']),9)
        self.assertEqual(len(self.data['q12']),7) # includes experience with zero bookings
        self.assertEqual(len(self.data['q17']),5) # excludes empty room

    def test_query_calculations(self):
        self.assertAlmostEqual(self.data['q01'][0]['atlagos_ar'],6714.29)
        self.assertEqual(self.data['q02'][0]['osszes_jatekido_percben'],390)
        self.assertEqual(self.data['q10'][0]['osszes_sikeres_befizetes'],11500)
        self.assertEqual(self.data['q10'][0]['vendeg_neve'],'Csilla Példa')
        self.assertEqual(self.data['q18'][0]['osszes_sikeres_befizetes'],11500)
        self.assertEqual(len(self.data['q05']),8)  # bookings created in October even if service later

    def test_completed_vs_failed_pending_payments(self):
        success=sum(r['sikeres_befizetes_osszesen'] for r in self.data['q13'])
        raw=sum(r['amount_paid'] for r in self.data['q11'])
        self.assertEqual(success,36000)
        self.assertEqual(raw,54500)
        self.assertEqual(raw-success,18500)
        categories={r['kategoria']:r['sikeres_befizetes_osszesen'] for r in self.data['q13']}
        self.assertEqual(categories,{'Adventure':16500,'Family':3500,'Sci-fi':16000})
        # Failed / pending Horror payment must not appear as completed revenue.
        self.assertNotIn('Horror', categories)

    def test_zero_result_paths(self):
        b={r['vendeg_neve']:r['foglalasok_szama'] for r in self.data['q06']}
        self.assertEqual(b['Fanni NincsFoglalás'],0)
        z={r['experience_name']:r['foglalasok_szama'] for r in self.data['q12']}
        self.assertEqual(z['Orion tréning'],0)
        self.assertEqual(self.con.execute((Path(__file__).resolve().parent.parent/'sql/sqlite/q18.sql').read_text(),{'guest_id':999}).fetchall(),[])

    def test_invalid_foreign_key_rejected(self):
        with self.assertRaises(sqlite3.IntegrityError):
            self.con.execute("INSERT INTO BOOKINGS(booking_id,guest_id,experience_id,room_id,booking_date,start_time,end_time,status) VALUES(99,999,1,1,'2025-10-01','2025-10-05','2025-10-06','A')")

    def test_negative_price_and_invalid_rating_rejected(self):
        with self.assertRaises(sqlite3.IntegrityError):
            self.con.execute("INSERT INTO EXPERIENCES VALUES(91,1,-1,'Negatív teszt','A','M',45,12)")
        with self.assertRaises(sqlite3.IntegrityError):
            self.con.execute("INSERT INTO REVIEWS(review_id,guest_id,experience_id,rating) VALUES(91,1,1,9)")
        with self.assertRaises(sqlite3.IntegrityError):
            self.con.execute("INSERT INTO EXPERIENCES VALUES(92,1,5,'Tiltott Family Hard','F','H',45,12)")

    def test_html_escapes_cell_content(self):
        data={'q'+str(i).zfill(2): [dict(v) for v in self.data[f'q{i:02d}']] for i in range(1,19)}
        data['q12']=[{'experience_name':'<script>alert(1)</script>','kategoria':'Demo','foglalasok_szama':1}]
        s=make_html(data,{'GUESTS':6})
        self.assertNotIn('<script>alert(1)</script>',s)
        self.assertIn('&lt;script&gt;',s)

    def test_consistency_room_mapping_in_fixture(self):
        count=self.con.execute('SELECT COUNT(*) FROM BOOKINGS b JOIN EXPERIENCES e ON e.experience_id=b.experience_id WHERE b.room_id<>e.room_id').fetchone()[0]
        self.assertEqual(count,0)
        # Note: this equality is NOT enforced by the original DDL generally.

if __name__ == '__main__':
    unittest.main()
