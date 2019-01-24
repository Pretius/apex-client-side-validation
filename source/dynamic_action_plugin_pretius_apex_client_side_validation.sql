prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_180200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.3.00.05'
,p_default_workspace_id=>21717127411908241868
,p_default_application_id=>103428
,p_default_owner=>'RD_DEV'
);
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_ais_live_validation
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(8282892867757180115)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'LIVE.VALIDATION'
,p_display_name=>'APEX Item Live Validation'
,p_category=>'EXECUTE'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'e_validation_failed exception;',
'type t_tab is table of varchar2(4000) index by binary_integer;',
'  /* function to render validation plugin */',
'function render_validation (',
'  p_dynamic_action in apex_plugin.t_dynamic_action,',
'  p_plugin         in apex_plugin.t_plugin ',
') return apex_plugin.t_dynamic_action_render_result',
'is',
'  v_result apex_plugin.t_dynamic_action_render_result;',
'BEGIN',
'  apex_javascript.add_library(',
'    p_name      => ''live_validation.min'',',
'    p_directory => p_plugin.file_prefix,',
'    p_version   => NULL ',
'  );',
'  v_result.ajax_identifier := APEX_PLUGIN.GET_AJAX_IDENTifIER();',
'  v_result.javascript_function := ''function() { live_validation(this);}'';    ',
'  APEX_PLUGIN_UTIL.DEBUG_DYNAMIC_ACTION (',
'    p_plugin         => p_plugin,',
'    p_dynamic_action => p_dynamic_action',
'  );  ',
'  return v_result;',
'EXCEPTION',
'  WHEN OTHERS then',
'    htp.p( SQLERRM );',
'    return v_result;',
'end render_validation;',
'  /* function to get item value */',
'FUNCTION GET_VALUE (',
'  P_NAME IN VARCHAR2 )',
'  RETURN VARCHAR2',
'IS',
'  v_value VARCHAR2(32767);',
'BEGIN',
'  v_value := V(P_NAME);',
'  ',
'  RETURN CASE',
'    WHEN v_value = ''%null%'' then NULL',
'    ELSE v_value',
'  end;',
'end GET_VALUE;',
'  /* function to get current time */',
'function current_time_ms',
'  return number',
'is',
'  out_result number;',
'begin',
'  select ',
'    extract(day from(systimestamp - to_timestamp(''1970-01-01'', ''YYYY-MM-DD''))) * 86400000 + to_number(to_char(sys_extract_utc(systimestamp), ''SSSSSFF3''))',
'  into ',
'    out_result',
'  from ',
'    dual;',
'  return out_result;',
'end current_time_ms;',
'  /* to perform bindings */',
'FUNCTION PERFORM_BINDS (',
'    P_STRING IN VARCHAR2,',
'    P_ESCAPE IN BOOLEAN DEFAULT FALSE )',
'  RETURN VARCHAR2',
'IS VR_STR VARCHAR2(32767) := P_STRING;',
'VR_BINDS   SYS.DBMS_SQL.VARCHAR2_TABLE;',
'BEGIN',
'VR_BINDS   := APEX_180200.WWV_FLOW_UTILITIES.GET_BINDS(VR_STR);',
'IF VR_BINDS.COUNT > 0 THEN',
' FOR I IN 1..VR_BINDS.COUNT LOOP',
'  VR_STR   := REPLACE( VR_STR, VR_BINDS(I), '' V('''''' || LTRIM(VR_BINDS(I),'':'') || '''''') '' );',
' END LOOP;',
'END IF;',
'VR_STR := APEX_PLUGIN_UTIL.REPLACE_SUBSTITUTIONS( P_VALUE    => VR_STR, P_ESCAPE   => TRUE);',
'RETURN VR_STR;',
'END PERFORM_BINDS;',
'  /* function to get results */',
'function get_func_boolean_result(',
'  p_code in varchar2',
') return boolean',
'is',
'  v_func_block varchar2(32000);',
'  v_result varchar2(1);',
'  v_code varchar2(32000);',
'BEGIN',
'  ',
'  v_code := perform_binds( p_code, true );',
'  v_code := replace(v_code, ''declare'', ''DECLARE'');',
'  v_code := replace(v_code, ''begin'', ''BEGIN'');',
'',
'  if instr(v_code, ''DECLARE'') > 0 then',
'    v_code := replace(v_code, ''DECLARE'', ''function test return boolean is'');',
'  elsif instr(v_code, ''BEGIN'') > 0 then',
'    v_code := replace(v_code, ''BEGIN'', ''function test return boolean is begin'');',
'  else',
'    v_code := ''function test return boolean is begin ''||v_code||'' end;'';',
'  end if;',
'',
'  v_func_block := ''',
'    declare',
'      v_result boolean;',
'      ''||v_code||''',
'    begin',
'      v_result := test();',
'',
'      if v_result then',
'        :out := 1;',
'      else',
'        :out := 0;',
'      end if;',
'    end; ',
'  '';',
'  execute immediate v_func_block using out v_result;',
'',
'  if v_result = 1 then',
'    return true;',
'  else',
'    return false;',
'  end if;',
'',
'end get_func_boolean_result;',
'  /* function to get pl/sql expression result */',
'function get_plsql_expression_result(',
'  p_expression in varchar2',
') return boolean',
'is',
'  v_expression varchar2(32000);',
'  v_func_block varchar2(32000);',
'  v_result varchar2(1);',
'BEGIN',
'  v_expression := perform_binds( p_expression, true );',
'  v_func_block := ''',
'    begin ',
'      if ''||v_expression||'' then ',
'        return 1; ',
'      else ',
'       return 0; ',
'      end if;',
'    end;',
'  '';',
' ',
'  v_result := APEX_PLUGIN_UTIL.GET_PLSQL_FUNCTION_RESULT( v_func_block );',
'',
'  if v_result = ''1'' then',
'    return true;',
'  else',
'    return false;',
'  end if;',
'',
'end get_plsql_expression_result;',
'  /* function to get item mask */',
'function getItemFormatMask(',
'  p_item_id in varchar2',
') return varchar2 is',
'  v_format_mask varchar2(200);',
'BEGIN',
'  select ',
'    FORMAT_MASK ',
'  into',
'    v_format_mask',
'  from ',
'    APEX_APPLICATION_PAGE_ITEMS ',
'  where ',
'    application_id = :APP_TRANSLATION_ID ',
'    and page_id = :APP_TRANSLATION_PAGE_ID  ',
'    and item_name = p_item_id;',
'',
'  return v_format_mask;  ',
'',
'EXCEPTION',
'  WHEN OTHERS then',
'    return null;',
'end getItemFormatMask;',
'  /* function to select count from query */',
'function selectCountFromQuery(',
'  p_query in varchar2',
') return number',
'is',
'  v_query varchar2(32000);',
'  v_count number :=0;',
'BEGIN',
'',
'  v_query := perform_binds( p_query, true );',
'  v_query := ''select count(1) from (''|| v_query ||'')'';',
'  ',
'  execute immediate v_query into v_count;',
'  ',
'  return v_count;',
'exception when others then ',
'APEX_DEBUG.ERROR (v_query);',
'raise;',
'end selectCountFromQuery;',
'  /* function to trim whitespace */',
'function rtrim_ws(',
'  p_val in varchar2',
') return varchar2',
'as',
'',
'begin',
'  return rtrim(replace(replace(p_val,chr(13),null),chr(10),null));',
'end rtrim_ws;',
'  /* procedure to check matching */',
'procedure isRunConditionMatched(',
'  p_condition_type_code in varchar2,',
'  p_condition_expression1 in varchar2,',
'  p_condition_expression2 in varchar2,',
'  p_out_run out number,',
'  p_out_msg out varchar2',
'',
')',
'is',
'  v_cond_type varchar2(100) := p_condition_type_code;',
'  v_cond_1  VARCHAR2(32767) := WWV_FLOW.DO_SUBSTITUTIONS(p_condition_expression1);',
'  v_cond_2  VARCHAR2(32767) := WWV_FLOW.DO_SUBSTITUTIONS(p_condition_expression2);',
'  e_stop_processing exception;',
'  e_return_true exception;',
'  e_return_false exception;',
'  e_unkown_condition exception;',
'  e_return_no_condition exception;',
'',
'  v_test_boolean boolean;',
'  v_test_result varchar2(3200);',
'  v_test_number number;',
'',
'  l_val varchar2(4000);',
'  l_len number;',
'',
'BEGIN',
'',
'  if p_condition_type_code is null then',
'    raise e_return_no_condition;',
'  end if;',
'',
'  if v_cond_type = ''NEVER'' then',
'    raise e_return_false;',
'',
'  elsif v_cond_type = ''ALWAYS'' then',
'    raise e_return_true;',
'',
'  elsif v_cond_type IN (''SQL_EXPRESION'', ''SQL_EXPRESSION'') then',
'    v_test_result := ''select 1 from dual where ''||perform_binds( v_cond_1 );',
'',
'    if selectCountFromQuery( v_test_result ) = 0 then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_cond_type = ''FUNCTION_BODY'' then',
'',
'    v_test_boolean := get_func_boolean_result( v_cond_1 );',
'',
'    if NOT v_test_boolean then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_cond_type = ''ITEM_IS_NOT_NULL'' then ',
'    if GET_VALUE( v_cond_1 ) is null then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_cond_type =''EXISTS'' then',
'    if selectCountFromQuery( v_cond_1 ) <= 0 then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_cond_type =''NOT_EXISTS'' then',
'    if selectCountFromQuery( v_cond_1 ) > 0 then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_cond_type =''VAL_OF_ITEM_IN_COND_EQ_COND2'' then',
'    if GET_VALUE( v_cond_1 ) <> v_cond_2 OR GET_VALUE( v_cond_1 ) is null then',
'      raise e_return_false;',
'    end if;      ',
'',
'  elsif v_cond_type in (''PLSQL_EXPRESSION'',''PLSQL_EXPRESION'') then',
'    if not get_plsql_expression_result( v_cond_1 ) then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_cond_type IN (''ITEM_IS_NOT_ZERO'',''ITEM_NOT_ZERO'')  then',
'    if NVL( V( RTRIM_WS(v_cond_1) ),''x'' ) = ''0'' then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_cond_type = ''ITEM_CONTAINS_NO_SPACES'' then',
'    if INSTR(REPLACE(V(WWV_FLOW.DO_SUBSTITUTIONS(RTRIM_WS(v_cond_1),''TEXT'')),''%null%'',NULL),'' '') > 0 then',
'       raise e_return_false;',
'    end if;',
'',
'  elsif v_cond_type IN (''ITEM_NOT_NULL_OR_ZERO'', ''ITEM_IS_NOT_NULL_OR_ZERO'', ''FLOW_ITEM_IS_NOT_NULL_OR_ZERO'') then',
'    if V(RTRIM_WS(v_cond_1)) IS NULL OR V(RTRIM_WS(v_cond_1)) = ''0'' then',
'        raise e_return_false;',
'    end if;    ',
'',
'  elsif v_cond_type = ''ITEM_IS_ALPHANUMERIC'' then',
'',
'    l_len := NVL(LENGTH(REPLACE(V(WWV_FLOW.DO_SUBSTITUTIONS(UPPER(RTRIM_WS(v_cond_1)),''TEXT'')),''%null%'',NULL)),0);',
'    l_val := REPLACE(V(UPPER(v_cond_1)),''%null%'',NULL);',
'',
'    FOR J IN 1..L_LEN LOOP',
'      if INSTR(''abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_'',SUBSTR(L_VAL,J,1)) = 0 then',
'        raise e_return_false;',
'      end if;',
'    end LOOP;',
'',
'  elsif v_cond_type = ''ITEM_IS_NUMERIC'' then',
'    begin',
'      v_test_number := REPLACE(V(WWV_FLOW.DO_SUBSTITUTIONS(RTRIM_WS(v_cond_1),''TEXT'')),''%null%'',NULL);',
'    exception ',
'      when others then',
'        raise e_return_false;',
'    end;',
'',
'  elsif v_cond_type = ''ITEM_IS_NOT_NUMERIC'' then',
'      begin',
'         v_test_number := REPLACE(V(WWV_FLOW.DO_SUBSTITUTIONS(RTRIM_WS( v_cond_1 ),''TEXT'')),''%null%'',NULL);',
'         raise e_return_false; ',
'      exception when others then',
'         null;',
'      end;',
'',
'  elsif v_cond_type IN (''VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'', ''VAL_OF_ITEM_IN_COND_NOT_EQ_COND_TEXT'', ''VALUE_OF_ITEM_NAMED_IN_COND1_NOT_EQUAL_TEXT_IN_COND2'') then',
'    if NVL(V(RTRIM_WS( v_cond_1 )),''Mjhakb'') = NVL(WWV_FLOW.DO_SUBSTITUTIONS( v_cond_1 ),''mjHbka'') then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_cond_type IN (''ITEM_IS_NULL'',''FLOW_ITEM_IS_NULL'') then',
'    if REPLACE(V(RTRIM_WS( v_cond_1 )),''%null%'',NULL) IS NULL then',
'      null;',
'    ELSE',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_cond_type IN (''ITEM_IS_NULL_OR_ZERO'') then',
'    if V(RTRIM_WS( v_cond_1 )) IS NULL OR V(RTRIM_WS( v_cond_1 )) = ''0'' then',
'      null;',
'    ELSE',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_cond_type IN (''ITEM_IS_ZERO'') then',
'    if NVL(V(RTRIM_WS( v_cond_1 )),''x'') <> ''0'' then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_cond_type = ''VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'' then',
'    IF INSTR('':''||WWV_FLOW.DO_SUBSTITUTIONS(v_cond_2,''TEXT'')||'':'','':''||V(RTRIM_WS( v_cond_1 ))||'':'') > 0 THEN',
'      null;',
'    ELSE',
'      raise e_return_false;',
'    END IF;',
'',
'  elsif v_cond_type = ''VALUE_OF_ITEM_IN_CONDITION_NOT_IN_COLON_DELIMITED_LIST'' then',
'    if instr('':''||WWV_FLOW.DO_SUBSTITUTIONS( v_cond_2,''TEXT'')||'':'','':''||V(RTRIM_WS( v_cond_1 ))||'':'') > 0 THEN',
'      raise e_return_false;',
'    else',
'      null;',
'    end if;',
'',
'  else',
'    raise e_unkown_condition;',
'  end if;',
'',
'  raise e_return_true;',
'',
'EXCEPTION',
'  when e_return_no_condition then',
'    p_out_run := 1;',
'    p_out_msg := ''No condition for validation'';',
'  when e_return_true then',
'    p_out_run := 1;',
'    p_out_msg := ''Condition [''||v_cond_type||''] passed.'';',
'  when e_return_false then',
'    p_out_run := 0;',
'    p_out_msg := ''Condition [''||v_cond_type||''] not passed. Validation is not executed.'';',
'  when e_unkown_condition then',
'    p_out_run := 2;',
'    p_out_msg := ''Condition type [''|| v_cond_type || ''] not suppoerted. Sorry'';',
'  WHEN OTHERS then',
'    p_out_run := 2;',
'    p_out_msg := ''Unexpected error: ''||SQLERRM;',
'end isRunConditionMatched;',
'  /* procedure to validate */',
'procedure validate(',
'  P_VALIDATION_TYPE in varchar2,',
'  p_validation_name in varchar2,',
'  p_validation_expression1 in varchar2,',
'  p_validation_expression2 in varchar2,',
'  p_validation_error_text in varchar2,',
'  p_out_error_text out varchar2,',
'  p_out_status out number,',
'  p_out_msg out varchar2',
')',
'is',
'  L_EXPRESSION1 VARCHAR2(32767) := WWV_FLOW.DO_SUBSTITUTIONS(p_validation_expression1);',
'  L_EXPRESSION2 VARCHAR2(32767) := WWV_FLOW.DO_SUBSTITUTIONS(p_validation_expression2);',
'  L_VALUE VARCHAR2(32767);',
'  L_LEN number;',
'  l_boolean boolean;',
'  ',
'  v_val_type varchar2(3200) := P_VALIDATION_TYPE;',
'  v_val_name varchar2(3200) := P_VALIDATION_name;',
'',
'  e_return_true exception;',
'  e_return_false exception;',
'  e_unknown_validation exception;',
'',
'  v_test_number number;',
'  v_test_date date;',
'  v_test_result varchar2(3200);',
'BEGIN',
'  p_out_error_text := p_validation_error_text;',
'',
'  if P_VALIDATION_TYPE = ''NATIVE_NUMBER_FIELD'' then',
'    p_out_error_text := REPLACE(APEX_LANG.MESSAGE(''APEX.NUMBER_FIELD.VALUE_INVALID''), ''APEX.NUMBER_FIELD.VALUE_INVALID'', ''#LABEL# '' || APEX_LANG.MESSAGE(''MUST_BE_NUMERIC''));',
'',
'  elsif P_VALIDATION_TYPE = ''ITEM_REQUIRED'' then',
'    p_out_error_text := REPLACE(APEX_LANG.MESSAGE(''APEX.PAGE_ITEM_IS_REQUIRED'', L_EXPRESSION2), ''APEX.PAGE_ITEM_IS_REQUIRED'', ''#LABEL# '' || APEX_LANG.MESSAGE(''REQUIRED''));',
'',
'  elsif P_VALIDATION_TYPE = ''NATIVE_DATE_PICKER'' then',
'    p_out_error_text := REPLACE(APEX_LANG.MESSAGE(''APEX.DATEPICKER_VALUE_INVALID'', L_EXPRESSION2), ''APEX.DATEPICKER_VALUE_INVALID'', ''#LABEL# ''|| APEX_LANG.MESSAGE(''DOES_NOT_MATCH_FORMAT'') || '' '' ||L_EXPRESSION2||''.'');',
'  end if;  ',
'',
'  if v_val_type =''EXISTS'' then',
'    if selectCountFromQuery( L_EXPRESSION1 ) <= 0 then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type =''NOT_EXISTS'' then',
'    if selectCountFromQuery( L_EXPRESSION1 ) > 0 then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type =''ITEM_NOT_ZERO'' then',
'    if NOT NVL(GET_VALUE(L_EXPRESSION1),''x'') != ''0'' then',
'      raise e_return_false;',
'    end if;    ',
'',
'  elsif v_val_type in (''ITEM_NOT_NULL'', ''ITEM_REQUIRED'') then',
'    if GET_VALUE(L_EXPRESSION1) IS NULL then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type =''ITEM_NOT_NULL_OR_ZERO'' then',
'    L_VALUE := GET_VALUE(L_EXPRESSION1);',
'',
'    if L_VALUE IS NULL OR L_VALUE = ''0'' then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type = ''ITEM_IS_ALPHANUMERIC'' then',
'    L_VALUE := GET_VALUE(L_EXPRESSION1);',
'    L_LEN   := NVL(LENGTH(L_VALUE),0);',
'    FOR J IN 1 .. L_LEN LOOP ',
'      if INSTR(''abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_'',SUBSTR(L_VALUE,J,1)) = 0 then',
'        raise e_return_false;',
'      end if;',
'    end LOOP;  ',
'    ',
'  elsif v_val_type in (''NATIVE_NUMBER_FIELD'', ''ITEM_IS_NUMERIC'')  then',
'    L_VALUE := GET_VALUE(L_EXPRESSION1);',
'    BEGIN',
'      v_test_number := to_number( replace(replace(L_VALUE, '','', NULL), ''.'', null) );',
'    EXCEPTION',
'      WHEN OTHERS then',
'        raise e_return_false;',
'    end;',
'    ',
'  elsif v_val_type =''ITEM_CONTAINS_NO_SPACES'' then',
'    if INSTR(GET_VALUE(L_EXPRESSION1),'' '') > 0 then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type in (''ITEM_IS_DATE'', ''NATIVE_DATE_PICKER'') then',
'    L_VALUE := GET_VALUE(L_EXPRESSION1);',
'    if L_VALUE is not null then',
'      begin',
'        v_test_date := to_date(L_VALUE, nvl(getItemFormatMask(L_EXPRESSION1),''DD-MON-RR''));',
'      exception',
'        when others then',
'          raise e_return_false;',
'      end;',
'    end if;',
'',
'  elsif v_val_type =''ITEM_IS_TIMESTAMP'' then',
'    raise e_unknown_validation;',
'',
'  elsif v_val_type IN (''SQL_EXPRESION'', ''SQL_EXPRESSION'') then',
'    v_test_result := ''select 1 from dual where ''||perform_binds( L_EXPRESSION1, true );',
'',
'    if selectCountFromQuery( v_test_result ) = 0 then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type in (''PLSQL_EXPRESION'', ''PLSQL_EXPRESSION'') then',
'    ',
'    if not get_plsql_expression_result( L_EXPRESSION1 ) then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type =''PLSQL_ERROR'' then',
'    raise e_return_false;',
'',
'  elsif v_val_type =''FUNC_BODY_RETURNING_ERR_TEXT'' then',
'    ',
'    v_test_result := APEX_PLUGIN_UTIL.GET_PLSQL_FUNCTION_RESULT( L_EXPRESSION1 );',
'',
'    if v_test_result is not null then',
'      p_out_error_text := v_test_result; ',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type =''FUNC_BODY_RETURNING_BOOLEAN'' then',
'    l_boolean := get_func_boolean_result( L_EXPRESSION1 );',
'',
'    if not l_boolean then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type =''REGULAR_EXPRESSION'' then',
'    L_VALUE := GET_VALUE(L_EXPRESSION1);',
'    if not REGEXP_LIKE (l_value, l_expression2) then',
'      raise e_return_false;',
'    end if;',
'',
'',
'  elsif v_val_type =''ITEM_IN_VALIDATION_IN_STRING2'' then  ',
'    if instr(L_EXPRESSION2, get_value(L_EXPRESSION1)) = 0 then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type =''ITEM_IN_VALIDATION_NOT_IN_STRING2'' then',
'    if instr(L_EXPRESSION2, get_value(L_EXPRESSION1)) > 0 then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type =''ITEM_IN_VALIDATION_EQ_STRING2'' then',
'    L_VALUE := GET_VALUE(L_EXPRESSION1);',
'',
'    if L_EXPRESSION2 = l_value then',
'      l_boolean := true;',
'    else',
'      l_boolean := false;',
'    end if;',
'',
'    if not l_boolean then',
'      raise e_return_false;',
'    end if;',
'    ',
'  elsif v_val_type =''ITEM_IN_VALIDATION_NOT_EQ_STRING2'' then',
'    if L_EXPRESSION2 = get_value(L_EXPRESSION1) then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type =''ITEM_IN_VALIDATION_CONTAINS_ONLY_CHAR_IN_STRING2'' then',
'    l_value := get_value(l_expression1);',
'    ',
'    if l_value is null then',
'      l_boolean := true;',
'    else',
'      for i in 1 .. length(l_value) loop',
'        if instr(l_expression2, substr(l_value, i, 1)) = 0 then',
'          l_boolean := false;',
'          exit;',
'        end if;',
'      end loop;',
'    end if;',
'    ',
'    if not l_boolean then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type =''ITEM_IN_VALIDATION_CONTAINS_AT_LEAST_ONE_CHAR_IN_STRING2'' then',
'    l_boolean := false;',
'    l_value   := get_value(l_expression1);',
'',
'    if l_value is null then',
'      l_boolean := false;',
'    else',
'      for i in 1..length(l_value) loop',
'        if instr(l_expression2, substr(l_value, i, 1)) > 0 then',
'          l_boolean := true;',
'          exit;',
'        end if;',
'      end loop;',
'    end if;',
'    ',
'    if not l_boolean then',
'      raise e_return_false;',
'    end if;',
'',
'  elsif v_val_type =''ITEM_IN_VALIDATION_CONTAINS_NO_CHAR_IN_STRING2'' then',
'  ',
'    l_value := get_value(l_expression1);',
'    if l_value is null then',
'      l_boolean := true;',
'    else',
'      for i in 1..length(l_value) loop',
'        if instr(l_expression2, substr(l_value, i, 1)) > 0 then',
'          l_boolean := false;',
'          exit;',
'        end if;',
'      end loop;',
'    end if;',
'    ',
'    if not l_boolean then',
'      raise e_return_false;',
'    end if;',
'',
'  else',
'    raise e_unknown_validation;',
'  end if;',
'  raise e_return_true;',
'EXCEPTION',
'  when e_return_true then',
'    p_out_status := 1;',
'    p_out_msg := ''Validation "''|| v_val_name ||''" [''|| v_val_type ||''] passed'';',
'  when e_return_false then',
'    p_out_status := 0;',
'    p_out_msg := ''Validation "''|| v_val_name ||''" [''|| v_val_type ||''] failed'';',
'  when e_unknown_validation then',
'    p_out_status := 2;',
'    p_out_msg := ''Validation type [''|| v_val_type || ''] not suppoerted. Sorry'';',
'  WHEN OTHERS then',
'    p_out_status := 2;',
'    p_out_error_text := ''Error occured while performin validation: ''||replace(replace(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, chr(13), '' ''), chr(10), '' '');',
'    p_out_msg := ''Error occured while performin validation: ''||replace(replace(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, chr(13), '' ''), chr(10), '' '');',
'end validate;',
'  /* procedure to collect logs */',
'procedure collectLogs(',
'  pi_names IN t_tab,',
'  pi_codes IN t_tab,',
'  pi_statuses IN t_tab,',
'  pi_msges IN t_tab,',
'  pi_conditions IN t_tab,',
'  po_exception OUT varchar2,',
'  po_json OUT varchar2',
') is',
'  v_logs_json varchar2(32000);',
'BEGIN',
'  if pi_names.count > 0 then',
'    for i in pi_names.first..pi_names.last loop',
'      v_logs_json := v_logs_json||''{',
'        "validationCode": "''||pi_codes(i)||''",',
'        "validationName": "''||pi_names(i)||''",',
'        "validationMsg": "''||pi_msges(i)||''",',
'        "validationCondition": "''||pi_conditions(i)||''",',
'        "passed": ''||pi_statuses(i)||''',
'      }'';',
'    ',
'      if i <> pi_names.last then',
'        v_logs_json := v_logs_json||'','';',
'      end if;',
'    end loop;',
'',
'  end if;',
'',
'  po_json := v_logs_json;',
'',
'EXCEPTION',
'  WHEN OTHERS then',
'    po_exception := SQLERRM;',
'end collectLogs;',
'',
'function getFieldsToReValidate(',
'  p_item_name in varchar2',
') return varchar2 is',
'  v_items_to_validate varchar2(3200);',
'BEGIN',
'',
'  select',
'    listagg(''#''||ASSOCIATED_ITEM, '','') within group( order by 1 )',
'  into ',
'    v_items_to_validate',
'  from (',
'    select ',
'      distinct',
'        ASSOCIATED_ITEM',
'    from',
'      APEX_APPLICATION_PAGE_VAL aapv',
'    where ',
'      application_id = :APP_TRANSLATION_ID',
'      and page_id = :APP_TRANSLATION_PAGE_ID',
'      and instr('':''||CONDITION_EXPRESSION1||CONDITION_EXPRESSION2||VALIDATION_EXPRESSION1||VALIDATION_EXPRESSION2||'':'', p_item_name) > 0',
'      and ASSOCIATED_ITEM <> p_item_name  ',
'  );',
'',
'  return v_items_to_validate;',
'',
'end getFieldsToReValidate;',
'  /* function to get validation results */',
'function validation_result( ',
'  p_time in number,',
'  p_item in varchar2,',
'  p_passed in varchar2,',
'  p_message in varchar2,',
'  p_revalidate in varchar2,',
'  p_logs in varchar2',
') return varchar2 is',
'  v_time_mask varchar2(24) := ''999G999G999G999G990D0000'';',
'begin',
'  return ''',
'    {',
'      "validation_result": {',
'        "time": {',
'          "ms": "''     ||replace(to_char(p_time, v_time_mask),'' '', '''')||''",',
'          "seconds": "''||replace(to_char((p_time/1000), v_time_mask),'' '', '''')||''",',
'          "minutes": "''||replace(to_char((p_time/1000/60), v_time_mask),'' '', '''')||''"',
'        },',
'        "item": "''||p_item||''",',
'        "passed": ''||p_passed||'',',
'        "message": "''||p_message||''",',
'        "revalidate": "''||p_revalidate||''",',
'        "logs": [''||p_logs||'']',
'      }',
'    }',
'  '';',
'end;',
'  /* function to the ajax call */',
'function ajax_validation (',
'  p_dynamic_action in apex_plugin.t_dynamic_action,',
'  p_plugin         in apex_plugin.t_plugin ',
') return apex_plugin.t_dynamic_action_ajax_result',
'is',
'  v_val_names t_tab;',
'  v_val_statuses t_tab;',
'  v_val_codes t_tab;',
'  v_val_msges t_tab;',
'  v_val_conditions t_tab;',
'  v_revalidate number := NVL(p_dynamic_action.attribute_08, 0);',
'  v_reval_fields varchar2(4000);',
'  v_result apex_plugin.t_dynamic_action_ajax_result;',
'  v_item_id varchar2(100) := apex_application.g_x01;',
'  v_validation_msg varchar2(32000);',
'',
'  v_cond_out_msg varchar2(3200);',
'  v_cond_out_run number;',
'',
'  v_val_out_msg varchar2(3200);',
'  v_val_out_status number;',
'',
'  v_label varchar2(100);',
'  ',
'  v_logs_json varchar2(32000);',
'',
'  v_log_exception varchar2(32000);',
'  v_val_count number :=0;',
'  e_validation_not_found exception;',
'',
'  v_val_error_text varchar2(32000);',
'  v_itemsReValidate varchar2(32000);',
'',
'  v_time_start number;',
'  v_time_end number;',
'  v_time_diff number;',
'begin',
'  v_time_start := current_time_ms();',
'',
'  if v_revalidate = 1 then',
'    v_reval_fields := getFieldsToReValidate(v_item_id);',
'  end if;',
'',
'  BEGIN',
'    select',
'      LABEL',
'    into',
'      v_label',
'    from',
'      APEX_APPLICATION_PAGE_ITEMS',
'    where',
'      application_id = :APP_TRANSLATION_ID',
'      and page_id = :APP_TRANSLATION_PAGE_ID',
'      and ITEM_NAME = v_item_id;',
'',
'  EXCEPTION',
'    when no_data_found then',
'      v_label := ''label not found'';',
'    WHEN OTHERS then',
'      v_label := SQLERRM;',
'  end;',
'',
'  for validation_row in (',
'    select',
'      *',
'    from (',
'      select ',
'        VALIDATION_TYPE_CODE,',
'        VALIDATION_name,',
'        validation_expression1,',
'        validation_expression2,',
'        VALIDATION_FAILURE_TEXT,',
'        VALIDATION_SEQUENCE,',
'        CONDITION_TYPE,',
'        CONDITION_TYPE_CODE,',
'        CONDITION_EXPRESSION1,',
'        CONDITION_EXPRESSION2             ',
'      from',
'        APEX_APPLICATION_PAGE_VAL aapv',
'      where',
'        aapv.application_id = :APP_TRANSLATION_ID',
'        and aapv.page_id = :APP_TRANSLATION_PAGE_ID',
'        and aapv.ASSOCIATED_ITEM = v_item_id',
'        and ( ',
'          aapv.CONDITION_TYPE_CODE <> ''NEVER'' ',
'          OR aapv.CONDITION_TYPE_CODE is null',
'        )',
'      union all',
'',
'      select',
'        DISPLAY_AS_CODE VALIDATION_TYPE_CODE,',
'        DISPLAY_AS_CODE VALIDATION_name,',
'        v_item_id validation_expression1,',
'        FORMAT_MASK validation_expression2,',
'        ''item buildin validation ''||DISPLAY_AS_CODE VALIDATION_FAILURE_TEXT,',
'        999999999999 VALIDATION_SEQUENCE,',
'        null CONDITION_TYPE,',
'        null CONDITION_TYPE_CODE,',
'        null CONDITION_EXPRESSION1,',
'        null CONDITION_EXPRESSION2',
'      from',
'        APEX_APPLICATION_PAGE_ITEMS',
'      where',
'        application_id = :APP_TRANSLATION_ID',
'        and page_id = :APP_TRANSLATION_PAGE_ID',
'        and ITEM_NAME = v_item_id',
'        and DISPLAY_AS_CODE in (''NATIVE_NUMBER_FIELD'', ''NATIVE_DATE_PICKER'') ',
'',
'      union all',
'',
'      select',
'        ''ITEM_REQUIRED'',',
'        ''ITEM_REQUIRED'',',
'        v_item_id,',
'        FORMAT_MASK,',
'        ''item buildin validation ITEM_REQUIRED'',',
'        999999999999,',
'        null,',
'        null,',
'        null,',
'        null',
'      from',
'        APEX_APPLICATION_PAGE_ITEMS',
'      where',
'        application_id = :APP_TRANSLATION_ID',
'        and page_id = :APP_TRANSLATION_PAGE_ID',
'        and ITEM_NAME = v_item_id',
'        and upper(IS_REQUIRED) = ''YES''',
'    )',
'    order by',
'      VALIDATION_SEQUENCE asc',
'  ) LOOP',
'    v_val_count := v_val_count +1;',
'    ',
'    isRunConditionMatched(',
'      p_condition_type_code => validation_row.condition_type_code,',
'      p_condition_expression1 => validation_row.condition_expression1,',
'      p_condition_expression2 => validation_row.condition_expression2,',
'      p_out_run => v_cond_out_run,',
'      p_out_msg => v_cond_out_msg',
'    );',
'',
'    if v_cond_out_run in (0,2) then',
'      v_val_names( v_val_names.count+1 ) := htf.escape_sc( validation_row.VALIDATION_name );',
'      v_val_codes( v_val_codes.count+1 ) := htf.escape_sc( validation_row.VALIDATION_TYPE_CODE );',
'      v_val_conditions( v_val_conditions.count+1 ) := htf.escape_sc( v_cond_out_msg );',
'',
'      if v_cond_out_run = 2 then',
'        v_val_msges( v_val_msges.count+1) := htf.escape_sc( ''Error occured in validation.'');',
'        v_val_statuses( v_val_statuses.count+1 ) := ''"error"'';    ',
'        v_validation_msg := ''Error occured in validation.'';',
'        raise e_validation_failed; ',
'      else',
'        v_val_statuses( v_val_statuses.count+1 ) := ''null'';',
'        v_val_msges( v_val_msges.count+1) := htf.escape_sc( ''null'' );',
'        continue;',
'      end if;',
'',
'    end if;',
'',
'    validate(',
'      P_VALIDATION_TYPE => validation_row.VALIDATION_TYPE_CODE,',
'      p_validation_name => validation_row.VALIDATION_name,',
'      p_validation_expression1 => validation_row.validation_expression1,',
'      p_validation_expression2 => validation_row.validation_expression2,',
'      p_validation_error_text => validation_row.VALIDATION_FAILURE_TEXT,',
'      p_out_error_text => v_val_error_text,',
'      p_out_status => v_val_out_status,',
'      p_out_msg => v_val_out_msg',
'    );',
'    ',
'    v_val_msges( v_val_msges.count+1) := htf.escape_sc(v_val_out_msg);',
'    v_val_names( v_val_names.count+1 ) := htf.escape_sc(validation_row.VALIDATION_name);',
'    v_val_codes( v_val_codes.count+1 ) := htf.escape_sc(validation_row.VALIDATION_TYPE_CODE);',
'    v_val_conditions( v_val_conditions.count+1 ) := htf.escape_sc( v_cond_out_msg );',
'',
'    if v_val_out_status = 1 then',
'      v_val_statuses( v_val_statuses.count+1 ) := ''true'';',
'      continue;',
'    elsif v_val_out_status = 0 then',
'      v_val_statuses( v_val_statuses.count+1 ) := ''false'';',
'      v_validation_msg := v_val_error_text;',
'      raise e_validation_failed; ',
'    else --2',
'      v_val_statuses( v_val_statuses.count+1 ) := ''"error"'';',
'      v_validation_msg := ''Error occured while performin validation. Check Debug!'';',
'      raise e_validation_failed; ',
'    end if;',
'',
'  end LOOP;',
'',
'  if v_val_count = 0 then',
'    raise e_validation_not_found;',
'  end if;',
'',
'  collectLogs(v_val_names, v_val_codes, v_val_statuses, v_val_msges, v_val_conditions, v_log_exception, v_logs_json);',
'',
'  if v_log_exception is not null then',
'    htp.p( v_log_exception );',
'  end if;',
'',
'  v_time_end := current_time_ms();',
'  v_time_diff := v_time_end - v_time_start;',
'',
'  htp.p( validation_result(v_time_diff, v_item_id, ''true'', ''Field is valid.'', v_reval_fields, v_logs_json ) );',
'',
'  return v_result;',
'EXCEPTION',
'  when e_validation_not_found then',
'    v_time_end := current_time_ms();',
'    v_time_diff := v_time_end - v_time_start;',
'',
'    htp.p( validation_result(v_time_diff, v_item_id, chr(34)||''not_found''||chr(34), ''Validation for this field not found'', v_reval_fields, ''[]'' ) );',
'',
'    return v_result;',
'  when e_validation_failed then',
'    v_validation_msg := htf.escape_sc(v_validation_msg);',
'    v_validation_msg := replace(v_validation_msg, chr(35)||''LABEL''||chr(35), v_label);',
'    v_validation_msg := replace(v_validation_msg, chr(13)||chr(10), ''\n'');',
'',
'    collectLogs(v_val_names, v_val_codes, v_val_statuses, v_val_msges, v_val_conditions, v_log_exception, v_logs_json);',
'    ',
'    v_time_end := current_time_ms();',
'    v_time_diff := v_time_end - v_time_start;',
'',
'    htp.p( validation_result(v_time_diff, v_item_id, ''false'', v_validation_msg, v_reval_fields, v_logs_json ) );',
'',
'    return v_result;',
'  WHEN OTHERS then',
'    htp.p(''ajax_validation: ''||SQLERRM );',
'    return v_result;',
'end ajax_validation;'))
,p_api_version=>1
,p_render_function=>'RENDER_VALIDATION'
,p_ajax_function=>'AJAX_VALIDATION'
,p_substitute_attributes=>false
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This Plug-in is used to get Apex Validation live. You can use this plugin by define an apex validation and add this plugin as dynamic action on the item you want to validate. This dynamic action can be fired on "lose focus".',
'',
'Important:',
'',
'To use this plugin please add to text messages the following strings (KEY, value_example):',
'',
'- MUST_BE_NUMERIC => must be numeric',
'- REQUIRED => required',
'- DOES_NOT_MATCH_FORMAT => does not match format'))
,p_version_identifier=>'2.3'
,p_files_version=>56
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E206C6976655F76616C69646174696F6E2865297B66756E6374696F6E206128297B24282223222B73292E72656D6F7665436C6173732822617065782D706167652D6974656D2D6572726F7222292C6C2E6869646528292C6C2E656D70';
wwv_flow_api.g_varchar2_table(2) := '747928297D76617220723D2428652E74726967676572696E67456C656D656E74292C693D722E697328223A636865636B626F7822292C743D722E697328223A726164696F22292C6E3D722E697328226669656C6473657422292C733D6E756C6C2C6F3D6E';
wwv_flow_api.g_varchar2_table(3) := '756C6C2C6C3D6E756C6C2C643D6E756C6C2C703D6E756C6C3B7472797B6E3F28733D722E617474722822696422292C6F3D242E6D616B65417272617928722E66696E6428223A696E7075743A76697369626C653A636865636B656422292E6D6170286675';
wwv_flow_api.g_varchar2_table(4) := '6E6374696F6E28297B72657475726E20746869732E76616C75657D29292E6A6F696E28223A2229293A697C7C743F28733D722E706172656E747328226669656C6473657422292E666972737428292E617474722822696422292C6F3D242E6D616B654172';
wwv_flow_api.g_varchar2_table(5) := '72617928722E706172656E747328226669656C6473657422292E666972737428292E66696E6428223A696E7075743A76697369626C653A636865636B656422292E6D61702866756E6374696F6E28297B72657475726E20746869732E76616C75657D2929';
wwv_flow_api.g_varchar2_table(6) := '2E6A6F696E28223A2229293A28733D722E617474722822696422292C6F3D722E76616C2829292C6C3D24282223222B732B225F6572726F725F706C616365686F6C64657222292C6128292C6C2E656D70747928292C28643D2428223C7370616E3E3C2F73';
wwv_flow_api.g_varchar2_table(7) := '70616E3E2229292E616464436C6173732822666122292C642E616464436C617373282266612D7265667265736822292C642E616464436C617373282266612D616E696D2D7370696E22292C642E6869646528292C6C2E617070656E642864292C6C2E7368';
wwv_flow_api.g_varchar2_table(8) := '6F7728292C6C2E72656D6F7665436C6173732822752D68696464656E22292C642E73686F7728226661737422297D63617463682865297B636F6E736F6C652E6572726F722865297D7472797B242E616A6178287B75726C3A227777765F666C6F772E7368';
wwv_flow_api.g_varchar2_table(9) := '6F77222C747970653A22706F7374222C64617461547970653A226A736F6E222C747261646974696F6E616C3A21302C646174613A7B705F726571756573743A224E41544956453D222B652E616374696F6E2E616A61784964656E7469666965722C705F66';
wwv_flow_api.g_varchar2_table(10) := '6C6F775F69643A2476282270466C6F77496422292C705F666C6F775F737465705F69643A2476282270466C6F7753746570496422292C705F696E7374616E63653A2476282270496E7374616E636522292C705F6172675F6E616D65733A5B735D2C705F61';
wwv_flow_api.g_varchar2_table(11) := '72675F76616C7565733A5B6F5D2C7830313A737D2C737563636573733A66756E6374696F6E28652C722C69297B696628642E68696465282266617374222C66756E6374696F6E28297B642E72656D6F766528297D292C617065782E64656275672865292C';
wwv_flow_api.g_varchar2_table(12) := '313D3D652E76616C69646174696F6E5F726573756C742E706173736564296128293B656C73657B696628226E6F745F666F756E64223D3D652E76616C69646174696F6E5F726573756C742E7061737365642972657475726E20766F696420617065782E64';
wwv_flow_api.g_varchar2_table(13) := '6562756728226C6976652076616C69646174696F6E3A206E6F2076616C69646174696F6E20666F756E6420666F72206974656D203D20222B732B222E22293B76617220743D652E76616C69646174696F6E5F726573756C742E6D6573736167653B216675';
wwv_flow_api.g_varchar2_table(14) := '6E6374696F6E2865297B636F6E736F6C652E6C6F672865292C6C2E656D70747928292C28703D2428223C7370616E3E3C2F7370616E3E2229292E616464436C6173732822742D466F726D2D6572726F7222292C702E68746D6C2865292C702E6869646528';
wwv_flow_api.g_varchar2_table(15) := '292C6C2E617070656E642870292C24282223222B73292E616464436C6173732822617065782D706167652D6974656D2D6572726F7222292C6C2E73686F7728292C702E73686F7728297D28743D742E7265706C616365282F266C743B2F672C223C22292E';
wwv_flow_api.g_varchar2_table(16) := '7265706C616365282F2667743B2F672C223E2229297D7D2C6572726F723A66756E6374696F6E28652C612C72297B636F6E736F6C652E6572726F7228224572726F72206F636375726564207768696C652072657472696576696E6720414A415820646174';
wwv_flow_api.g_varchar2_table(17) := '613A20222B612B225C6E222B72297D7D297D63617463682865297B636F6E736F6C652E6572726F722865297D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(8132555563812829902)
,p_plugin_id=>wwv_flow_api.id(8282892867757180115)
,p_file_name=>'live_validation.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
