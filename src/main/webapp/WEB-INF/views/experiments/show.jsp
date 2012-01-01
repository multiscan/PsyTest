<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%@ include file="../../../html/libraries.html"%>

<script type="text/javascript">
       Ext.onReady(function() {
               Ext.QuickTips.init();

               new Ext.ux.Carousel('storys', {

               transitionEasing: 'easeIn'
               });
       });
</script>
</head>
<body>

       <h1>
               <c:out escapeXml='false' value="${experiment.subjectName}" />
       </h1>

       <div id="storys"
               style="padding: 5px; height: 280px; width: 420px; background-color: #E6E6E0">
               <c:forEach items="${experiment.stories}" var="story">
                       <c:forEach items="${story.slides}" var="slide">
                               <img
                                       src="../uploadedFiles/<c:out escapeXml='false' value="${slide.fileName}"/>"
                                       title="<c:out escapeXml='false' value="${slide.description}"/>"
                                       height="280px" width="420px">
                       </c:forEach>                        
               </c:forEach>
       </div>

</body>
</html>