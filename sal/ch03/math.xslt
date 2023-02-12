<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes"
xmlns:ckbk="http://www.oreilly.com/catalog/xsltckbk">
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

   <xsl:template match="/">
     <tests>

       <test result="120"><xsl:value-of select="ckbk:factorial(5)"/></test>
       <test result="120"><xsl:value-of select="ckbk:prod( (1 to 5) )"/></test>
 
       <test result="4"><xsl:value-of select="ckbk:power(2,2)"/></test>
       <test result="57.6650390625"><xsl:value-of select="ckbk:power(1.5,10)"/></test>
       <test result="4"><xsl:value-of select="ckbk:power(-2,2)"/></test>
       <test result="-38.443359375"><xsl:value-of select="ckbk:power(-1.5,9)"/></test>
       <test result="4"><xsl:value-of select="ckbk:power(2,-2)"/></test>
       <test result="57.6650390625"><xsl:value-of select="ckbk:power(1.5,-10)"/></test>
       <test result="4"><xsl:value-of select="ckbk:power(-2,-2)"/></test>
       <test result="-38.443359375"><xsl:value-of select="ckbk:power(-1.5,-9)"/></test>

       <!--sqrt -->
       <test result="2.0" tolerance="0"><xsl:value-of select="ckbk:sqrt(4.0)"/></test>
       <test result="4.0" tolerance="0"><xsl:value-of select="ckbk:sqrt(16.0)"/></test>

       <!--log10 -->
       <test result="1" tolerance="0"><xsl:value-of select="ckbk:log10(10)"/></test>
       <test result="2" tolerance="0"><xsl:value-of select="ckbk:log10(1e2)"/></test>
       <test result="1.079181246" tolerance="0"><xsl:value-of select="ckbk:log10(12)"/></test>
       <test result="-1" tolerance="0"><xsl:value-of select="ckbk:log10(1e-1)"/></test>

       <test desc="ckbk:variance( () )" result="0"><xsl:value-of select="ckbk:variance( () )"/></test>
       <test desc="ckbk:variance( (1) )" result="0"><xsl:value-of select="ckbk:variance( (1) )"/></test>
       <test result="0"><xsl:value-of select="ckbk:variance( (1,1) )"/></test>
       <test result="1"><xsl:value-of select="ckbk:variance( (1,2) )"/></test>
    

       <test desc="ckbk:median( (2,1,2) )"><xsl:value-of select="ckbk:median( (2,1,2) )"/></test>
       <test desc="ckbk:median( (2,1,1,2) )"><xsl:value-of select="ckbk:median( (2,1,1,2) )"/></test>
       <test desc="ckbk:median( () )"><xsl:value-of select="ckbk:median( () )"/></test>
       <test desc="ckbk:median( (1) )"><xsl:value-of select="ckbk:median( (1) )"/></test>
       <test desc="ckbk:median( (8,8,8,3,3,3,7,7,7,1,7,8,3,3,3,3) )"><xsl:value-of select="ckbk:median( (8,8,8,3,3,3,7,7,7,1,7,8,3,3,3,3) )"/></test>

    
       <test desc="ckbk:mode( (2,1,2) )"><xsl:value-of select="ckbk:mode( (2,1,2) )"/></test>
       <test desc="ckbk:mode( (2,1,1,2) )"><xsl:value-of select="ckbk:mode( (2,1,1,2) )"/></test>
       <test desc="ckbk:mode( () )"><xsl:value-of select="ckbk:mode( () )"/></test>
       <test desc="ckbk:mode( (1) )"><xsl:value-of select="ckbk:mode( (1) )"/></test>
       <test desc="ckbk:mode( (8,8,8,3,3,3,7,7,7,1,7,8,3,3,3,3) )"><xsl:value-of select="ckbk:mode( (8,8,8,3,3,3,7,7,7,1,7,8,3,3,3,3) )"/></test>

       <test desc="ckbk:P(2,5)" result="30"><xsl:value-of select="ckbk:P(2,5)"/></test> 
       <test desc="ckbk:C(2,5)" result="10"><xsl:value-of select="ckbk:C(2,5)"/></test> 
           
      
     </tests>
     
  </xsl:template>
  
  <xsl:function name="ckbk:sum-of-squares">
    <xsl:param name="input" as="xs:integer *"/>
    <xsl:sequence select="sum(for $x in $input return $x * $x)"/>
