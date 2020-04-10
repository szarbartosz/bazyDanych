--Tables
CREATE TABLE OSOBY
(
    ID_OSOBY INT GENERATED ALWAYS AS IDENTITY NOT NULL,
    IMIE VARCHAR2(50),
    NAZWISKO VARCHAR2(50),
    PESEL VARCHAR2(11),
    KONTAKT VARCHAR2(100),
    CONSTRAINT OSOBY_PK PRIMARY KEY
    (
    ID_OSOBY
    )
    ENABLE
);

CREATE TABLE WYCIECZKI
(
    ID_WYCIECZKI INT GENERATED ALWAYS AS IDENTITY NOT NULL,
    NAZWA VARCHAR2(100),
    KRAJ VARCHAR2(50),
    DATA DATE,
    OPIS VARCHAR2(200),
    LICZBA_MIEJSC INT,
    CONSTRAINT WYCIECZKI_PK PRIMARY KEY
    (
        ID_WYCIECZKI
    )
    ENABLE
);

CREATE TABLE REZERWACJE
(
    NR_REZERWACJI INT GENERATED ALWAYS AS IDENTITY NOT NULL,
    ID_WYCIECZKI INT,
    ID_OSOBY INT,
    STATUS CHAR(1),
    CONSTRAINT REZERWACJE_PK PRIMARY KEY
    (
        NR_REZERWACJI
    )
    ENABLE
);

ALTER TABLE REZERWACJE
ADD CONSTRAINT REZERWACJE_FK1 FOREIGN KEY
(
    ID_OSOBY
)
REFERENCES OSOBY
(
    ID_OSOBY
)
ENABLE;

ALTER TABLE REZERWACJE
ADD CONSTRAINT REZERWACJE_FK2 FOREIGN KEY
(
    ID_WYCIECZKI
)
REFERENCES WYCIECZKI
(
    ID_WYCIECZKI
)
ENABLE;

--Inserting into tables
-- INSERT INTO OSOBY(IMIE, NAZWISKO, PESEL, KONTAKT)
-- VALUES();
--
-- INSERT INTO WYCIECZKI(NAZWA, KRAJ, DATA, OPIS, LICZBA_MIEJSC)
-- VALUES();
--
-- INSERT INTO REZERWACJE (ID_WYCIECZKI, ID_OSOBY, STATUS)
-- VALUES();

SELECT * FROM OSOBY;
SELECT * FROM WYCIECZKI;
SELECT * FROM REZERWACJE;

--Views
--a) RzerwacjeWszystkie(kraj,data, nazwa_wycieczki, imie, nazwisko,status_rezerwacji)
CREATE VIEW RezerwacjeWszystkie
    AS
        SELECT
            w.NAZWA,
            w.KRAJ,
            w.DATA,
            o.IMIE,
            o.NAZWISKO,
            r.STATUS
        FROM WYCIECZKI w
            JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
            JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY;

SELECT * FROM RezerwacjeWszystkie;

--b) RezerwacjePotwierdzone (kraj,data, nazwa_wycieczki, imie, nazwisko,status_rezerwacji)
CREATE VIEW RezerwacjePotwierdzone
    AS
        SELECT
            w.NAZWA,
            w.KRAJ,
            w.DATA,
            o.IMIE,
            o.NAZWISKO,
            r.STATUS
        FROM WYCIECZKI w
            JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
            JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
        WHERE r.STATUS LIKE 'P' OR r.STATUS LIKE 'Z';

SELECT * FROM RezerwacjePotwierdzone;

--c) RezerwacjeWPrzyszlosci (kraj,data, nazwa_wycieczki, imie, nazwisko,status_rezerwacji)
CREATE VIEW RezerwacjeWPrzyszlosci
    AS
        SELECT
            w.NAZWA,
            w.KRAJ,
            w.DATA,
            o.IMIE,
            o.NAZWISKO,
            r.STATUS
        FROM WYCIECZKI w
            JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
            JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
        WHERE w.DATA > CURRENT_DATE;

SELECT * FROM RezerwacjeWPrzyszlosci;

-- d) WycieczkiMiejsca(kraj,data, nazwa_wycieczki,liczba_miejsc, liczba_wolnych_miejsc)
CREATE VIEW WycieczkiMiejsca
    AS
        SELECT
            w.KRAJ,
            w.DATA,
            w.NAZWA,
            w.LICZBA_MIEJSC,
            SELECT w.LICZBA_MIEJSC - (SELECT COUNT(*) FROM REZERWACJE r
                                      INNER JOIN WYCIECZKI W ON r.ID_WYCIECZKI = W.ID_WYCIECZ



