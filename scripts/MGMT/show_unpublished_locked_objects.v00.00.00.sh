#!/bin/bash
#

psql_client cpm postgres -c "select obj.name,obj.objid,obj.dlesession,dom.name as "Domain" from dleobjectderef_data as obj, domainbase_data as dom where obj.objid in (select lockedobjid from locknonos) and obj.dlesession>0 and obj.domainid=dom.objid and not dom.deleted and dom.dlesession=0;"
