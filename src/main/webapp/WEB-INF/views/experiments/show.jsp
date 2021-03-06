<%@page import="ch.epfl.psytest.domain.Response"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%@ include file="../../../html/libraries.html"%>

<script type="text/javascript">
  var storyOrder = "";
  var questionChoicesOrder = "";
  document.addEventListener('DOMContentLoaded', function() {
    var swipesArray = new Array();
    var storyTitles = new Array();
    var i = 0;
    /* var currentSlideIndex = <c:out escapeXml='false' value="${currentSlideIndex}"/>;
    var controlSlidesIndices = <c:out escapeXml='false' value="${controlSlideIndices}"/>; */
    
    /* <c:forEach items="${experiment.experimentSession.stories}" var="story">
    swipesArray[i] = Code.PhotoSwipe.attach(window.document
        .querySelectorAll('#story<c:out escapeXml='false' value="${story.id}"/> a'), {
      enableMouseWheel : false,
      enableKeyboard : true,
      allowUserZoom : false,
      loop : false,
      captionAndToolbarAutoHideDelay : 0
    });
    storyTitles[i] = '<c:out escapeXml='false' value="${story.title}"/>';
    ++i;
    $('#story<c:out escapeXml='false' value="${story.id}"/> li').hide().filter(':lt(1)').show();
    </c:forEach> */

    /* $('#storys').anythingSlider({
      resizeContents : false, // If true, solitary images/objects in the panel will expand to fit the viewport
      navigationSize : 3, // Set this to the maximum number of visible navigation tabs; false to disable
      navigationFormatter : function(index, panel) { // Format navigation labels with text
        return storyTitles[index - 1];
      },
      onSlideBegin : function(e, slider) {
        // keep the current navigation tab in view
        slider.navWindow(slider.targetPage);
      }
    }); */

    var storyDialog = $("#storys").dialog({
      height : $(document).height() - 20,
      width : $(document).width() - 20
    });

    $('#start-experiment').click(function() {
      $("#storys").dialog('open');
    });

    var answerIds = new Array();
    var storyIds = new Array();
    var questionIds = new Array();
    var choiceIndexes = new Array();
    var controlQuestionAnswers = new Array();
    var lastControlQuestionAnswer = true;

    var temp = $('#proceed');
    $('#proceed').live('click', function() {
      var nResponsesReceived = 0;
      for ( var i = 0; i < storyIds.length; ++i) {
        $.post('../responses', {
          question : questionIds[i],
          experiment : <c:out escapeXml='false' value="${experiment.id}"/>,
          answer : answerIds[i],
          story : storyIds[i],
          choiceIndexOfAnswer : choiceIndexes[i],
          isControlQuestionAnsweredCorrectly : controlQuestionAnswers[i]
        }, function(data) {
          nResponsesReceived++;
          if (nResponsesReceived >= storyIds.length - 1) {
            window.location.href = "../experiments";
          }
          /* alert(data); */
        });
      }

    });

    $('.question-choice').live('click', function() {
      $(this).addClass('question-choice-checked');
      $(this).siblings('.question-choice-checked').removeClass('question-choice-checked');
      var storyId = $(this).attr('data-story-id');
      var storyIndex = $.inArray(storyId, storyIds);
      var i;
      if (storyIndex != -1) {
        i = storyIndex;
      } else {
        i = storyIds.length;
      }
      answerIds[i] = $(this).attr('data-choice-id');
      storyIds[i] = $(this).attr('data-story-id');
      questionIds[i] = $(this).attr('data-question-id');
      choiceIndexes[i] = $(this).attr('data-choice-index');
      controlQuestionAnswers[i] = lastControlQuestionAnswer;
      lastControlQuestionAnswer = true;

      $(this).siblings('input').attr('checked', false);
      $('#' + $(this).attr('data-radio-id')).attr('checked', true);
    });

    $("#storys").awShowcase({
      content_width : $(document).width() - 20,
      content_height : $(document).height() - 20,
      fit_to_parent : true,
      auto : false,
      interval : 3000,
      continuous : true,
      loading : true,
      arrows : true,
      buttons : true,
      btn_numbers : true,
      keybord_keys : true,
      mousetrace : false,
      pauseonover : true,
      stoponclick : true,
      transition : 'hslide', /* hslide/vslide/fade */
      transition_speed : 500,
      transition_delay : 300,
      show_caption : 'onhover', /* onload/onhover/show */
      viewline : false,
      custom_function : function(current_id, content) {
        var temp = current_id;
        if ($(content).hasClass("control-slide")) {
          $('body').append('<div class="clickable-correct-control"></div>');
          $('body').append('<div class="clickable-incorrect-control"></div>');
          var correctControlDiv = $('.clickable-correct-control');
          var incorrectControlDiv = $('.clickable-incorrect-control');
          var image = $(content).find('img');
          var temp = $('.control-slide');
          var imageWidth = $(temp).find('img').width();
          var imageTop = $(temp).find('img').offset().top;
          var imageLeft = $(temp).find('img').offset().left;
          var imageHeight = $(temp).find('img').height();
          
          var correctControlPositionTop = imageTop;
          var correctControlPositionLeft = $(document).width() - 350;//imageLeft+imageWidth;
          var correctControlHeight = $(document).height()/2; //imageHeight/2;
          var correctControlWidth = $(document).width() - correctControlPositionLeft;
          correctControlDiv.css('position', 'absolute');
          correctControlDiv.css('top', correctControlPositionTop);
          correctControlDiv.css('left', correctControlPositionLeft);
          correctControlDiv.css('height', correctControlHeight);
          correctControlDiv.css('width', correctControlWidth);
          correctControlDiv.css('z-index', 10000);
          
          var incorrectControlPositionTop = imageTop + correctControlHeight;
          var incorrectControlPositionLeft = $(document).width() - 350; //imageLeft+imageWidth;
          var incorrectControlHeight = $(document).height()/2; //imageHeight/2;
          var incorrectControlWidth = $(document).width() - incorrectControlPositionLeft;
          incorrectControlDiv.css('position', 'absolute');
          incorrectControlDiv.css('top', incorrectControlPositionTop);
          incorrectControlDiv.css('left', incorrectControlPositionLeft);
          incorrectControlDiv.css('height', incorrectControlHeight);
          incorrectControlDiv.css('width', incorrectControlWidth);
          incorrectControlDiv.css('z-index', 10000);
          
          $('.clickable-correct-control').click(function() {
            lastControlQuestionAnswer = true;
            $('.showcase-arrow-next').click();
          });
		  
          $('.clickable-incorrect-control').click(function() {
            lastControlQuestionAnswer = false;
            $('.showcase-arrow-next').click();
          });
          
          $('.showcase-arrow-next').hide();
          $('.showcase-arrow-previous').hide();
        } else {
          $('.clickable-incorrect-control').remove();
          $('.clickable-correct-control').remove();
          $('.showcase-arrow-next').show();
          $('.showcase-arrow-previous').show();
        }
      }
    });

    <c:forEach items="${experiment.experimentSession.stories}" var="story">
    storyOrder += "<c:out escapeXml='false' value="${story.id}"/>;";
    <c:forEach items="${story.question.choices}" var="choice">
    questionChoicesOrder += "<c:out escapeXml='false' value="${choice.id}"/>:";
    </c:forEach>
    questionChoicesOrder = questionChoicesOrder.substring(0, questionChoicesOrder.length - 1);
    questionChoicesOrder += ';';
    </c:forEach>

    $.post('../experiments', {
      _method : 'PUT',
      subjectAge : <c:out escapeXml='false' value="${experiment.subjectAge}"/>,
      subjectName : '<c:out escapeXml='false' value="${experiment.subjectName}"/>',
      experimentSession : <c:out escapeXml='false' value="${experiment.experimentSession.id}"/>,
      storyOrder : storyOrder,
      questionChoicesOrder : questionChoicesOrder,
      id : <c:out escapeXml='false' value="${experiment.id}"/>,
      version : <c:out escapeXml='false' value="${experiment.version}"/>
    }, function(data) {
      /* alert(data); */
    });

  }, false);
