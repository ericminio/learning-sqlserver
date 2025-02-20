#!/bin/bash

function test_load_data_from_csv_with_headers {
    DIR=$(current_dir ${BASH_SOURCE[0]})
    execute "
        drop table if exists events;
        create table events(
            id varchar(10), 
            external_id varchar(10),
            flag boolean
        );"
    bulk_copy "./mysql/load/data.csv" "events" 

    execute "
        select external_id, count(id) count
        from events
        group by external_id;" > $DIR/run.output
    value=`cat ${DIR}/run.output | extract_query_result`

    assertequals "$value" "AA 4 BB 2"
}

function test_load_data_from_csv_resisting_comma_in_data {
    DIR=$(current_dir ${BASH_SOURCE[0]})

    execute "
        drop table if exists events;
        create table events(
            internal_key varchar(10), 
            external_key varchar(10)
        );"
    bulk_copy "./mysql/load/data_comma.csv" "events" 

    execute "
        select 
            external_key,
            count(internal_key) as total_count
        from events
        group by external_key;" > $DIR/run.output
    value=`cat ${DIR}/run.output | extract_query_result`

    assertequals "$value" "AA, BB 2"
}

function test_bulk_can_load_boolean {
    DIR=$(current_dir ${BASH_SOURCE[0]})
    execute "
        drop table if exists events;
        create table events(
            id varchar(10), 
            external_id varchar(10),
            flag boolean
        );"
    bulk_copy "./mysql/load/boolean.csv" "events" 

    execute "
        select count(id)
        from events
        where flag = 1" > $DIR/run.output
    value=`cat ${DIR}/run.output | extract_query_result`

    assertequals "$value" "5"
}

function test_bulk_truncates_too_long_fields {
    DIR=$(current_dir ${BASH_SOURCE[0]})
    execute "
        drop table if exists events;
        create table events(
            one varchar(10), 
            two varchar(5),
            three varchar(10)
        );"
    bulk_copy "./mysql/load/toolong.csv" "events" 

    execute "
        select *
        from events" > $DIR/run.output
    value=`cat ${DIR}/run.output | extract_query_result`

    assertequals "$value" "before 12345 after"
}