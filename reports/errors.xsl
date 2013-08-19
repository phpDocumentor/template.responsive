<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="html" />
    <xsl:include href="../layout.xsl" />

    <xsl:template match="/project" mode="contents">
        <xsl:variable name="files" select="file[parse_markers]" />

        <div class="row">
            <div class="span4">
                <ul class="side-nav nav nav-list">
                    <li class="nav-header">Filter type</li>
                    <li>
                        <div class="btn-group type-filter" data-toggle="buttons-checkbox">
                            <button class="btn critical">Critical</button>
                            <button class="btn error">Error</button>
                            <button class="btn notice">Notice</button>
                        </div>
                    </li>
                    <li class="nav-header">Navigation</li>
                    <xsl:apply-templates select="$files" mode="sidebar-nav" />
                </ul>
            </div>

            <div class="span8">
                <ul class="breadcrumb">
                    <li><a href="{$root}"><i class="icon-remove-sign"></i></a><span class="divider">\</span></li>
                    <li>Compilation Errors</li>
                </ul>

                <xsl:if test="count(file/parse_markers) &lt; 1">
                    <div class="alert alert-info">No errors have been found in this project.</div>
                </xsl:if>

                <div id="marker-accordion">
                    <xsl:apply-templates select="$files" mode="contents" />
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="file" mode="sidebar-nav">
        <li>
            <a href="#{@path}">
                <i class="icon-file"></i>
                <xsl:value-of select="@path" />
            </a>
        </li>
    </xsl:template>

    <xsl:template match="file" mode="contents">
        <xsl:variable name="item" select="parse_markers/*" />

        <a name="{@path}" id="{@path}"></a>
        <h3>
            <i class="icon-file"></i>
            <xsl:value-of select="@path" />
            <small style="float: right;padding-right: 10px;">
                <xsl:value-of select="count($item)" />
            </small>
        </h3>
        <div>
            <table class="table markers table-bordered">
                <thead>
                    <tr>
                        <th>Type</th>
                        <th>Line</th>
                        <th>Description</th>
                    </tr>
                </thead>

                <tbody>
                    <xsl:apply-templates select="$item" mode="tabular">
                        <xsl:sort select="@line" data-type="number"/>
                    </xsl:apply-templates>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="*" mode="tabular">
        <tr>
            <xsl:if test="name() = 'tag'">
                <xsl:attribute name="class">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <td>
                    <xsl:value-of select="@name" />
                </td>
            </xsl:if>
            <xsl:if test="name() != 'tag'">
                <xsl:attribute name="class">
                    <xsl:value-of select="name()" />
                </xsl:attribute>
                <td>
                    <xsl:value-of select="name()" />
                </td>
            </xsl:if>
            <td>
                <xsl:value-of select="@line" />
            </td>
            <xsl:if test="name() = 'tag'">
                <td>
                    <xsl:value-of select="@description" disable-output-escaping="yes" />
                </td>
            </xsl:if>
            <xsl:if test="name() != 'tag'">
                <td>
                    <xsl:value-of select="." disable-output-escaping="yes" />
                </td>
            </xsl:if>
        </tr>
    </xsl:template>

</xsl:stylesheet>