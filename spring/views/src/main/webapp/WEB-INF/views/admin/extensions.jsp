<%--

    Copyright (C) 2012-2023 52°North Spatial Information Research GmbH

    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License version 2 as published
    by the Free Software Foundation.

    If the program is linked with libraries which are licensed under one of
    the following licenses, the combination of the program with the linked
    library is not considered a "derivative work" of the program:

        - Apache License, version 2.0
        - Apache Software License, version 1.0
        - GNU Lesser General Public License, version 3
        - Mozilla Public License, versions 1.0, 1.1 and 2.0
        - Common Development and Distribution License (CDDL), version 1.0

    Therefore the distribution of the program linked with libraries licensed
    under the aforementioned licenses, is permitted by the copyright holders
    if the distribution is compliant with both the GNU General Public
    License version 2 and the aforementioned licenses.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
    Public License for more details.

--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../common/header.jsp">
    <jsp:param name="activeMenu" value="admin" />
</jsp:include>

<jsp:include page="../common/logotitle.jsp">
    <jsp:param name="title" value="Configure Extensions" />
    <jsp:param name="leadParagraph" value="Disable or enable extensions" />
</jsp:include>

<link rel="stylesheet" href="<c:url value='/static/lib/jquery.tablesorter-bootstrap-2.712.min.css' />">
<script type="text/javascript" src="<c:url value='/static/lib/jquery.tablesorter-2.7.12.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/static/lib/jquery.tablesorter.widgets-2.7.12.min.js'/>"></script>

<div class="btn-group pull-right">
    <button id="activateAll" class="btn btn-success"><i class="icon-ok-circle icon-white" style="color:#fff;"></i></button>
    <button id="disableAll" class="btn btn-danger"><i class="icon-ban-circle icon-white"></i></button>
</div>

<script type="text/javascript">
jQuery(document).ready(function($) {
    $("#activateAll").on("click", function() {
        $("tbody > tr > td.status > button.btn-danger").each(function(){
            $( this ).click();
        });
    });
    $("#disableAll").on("click", function() {
        $("tbody > tr > td.status > button.btn-success").each(function(){
            $( this ).click();
        });
    });
});
</script>

<table id="extendedCapabilitiesExtensions" class="table table-striped table-bordered">
    <caption>ExtendedCapabilities extensions</caption>
    <thead>
        <tr>
            <th>Service</th>
            <th>Version</th>
            <th>Domain</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody></tbody>
</table>

<table id="offeringExtensionExtensions" class="table table-striped table-bordered">
    <caption>Offering extension extensions</caption>
    <thead>
        <tr>
            <th>Service</th>
            <th>Version</th>
            <th>Domain</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody></tbody>
</table>

<script type="text/javascript">
jQuery(document).ready(function($) {

    $.extend($.tablesorter.themes.bootstrap, {
        table: "table table-bordered",
        header: "bootstrap-header",
        sortNone: "bootstrap-icon-unsorted",
        sortAsc: "icon-chevron-up",
        sortDesc: "icon-chevron-down"
    });

    function extendedCapabilitiesExtensions(extensions) {
        var $tbody = $("#extendedCapabilitiesExtensions tbody"), i, o, $row, $button;
        for (i = 0; i < extensions.length; ++i) {
            o = extensions[i];
            $row = $("<tr>");
            $("<td>").addClass("service").text(o.service).appendTo($row);
            $("<td>").addClass("version").text(o.version).appendTo($row);
            $("<td>").addClass("domain").text(o.extendedCapabilitiesDomain).appendTo($row);
            $button = $("<button>").attr("type", "button")
                    .addClass("btn btn-small btn-block").on("click", function() {
                var $b = $(this),
                    $tr = $b.parents("tr"),
                    active = !$b.hasClass("btn-success"),
                    j = {
                        service: $tr.find(".service").text(),
                        version: $tr.find(".version").text(),
                        extendedCapabilitiesDomain: $tr.find(".domain").text(),
                        active: active
                    };
                $b.prop("disabled", true);
                $.ajax("<c:url value='/admin/extensions/json'/>", {
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(j)
                }).fail(function(e) {
                    showError("Failed to save extended capabilities extension: " 
                        + e.status + " " + e.statusText);
                    $b.prop("disabled", false);
                }).done(function() {
                    $b.toggleClass("btn-danger btn-success")
                      .text(active ? "active" : "inactive")
                      .prop("disabled", false);
                    location.reload();
                });
            });
            if (o.active) { 
                $button.addClass("btn-success").text("active"); 
            } else {
                $button.addClass("btn-danger").text("inactive"); 
                
            }
            $("<td>").addClass("status").append($button).appendTo($row);
            
            $tbody.append($row);    
        }
        
        $("#extendedCapabilitiesExtensions").tablesorter({
            theme : "bootstrap",
            widgets : [ "uitheme", "zebra" ],
            headerTemplate: "{content} {icon}",
            widthFixed: true,
            headers: { 
                0: { sorter: "text" },
                1: { sorter: "text" },
                2: { sorter: "text" },
                3: { sorter: false } 
            },
            sortList: [ [0,0], [1,1], [2,0] ]
        });
    }

    function offeringExtensionExtensions(extensions) {
        var $tbody = $("#offeringExtensionExtensions tbody"), i, o, $row, $button;
        for (i = 0; i < extensions.length; ++i) {
            o = extensions[i];
            $row = $("<tr>");
            $("<td>").addClass("service").text(o.service).appendTo($row);
            $("<td>").addClass("version").text(o.version).appendTo($row);
            $("<td>").addClass("domain").text(o.offeringExtensionDomain).appendTo($row);
            $button = $("<button>").attr("type", "button")
                    .addClass("btn btn-small btn-block").on("click", function() {
                var $b = $(this),
                    $tr = $b.parents("tr"),
                    active = !$b.hasClass("btn-success"),
                    j = {
                        service: $tr.find(".service").text(),
                        version: $tr.find(".version").text(),
                        offeringExtensionDomain: $tr.find(".domain").text(),
                        active: active
                    };
                $b.prop("disabled", true);
                $.ajax("<c:url value='/admin/extensions/json'/>", {
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(j)
                }).fail(function(e) {
                    showError("Failed to save offering extension extension: " 
                        + e.status + " " + e.statusText);
                    $b.prop("disabled", false);
                }).done(function() {
                    $b.toggleClass("btn-danger btn-success")
                      .text(active ? "active" : "inactive")
                      .prop("disabled", false);
                    
                });
            });
            if (o.active) { 
                $button.addClass("btn-success").text("active"); 
            } else {
                $button.addClass("btn-danger").text("inactive"); 
                
            }
            $("<td>").addClass("status").append($button).appendTo($row);
            
            $tbody.append($row);    
        }
                $("#offeringExtensionExtensions").tablesorter({
            theme : "bootstrap",
            widgets : [ "uitheme", "zebra" ],
            headerTemplate: "{content} {icon}",
            widthFixed: true,
            headers: { 
                0: { sorter: "text" },
                1: { sorter: "text" },
                2: { sorter: "text" },
                3: { sorter: false } 
            },
            sortList: [ [0,0], [1,1], [2,0] ]
        });
    }

    $.getJSON("<c:url value='/admin/extensions/json'/>", function(j) {
    	extendedCapabilitiesExtensions(j.extendedCapabilitiesExtensions);
        offeringExtensionExtensions(j.offeringExtensionExtensions);
    });
});
</script>

<jsp:include page="../common/footer.jsp" />
