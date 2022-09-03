/* Table hmlg.klijent */
DROP TABLE IF EXISTS hmlg.klijent CASCADE;
-- Table hmlg.klijent
CREATE TABLE hmlg.klijent
(
  kl_id integer NOT NULL,
  kl_naziv character varying(100) NOT NULL,
  kl_adresa character varying(100),
  kl_telefon character varying(20),
  kl_firma character(1) DEFAULT 'N' CHECK (kl_firma IN ('D', 'N'))
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.klijent
COMMENT ON TABLE hmlg.klijent IS 'Klijenti (podnosioci zahteva)';
COMMENT ON COLUMN hmlg.klijent.kl_id IS 'ID klijenta';
COMMENT ON COLUMN hmlg.klijent.kl_naziv IS 'Naziv klijenta';
COMMENT ON COLUMN hmlg.klijent.kl_adresa IS 'Adresa klijenta';
COMMENT ON COLUMN hmlg.klijent.kl_telefon IS 'Telefon kontakta';
COMMENT ON COLUMN hmlg.klijent.kl_firma IS 'Klijent je pravno lice?';

-- Primary key on table hmlg.klijent
ALTER TABLE hmlg.klijent ADD CONSTRAINT kl_pk PRIMARY KEY (kl_id);

COMMIT;
