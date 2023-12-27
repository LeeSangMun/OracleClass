SELECT *
FROM movie_rs;

EXEC up_order_option(3);

SELECT *
FROM seat
WHERE screen_id = 1000;

SELECT *
FROM screen_cat;

SELECT *
FROM store;

EXEC up_select_store('패키지');
EXEC up_select_store('음료');

SELECT *
FROM movie_rs;

SELECT *
FROM seat_rs;

SELECT *
FROM store;

EXEC up_seatview(1002);

create or replace PROCEDURE up_seatView
(
    pscreen_id seat.screen_id%TYPE
)
IS
    vseat_code_first CHAR(1) := ' ';
    vflag CHAR(1) := 'f';
BEGIN
    DBMS_OUTPUT.PUT_LINE('─────────────');
    DBMS_OUTPUT.PUT_LINE('       screen');
    DBMS_OUTPUT.PUT_LINE('─────────────');
    FOR vrow IN(SELECT seat_code, seat_grade, seat_category
                FROM seat
                WHERE screen_id = pscreen_id
                )
    LOOP  
        vflag := 'f';
        IF SUBSTR(vrow.seat_code, 0, 1) = vseat_code_first THEN
            FOR vseat_code IN (SELECT seat_code FROM seat_rs WHERE screen_id = pscreen_id)
            LOOP
                IF vseat_code.seat_code = vrow.seat_code THEN
                    DBMS_OUTPUT.PUT('X' || '|');
                    vflag := 't';
                    EXIT;
                END IF;
            END LOOP;
            IF vflag = 'f' THEN
                DBMS_OUTPUT.PUT(SUBSTR(vrow.seat_code, 3) || '|');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('');
            vseat_code_first := SUBSTR(vrow.seat_code, 0, 1);
            DBMS_OUTPUT.PUT(vseat_code_first || ' ');
            FOR vseat_code IN (SELECT seat_code FROM seat_rs WHERE screen_id = pscreen_id)
            LOOP
                IF vseat_code.seat_code = vrow.seat_code THEN
                    DBMS_OUTPUT.PUT('|' || 'X' || '|');
                    vflag := 't';
                    EXIT;
                END IF;
            END LOOP;
            IF vflag = 'f' THEN
                DBMS_OUTPUT.PUT('|' || SUBSTR(vrow.seat_code, 3) || '|');
            END IF;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
END;

SELECT *
FROM event;

SELECT *
FROM event_part;

SELECT *
FROM winner;

create or replace PROCEDURE up_mc_grade_order
IS
    i NUMBER := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<<무비차트 - 평점순>>');
    DBMS_OUTPUT.PUT_LINE('');
    FOR vrow IN (SELECT m.mv_title, TO_CHAR(mv_open, 'YYYY.MM.DD') mv_open, mv_golegg, NVL(예매율, '0%') 예매율
                FROM show s JOIN movie m ON s.movie_id = m.mv_id
                            LEFT JOIN movie_rs r ON s.show_id = r.show_id
                            LEFT JOIN uv_rsrate u ON m.mv_title = u.mv_title
                GROUP BY m.mv_title, mv_open, mv_golegg, 예매율
                ORDER BY mv_golegg DESC)
    LOOP
        DBMS_OUTPUT.PUT_LINE('[NO.' || i || ']');
        DBMS_OUTPUT.PUT_LINE(vrow.mv_title);
        DBMS_OUTPUT.PUT_LINE('예매율  ' || vrow.예매율 || ' | ?' || vrow.mv_golegg || '%');
        DBMS_OUTPUT.PUT_LINE(vrow.mv_open || '  개봉');
        DBMS_OUTPUT.PUT_LINE('');
        i := i + 1;
    END LOOP;
END;

create or replace PROCEDURE up_mc_rs_order
IS
    i NUMBER := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<<무비차트 - 예매율순>>');
    DBMS_OUTPUT.PUT_LINE('');
    FOR vrow IN (SELECT m.mv_title, TO_CHAR(mv_open, 'YYYY.MM.DD') mv_open, mv_golegg, NVL(예매율, '0%') 예매율
                FROM show s JOIN movie m ON s.movie_id = m.mv_id
                            LEFT JOIN movie_rs r ON s.show_id = r.show_id
                            LEFT JOIN uv_rsrate u ON m.mv_title = u.mv_title
                GROUP BY m.mv_title, mv_open, mv_golegg, 예매율
                ORDER BY 예매율 DESC)
    LOOP
        DBMS_OUTPUT.PUT_LINE('[NO.' || i || ']');
        DBMS_OUTPUT.PUT_LINE(vrow.mv_title);
        DBMS_OUTPUT.PUT_LINE('예매율  ' || vrow.예매율 || ' | ?' || vrow.mv_golegg || '%');
        DBMS_OUTPUT.PUT_LINE(vrow.mv_open || '  개봉');
        DBMS_OUTPUT.PUT_LINE('');
        i := i + 1;
    END LOOP;
END;