</xsl:function> 


  <xsl:function name="ckbk:factorial" as="xs:decimal">
     <xsl:param name="n" as="xs:integer"/>
     <xsl:sequence select="if ($n eq 0) then 1 else $n * ckbk:factorial($n - 1)"/> 
  </xsl:function>

  <xsl:function name="ckbk:prod-range" as="xs:decimal">
     <xsl:param name="from" as="xs:integer"/>
     <xsl:param name="to" as="xs:integer"/>
     <xsl:sequence select="if ($from ge $to) then $from else $from * ckbk:prod-range($from + 1, $to)"/> 
  </xsl:function>

   <xsl:function name="ckbk:prod" as="xs:double">
     <xsl:param name="numbers" as="xs:double*"/>
     <xsl:sequence select="if (count($numbers) eq 0) then 0
                           else if (count($numbers) = 1) then $numbers[1]
                           else $numbers[1] * ckbk:prod(subsequence($numbers,2))"/> 
   </xsl:function>
 
  <xsl:function name="ckbk:power" as="xs:double">
    <xsl:param name="base" as="xs:double"/>
    <xsl:param name="exp" as="xs:integer"/>
    <xsl:sequence select="if ($exp lt 0) then ckbk:power(1.0 div $base, -$exp) 
                          else if ($exp eq 0) then 1e0 else $base * ckbk:power($base, $exp - 1)"/>
  </xsl:function>


  <xsl:function name="ckbk:sqrt" as="xs:double">
    <xsl:param name="number" as="xs:double"/>
    <xsl:variable name="try" select="if ($number lt 100.0) then 1.0
                                     else if ($number gt 100.0 and $number lt 1000.0) then 10.0
                                     else if ($number gt 1000.0 and $number lt 10000.0) then 31.0
                                     else 100.00" as="xs:decimal"/>
                                      
    <xsl:sequence select="if ($number ge 0) then ckbk:sqrt($number,$try,1,20) 
                          else 'NaN'"/>
  </xsl:function>
  

  <xsl:function name="ckbk:sqrt" as="xs:double">

    <xsl:param name="number" as="xs:double"/>
    <xsl:param name="try" as="xs:double"/>
    <xsl:param name="iter" as="xs:integer"/>
    <xsl:param name="maxiter" as="xs:integer"/>
    
    <xsl:variable name="result" select="$try * $try" as="xs:double"/>
    <xsl:sequence select="if ($result eq $number or $iter gt $maxiter) 
                          then $try 
                          else ckbk:sqrt($number, ($try - (($result - $number) div (2 * $try))), $iter + 1, $maxiter)"/>
    </xsl:function>
    
    
  <xsl:function name="ckbk:log10" as="xs:double">
    <xsl:param name="number" as="xs:double"/>
    <xsl:sequence select="if ($number le 0) then 'NaN' else ckbk:log10($number,0)"/>
  </xsl:function>
  
  <xsl:function name="ckbk:log10" as="xs:double">
    <xsl:param name="number" as="xs:double"/>
    <xsl:param name="n" as="xs:double"/>
    <xsl:sequence select="if ($number le 1) 
                          then ckbk:log10($number * 10, $n - 1) 
                          else if($number gt 10) 
                          then ckbk:log10($number div 10, $n + 1)
                          else if($number eq 10) 
                          then $n + 1
                          else $n + ckbk:log10-util($number,0,0,2,38)"/>
  </xsl:function>
    
  <xsl:function name="ckbk:log10-util" as="xs:double">
    <xsl:param name="number" as="xs:double"/>
    <xsl:param name="frac" as="xs:double"/>
    <xsl:param name="iter" as="xs:integer"/>
    <xsl:param name="divisor" as="xs:double"/>
    <xsl:param name="maxiter" as="xs:integer"/>
    
    <xsl:variable name="x" select="$number * $number"/>

    <xsl:sequence select="if ($iter ge $maxiter)
                          then round-half-to-even($frac,10)
                          else if ($x lt 10)
                          then ckbk:log10-util($x,$frac,$iter + 1, $divisor * 2, $maxiter)
                          else ckbk:log10-util($x div 10,$frac + (1 div $divisor),$iter + 1, $divisor * 2, $maxiter)"/>
  </xsl:function>
  
  <xsl:function name="ckbk:median">
  <xsl:param name="nodes" as="xs:double*" />
  
  <xsl:variable name="count" select="count($nodes)"/>
  <xsl:variable name="middle" select="ceiling($count div 2)"/>
   
  <xsl:variable name="sorted" as="xs:double*">
    <xsl:perform-sort select="$nodes">
      <xsl:sort data-type="number"/>
    </xsl:perform-sort>
  </xsl:variable>
   
  <xsl:sequence select="if ($count mod 2 eq 0) 
                        then avg(subsequence($sorted,$middle,2)) 
                        else $sorted[$middle]"/>
 </xsl:function>

  <xsl:function name="ckbk:variance" as="xs:double">
    <xsl:param name="nodes" as="xs:double*"/>
    <xsl:variable name="sum" select="sum($nodes)"/>
    <xsl:variable name="count" select="count($nodes)"/>
    <xsl:sequence select="if ($count lt 2) 
                          then 0 
                          else sum(for $i in $nodes return $i * $i) - 
                               ($sum * $sum) div  ($count * $count - $count)"/>
  </xsl:function>

  <xsl:function name="ckbk:mode" as="item()*">
    <xsl:param name="nodes" as="item()*"/>
    <xsl:variable name="distinct" select="distinct-values($nodes)" as="item()*"/>
    <xsl:variable name="counts" select="for $i in $distinct return count($nodes[. = $i])" as="xs:integer*"/>
    <xsl:variable name="max" select="max($counts)" as="xs:integer?"/>
    <xsl:sequence select="$distinct[position() = index-of($counts,$max)]"/>
   </xsl:function>
    
    
  <xsl:function name="ckbk:P" as="xs:decimal">
    <xsl:param name="r" as="xs:integer"/>
    <xsl:param name="n" as="xs:integer"/>
    <xsl:sequence select="if ($n eq 0) then 0 else ckbk:prod-range($r + 1, $n)"/>
  </xsl:function>
   
  <xsl:function name="ckbk:C" as="xs:decimal">
    <xsl:param name="r" as="xs:integer"/>
    <xsl:param name="n" as="xs:integer"/>
    <xsl:variable name="min" select="min( ($r, $n - $r) )" as="xs:integer"/>
    <xsl:variable name="max" select="max( ($r, $n - $r) )" as="xs:integer"/>
    <xsl:sequence select="if ($n eq 0) then 0 
                          else ckbk:prod-range($max + 1, $n) div 
                               ckbk:factorial($min)"/>
  </xsl:function>
  
    
</xsl:stylesheet>
