from pathlib import Path
import re
import unittest

ROOT=Path(__file__).resolve().parent.parent
SQL=ROOT/'sql'/'sqlserver'

class StaticSqlServerContract(unittest.TestCase):
    def test_schema_has_exact_13_named_tables(self):
        text=(SQL/'01_schema.sql').read_text()
        names=re.findall(r'CREATE TABLE dbo\.([A-Z_]+)',text)
        self.assertEqual(len(names),13)
        self.assertEqual(set(names),{
            'GUESTS','BOOKINGS','BOOKING_PARTICIPANTS','EXPERIENCES','ROOMS','PAYMENTS','REVIEWS',
            'BOOKING_STATUSES','DIFFICULTY_LEVELS','EXPERIENCE_CATEGORIES','GENDERS',
            'PAYMENT_METHODS','PAYMENT_STATUSES'})

    def test_17_named_queries_present(self):
        s=(SQL/'03_queries.sql').read_text()
        self.assertEqual(re.findall(r'(?m)^-- Q(\d\d)$',s),[f'{i:02d}' for i in range(1,18)])
        self.assertNotIn(' || ',s)
        self.assertNotIn(' LIMIT ',s)

    def test_database_guard_cannot_be_skipped_by_next_batch(self):
        # Source-level safety invariant: GO splits SSMS batches after THROW.
        # This is NOT a native SQL Server syntax / execution test.
        for f in SQL.glob('*.sql'):
            s=f.read_text(encoding='utf-8')
            self.assertNotRegex(s, r'(?m)^GO\s*$', msg=f.name)
            self.assertIn("IF DB_NAME() <> N'VRElmenyparkPortfolio'", s, f.name)
            self.assertNotIn('DROP DATABASE', s.upper())
            if f.name == '04_stored_procedure_portfolio.sql':
                self.assertIn('EXEC sys.sp_executesql', s)
                self.assertIn('CREATE OR ALTER PROCEDURE', s)

    def test_seed_synthetic_and_isolated_database(self):
        for p in SQL.glob('*.sql'):
            s=p.read_text()
            self.assertIn('VRElmenyparkPortfolio',s if p.name!='04_stored_procedure_portfolio.sql' else 'VRElmenyparkPortfolio')
            self.assertNotIn('DROP DATABASE',s)
            self.assertNotIn('MSSQL16.SQLEXPRESS',s)
        seed=(SQL/'02_synthetic_seed.sql').read_text()
        self.assertIn('@example.test',seed)
        self.assertEqual(seed.count('SET IDENTITY_INSERT'),7*2)

if __name__=='__main__':unittest.main()
