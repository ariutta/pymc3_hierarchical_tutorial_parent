<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:bp="http://www.biopax.org/release/biopax-level3.owl#">

  <!--Normalize whitespace by stripping space and and indenting -->
  <xsl:output method="xml" version="1.0" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!--Normalize order of sibling elements -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*">
	<!--TODO are these sort statements needed/correct? -->
        <xsl:sort select="name()"/>
        <xsl:sort select="."/>
	<xsl:attribute name="{@name}">
	  <xsl:value-of select="current()"/>
  	</xsl:attribute>
      </xsl:apply-templates>
      <xsl:apply-templates select="node()">
        <xsl:sort select="name()"/>
        <xsl:sort select="@rdf:about"/>
        <xsl:sort select="@rdf:resource"/>
        <xsl:sort select="@*"/>
        <xsl:sort select="."/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
