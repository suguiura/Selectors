<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="http://exslt.org/dynamic"
  xmlns:s="http://exslt.org/strings"
>
<xsl:output method="text" />

<xsl:template name="tag">
  <xsl:param name="header" />
  
  <xsl:variable name="key" select="translate($header, ' :', '-')" />
  <xsl:variable name="value" select="normalize-space(.)" />
    
  <xsl:if test="not(child::*)">
    <xsl:value-of select="concat($key, ' ', $value, '&#xA;')"/>
  </xsl:if>
</xsl:template>

<xsl:template match="//div[@id='project-details']/div">
  <xsl:call-template name="tag">
    <xsl:with-param name="header" select="./preceding-sibling::h2[1]" />
  </xsl:call-template>
</xsl:template>

<xsl:template match="//div[@id='project-details']/div/a">
  <xsl:call-template name="tag">
    <xsl:with-param name="header" select="../preceding-sibling::h2[1]" />
  </xsl:call-template>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates select="//div[@id='project-details']/div" />
  <xsl:apply-templates select="//div[@id='project-details']/div/a" />
</xsl:template>

</xsl:stylesheet>
