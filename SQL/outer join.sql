-- Division 1)
-- Afisarea id-ului si numarului de echipamente folosite pentru evenimentele in realizarea carora au fost
-- utilizate numai echipamente care au intrat cel putin o data in service.
-- (multimea tuturor evenimentelor pentru care au fost folosite echipamente) / (multimea echipamentelor care au intrat cel putin o data in service)
--      - no remainder (nu sunt permise evenimente in cadrul carora au fost folosite evenimente care nu au intrat in service)
select EVENIMENT_ID, COUNT(DISTINCT F.SERIE) ECHIPAMENTE_FOLOSITE
from FOLOSESTE F
         cross join ISTORIC_SERVICE I
where F.SERIE = I.SERIE
group by EVENIMENT_ID
having COUNT(DISTINCT F.SERIE) = (select COUNT(F1.SERIE) from FOLOSESTE F1 where F1.EVENIMENT_ID = F.EVENIMENT_ID);

/
-- Division 2)
-- Afisarea id-ului si numelui angajatilor care au lucrat in cadrul evenimentelor organizate de clientul cu id-ul 2000.
-- Rezultatul va fi ordonat in ordine crescatoare in functie de id.
-- (multimea tuturor angajatilor care au lucrat in cadrul evenimentelor - prelucrare/fotografiere/inregistrare) / (multimea evenimentelor organizate de clientul cu id-ul 2000)
--      - remainder (angajatii nu trebuie sa fi lucrat numai in cadrul acestor evenimente)
select ANGAJAT_ID, NUME
from ANGAJATI
where ANGAJAT_ID in
      (select DISTINCT ANGAJAT_ID
       from (select *
             from ORGANIZEAZA
                      cross join FOLOSESTE
             where FOLOSESTE.EVENIMENT_ID = ORGANIZEAZA.EVENIMENT_ID
             union
             select *
             from ORGANIZEAZA
                      cross join PRELUCREAZA_CU
             where ORGANIZEAZA.EVENIMENT_ID = PRELUCREAZA_CU.EVENIMENT_ID)
       where CLIENT_ID = 2000)
order by ANGAJAT_ID;

/
-- Outer join
-- Afisarea id-ului si numelui angajatilor care nu au prelucrat niciun eveniment, cheii si numelui licentelor care nu au fost
-- folosite in prelucrarea niciunui eveniment si id-ului evenimentelor care nu au fost prelucrate
select a.ANGAJAT_ID, a.NUME, l.CHEIE, l.NUME_PRODUS, e.EVENIMENT_ID
from PRELUCREAZA_CU p
         full outer join ANGAJATI a on p.ANGAJAT_ID = a.ANGAJAT_ID
         full outer join LICENTE L on p.CHEIE = L.CHEIE
         full outer join EVENIMENTE e on p.EVENIMENT_ID = e.EVENIMENT_ID
where p.EVENIMENT_ID is null;