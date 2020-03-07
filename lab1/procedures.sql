-- Procedures
-- a) DodajRezerwacje(id_wycieczki, id_osoby), procedura powinna kontrolować czy wycieczka
-- jeszcze się nie odbyła, i czy sa wolne miejsca

CREATE OR REPLACE PROCEDURE DODAJ_REZERWACJE(IDwycieczki INT, IDosoby INT)
AS
    person_exists INT;
    trip_exists INT;
    reservation_exists INT;
    free_places INT;
BEGIN
    SELECT COUNT(*) INTO trip_exists
    FROM WYCIECZKI W
    WHERE W.ID_WYCIECZKI = IDwycieczki;

    IF trip_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nie znaleziono wycieczki o podanym ID');
    END IF;

    SELECT COUNT(*) INTO person_exists
    FROM OSOBY o
    WHERE o.ID_OSOBY = IDosoby;

    IF person_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nie znaleziono osoby o podanym ID');
    END IF;

    SELECT COUNT(*) INTO reservation_exists
    FROM REZERWACJE r
    WHERE r.ID_WYCIECZKI = IDwycieczki
          AND r.ID_OSOBY = IDosoby;

    IF reservation_exists > 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Rezerwacja podanej osoby na tę wycieczkę już istnieje');
    END IF;

    SELECT w.LICZBA_MIEJSC - (SELECT COUNT(*)
                               FROM REZERWACJE r
                               INNER JOIN WYCIECZKI w2 ON r.ID_WYCIECZKI = w2.ID_WYCIECZKI
                               WHERE w.ID_WYCIECZKI = r.ID_WYCIECZKI AND r.STATUS <> 'A') INTO free_places
    FROM WYCIECZKI w
    WHERE DODAJ_REZERWACJE.IDwycieczki = w.ID_WYCIECZKI;

    IF free_places = 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Na wybraną wycieczkę nie ma już wolnych miejsc');
    END IF;

    INSERT INTO REZERWACJE(ID_WYCIECZKI, ID_OSOBY, STATUS)
    VALUES (IDwycieczki, IDosoby, 'N');
    COMMIT;
END;

BEGIN
    DODAJ_REZERWACJE(2,10);
END;

SELECT * FROM REZERWACJE;

-- b) ZmienStatusRezerwacji(nr_rezerwacji, status), procedura kontrolować czy możliwa jest
-- zmiana statusu, np. zmiana statusu już anulowanej wycieczki (przywrócenie do stanu
-- aktywnego nie zawsze jest możliwa – może już nie być miejsc)

CREATE OR REPLACE PROCEDURE ZMIEN_STATUS_REZERWACJI(NRrezerwacji INT, status REZERWACJE.STATUS%TYPE)
AS
    reservation_exists INT;
    old_status REZERWACJE.STATUS%TYPE;
BEGIN
    SELECT COUNT(*) INTO reservation_exists
    FROM REZERWACJE r
    WHERE r.NR_REZERWACJI = NRrezerwacji;

    IF reservation_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Rezerwacja o podanym numerze nie istinieje');
    END IF;

    SELECT STATUS INTO old_status
    FROM REZERWACJE r
    WHERE r.NR_REZERWACJI = NRrezerwacji;

    CASE
        WHEN old_status = 'A' THEN
            RAISE_APPLICATION_ERROR(-20000, 'Nie można zmienić statusu anulowanej rezewracji');
        WHEN old_status = ZMIEN_STATUS_REZERWACJI.status THEN
            RAISE_APPLICATION_ERROR(-20000, 'Rezerwacja już posiada podany status');
        WHEN old_status = 'P' THEN
            IF ZMIEN_STATUS_REZERWACJI.status <> 'Z' and ZMIEN_STATUS_REZERWACJI.status <> 'A' THEN
                RAISE_APPLICATION_ERROR(-20000, 'Status rezerwacji "potwierdzona" może być zmieniony jedynie na "opłacona" lub "anulowana"');
            END IF;
        WHEN old_status = 'Z' THEN
            IF ZMIEN_STATUS_REZERWACJI.status <> 'A' THEN
                RAISE_APPLICATION_ERROR(-20000, 'Status rezerwacji "opłacona" może być zmieniony jedynie na "anulowana"');
            END IF;
        WHEN old_status = 'N' THEN
            IF ZMIEN_STATUS_REZERWACJI.status <> 'Z' and ZMIEN_STATUS_REZERWACJI.status <> 'P' and ZMIEN_STATUS_REZERWACJI.status <> 'A' THEN
                RAISE_APPLICATION_ERROR(-20000, 'Status rezerwacji "nowa" może być zmieniony jedynie na "potwierdzona", "opłacona" lub "anulowana"');
            END IF;
        ELSE
                RAISE_APPLICATION_ERROR(-20000, 'CASE not found"');
    END CASE;

    UPDATE REZERWACJE r
    SET r.STATUS = ZMIEN_STATUS_REZERWACJI.status
    WHERE r.NR_REZERWACJI = ZMIEN_STATUS_REZERWACJI.NRrezerwacji;
    COMMIT;
END;

BEGIN
    ZMIEN_STATUS_REZERWACJI(22,'P');
END;

SELECT * FROM REZERWACJE;

-- c) ZmienLiczbeMiejsc(id_wycieczki, liczba_miejsc), nie wszystkie zmiany liczby miejsc są
-- dozwolone, nie można zmniejszyć liczby miesc na wartość poniżej liczby zarezerwowanych
-- miejsc
CREATE OR REPLACE PROCEDURE ZMIEN_LICZBE_MIEJSC(IDwycieczki INT, miejsca INT)
AS
    trip_exists INT;
    places_booked INT;
BEGIN
    SELECT COUNT(*) INTO trip_exists
    FROM WYCIECZKI w
    WHERE w.ID_WYCIECZKI = ZMIEN_LICZBE_MIEJSC.IDwycieczki;

    IF trip_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Wycieczka o podanym ID nie istnieje');
    END IF;

    SELECT COUNT(*) INTO places_booked
    FROM REZERWACJE r
    WHERE r.ID_WYCIECZKI = ZMIEN_LICZBE_MIEJSC.IDwycieczki AND r.STATUS <> 'A';

    IF ZMIEN_LICZBE_MIEJSC.miejsca < places_booked THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nie można zmniejszyć liczby miejsc poniżej liczby miejsc już zarezerwowanych');
    END IF;

    IF ZMIEN_LICZBE_MIEJSC.miejsca < 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nie można zmniejszyć liczby miejsc poniżej 1');
    END IF;

    UPDATE WYCIECZKI w
    SET w.LICZBA_MIEJSC = ZMIEN_LICZBE_MIEJSC.miejsca
    WHERE w.ID_WYCIECZKI = ZMIEN_LICZBE_MIEJSC.IDwycieczki;
    COMMIT;
END;

BEGIN
    ZMIEN_LICZBE_MIEJSC(1,50);
END;

SELECT * FROM WYCIECZKI;