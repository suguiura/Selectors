<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="//div[@id='project-details']/h2">
  <xsl:if test=". = $NAME">
    <xsl:for-each select="following::div[1]/a">
      <xsl:value-of select="."/>
      <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates select="//div[@id='project-details']/h2"/>
</xsl:template>

</xsl:stylesheet>
