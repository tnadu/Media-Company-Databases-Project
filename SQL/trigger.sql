-- Autoincrementare

-- Crearea unei secvente de la ultima valoarea a ID-ului pentru care s-a facut insertia in tabel manual care se incrementeaza cu 10 unitati.
-- De fiecare data cand va fi accesata, valoarea stocata in secventa se va incrementa.
create SEQUENCE secventa_angajat start with 280 increment by 10;

-- Creare trigger care, inainte de insertie, acceseaza secventa initializata mai sus si introduce valoarea in campul ID-ului.
create or replace TRIGGER angajat_la_inserare
  BEFORE insert on ANGAJATI
  FOR EACH ROW
BEGIN
  select secventa_angajat.nextval
  INTO :new.ANGAJAT_ID
  FROM dual;
END;

-- Exemplu
insert into ANGAJATI values (1, 'DIR_EXEC', 'Bucuresti', 'Nanu', 'Marian', 'nanu.marian@cmp.media.ro', '0737888921');


/
create SEQUENCE secventa_departamente start with 90 increment by 10;

create or replace TRIGGER departament_la_inserare
  BEFORE insert on DEPARTAMENTE
  FOR EACH ROW
BEGIN
  select secventa_departamente.nextval
  INTO :new.DEPARTAMENT_ID
  FROM dual;
END;

/
create SEQUENCE secventa_tipuri_de_echipamente start with 7;

create or replace TRIGGER tip_de_echipament_la_inserare
  BEFORE insert on TIPURI_DE_ECHIPAMENTE
  FOR EACH ROW
BEGIN
  select secventa_tipuri_de_echipamente.nextval
  INTO :new.TIP_ECHIPAMENT_ID
  FROM dual;
END;

/
create SEQUENCE secventa_clienti start with 7000 increment by 1000;

create or replace TRIGGER client_la_inserare
  BEFORE insert on CLIENTI
  FOR EACH ROW
BEGIN
  select secventa_clienti.nextval
  INTO :new.CLIENT_ID
  FROM dual;
END;

/
create SEQUENCE secventa_evenimente start with 1000006;

create or replace TRIGGER eveniment_la_inserare
  BEFORE insert on EVENIMENTE
  FOR EACH ROW
BEGIN
  select secventa_evenimente.nextval
  INTO :new.EVENIMENT_ID
  FROM dual;
END;

/
create SEQUENCE secventa_tipuri_de_licente start with 5;

create or replace TRIGGER tip_de_licenta_la_inserare
  BEFORE insert on TIPURI_DE_LICENTE
  FOR EACH ROW
BEGIN
  select secventa_tipuri_de_licente.nextval
  INTO :new.TIP_LICENTA_ID
  FROM dual;
END;
