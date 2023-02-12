<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes">


<!-- Draw a graduated X-Axis -->
<xsl:template name="svgu:xAxis">
    <xsl:param name="min" 
               select="0" as="xs:double"/>   <!-- Min x coordinate -->
    <xsl:param name="max" 
               select="100" as="xs:double"/> <!-- Max x coordinate -->
    <xsl:param name="offsetX" 
               select="0" as="xs:double"/>   <!-- X offset of axis placement -->
    <xsl:param name="offsetY" 
               select="0" as="xs:double"/>   <!-- Y offset of axis placement -->
    <xsl:param name="width" 
               select="500" as="xs:double"/> <!-- Width of the physical 
                                                plotting area -->
    <xsl:param name="height" 
               select="500" as="xs:double"/> <!-- Height of the physical plotting area -->  
    <xsl:param name="majorTicks" 
               select="10" as="xs:double"/>     <!-- Number of major axis divisions -->
    <xsl:param name="majorBottomExtent" 
               select="4" as="xs:double"/>      <!-- Length of the major tick mark from 
                                      axis downward -->
    <xsl:param name="majorTopExtent" 
               select="$majorBottomExtent" as="xs:double"/> <!-- Length of the major tick 
                                                  mark from axis upward -->
    <xsl:param name="labelMajor" 
               select="true()" as="xs:boolean"/> <!-- Label the major tick marks if 
                                      true -->
    <xsl:param name="minorTicks" 
               select="4" as="xs:integer"/>      <!-- Number of minor axis divisions per 
                                      major division-->
    <xsl:param name="minorBottomExtent" 
               select="2" as="xs:double"/>      <!-- Length of the minor tick mark from 
                                      axis downward -->
    <xsl:param name="minorTopExtent" 
               select="$minorBottomExtent" as="xs:double"/> <!-- Length of the minor tick 
                                                  mark from axis upward -->
    <xsl:param name="context" as="xs:item"/>   <!-- A user defined context indicator for 
                                       formatting template calls. -->
    
    <!-- Compute the range and scaling factors -->
    <xsl:variable name="range" select="$max - $min" as="xs:double"/>
    <xsl:variable name="scale" select="$width div $range" as="xs:double"/>
    
    <!-- Establish a Cartesian coordinate system with correct offset -->
    <!-- and scaling                                                 -->
    <svg:g transform="translate({$offsetX},{$offsetY+$height}) 
                  scale({$scale},-1) translate({$min},0)">
      <!-- Draw a line for the axis -->
      <svg:line x1="{$min}" y1="0" x2="{$max}"  y2="0">
        <xsl:attribute name="style">
         <!-- Call a template that can be overridden to -->
         <!-- determine the axis style -->
          <xsl:call-template name="xAxisStyle">
            <xsl:with-param name="context" select="$context"/>
          </xsl:call-template>
        </xsl:attribute>
      </svg:line>
   
      <!-- Draw the tick marks and labels -->
      <xsl:call-template name="svgu:ticks">
        <xsl:with-param name="xMajor1" select="$min" as="xs:double"/>
        <xsl:with-param name="yMajor1" select="$majorTopExtent" as="xs:double"/>
        <xsl:with-param name="xMajor2" select="$min" as="xs:double"/>
        <xsl:with-param name="yMajor2" select="-$majorBottomExtent" as="xs:double"/>
        <xsl:with-param name="labelMajor" select="$labelMajor" as="xs:double"/>
        <xsl:with-param name="freq" select="$minorTicks" as="xs:integer"/>
        <xsl:with-param name="xMinor1" select="$min" as="xs:double"/>
        <xsl:with-param name="yMinor1" select="$minorTopExtent" as="xs:double"/>
        <xsl:with-param name="xMinor2" select="$min" as="xs:double"/>
        <xsl:with-param name="yMinor2" select="-$minorBottomExtent" as="xs:double"/>
        <xsl:with-param name="nTicks" 
                        select="$majorTicks * $minorTicks + 1" as="xs:integer"/>
        <xsl:with-param name="xIncr" 
             select="($max - $min) div ($majorTicks * $minorTicks)" as="xs:double"/>
        <xsl:with-param name="scale" select="1 div $scale" as="xs:double"/>
      </xsl:call-template>
    </svg:g>
    
   </xsl:template>
   
  <xsl:template name="svgu:yAxis">
    <xsl:param name="min" 
               select="0" as="xs:double"/>   <!-- Min x coordinate -->
    <xsl:param name="max" 
               select="100" as="xs:double"/> <!-- Max x coordinate -->
    <xsl:param name="offsetX" 
               select="0" as="xs:double"/>   <!-- X offset of axis placement -->
    <xsl:param name="offsetY" 
               select="0" as="xs:double"/>   <!-- Y offset of axis placement -->
    <xsl:param name="width" 
               select="500" as="xs:double"/> <!-- Width of the physical 
                                                plotting area -->
    <xsl:param name="height" 
               select="500" as="xs:double"/> <!-- Height of the physical plotting area -->  
    <xsl:param name="majorTicks" 
               select="10" as="xs:integer"/>     <!-- Number of major axis divisions -->
    <xsl:param name="majorLeftExtent" 
               select="4" as="xs:integer"/>      <!-- Length of the major tick mark from 
                                      axis downward -->
    <xsl:param name="majorRightExtent" 
               select="$majorBottomExtent" as="xs:double"/> <!-- Length of the major tick 
                                                  mark from axis upward -->
    <xsl:param name="labelMajor" 
               select="true()"  as="xs:boolean"/> <!-- Label the major tick marks if 
                                      true -->
    <xsl:param name="minorTicks" 
               select="4"  as="xs:integer"/>      <!-- Number of minor axis divisions per 
                                      major division-->
    <xsl:param name="minorLeftExtent" 
               select="2" as="xs:double"/>      <!-- Length of the minor tick mark from 
                                      axis right -->
    <xsl:param name="minorRightExtent" 
               select="$minorBottomExtent" as="xs:double"/> <!-- Length of the minor tick 
                                                  mark from axis left -->
    <xsl:param name="context" as="xs:item"/>   <!-- A user defined context indicator for 
                                       formatting template calls -->
   
    <xsl:param name="majorLeftExtent" 
               select="4"  as="xs:double"/>
    <xsl:param name="majorRightExtent" 
               select="$majorLeftExtent" as="xs:double"/>
    <xsl:param name="minorLeftExtent" 
               select="2" as="xs:double"/>
    <xsl:param name="minorRightExtent" 
               select="$minorLeftExtent" as="xs:double"/>
    
    <!-- Compute the range and scaling factors -->
    <xsl:variable name="range" select="$max - $min" as="xs:double"/>
    <xsl:variable name="scale" select="$height div $range" as="xs:double"/>
   
    
    <!-- Establish a Cartesian coordinate system with correct offset -->
    <!-- and scaling                                                 -->
    <svg:g transform="translate({$offsetX},{$offsetY+$height}) 
                  scale(1,{-$scale}) translate(0,{-$min})">
      <svg:line x1="0" y1="{$min}" x2="0"  y2="{$max}">
        <xsl:attribute name="style">
          <xsl:call-template name="yAxisStyle">
            <xsl:with-param name="context" select="$context"/>
          </xsl:call-template>
        </xsl:attribute>
      </svg:line>
   
      <xsl:call-template name="svgu:ticks">
        <xsl:with-param name="xMajor1" select="-$majorLeftExtent"/>
        <xsl:with-param name="yMajor1" select="$min"/>
        <xsl:with-param name="xMajor2" select="$majorRightExtent"/>
        <xsl:with-param name="yMajor2" select="$min"/>
        <xsl:with-param name="labelMajor" select="$labelMajor"/>
        <xsl:with-param name="freq" select="$minorTicks"/>
        <xsl:with-param name="xMinor1" select="-$minorLeftExtent"/>
        <xsl:with-param name="yMinor1" select="$min"/>
        <xsl:with-param name="xMinor2" select="$minorRightExtent"/>
        <xsl:with-param name="yMinor2" select="$min"/>
        <xsl:with-param name="nTicks" 
                        select="$majorTicks * $minorTicks + 1"/>
        <xsl:with-param name="yIncr" 
             select="($max - $min) div ($majorTicks * $minorTicks)"/>
        <xsl:with-param name="scale" select="1 div $scale"/>
      </xsl:call-template>
    </svg:g>
    
   </xsl:template>
   
   <!--Recursive utility for drawing tick marks and labels -->
   <xsl:template name="svgu:ticks">
     <xsl:param name="xMajor1" /> 
     <xsl:param name="yMajor1" />
     <xsl:param name="xMajor2" />
     <xsl:param name="yMajor2" />
     <xsl:param name="labelMajor"/>
     <xsl:param name="freq" />
     <xsl:param name="xMinor1" />
     <xsl:param name="yMinor1" />
     <xsl:param name="xMinor2" />
     <xsl:param name="yMinor2" />
     <xsl:param name="nTicks" select="0"/>
     <xsl:param name="xIncr" select="0"/> 
     <xsl:param name="yIncr" select="0"/> 
     <xsl:param name="i" select="0"/>
     <xsl:param name="scale"/>
     <xsl:param name="context"/>
      
     <xsl:if test="$i &lt; $nTicks">
       <xsl:choose>
         <!-- Time to draw a major tick -->
         <xsl:when test="$i mod $freq = 0">
           <svg:line x1="{$xMajor1}" y1="{$yMajor1}" 
                 x2="{$xMajor2}" y2="{$yMajor2}">
           </svg:line>
           <xsl:if test="$labelMajor">
             <xsl:choose>
              <!-- Ticking along x-axis -->
               <xsl:when test="$xIncr > 0">
                 <!-- Tick label must compensate for distorted coordinate 
                      system -->
                 <svg:text x="{$xMajor1}" y="{$yMajor2}" 
                       transform="translate({$xMajor1},{$yMajor2})
                                  scale({$scale},-1) 
                                  translate({-$xMajor1},{-$yMajor2})">
                          <xsl:attribute name="style">
                            <xsl:call-template name="xAxisLabelStyle">
                              <xsl:with-param name="context"
                                              select="$context"/>
                            </xsl:call-template>
                          </xsl:attribute>
                   <!-- Perhaps label format should be parameter -->
                   <xsl:value-of select="format-number($xMajor1,'#0.0')"/>
                 </svg:text>
               </xsl:when>
              <!-- Ticking along y-axis -->
               <xsl:otherwise>
                 <svg:text x="{$xMajor1}" y="{$yMajor1}" 
                          transform="translate({$xMajor1},{$yMajor1})
                          scale(1,{-$scale}) 
                          translate({-$xMajor1},{-$yMajor1})">
                   <xsl:attribute name="style">
                     <xsl:call-template name="yAxisLabelStyle">
                       <xsl:with-param name="context" select="$context"/>
                     </xsl:call-template>
                   </xsl:attribute>
                   <xsl:value-of select="format-number($yMajor1,'#0.0')"/>
                 </svg:text>
               </xsl:otherwise>
             </xsl:choose>
           </xsl:if>
         </xsl:when>
          <!-- Time to draw a minor tick -->
         <xsl:otherwise>
           <svg:line x1="{$xMinor1}" y1="{$yMinor1}" 
                 x2="{$xMinor2}" y2="{$yMinor2}">
           </svg:line>
         </xsl:otherwise>
       </xsl:choose>
   
        <!-- Recursive call for next tick -->     
       <xsl:call-template name="svgu:ticks">
         <xsl:with-param name="xMajor1" select="$xMajor1 + $xIncr"/>
         <xsl:with-param name="yMajor1" select="$yMajor1 + $yIncr"/>
         <xsl:with-param name="xMajor2" select="$xMajor2 + $xIncr"/>
         <xsl:with-param name="yMajor2" select="$yMajor2 + $yIncr"/>
         <xsl:with-param name="labelMajor" select="$labelMajor"/>
         <xsl:with-param name="freq" select="$freq"/>
         <xsl:with-param name="xMinor1" select="$xMinor1 + $xIncr"/>
         <xsl:with-param name="yMinor1" select="$yMinor1 + $yIncr"/>
         <xsl:with-param name="xMinor2" select="$xMinor2 + $xIncr"/>
         <xsl:with-param name="yMinor2" select="$yMinor2 + $yIncr"/>
         <xsl:with-param name="nTicks" select="$nTicks"/>
         <xsl:with-param name="xIncr" select="$xIncr"/> 
         <xsl:with-param name="yIncr" select="$yIncr"/> 
         <xsl:with-param name="i" select="$i + 1"/>
         <xsl:with-param name="scale" select="$scale"/>
         <xsl:with-param name="context" select="$context"/>
       </xsl:call-template>
     </xsl:if>
      
   </xsl:template>
   
   <!-- Override this template to change x-axis style -->
   <xsl:template name="xAxisStyle">
     <xsl:param name="context"/>
      <xsl:text>stroke-width:0.5;stroke:black</xsl:text>
   </xsl:template>
   
   <!-- Override this template to change y-axis style -->
   <xsl:template name="yAxisStyle">
     <xsl:param name="context"/>
      <xsl:text>stroke-width:0.5;stroke:black</xsl:text>
   </xsl:template>
   
   <!-- Override this template to change x-axis label style -->
   <xsl:template name="xAxisLabelStyle">
     <xsl:param name="context"/>
     <xsl:text>text-anchor:middle; font-size:8; 
               baseline-shift:-110%</xsl:text>
   </xsl:template>
   
   <!-- Override this template to change y-axis label style -->
   <xsl:template name="yAxisLabelStyle">
     <xsl:param name="context"/>
     <xsl:text>text-anchor:end;font-size:8;baseline-shift:-50%</xsl:text>
   </xsl:template>



</xsl:stylesheet>
