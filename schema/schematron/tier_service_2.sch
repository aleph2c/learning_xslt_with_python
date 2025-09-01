<?xml version="1.0" encoding="UTF-8"?>
<!--
  We explicitly declare queryBinding="xslt2". This is a best practice that
  tells the compiler exactly what syntax to expect.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

  <sch:title>Service Tier and Speed Limit Rules (XSLT 2.0)</sch:title>

  <!-- Namespace support is identical and works perfectly in XSLT 2.0 -->
  <sch:ns prefix="s" uri="http://www.a_long_stupid_string_that_makes_people_hate_xml.com/v1">

  <sch:pattern>
    <sch:title>Validation of Service Tiers and Speeds</sch:title>

    <sch:rule context="s:service">
      <!--
        Assertion 1: Check that the tier is one of the allowed values.
        This is a simple sequence comparison that works perfectly in XPath 2.0.
      -->
      <sch:assert test="s:tier = ('Free', 'Pro', 'Enterprise')">
        The service tier '<sch:value-of select="s:tier"/>' is invalid.
        Must be one of: 'Free', 'Pro', 'Enterprise'.
      </sch:assert>

      <!--
        XSLT 2.0 FEATURE: The `if (A) then B else C` expression.
        This allows us to define the speed limit dynamically based on the tier.
        This is far more powerful than what is available in XPath 1.0.
      -->
      <sch:let name="allowed_speed" 
               value="if (s:tier = 'Pro') then 100 else 1000"/>

      <sch:assert test="s:max_speed &lt;= $allowed_speed">
        The speed limit for the '<sch:value-of select="s:tier"/>' tier is <sch:value-of select="$allowed_speed"/> Mbps.
        The provided speed of <sch:value-of select="s:max_speed"/> Mbps is too high.
      </sch:assert>

    </sch:rule>
  </sch:pattern>
</sch:schema>
