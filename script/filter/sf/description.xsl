<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:output method="text" />

<xsl:template match="//p[@id='pd-txt']">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates select="//p[@id='pd-txt']"/>
</xsl:template>

</xsl:stylesheet>
