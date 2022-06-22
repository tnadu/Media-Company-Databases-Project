create table SEDII (
    locatie varchar2(25) PRIMARY KEY
);

create table DEPARTAMENTE (
    departament_id number(2) PRIMARY KEY,
    titlu_departament varchar2(30) NOT NULL
);

create table JOBURI (
    job_id varchar2(20) PRIMARY KEY,
    departament_id number(3),
    titlu_job varchar2(30) NOT NULL,
    salariu_min number(4, 2) DEFAULT 0,
    salariu_max number(7, 2) DEFAULT 20000,
    CONSTRAINT departament_id_fk FOREIGN KEY (departament_id) references DEPARTAMENTE(departament_id)
);

create table ANGAJATI (
    angajat_id number(3) PRIMARY KEY,
    job_id varchar2(20),
    locatie varchar2(25),
    nume varchar2(30) NOT NULL,
    prenume varchar2(30) NOT NULL,
    email varchar2(40) UNIQUE NOT NULL,
    telefon varchar2(10) NOT NULL,
    data_angajare date DEFAULT SYSDATE,
    salariu number(7,2) DEFAULT 0,
    CONSTRAINT validare_telefon_angajati CHECK (LENGTH(telefon)=10),
    CONSTRAINT job_id_fk FOREIGN KEY (job_id) references JOBURI(job_id),
    CONSTRAINT locatie_angajat_fk FOREIGN KEY (locatie) references SEDII(locatie)
);

create table TIPURI_DE_ECHIPAMENTE (
    tip_echipament_id number(1) PRIMARY KEY,
    titlu_tip_echipament varchar2(30) NOT NULL
);

create table ECHIPAMENTE (
    serie varchar2(20) PRIMARY KEY,
    locatie varchar2(25),
    tip_echipament_id number(1),
    nume_produs varchar2(30) NOT NULL,
    data_achizitie date DEFAULT SYSDATE,
    perioada_garantie number(3) DEFAULT 0,
    CONSTRAINT locatie_echipamente_fk FOREIGN KEY (locatie) references SEDII(locatie),
    CONSTRAINT tip_echipament_id_fk FOREIGN KEY (tip_echipament_id) references TIPURI_DE_ECHIPAMENTE(tip_echipament_id)
);

create table ISTORIC_SERVICE (
    serie varchar2(20),
    data_intrare date DEFAULT SYSDATE,
    data_solutionare date DEFAULT SYSDATE,
    CONSTRAINT serie_service_fk FOREIGN KEY (serie) references ECHIPAMENTE(serie),
    CONSTRAINT istoric_service_pk PRIMARY KEY (serie, data_intrare, data_solutionare)
);

create table TIPURI_DE_LICENTE (
    tip_licenta_id number(1) PRIMARY KEY,
    titlu_tip_licenta varchar2(30) NOT NULL
);

create table LICENTE (
    cheie varchar2(40) PRIMARY KEY,
    tip_licenta_id number(3),
    nume_produs varchar2(30) NOT NULL,
    data_achizitie date DEFAULT SYSDATE,
    perioada_valabilitate number(3) DEFAULT 0,
    CONSTRAINT tip_licenta_id_fk FOREIGN KEY (tip_licenta_id) references TIPURI_DE_LICENTE(tip_licenta_id)
);

create table CLIENTI (
    client_id number(4) PRIMARY KEY,
    tip_client varchar2(1) DEFAULT 'F',
    nume varchar2(30) NOT NULL,
    prenume varchar2(30) NOT NULL,
    email varchar2(40) UNIQUE,
    telefon varchar2(10) NOT NULL,
    CONSTRAINT validare_telefon_clienti CHECK (LENGTH(telefon)=10)
);

create table EVENIMENTE (
    eveniment_id number(7) PRIMARY KEY,
    data_inceput date DEFAULT SYSDATE,
    data_final date DEFAULT SYSDATE
);

create table FOLOSESTE (
    angajat_id number(3),
    serie varchar2(20),
    eveniment_id number(7),
    CONSTRAINT angajat_id_foloseste_fk FOREIGN KEY (angajat_id) references ANGAJATI(angajat_id),
    CONSTRAINT serie_foloseste_fk FOREIGN KEY (serie) references ECHIPAMENTE(serie),
    CONSTRAINT eveniment_id_foloseste_fk FOREIGN KEY (eveniment_id) references EVENIMENTE(eveniment_id),
    CONSTRAINT foloseste_pk PRIMARY KEY (angajat_id, serie, eveniment_id)
);

create table PRELUCREAZA_CU (
    angajat_id number(3),
    cheie varchar2(20),
    eveniment_id number(7),
    CONSTRAINT angajat_id_prelucreaza_fk FOREIGN KEY (angajat_id) references ANGAJATI(angajat_id),
    CONSTRAINT cheie_prelucreaza_fk FOREIGN KEY (cheie) references LICENTE(cheie),
    CONSTRAINT eveniment_id_prelucreaza_fk FOREIGN KEY (eveniment_id) references EVENIMENTE(eveniment_id),
    CONSTRAINT prelucreaza_pk PRIMARY KEY (angajat_id, cheie, eveniment_id)
);

create table ORGANIZEAZA (
    client_id number(4),
    eveniment_id number(7),
    CONSTRAINT organizeaza_pk PRIMARY KEY (client_id, eveniment_id)
)