</script>
</head>
<body>

	<h1>
		<c:out escapeXml='false' value="${experiment.subjectName}" />
	</h1>

	<div id="storys_div">
		<div id="storys" class="showcase">
			<c:forEach items="${experiment.experimentSession.stories}"
				var="story">
				<%-- <li>
					<!-- Story begins here -->
					<h1>
						<c:out escapeXml='false' value="${story.title}" />
					</h1>
					<ul id="story<c:out escapeXml='false' value="${story.id}"/>"> --%>
				<!-- Slides in a story here-->
				<c:forEach items="${story.slides}" var="slide">

					<!-- <script>
			           ++currentSlideIndex;
			        </script> -->
					<%-- <c:if test="${slide.isControlSlide}">
						<script>
			              controlSlideIndices.push(currentSlideIndex);
			            </script>
					</c:if> --%>
					<c:choose>
						<c:when test="${slide.isControlSlide}">
							<div class="showcase-slide control-slide">
							<div class="showcase-content control-slide">
							<a
								href="../uploadedFiles/<c:out escapeXml='false' value="${slide.fileName}"/>">
								<img
								src="../uploadedFiles/<c:out escapeXml='false' value="${slide.fileName}"/>"
								title="<c:out escapeXml='false' value="${slide.description}"/>">
								<!-- height="280px" width="420px" <c:out escapeXml='false' value="${story.id}"/> -->
							</a>
						</div>
					</div>
						</c:when>
						<c:otherwise>
							<div class="showcase-slide">
							<div class="showcase-content">
							<a
								href="../uploadedFiles/<c:out escapeXml='false' value="${slide.fileName}"/>">
								<img
								src="../uploadedFiles/<c:out escapeXml='false' value="${slide.fileName}"/>"
								title="<c:out escapeXml='false' value="${slide.description}"/>">
								<!-- height="280px" width="420px" <c:out escapeXml='false' value="${story.id}"/> -->
							</a>
						</div>
					</div>
						</c:otherwise>
					</c:choose>

				</c:forEach>
				<!-- </ul> Question begins here -->
				<!-- <li> -->
				<div class="showcase-slide" id="question">
					<div class="showcase-content">

						<!-- Question -->
						<h1>
							<c:out escapeXml='false' value="${story.question.statement}" />
						</h1>

						<div id="question-choices">
							<c:forEach items="${story.question.choices}" var="choice"
								varStatus="status">
								<div class="question-choice"
										data-radio-id="radioStory<c:out escapeXml='false' value="${story.id}"/>Question<c:out escapeXml='false' value="${question.id}"/>Choice<c:out escapeXml='false' value="${choice.id}"/>"
										data-story-id="<c:out escapeXml='false' value="${story.id}"/>"
										data-question-id="<c:out escapeXml='false' value="${story.question.id}"/>"
										data-choice-id="<c:out escapeXml='false' value="${choice.id}"/>"
										data-choice-index="<c:out escapeXml='false' value="${status.index}"/>"
										>
								<input type="radio" style="display: none;"
									name="choices-story-<c:out escapeXml='false' value="${story.id}"/>"
									value="<c:out escapeXml='false' value="${choice.id}"/>"
									id="radioStory<c:out escapeXml='false' value="${story.id}"/>Question<c:out escapeXml='false' value="${question.id}"/>Choice<c:out escapeXml='false' value="${choice.id}"/>"
									index="<c:out escapeXml='false' value="${status.count}"/>">
									<c:out escapeXml='false' value="${choice.description}" /><br/>
								<%-- <label
										for="radioStory<c:out escapeXml='false' value="${story.id}"/>Question<c:out escapeXml='false' value="${question.id}"/>Choice<c:out escapeXml='false' value="${choice.id}"/>">
										<c:out escapeXml='false' value="${choice.description}" />
									</label> --%>
								<c:if test="${not empty choice.fileName}">
									<img src="../uploadedFiles/<c:out escapeXml='false' value="${choice.fileName}"/>"
									title="<c:out escapeXml='false' value="${choice.description}"/>" 
										style="vertical-align: middle" height="140px" width="210px">
								</c:if>
								<br/>
								</div>
								<br/>
							</c:forEach>
						</div>
					</div>
				</div>
				<!-- Question Ends -->
				<!-- </li> -->
				<!-- </li> -->
				<!-- Story Ends -->
			</c:forEach>

			<div class="showcase-slide">
				<div class="showcase-content">
					<input value="Save" type="submit" id="proceed">
				</div>
			</div>
		</div>
	</div>

	<div id="fc_ch_epfl_psytest_domain_Response_submit" class="submit">
		<!-- <script type="text/javascript">
			Spring.addDecoration(new Spring.ValidateAllDecoration({
				elementId : 'proceed',
				event : 'onclick'
			}));
		</script> -->
		<input value="Start Experiment" type="submit" id="start-experiment">

	</div>
</body>
</html>