<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dm="http://azure.workflow.datamapper" xmlns:ef="http://azure.workflow.datamapper.extensions" xmlns="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xsl xs math dm ef" version="3.0" expand-text="yes">
  <xsl:output indent="yes" media-type="text/json" method="text" omit-xml-declaration="yes" />
  <xsl:template match="/">
    <xsl:variable name="xmlinput" select="json-to-xml(/)" />
    <xsl:variable name="xmloutput">
      <xsl:apply-templates select="$xmlinput" mode="azure.workflow.datamapper" />
    </xsl:variable>
    <xsl:value-of select="xml-to-json($xmloutput,map{'indent':true()})" />
  </xsl:template>
  <xsl:template match="/" mode="azure.workflow.datamapper">
    <map>
      <xsl:choose>
        <xsl:when test="local-name-from-QName(node-name(/*/*[@key='order']/*[@key='reference'])) = 'null'">
          <null key="external_order_reference" />
        </xsl:when>
        <xsl:otherwise>
          <string key="external_order_reference">{/*/*[@key='order']/*[@key='reference']}</string>
        </xsl:otherwise>
      </xsl:choose>
      <string key="created_at">{concat(/*/*[@key='situation']/*[@key='registrationDate'], '$TZT')}</string>
      <string key="event_type">{ef:event-mapping(/*/*[@key='situation']/*[@key='event'])}</string>
      <string key="occured_at">{concat(/*/*[@key='situation']/*[@key='actualDate'], '$TZT')}</string>
      <string key="source">{string('BROKER')}</string>
      <map key="location">
        <xsl:choose>
          <xsl:when test="not(local-name-from-QName(node-name(/*/*[@key='situation']/*[@key='position'])) = 'null')">
            <xsl:choose>
              <xsl:when test="local-name-from-QName(node-name(/*/*[@key='situation']/*[@key='position']/*[@key='locationReference'])) = 'null'">
                <null key="code" />
              </xsl:when>
              <xsl:otherwise>
                <string key="code">{/*/*[@key='situation']/*[@key='position']/*[@key='locationReference']}</string>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="not(local-name-from-QName(node-name(/*/*[@key='situation']/*[@key='position'])) = 'null')">
            <xsl:choose>
              <xsl:when test="local-name-from-QName(node-name(/*/*[@key='situation']/*[@key='position']/*[@key='latitude'])) = 'null'">
                <null key="latitude" />
              </xsl:when>
              <xsl:otherwise>
                <number key="latitude">{/*/*[@key='situation']/*[@key='position']/*[@key='latitude']}</number>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="not(local-name-from-QName(node-name(/*/*[@key='situation']/*[@key='position'])) = 'null')">
            <xsl:choose>
              <xsl:when test="local-name-from-QName(node-name(/*/*[@key='situation']/*[@key='position']/*[@key='longitude'])) = 'null'">
                <null key="longitude" />
              </xsl:when>
              <xsl:otherwise>
                <number key="longitude">{/*/*[@key='situation']/*[@key='position']/*[@key='longitude']}</number>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </map>
    </map>
  </xsl:template>
  <xsl:function name="ef:event-mapping" as="xs:string">
    <xsl:param name="eventType" as="xs:string" />
    <xsl:value-of select="         let $eventMap := map{           'ORDER_CREATED':'BOOKED',           'DRIVING_TO_LOAD':'DISPATCHED',           'ORDER_LOADED':'PICKED_UP',           'ETA_EVENT':'ETA_CHANGED',           'ORDER_DELIVERED':'DELIVERED',           'CANCEL_ORDER':'CANCELLED'         }         return $eventMap($eventType)       " />
  </xsl:function>
</xsl:stylesheet>