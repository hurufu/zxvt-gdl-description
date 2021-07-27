<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="width" select="400"/>
  <xsl:param name="height" select="400"/>
  <xsl:template match="/">
    <html>
      <head>
        <title>Capture of the Territory</title>
        <style type="text/css" media="all">
          td {
            width: <xsl:value-of select="$width * 0.333"/>px;
            height: <xsl:value-of select="$height * 0.333"/>px;
            border: 2px solid #000;
            font-size: <xsl:value-of select="$width * 0.6 * 0.333"/>px;
            text-align: center;
            font-weight: bold;
            align: center;
          }
          td[ownership="red"] {
            background-color: #990000;
          }
          td[ownership="blue"] {
            background-color: #000099;
          }
          td[ownership="wild"] {
            background-color: #CCCCCC;
          }
          td[occupation="red"] {
            color: #CC0000;
          }
          td[occupation="blue"] {
            color: #0000CC;
          }
          samp.red {
            color: #CC0000;
          }
          samp.blue {
            color: #0000CC;
          }
          table.board {
            background-color: #000000;
          }</style>
      </head>
      <body>
        <xsl:apply-templates select="state"/>
        <div>
          <xsl:text>Control: </xsl:text>
          <samp>
            <xsl:attribute name="class">
              <xsl:value-of select="state/fact[relation = 'control']/argument"/>
            </xsl:attribute>
            <xsl:value-of select="state/fact[relation = 'control']/argument"/>
          </samp>
        </div>
      </body>
    </html>
  </xsl:template>
  <!---->
  <xsl:template match="state">
    <table class="board">
      <xsl:for-each select="fact[relation = 'cell']">
        <xsl:sort select="argument[relation = 'rc']/argument[1]"/>
        <xsl:sort select="argument[relation = 'rc']/argument[2]"/>
        <xsl:if test="(position() mod 3) = 1">
          <tr>
            <xsl:variable name="row">
              <xsl:value-of select="argument[relation = 'rc']/argument[1]"/>
            </xsl:variable>
            <xsl:for-each select="//fact[relation = 'cell' and argument[relation = 'rc' and argument[1] = $row]]">
              <xsl:sort select="argument[relation = 'rc']/argument[2]"/>
              <td>
                <xsl:attribute name="id">
                  <xsl:value-of select="argument[relation = 'rc']/argument[1]"/>
                  <xsl:value-of select="argument[relation = 'rc']/argument[2]"/>
                </xsl:attribute>
                <xsl:apply-templates select="argument[relation='situation']" mode="cell"/>
              </td>
            </xsl:for-each>
          </tr>
        </xsl:if>
      </xsl:for-each>
    </table>
  </xsl:template>
  <!---->
  <xsl:template match="argument[argument='nobody']" mode="cell">
    <xsl:attribute name="occupation">nobody</xsl:attribute>
    <xsl:apply-templates select="argument[relation='on']" mode="cell"/>
  </xsl:template>
  <!---->
  <xsl:template match="argument[argument/relation='army']" mode="cell">
    <xsl:attribute name="occupation">
      <xsl:value-of select="argument/argument[relation='of']/argument"/>
    </xsl:attribute>
    <xsl:apply-templates select="argument[relation='on']" mode="cell"/>
    <xsl:value-of select="argument/argument[relation='count']/argument"/>
  </xsl:template>
  <!---->
  <xsl:template match="argument[relation='on']" mode="cell">
    <xsl:attribute name="tile">
      <xsl:value-of select="argument[1]"/>
    </xsl:attribute>
    <xsl:apply-templates select="argument[2]" mode="cell"/>
  </xsl:template>
  <!---->
  <xsl:template match="argument[text()='wild']" mode="cell">
    <xsl:attribute name="ownership">wild</xsl:attribute>
  </xsl:template>
  <xsl:template match="argument[relation='owned_by']" mode="cell">
    <xsl:attribute name="ownership">
      <xsl:value-of select="argument"/>
    </xsl:attribute>
  </xsl:template>
  <!--
  Only used for debugging
  https://stackoverflow.com/a/15783514
  -->
  <xsl:template match="*" mode="serialize">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:apply-templates select="@*" mode="serialize"/>
    <xsl:choose>
      <xsl:when test="node()">
        <xsl:text>&gt;</xsl:text>
        <xsl:apply-templates mode="serialize"/>
        <xsl:text>&lt;/</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> /&gt;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="@*" mode="serialize">
    <xsl:text> </xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>="</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
  </xsl:template>
  <xsl:template match="text()" mode="serialize">
    <xsl:value-of select="."/>
  </xsl:template>
</xsl:stylesheet>
