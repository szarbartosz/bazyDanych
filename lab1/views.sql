--VIEWS
--a) RzerwacjeWszystkie(kraj,data, nazwa_wycieczki, imie, nazwisko,status_rezerwacji)
CREATE VIEW REZERWACJE_WSZYSTKIE
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

SELECT * FROM REZERWACJE_WSZYSTKIE;

--b) RezerwacjePotwierdzone (kraj,data, nazwa_wycieczki, imie, nazwisko,status_rezerwacji)
CREATE VIEW REZERWACJE_POTWIERDZONE
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

SELECT * FROM REZERWACJE_POTWIERDZONE;

--c) RezerwacjeWPrzyszlosci (kraj,data, nazwa_wycieczki, imie, nazwisko,status_rezerwacji)
CREATE VIEW REZERWACJE_W_PRZYSZLOSCI
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

SELECT * FROM REZERWACJE_W_PRZYSZLOSCI;

-- d) WycieczkiMiejsca(kraj,data, nazwa_wycieczki,liczba_miejsc, liczba_wolnych_miejsc)
CREATE VIEW WYCIECZKI_MIEJSCA
    AS
        SELECT
            w.KRAJ,
            w.DATA,
            w.NAZWA,
            w.LICZBA_MIEJSC,
            w.LICZBA_MIEJSC - (SELECT COUNT(*)
                               FROM REZERWACJE r
                               WHERE w.ID_WYCIECZKI = r.ID_WYCIECZKI AND r.STATUS <> 'A') WOLNE_MIEJSCA
        FROM WYCIECZKI w;
SELECT * FROM WYCIECZKI_MIEJSCA;

-- e) WycieczkiDostepne(kraj,data, nazwa_wycieczki,liczba_miejsc, liczba_wolnych_miejsc)
CREATE VIEW WYCIECZKI_DOSTEPNE
    AS
        SELECT *
        FROM WYCIECZKI_MIEJSCA wm
        WHERE wm.DATA > CURRENT_DATE AND wm.WOLNE_MIEJSCA > 0;

SELECT * FROM WYCIECZKI_DOSTEPNE;