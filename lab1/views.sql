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
