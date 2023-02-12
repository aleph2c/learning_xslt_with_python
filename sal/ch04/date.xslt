<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:fn="http://www.w3.org/2004/07/xpath-functions" 
xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes"
xmlns:ckbk="http://www.oreilly.com/catalog/xsltckbk" exclude-result-prefixes="xs fn xdt ckbk">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
 <xsl:template match="/">
 <Dates>
   <dayOfWeek><xsl:value-of select="ckbk:day-of-week(current-date())"/></dayOfWeek>
   <lastDayOfMonth><xsl:value-of select="ckbk:last-day-of-month(2,2004)"/></lastDayOfMonth>
   <lastDayOfMonth><xsl:value-of select="ckbk:last-day-of-month(2,2005)"/></lastDayOfMonth>

   <dayOfWeek><xsl:value-of select="ckbk:get-day-of-the-week-name(0)"/></dayOfWeek>
   <dayOfWeek><xsl:value-of select="ckbk:get-day-of-the-week-name(1)"/></dayOfWeek>
   <dayOfWeek><xsl:value-of select="ckbk:get-day-of-the-week-name(2)"/></dayOfWeek>
   <dayOfWeek><xsl:value-of select="ckbk:get-day-of-the-week-name(3)"/></dayOfWeek>
   <dayOfWeek><xsl:value-of select="ckbk:get-day-of-the-week-name(4)"/></dayOfWeek>
   <dayOfWeek><xsl:value-of select="ckbk:get-day-of-the-week-name(5)"/></dayOfWeek>
   <dayOfWeek><xsl:value-of select="ckbk:get-day-of-the-week-name(6)"/></dayOfWeek>

   <dayOfWeekAbbr><xsl:value-of select="ckbk:get-day-of-the-week-name-abbr(0)"/></dayOfWeekAbbr>
   <dayOfWeekAbbr><xsl:value-of select="ckbk:get-day-of-the-week-name-abbr(1)"/></dayOfWeekAbbr>
   <dayOfWeekAbbr><xsl:value-of select="ckbk:get-day-of-the-week-name-abbr(2)"/></dayOfWeekAbbr>
   <dayOfWeekAbbr><xsl:value-of select="ckbk:get-day-of-the-week-name-abbr(3)"/></dayOfWeekAbbr>
   <dayOfWeekAbbr><xsl:value-of select="ckbk:get-day-of-the-week-name-abbr(4)"/></dayOfWeekAbbr>
   <dayOfWeekAbbr><xsl:value-of select="ckbk:get-day-of-the-week-name-abbr(5)"/></dayOfWeekAbbr>
   <dayOfWeekAbbr><xsl:value-of select="ckbk:get-day-of-the-week-name-abbr(6)"/></dayOfWeekAbbr>

   <month><xsl:value-of select="ckbk:get-month-name(1)"/></month>
   <month><xsl:value-of select="ckbk:get-month-name(2)"/></month>
   <month><xsl:value-of select="ckbk:get-month-name(3)"/></month>
   <month><xsl:value-of select="ckbk:get-month-name(4)"/></month>
   <month><xsl:value-of select="ckbk:get-month-name(5)"/></month>
   <month><xsl:value-of select="ckbk:get-month-name(6)"/></month>
   <month><xsl:value-of select="ckbk:get-month-name(7)"/></month>
   <month><xsl:value-of select="ckbk:get-month-name(8)"/></month>
   <month><xsl:value-of select="ckbk:get-month-name(9)"/></month>
   <month><xsl:value-of select="ckbk:get-month-name(10)"/></month>
   <month><xsl:value-of select="ckbk:get-month-name(11)"/></month>
   <month><xsl:value-of select="ckbk:get-month-name(12)"/></month>

   <monthAbbr><xsl:value-of select="ckbk:get-month-name-abbr(1)"/></monthAbbr>
   <monthAbbr><xsl:value-of select="ckbk:get-month-name-abbr(2)"/></monthAbbr>
   <monthAbbr><xsl:value-of select="ckbk:get-month-name-abbr(3)"/></monthAbbr>
   <monthAbbr><xsl:value-of select="ckbk:get-month-name-abbr(4)"/></monthAbbr>
   <monthAbbr><xsl:value-of select="ckbk:get-month-name-abbr(5)"/></monthAbbr>
   <monthAbbr><xsl:value-of select="ckbk:get-month-name-abbr(6)"/></monthAbbr>
   <monthAbbr><xsl:value-of select="ckbk:get-month-name-abbr(7)"/></monthAbbr>
   <monthAbbr><xsl:value-of select="ckbk:get-month-name-abbr(8)"/></monthAbbr>
   <monthAbbr><xsl:value-of select="ckbk:get-month-name-abbr(9)"/></monthAbbr>
   <monthAbbr><xsl:value-of select="ckbk:get-month-name-abbr(10)"/></monthAbbr>
   <monthAbbr><xsl:value-of select="ckbk:get-month-name-abbr(11)"/></monthAbbr>
   <monthAbbr><xsl:value-of select="ckbk:get-month-name-abbr(12)"/></monthAbbr>
 
   <dateDiff><xsl:value-of select="xs:date('2005-02-21') - xs:date('2005-01-01')"/></dateDiff>

   <julian><xsl:value-of select="ckbk:calculate-julian-day(xs:date('2005-02-21'))"/></julian>
    
    <week><xsl:value-of select="ckbk:calculate-week-number(xs:date('2005-02-21'))"/></week>
    
   </Dates>
 </xsl:template>
  
  <xsl:function name="ckbk:day-of-week" as="xs:integer">
    <xsl:param name="date" as="xs:date"/>
    <xsl:sequence select="xs:integer(format-date(current-date(),'[F1]','en','ISO','us')) - 1"/>
  </xsl:function>
  
  
  <xsl:function name="ckbk:last-day-of-month" as="xs:integer">
    <xsl:param name="month" as="xs:integer"/>
    <xsl:param name="year" as="xs:integer"/>

    <xsl:variable name="date" select="xs:date(concat(xs:string($year),'-',format-number($month,'00'),'-01'))"/>
    <xsl:variable name="m" select="xdt:yearMonthDuration('P1M')" as="xdt:yearMonthDuration"/>
    <xsl:variable name="d" select="xdt:dayTimeDuration('P1D')" as="xdt:dayTimeDuration"/>
 
    <xsl:sequence select="day-from-date(($date + $m) - $d)"/>
   </xsl:function>
   
  <xsl:function name="ckbk:get-day-of-the-week-name" as="xs:string">
    <xsl:param name="day-of-week" as="xs:integer"/>

    <!--Any old sunday will do -->
    <xsl:variable name="aSunday" select="xs:date('2005-02-20')" as="xs:date"/>

    <xsl:sequence select="format-date($aSunday + xdt:dayTimeDuration(concat('P',$day-of-week,'D')), '[F]')"/>
    
  </xsl:function>   


  <xsl:function name="ckbk:get-day-of-the-week-name-abbr" as="xs:string">
    <xsl:param name="day-of-week" as="xs:integer"/>

    <!--Any old sunday will do -->
    <xsl:variable name="aSunday" select="xs:date('2005-02-20')" as="xs:date"/>

    <xsl:sequence select="format-date($aSunday + xdt:dayTimeDuration(concat('P',$day-of-week,'D')), '[FNn,3-3]')"/>
    
  </xsl:function>   
 
  <xsl:function name="ckbk:get-month-name" as="xs:string">
    <xsl:param name="month" as="xs:integer"/>

    <xsl:variable name="jan01" select="xs:date('2005-01-01')" as="xs:date"/>

    <xsl:sequence select="format-date($jan01 + xdt:yearMonthDuration(concat('P',$month - 1,'M')), '[MNn]')"/>
    
  </xsl:function>   


  <xsl:function name="ckbk:get-month-name-abbr" as="xs:string">
    <xsl:param name="month" as="xs:integer"/>

    <xsl:variable name="jan01" select="xs:date('2005-01-01')" as="xs:date"/>

    <xsl:sequence select="format-date($jan01 + xdt:yearMonthDuration(concat('P',$month - 1,'M')), '[MNn,3-3]')"/>    

  </xsl:function>   
   
   
   <xsl:function name="ckbk:calculate-julian-day" as="xs:integer">
     <xsl:param name="date" as="xs:date"/>
     
     <xsl:variable name="year" select="year-from-date($date)"  as="xs:integer"/>
     <xsl:variable name="month" select="month-from-date($date)" as="xs:integer"/>
     <xsl:variable name="day" select="month-from-date($date)" as="xs:integer"/>
   
     <xsl:variable name="a" select="(14 - $month) idiv 12" as="xs:integer"/>
     <xsl:variable name="y" select="$year + 4800 - $a" as="xs:integer"/>
     <xsl:variable name="m" select="$month + 12 * $a - 3" as="xs:integer"/>
   
     <xsl:sequence select="$day + ((153 * $m + 2) idiv 5) + $y * 365 + 
          floor($y div 4) - ($y idiv 100) + ($y idiv 400) - 
          32045"/>
   
  </xsl:function>

<xsl:function name="ckbk:calculate-week-number" as="xs:integer">
  <xsl:param name="date" as="xs:date"/>
  <xsl:sequence select="xs:integer(format-date($date,'[W]'))"/>
</xsl:function>

</xsl:stylesheet>