create or replace PROCEDURE up_mc_view_order
IS
    i NUMBER := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('<<무비차트 - 관람객순>>');
    DBMS_OUTPUT.PUT_LINE('');
    FOR vrow IN (SELECT m.mv_title, TO_CHAR(mv_open, 'YYYY.MM.DD') mv_open, mv_golegg, NVL(예매율, '0%') 예매율, NVL(SUM(totcnt), 0) 총관람객
                FROM show s JOIN movie m ON s.movie_id = m.mv_id
                            LEFT JOIN movie_rs r ON s.show_id = r.show_id
                            LEFT JOIN uv_rsrate u ON m.mv_title = u.mv_title
                GROUP BY m.mv_title, mv_open, mv_golegg, 예매율
                ORDER BY 총관람객 DESC)
    LOOP
        DBMS_OUTPUT.PUT_LINE('[NO.' || i || ']');
        DBMS_OUTPUT.PUT_LINE(vrow.mv_title);
        DBMS_OUTPUT.PUT_LINE('예매율  ' || vrow.예매율 || ' | ?' || vrow.mv_golegg || '%');
        DBMS_OUTPUT.PUT_LINE(vrow.mv_open || '  개봉');
        DBMS_OUTPUT.PUT_LINE('');
        i := i + 1;
    END LOOP;
END;

EXEC up_order_option(3);

CREATE OR REPLACE PROCEDURE up_endedEvent
(
    pevent_id event.event_id%TYPE
)
IS  
BEGIN
    FOR vrow IN (SELECT user_id , event_id
                            FROM ( 
                                SELECT user_id, p.event_id, event_title, event_end
                                FROM event e RIGHT JOIN event_part p ON e.event_id = p.event_id
                                WHERE EVENT_END <= SYSDATE
                                ORDER BY dbms_random.value
                            ) tmp
                            WHERE EVENT_id = pevent_id AND rownum <=5)
    LOOP
        INSERT INTO winner VALUES (seq_win_id.NEXTVAL, vrow.user_id, vrow.event_id) ;
    END LOOP;
END;

EXEC up_winner(11);
SELECT *
FROM winner;

DELETE FROM winner;

SELECT user_id, movie_id, mv_title, start_time , theater_id, screen_id, totcnt 
FROM(
SELECT user_id, movie_id, mv_title, start_time , theater_id, screen_id, totcnt FROM watchview
ORDER BY ROWNUM DESC
)
WHERE ROWNUM = 1;

DESC movie_pay;
SELECT * FROM movie_rs;

SELECT *
FROM screen_cat;

SELECT *
FROM screen;

EXEC up_seatview(1002,10004);

SELECT *
FROM show;

SELECT *
FROM seat_rs;

SELECT *
FROM seat;



DESC screen;

create or replace PROCEDURE up_seatView
(
    pscreen_id seat.screen_id%TYPE
    ,pshow_id seat_rs.show_id%TYPE
)
IS
    vseat_code_first CHAR(1) := ' ';
    vflag CHAR(1) := 'f';
BEGIN
    DBMS_OUTPUT.PUT_LINE('─────────────');
    DBMS_OUTPUT.PUT_LINE('       screen');
    DBMS_OUTPUT.PUT_LINE('─────────────');
    FOR vrow IN(SELECT seat_code, seat_grade, seat_category
                FROM seat
                WHERE screen_id = pscreen_id
                )
    LOOP  
        vflag := 'f';
        IF SUBSTR(vrow.seat_code, 0, 1) = vseat_code_first THEN
            FOR vseat_code IN (SELECT seat_code FROM seat_rs WHERE screen_id = pscreen_id AND show_id = pshow_id)
            LOOP
                IF vseat_code.seat_code = vrow.seat_code THEN
                    DBMS_OUTPUT.PUT('X' || '|');
                    vflag := 't';
                    EXIT;
                END IF;
            END LOOP;
            IF vflag = 'f' THEN
                DBMS_OUTPUT.PUT(SUBSTR(vrow.seat_code, 3) || '|');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('');
            vseat_code_first := SUBSTR(vrow.seat_code, 0, 1);
            DBMS_OUTPUT.PUT(vseat_code_first || ' ');
            FOR vseat_code IN (SELECT seat_code FROM seat_rs WHERE screen_id = pscreen_id AND show_id = pshow_id)
            LOOP
                IF vseat_code.seat_code = vrow.seat_code THEN
                    DBMS_OUTPUT.PUT('|' || 'X' || '|');
                    vflag := 't';
                    EXIT;
                END IF;
            END LOOP;
            IF vflag = 'f' THEN
                DBMS_OUTPUT.PUT('|' || SUBSTR(vrow.seat_code, 3) || '|');
            END IF;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
END;

EXEC up_mc_grade_order;
EXEC up_mc_rs_order;
EXEC up_mc_view_order;
EXEC up_selectAll_store;
EXEC up_select_store('팝콘');

SELECT tt_name
FROM bookmark_cgv b JOIN theater t ON t.theater_id in ( b.cinema_id1 , cinema_id2, cinema_id3, cinema_id4, cinema_id5)
WHERE b.USER_ID = 'shysong';