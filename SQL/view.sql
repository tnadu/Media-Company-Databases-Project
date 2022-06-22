-- Crearea unei vizualizari compuse care sa includa cheia, tipul si numele licentelor folosite in cadrul evenimentelor.
-- Se vor afisa si id-ul evenimentului, id-ul, numele, prenumele si email-ul angajatului pentru fiecare licenta in parte.
create view PRELUCRARE
            (CHEIE_LICENTA, TIP_LICENTA, NUME_LICENTA, EVENIMENT, LOCATIE_EVENIMENT, ANGAJAT_ID, NUME_ANGAJAT,
             PRENUME_ANGAJAT, EMAIL_ANGAJAT)
as
select l.CHEIE,
       t.TITLU_TIP_LICENTA,
       l.NUME_PRODUS,
       p.EVENIMENT_ID,
       a.LOCATIE,
       a.ANGAJAT_ID,
       a.NUME,
       a.PRENUME,
       a.EMAIL
from LICENTE l
         join TIPURI_DE_LICENTE t on t.TIP_LICENTA_ID = l.TIP_LICENTA_ID
         join PRELUCREAZA_CU p on l.CHEIE = p.CHEIE
         join ANGAJATI a on p.ANGAJAT_ID = a.ANGAJAT_ID;

-- Intr-o vizualizare creata printr-un join pot fi actualizate, sterse sau inserate valori apartinand
-- numai atributelor care nu sunt in niciun fel legate de mai multe tabele implicate in join.

-- Operatiile LMD sunt permise numai pentru atributul 'EVENIMENT' in cadrul vizualizarii create anterior,
-- pentru este singurul atribut care este asociat in niciun fel mai multor tabele din join, ci doar
-- tabelului 'PRELUCREAZA CU'. Celalte tabele sunt asociate intre ele prin foreign key-uri:
--      - atributele CHEIE_LICENTA, TIP_LICENTA, NUME_LICENTA <--> tabelele LICENTE, TIPURI_DE_LICENTA, PRELUCREAZA_CU
--      - atributele LOCATIE_EVENIMENT (provenit din atributul LOCATIE al tabelului ANGAJAT), ANGAJAT_ID, NUME_ANGAJAT, PRENUME_ANGAJAT, EMAIL_ANGAJAT
--                                              <--> tabelele PRELUCREAZA_CU, ANGAJATI

-- Operatie permisa:
update PRELUCRARE
set EVENIMENT=1000003
where EVENIMENT = 1000005;

-- Operatie interzisa:
update PRELUCRARE
set NUME_ANGAJAT='TEST';

select *
from PRELUCRARE;

-- Tabel generat automat de baza de data, care indica operatiile LMD permise pentru fiecare atribut al fiecarei entitati.
select *
from USER_UPDATABLE_COLUMNS;