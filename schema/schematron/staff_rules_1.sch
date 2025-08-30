<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:title>Business Rules for Staff Roster</sch:title>

  <sch:pattern>
    <sch:title>Manager and Associate Rules</sch:title>

    <sch:rule context="employee[@role='manager']">
      <sch:assert test="department != 'Support'">
        A manager cannot be in the Support department. This one is in the '
        <sch:value-of select="department"/>' department.
      </sch:assert>
    </sch:rule>

    <sch:rule context="employee[@role='associate']">
      <sch:assert test="bonus &lt;= 5000">
        An associate's bonus must not exceed 5000. This associate's bonus is 
        <sch:value-of select="bonus"/>.
      </sch:assert>
    </sch:rule>

  </sch:pattern>
</sch:schema>
