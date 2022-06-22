-- 1) Afisarea numelui job-ului, id-ului, numelui si salariul in ordine
-- descrescatoare, in functie de salariu, a angajatilor care lucreaza in departamentul de fotografie,
-- care au lucrat in cadrul evenimentului cu id-ul 10000.
select j.TITLU_JOB, a.ANGAJAT_ID, a.NUME, a.SALARIU
from ANGAJATI a
         join (JOBURI j join DEPARTAMENTE d on j.DEPARTAMENT_ID = d.DEPARTAMENT_ID) on a.JOB_ID = j.JOB_ID
         join FOLOSESTE f on a.ANGAJAT_ID = f.ANGAJAT_ID
where d.TITLU_DEPARTAMENT = 'Fotografie'
  and f.EVENIMENT_ID = 1000000
order by a.SALARIU desc;

/
-- 2) Afisarea cheii, numelui si frecventei de aparitie a licentei care a fost
-- folosita cel mai des in ultima luna.
select l.CHEIE,
       l.NUME_PRODUS,
       (select count(p1.CHEIE)
        from PRELUCREAZA_CU p1
                 join EVENIMENTE e1 on p1.EVENIMENT_ID = e1.EVENIMENT_ID
        where e1.DATA_INCEPUT >= add_months(SYSDATE, -1)
          and e1.DATA_FINAL <= SYSDATE
          and p1.CHEIE = l.CHEIE) FRECVENTA
from LICENTE l
where (select max(count(p.CHEIE))
       from PRELUCREAZA_CU p
                join EVENIMENTE e on p.EVENIMENT_ID = e.EVENIMENT_ID
       where e.DATA_INCEPUT >= add_months(SYSDATE, -1)
         and e.DATA_FINAL <= SYSDATE
       group by p.CHEIE) = (select count(p1.CHEIE)
                            from PRELUCREAZA_CU p1
                                     join EVENIMENTE e1 on p1.EVENIMENT_ID = e1.EVENIMENT_ID
                            where e1.DATA_INCEPUT >= add_months(SYSDATE, -1)
                              and e1.DATA_FINAL <= SYSDATE
                              and p1.CHEIE = l.CHEIE);


/
-- 3) Afisarea seriei, numelui si tipupului echipamentelor ale caror intrari in service
-- au fost solutionate intr-un interval de cel putin 2 luni. Pentru fiecare dintre acestea
-- se vor insera calificative intr-o noua coloana numita 'GRAD DE UZURA', in functie de frecventa intrarilor in service.
-- Astfel, echipamentele cu o singura intrare in service de tipul mentionat anterior vor avea calificativul 'INCERT',
-- cele cu 2 intrari vor primi calificativul 'GRAV', iar cele cu peste 2 incidente calificativul
-- 'SEVER'.

with SERVICE as
         (select SERIE as ID, COUNT(*) as FRECVENTA
          from ISTORIC_SERVICE
          where MONTHS_BETWEEN(DATA_SOLUTIONARE, DATA_INTRARE) >= 2
          group by SERIE)
select e.SERIE,
       e.NUME_PRODUS,
       t.TITLU_TIP_ECHIPAMENT,
       NVL(DECODE(s.FRECVENTA, 1, 'INCERT', 2, 'GRAV'), 'SEVER') GRAD_DE_UZURA
from SERVICE s,
     ECHIPAMENTE e
         join TIPURI_DE_ECHIPAMENTE t on e.TIP_ECHIPAMENT_ID = t.TIP_ECHIPAMENT_ID
where e.SERIE = s.ID;

/
-- 4) Afisarea sediului, titlului departamentului, tilului jobului, numelui, prenumelui, email-ului si salariului angajatilor cu salariul
-- maxim din departamentele FOTO si VIDEO pentru fiecare sediu in parte. Email-urile vor fi afisate cu domeniul schimbat in '@media.org'.
select a.LOCATIE                                     SEDIU,
       d.TITLU_DEPARTAMENT,
       j.TITLU_JOB,
       a.NUME,
       a.PRENUME,
       REPLACE(a.EMAIL, 'cmp.media.ro', 'media.org') EMAIL,
       a.SALARIU
from ANGAJATI a
         join JOBURI j on a.JOB_ID = j.JOB_ID
         join DEPARTAMENTE d on j.DEPARTAMENT_ID = d.DEPARTAMENT_ID
where (a.JOB_ID, a.SALARIU, a.LOCATIE) in
      (select JOB_ID, MAX(SALARIU), LOCATIE
       from ANGAJATI
       group by LOCATIE, JOB_ID
       having INSTR(JOB_ID, 'VID') > 0
           or INSTR(JOB_ID, 'FTO') > 0);

/
-- 5) Afisarea id-ului, tipului si numelui clientilor care au organizat evenimente in
-- cadrul carora s-au folosit numai echipamente care au fost niciodata in service.
select c.CLIENT_ID,
       c.NUME  DENUMIRE,
       CASE c.TIP_CLIENT
           WHEN 'F' then 'Persoana fizica'
           ELSE 'Persoana juridica'
           END TIP
from CLIENTI c
where c.CLIENT_ID in (select DISTINCT o.CLIENT_ID
                      from ORGANIZEAZA o
                               join FOLOSESTE f on f.EVENIMENT_ID = o.EVENIMENT_ID
                               join ISTORIC_SERVICE i on i.SERIE = f.SERIE);
