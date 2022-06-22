-- 1) Modificarea domeniului email-ului angajatilor din cadrul departamentului executiv din Bucuresti in 'dir.cmp.media.ro'.
update ANGAJATI set EMAIL=REPLACE(EMAIL, 'cmp.media.ro', 'dir.cmp.media.ro')
where UPPER(LOCATIE) = 'BUCURESTI'
and JOB_ID in (select j.JOB_ID from JOBURI j join DEPARTAMENTE d on j.DEPARTAMENT_ID=d.DEPARTAMENT_ID where d.DEPARTAMENT_ID=10);

/
-- 2) Majorarea cu 20% a salariului angajatilor care au lucrat in cadrul evenimentului cu id-ul 1000001.
update ANGAJATI set SALARIU=SALARIU+0.2*SALARIU
where ANGAJAT_ID in (select a.ANGAJAT_ID from ANGAJATI a join FOLOSESTE f on a.ANGAJAT_ID = f.ANGAJAT_ID where f.EVENIMENT_ID=1000001)
or ANGAJAT_ID in (select a.ANGAJAT_ID from ANGAJATI a join PRELUCREAZA_CU p on a.ANGAJAT_ID = p.ANGAJAT_ID where p.EVENIMENT_ID=1000001);

/
-- 3) Stergerea tuturor tipurilor de echipamente pentru care nu exista niciun echipament intregistrat.
delete from TIPURI_DE_ECHIPAMENTE where TIP_ECHIPAMENT_ID not in (select TIP_ECHIPAMENT_ID from ECHIPAMENTE);
