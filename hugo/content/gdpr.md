---
title     : Neo4J visualisation of RISK
type      : neo4j
layout    : simple
#cypher   : MATCH (n)-[r]->(m) RETURN n,r,m Limit 40
#cypher   : MATCH (n:RISK {key:'RISK-217'}) MATCH path = (n)-[a]-(p)-[:is_child_of*1..12]-(v) return path limit 10
#cypher   : MATCH (n {key:'RISK-235'}) MATCH path = (n)-[:is_child_of*1..5]-(v:RISK) return path
cypher    : MATCH (n {key:'GDPR-261'}) MATCH path = (n)-[m*1..2]-(v) return path
root_Node : GDPR-261
gravity   : -1500
labels  :
    ISSUE:
        caption: key
        color  : lightgray
        #image  : https://jira.photobox.com/secure/viewavatar?size=xsmall&avatarId=13544&avatarType=issuetype
    RISK:
        caption: key
        #image  : https://jira.photobox.com/secure/viewavatar?size=xsmall&avatarId=13534&avatarType=issuetype
    Risk_Service:
        caption: key
        #image  : https://jira.photobox.com/secure/viewavatar?size=xsmall&avatarId=13545&avatarType=issuetype
    Risk_Taxonomy:
        caption: key
        #image  : https://jira.photobox.com/secure/viewavatar?size=xsmall&avatarId=13538&avatarType=issuetype

    Data_Journey:
        caption: key
        image  : /img/osa/osa_lifecycle.png
relationships:
    is_parent_of:
        label : parent
    is_child_of:
        label : child
        arrow : true
    relates_to:
        label : relates


---

This is a Neovis graph on RISKs  (with options from defined in an
hugo markdown file )