create index data_angajare_per_job on ANGAJATI (JOB_ID, DATA_ANGAJARE);

select * from ANGAJATI a join PRELUCREAZA_CU p on a.ANGAJAT_ID = p.ANGAJAT_ID
where JOB_ID='EDIT' and DATA_ANGAJARE > TO_DATE('2022-01-01', 'YYYY-MM-DD');