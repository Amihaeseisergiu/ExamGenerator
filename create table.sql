drop table tests;
/

create table tests (
    id integer,
    email varchar2(100),
    q_nr integer,
    q_id varchar2(8),
    a_1 varchar2(8),
    a_2 varchar2(8),
    a_3 varchar2(8),
    a_4 varchar2(8),
    a_5 varchar2(8),
    a_6 varchar2(8),
    a_correct varchar2(1000),
    a_user varchar2(1000) DEFAULT NULL,
    CONSTRAINT fk_q_id FOREIGN KEY (q_id) REFERENCES intrebari(id),
    CONSTRAINT fk_a_1 FOREIGN KEY (a_1) REFERENCES raspunsuri(id),
    CONSTRAINT fk_a_2 FOREIGN KEY (a_2) REFERENCES raspunsuri(id),
    CONSTRAINT fk_a_3 FOREIGN KEY (a_3) REFERENCES raspunsuri(id),
    CONSTRAINT fk_a_4 FOREIGN KEY (a_4) REFERENCES raspunsuri(id),
    CONSTRAINT fk_a_5 FOREIGN KEY (a_5) REFERENCES raspunsuri(id),
    CONSTRAINT fk_a_6 FOREIGN KEY (a_6) REFERENCES raspunsuri(id)
);
/

drop table users;
/

create table users (
    email varchar2(100),
    hash varchar2(100)
);
/

insert into users values ('ion@info.uaic.ro', '123');
/