create or replace NONEDITIONABLE function urmatoarea_intrebare (p_email in varchar2, p_raspuns in varchar2 := null) return varchar2 as
    v_ret varchar2(4000);
    v_count integer;
    v_count2 integer;
    v_id_test integer;
    v_id_intrebare varchar2(8);
    v_id_intrebare2 varchar2(8);
    v_nr_ord_intrebare integer;
    v_raspuns_corect varchar2(8);
    v_val_intr float(4);
    v_scor_part float(4);
    v_scor_total float(4);
    v_nr_intrebari float(4) := 10;

    type raspuns is varray(6) of varchar2(8);
    v_raspunsuri raspuns;
    v_raspunsuri_global raspuns;
    v_raspunsuri_total raspuns;
    v_csv_string varchar2(1000);
    
    v_test_json json_array_t;
    v_test_obj_json json_object_t;
    v_question_json json_object_t;
    v_responses_json json_array_t;
    v_response_json json_object_t;
begin
    select count(*) into v_count from users u where u.email = p_email;
    if v_count > 0 then --verifies user existence

        select max(q_nr) into v_count from tests where email = p_email and a_user is null;

        if p_raspuns is null and (v_count < 10 or v_count is null) then --verifies if an active test exists

            v_nr_ord_intrebare := 1;
            v_raspunsuri_global := raspuns();
            select nvl(max(id)+1,1) into v_id_test from tests where email = p_email;

            for x in (select * from (select distinct(domeniu) from intrebari order by dbms_random.random) where rownum < 11) loop --loop over 10 random domains

                select id into v_id_intrebare from (select id from intrebari where domeniu = x.domeniu order by dbms_random.random) where rownum < 2;

                select id into v_raspuns_corect from (select id from raspunsuri where q_id = v_id_intrebare and corect = 1 order by dbms_random.random) where rownum < 2;            
                v_raspunsuri := raspuns(v_raspuns_corect);
                v_csv_string := v_raspuns_corect;

                for y in (select id,corect from raspunsuri where q_id = v_id_intrebare order by dbms_random.random) loop
                    if y.id <> v_raspuns_corect and v_raspunsuri.count < 6 then
                        v_raspunsuri.extend(1);
                        v_raspunsuri(v_raspunsuri.count) := y.id;

                        if y.corect = 1 then
                            v_csv_string := v_csv_string || ',' || y.id;
                        end if;
                    end if;
                end loop;

                execute immediate 'insert into tests (id, email, q_nr, q_id, a_1, a_2, a_3, a_4, a_5, a_6, a_correct) values (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11)' 
                using v_id_test, p_email, v_nr_ord_intrebare, v_id_intrebare, v_raspunsuri(1), v_raspunsuri(2), v_raspunsuri(3), v_raspunsuri(4), v_raspunsuri(5), v_raspunsuri(6), v_csv_string;
                v_nr_ord_intrebare := v_nr_ord_intrebare + 1;

                if v_raspunsuri_global.count = 0 then
                    for y in v_raspunsuri.first .. v_raspunsuri.last loop
                        v_raspunsuri_global.extend(1);
                        v_raspunsuri_global(y) := v_raspunsuri(y);
                    end loop;
                end if;
            end loop;

            select q_id into v_id_intrebare from tests where email = p_email and id = v_id_test and q_nr = 1;
            select json_object(
                'id_intrebare' VALUE v_id_intrebare,
                'intrebare' VALUE (select text_intrebare from intrebari where id = v_id_intrebare),
                'id_rasp_1' VALUE v_raspunsuri_global(1),
                'raspuns_1' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(1)),
                'id_rasp_2' VALUE v_raspunsuri_global(2),
                'raspuns_2' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(2)),
                'id_rasp_3' VALUE v_raspunsuri_global(3),
                'raspuns_3' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(3)),
                'id_rasp_4' VALUE v_raspunsuri_global(4),
                'raspuns_4' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(4)),
                'id_rasp_5' VALUE v_raspunsuri_global(5),
                'raspuns_5' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(5)),
                'id_rasp_6' VALUE v_raspunsuri_global(6),
                'raspuns_6' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(6))
            ) into v_ret from dual;
            return v_ret;
        elsif p_raspuns is null then

            v_raspunsuri_global := raspuns();
            v_raspunsuri_global.extend(6);
            select max(id) into v_id_test from tests where email = p_email;
            select q_id, a_1, a_2, a_3, a_4, a_5, a_6 into v_id_intrebare, v_raspunsuri_global(1), v_raspunsuri_global(2), v_raspunsuri_global(3), v_raspunsuri_global(4), v_raspunsuri_global(5), v_raspunsuri_global(6)
            from tests where email = p_email and id = v_id_test and q_nr = (select min(q_nr) from tests where email = p_email and id = v_id_test and a_user is null);

            select json_object(
                'id_intrebare' VALUE v_id_intrebare,
                'intrebare' VALUE (select text_intrebare from intrebari where id = v_id_intrebare),
                'id_rasp_1' VALUE v_raspunsuri_global(1),
                'raspuns_1' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(1)),
                'id_rasp_2' VALUE v_raspunsuri_global(2),
                'raspuns_2' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(2)),
                'id_rasp_3' VALUE v_raspunsuri_global(3),
                'raspuns_3' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(3)),
                'id_rasp_4' VALUE v_raspunsuri_global(4),
                'raspuns_4' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(4)),
                'id_rasp_5' VALUE v_raspunsuri_global(5),
                'raspuns_5' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(5)),
                'id_rasp_6' VALUE v_raspunsuri_global(6),
                'raspuns_6' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(6))
            ) into v_ret from dual;
            return v_ret;
        else

            select part1, part2 into v_id_intrebare, v_csv_string from 
            (select regexp_replace(val, ':[^:]+$', '', 1, 1) as part1, regexp_substr(val, '[^:]+$', 1, 1) as part2 from (select p_raspuns as val from dual));

            select max(q_nr) into v_count from tests where email = p_email and a_user is null;
            if v_count = 10 then

                select max(id) into v_id_test from tests where email = p_email;
                select q_id into v_id_intrebare2 from tests where email = p_email and id = v_id_test and q_nr = (select min(q_nr) from tests where email = p_email and id = v_id_test and a_user is null);
                if v_id_intrebare = v_id_intrebare2 then

                    update tests set a_user = v_csv_string where email = p_email and q_nr = (select min(q_nr) from tests where email = p_email and a_user is null);

                    select max(q_nr) into v_count from tests where email = p_email and a_user is null;
                    if v_count = 10 then

                        v_raspunsuri_global := raspuns();
                        v_raspunsuri_global.extend(6);
                        select max(id) into v_id_test from tests where email = p_email;
                        select q_id, a_1, a_2, a_3, a_4, a_5, a_6 into v_id_intrebare, v_raspunsuri_global(1), v_raspunsuri_global(2), v_raspunsuri_global(3), v_raspunsuri_global(4), v_raspunsuri_global(5), v_raspunsuri_global(6)
                        from tests where email = p_email and id = v_id_test and q_nr = (select min(q_nr) from tests where email = p_email and id = v_id_test and a_user is null);

                        select json_object(
                            'id_intrebare' VALUE v_id_intrebare,
                            'intrebare' VALUE (select text_intrebare from intrebari where id = v_id_intrebare),
                            'id_rasp_1' VALUE v_raspunsuri_global(1),
                            'raspuns_1' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(1)),
                            'id_rasp_2' VALUE v_raspunsuri_global(2),
                            'raspuns_2' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(2)),
                            'id_rasp_3' VALUE v_raspunsuri_global(3),
                            'raspuns_3' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(3)),
                            'id_rasp_4' VALUE v_raspunsuri_global(4),
                            'raspuns_4' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(4)),
                            'id_rasp_5' VALUE v_raspunsuri_global(5),
                            'raspuns_5' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(5)),
                            'id_rasp_6' VALUE v_raspunsuri_global(6),
                            'raspuns_6' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(6))
                        ) into v_ret from dual;
                        return v_ret;
                    else

                        v_scor_total := 0;
                        v_test_json := json_array_t();
                        for x in (select * from tests where email = p_email and id = (select max(id) from tests where email = p_email)) loop

                            v_question_json := json_object_t();
                            select text_intrebare into v_csv_string from intrebari where id = x.q_id;
                            v_question_json.put('intrebare', v_csv_string);
                            v_responses_json := json_array_t();
                            v_scor_part := 0;
                            v_raspunsuri := raspuns();
                            for y in (select regexp_substr(x.a_correct, '[^,]+', 1, level) as part from dual connect by regexp_substr(x.a_correct, '[^,]+', 1, level) is not null) loop
                                v_raspunsuri.extend(1);
                                v_raspunsuri(v_raspunsuri.count) := y.part;
                            end loop;

                            v_raspunsuri_global := raspuns();
                            for y in (select regexp_substr(x.a_user, '[^,]+', 1, level) as part from dual connect by regexp_substr(x.a_user, '[^,]+', 1, level) is not null) loop
                                v_raspunsuri_global.extend(1);
                                v_raspunsuri_global(v_raspunsuri_global.count) := y.part;
                            end loop;
                            
                            v_val_intr := v_nr_intrebari / v_raspunsuri.count;

                            for y in v_raspunsuri_global.first .. v_raspunsuri_global.last loop
                                v_count := 0;
                                v_response_json := json_object_t();
                                select text_raspuns into v_csv_string from raspunsuri where id = v_raspunsuri_global(y);
                                v_response_json.put('raspuns', v_csv_string);
                                for z in v_raspunsuri.first .. v_raspunsuri.last loop
                                    if v_raspunsuri_global(y) = v_raspunsuri(z) then
                                        v_count := 1;
                                        exit;
                                    end if;
                                end loop;

                                if v_count = 0 then
                                    v_scor_part := v_scor_part - v_val_intr;
                                    v_response_json.put('type', 'miss');
                                    v_response_json.put('points', '-' || v_val_intr);
                                else
                                    v_scor_part := v_scor_part + v_val_intr;
                                    v_response_json.put('type', 'hit');
                                    v_response_json.put('points', '+' || v_val_intr);
                                end if;
                                
                                v_responses_json.append(v_response_json);
                            end loop;
                            
                            v_raspunsuri_total := raspuns();
                            v_raspunsuri_total.extend(6);
                            v_raspunsuri_total(1) := x.a_1;
                            v_raspunsuri_total(2) := x.a_2;
                            v_raspunsuri_total(3) := x.a_3;
                            v_raspunsuri_total(4) := x.a_4;
                            v_raspunsuri_total(5) := x.a_5;
                            v_raspunsuri_total(6) := x.a_6;
                            
                            for y in v_raspunsuri_total.first..v_raspunsuri_total.last loop
                            
                                for z in v_raspunsuri.first .. v_raspunsuri.last loop
                                    v_response_json := json_object_t();
                                    if v_raspunsuri_total(y) = v_raspunsuri(z) then
                                        v_count := 0;
                                        for i in v_raspunsuri_global.first .. v_raspunsuri_global.last loop
                                            if v_raspunsuri(z) = v_raspunsuri_global(i) then
                                                v_count := 1;
                                                exit;
                                            end if;
                                        end loop;
                                        
                                        if v_count = 0 then
                                            select text_raspuns into v_csv_string from raspunsuri where id = v_raspunsuri(z);
                                            v_response_json.put('raspuns', v_csv_string);
                                            v_response_json.put('type', 'correct');
                                            v_responses_json.append(v_response_json);
                                        end if;
                                    end if;
                                end loop;
                                
                                v_count := 0;
                                 for z in v_raspunsuri.first .. v_raspunsuri.last loop
                                    if v_raspunsuri_total(y) = v_raspunsuri(z) then
                                        v_count := 1;
                                        exit;
                                    end if;
                                 end loop;
                                 for z in v_raspunsuri_global.first .. v_raspunsuri_global.last loop
                                    if v_raspunsuri_total(y) = v_raspunsuri_global(z) then
                                        v_count := 1;
                                        exit;
                                    end if;
                                 end loop;
                                 
                                 if v_count = 0 then
                                    select text_raspuns into v_csv_string from raspunsuri where id = v_raspunsuri_total(y);
                                    v_response_json.put('raspuns', v_csv_string);
                                    v_response_json.put('type', 'incorrect');
                                    v_responses_json.append(v_response_json);
                                end if;
                            end loop;

                            if v_scor_part > 0 then
                                v_scor_total := v_scor_total + v_scor_part;
                            end if;
                            
                            v_question_json.put('raspunsuri', v_responses_json);
                            v_test_json.append(v_question_json);
                        end loop;

                        v_test_obj_json := json_object_t();
                        v_response_json := json_object_t();
                        v_response_json.put('Total', v_scor_total);
                        v_test_obj_json.put('Score', v_response_json);
                        v_test_obj_json.put('questions', v_test_json);
                        return v_test_obj_json.to_string;
                    end if;

                else
                    v_raspunsuri_global := raspuns();
                    v_raspunsuri_global.extend(6);
                    select max(id) into v_id_test from tests where email = p_email;
                    select q_id, a_1, a_2, a_3, a_4, a_5, a_6 into v_id_intrebare, v_raspunsuri_global(1), v_raspunsuri_global(2), v_raspunsuri_global(3), v_raspunsuri_global(4), v_raspunsuri_global(5), v_raspunsuri_global(6)
                    from tests where email = p_email and id = v_id_test and q_nr = (select min(q_nr) from tests where email = p_email and id = v_id_test and a_user is null);

                    select json_object(
                        'id_intrebare' VALUE v_id_intrebare,
                        'intrebare' VALUE (select text_intrebare from intrebari where id = v_id_intrebare),
                        'id_rasp_1' VALUE v_raspunsuri_global(1),
                        'raspuns_1' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(1)),
                        'id_rasp_2' VALUE v_raspunsuri_global(2),
                        'raspuns_2' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(2)),
                        'id_rasp_3' VALUE v_raspunsuri_global(3),
                        'raspuns_3' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(3)),
                        'id_rasp_4' VALUE v_raspunsuri_global(4),
                        'raspuns_4' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(4)),
                        'id_rasp_5' VALUE v_raspunsuri_global(5),
                        'raspuns_5' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(5)),
                        'id_rasp_6' VALUE v_raspunsuri_global(6),
                        'raspuns_6' VALUE (select text_raspuns from raspunsuri where id = v_raspunsuri_global(6))
                    ) into v_ret from dual;
                    return v_ret;
                end if;
            else
                v_scor_total := 0;
                v_test_json := json_array_t();
                for x in (select * from tests where email = p_email and id = (select max(id) from tests where email = p_email)) loop

                    v_question_json := json_object_t();
                    select text_intrebare into v_csv_string from intrebari where id = x.q_id;
                    v_question_json.put('intrebare', v_csv_string);
                    v_responses_json := json_array_t();
                    v_scor_part := 0;
                    v_raspunsuri := raspuns();
                    for y in (select regexp_substr(x.a_correct, '[^,]+', 1, level) as part from dual connect by regexp_substr(x.a_correct, '[^,]+', 1, level) is not null) loop
                        v_raspunsuri.extend(1);
                        v_raspunsuri(v_raspunsuri.count) := y.part;
                    end loop;

                    v_raspunsuri_global := raspuns();
                    for y in (select regexp_substr(x.a_user, '[^,]+', 1, level) as part from dual connect by regexp_substr(x.a_user, '[^,]+', 1, level) is not null) loop
                        v_raspunsuri_global.extend(1);
                        v_raspunsuri_global(v_raspunsuri_global.count) := y.part;
                    end loop;
                    
                    v_val_intr := v_nr_intrebari / v_raspunsuri.count;

                    for y in v_raspunsuri_global.first .. v_raspunsuri_global.last loop
                        v_count := 0;
                        v_response_json := json_object_t();
                        select text_raspuns into v_csv_string from raspunsuri where id = v_raspunsuri_global(y);
                        v_response_json.put('raspuns', v_csv_string);
                        for z in v_raspunsuri.first .. v_raspunsuri.last loop
                            if v_raspunsuri_global(y) = v_raspunsuri(z) then
                                v_count := 1;
                                exit;
                            end if;
                        end loop;

                        if v_count = 0 then
                            v_scor_part := v_scor_part - v_val_intr;
                            v_response_json.put('type', 'miss');
                            v_response_json.put('points', '-' || v_val_intr);
                        else
                            v_scor_part := v_scor_part + v_val_intr;
                            v_response_json.put('type', 'hit');
                            v_response_json.put('points', '+' || v_val_intr);
                        end if;
                        
                        v_responses_json.append(v_response_json);
                    end loop;
                    
                    v_raspunsuri_total := raspuns();
                    v_raspunsuri_total.extend(6);
                    v_raspunsuri_total(1) := x.a_1;
                    v_raspunsuri_total(2) := x.a_2;
                    v_raspunsuri_total(3) := x.a_3;
                    v_raspunsuri_total(4) := x.a_4;
                    v_raspunsuri_total(5) := x.a_5;
                    v_raspunsuri_total(6) := x.a_6;
                    
                    for y in v_raspunsuri_total.first..v_raspunsuri_total.last loop
                    
                        for z in v_raspunsuri.first .. v_raspunsuri.last loop
                            v_response_json := json_object_t();
                            if v_raspunsuri_total(y) = v_raspunsuri(z) then
                                v_count := 0;
                                for i in v_raspunsuri_global.first .. v_raspunsuri_global.last loop
                                    if v_raspunsuri(z) = v_raspunsuri_global(i) then
                                        v_count := 1;
                                        exit;
                                    end if;
                                end loop;
                                
                                if v_count = 0 then
                                    select text_raspuns into v_csv_string from raspunsuri where id = v_raspunsuri(z);
                                    v_response_json.put('raspuns', v_csv_string);
                                    v_response_json.put('type', 'correct');
                                    v_responses_json.append(v_response_json);
                                end if;
                            end if;
                        end loop;
                        
                        v_count := 0;
                         for z in v_raspunsuri.first .. v_raspunsuri.last loop
                            if v_raspunsuri_total(y) = v_raspunsuri(z) then
                                v_count := 1;
                                exit;
                            end if;
                         end loop;
                         for z in v_raspunsuri_global.first .. v_raspunsuri_global.last loop
                            if v_raspunsuri_total(y) = v_raspunsuri_global(z) then
                                v_count := 1;
                                exit;
                            end if;
                         end loop;
                         
                         if v_count = 0 then
                            select text_raspuns into v_csv_string from raspunsuri where id = v_raspunsuri_total(y);
                            v_response_json.put('raspuns', v_csv_string);
                            v_response_json.put('type', 'incorrect');
                            v_responses_json.append(v_response_json);
                        end if;
                    end loop;

                    if v_scor_part > 0 then
                        v_scor_total := v_scor_total + v_scor_part;
                    end if;
                    
                    v_question_json.put('raspunsuri', v_responses_json);
                    v_test_json.append(v_question_json);
                end loop;

                v_test_obj_json := json_object_t();
                v_response_json := json_object_t();
                v_response_json.put('Total', v_scor_total);
                v_test_obj_json.put('Score', v_response_json);
                v_test_obj_json.put('questions', v_test_json);
                return v_test_obj_json.to_string;
            end if;
        end if;

    else
        select json_object('error' VALUE 'User not found!') into v_ret from dual;
        return v_ret;
    end if;
end;