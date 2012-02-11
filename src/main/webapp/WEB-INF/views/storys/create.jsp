<%@page import="ch.epfl.psytest.domain.Response"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script type="text/javascript">
  
<%@ include file="../../../js/jquery-1.7.1.min.js"%>
  
<%@ include file="../../../js/jquery-ui-1.8.17.custom.min.js"%>
  
</script>

<!-- <link rel="stylesheet" type="text/css" href="css/styles.css"/> -->
<link rel="stylesheet" type="text/css" href="css/jquery-ui-1.8.17.custom.css"/>
<style>
	#gallery { float: left; width: 65%; min-height: 12em; } * html #gallery { height: 12em; } /* IE6 */
	.gallery.custom-state-active { background: #eee; }
	.gallery li { float: left; width: 96px; padding: 0.4em; margin: 0 0.4em 0.4em 0; text-align: center; }
	.gallery li h5 { margin: 0 0 0.4em; cursor: move; }
	.gallery li a { float: right; }
	.gallery li a.ui-icon-zoomin { float: left; }
	.gallery li img { width: 100%; cursor: move; }

	#cart { float: right; width: 32%; min-height: 18em; padding: 1%;} * html #cart { height: 18em; } /* IE6 */
	#cart h4 { line-height: 16px; margin: 0 0 0.4em; }
	#cart h4 .ui-icon { float: left; }
	#cart .gallery h5 { display: none; }
	</style>

<script type="text/javascript">
  document.addEventListener('DOMContentLoaded', function() {

   /*  $( "#catalog" ).accordion();
		$( "#catalog li" ).draggable({
			appendTo: "body",
			helper: "clone"
		});
		$( "#cart ol" ).droppable({
			activeClass: "ui-state-default",
			hoverClass: "ui-state-hover",
			accept: ":not(.ui-sortable-helper)",
			drop: function( event, ui ) {
				$( this ).find( ".placeholder" ).remove();
				$( "<li></li>" ).text( ui.draggable.text() ).appendTo( this );
			}
		}).sortable({
			items: "li:not(.placeholder)",
			sort: function() {
				// gets added unintentionally by droppable interacting with sortable
				// using connectWithSortable fixes this, but doesn't allow you to customize active/hoverClass options
				$( this ).removeClass( "ui-state-default" );
			}
		}); */
		
 // there's the gallery and the cart
		var $gallery = $( "#gallery" ),
			$cart = $( "#cart" );

		// let the gallery items be draggable
		$( "li", $gallery ).draggable({
			cancel: "a.ui-icon", // clicking an icon won't initiate dragging
			revert: "invalid", // when not dropped, the item will revert back to its initial position
			containment: $( "#demo-frame" ).length ? "#demo-frame" : "document", // stick to demo-frame if present
			helper: "clone",
			cursor: "move"
		});

		// let the cart be droppable, accepting the gallery items
		$cart.droppable({
			accept: "#gallery > li",
			activeClass: "ui-state-highlight",
			drop: function( event, ui ) {
				deleteImage( ui.draggable );
			}
		});

		// let the gallery be droppable as well, accepting items from the cart
		$gallery.droppable({
			accept: "#cart li",
			activeClass: "custom-state-active",
			drop: function( event, ui ) {
				recycleImage( ui.draggable );
			}
		});

		// image deletion function
		var recycle_icon = "<a href='link/to/recycle/script/when/we/have/js/off' title='Recycle this image' class='ui-icon ui-icon-refresh'>Recycle image</a>";
		function deleteImage( $item ) {
			$item.fadeOut(function() {
				var $list = $( "ul", $cart ).length ?
					$( "ul", $cart ) :
					$( "<ul class='gallery ui-helper-reset'/>" ).appendTo( $cart );

				$item.find( "a.ui-icon-cart" ).remove();
				$item.append( recycle_icon ).appendTo( $list ).fadeIn(function() {
					$item
						.animate({ width: "48px" })
						.find( "img" )
							.animate({ height: "36px" });
				});
			});
		}

		// image recycle function
		var cart_icon = "<a href='link/to/cart/script/when/we/have/js/off' title='Delete this image' class='ui-icon ui-icon-cart'>Delete image</a>";
		function recycleImage( $item ) {
			$item.fadeOut(function() {
				$item
					.find( "a.ui-icon-refresh" )
						.remove()
					.end()
					.css( "width", "96px")
					.append( cart_icon )
					.find( "img" )
						.css( "height", "72px" )
					.end()
					.appendTo( $gallery )
					.fadeIn();
			});
		}

		// image preview function, demonstrating the ui.dialog used as a modal window
		function viewLargerImage( $link ) {
			var src = $link.attr( "href" ),
				title = $link.siblings( "img" ).attr( "alt" ),
				$modal = $( "img[src$='" + src + "']" );

			if ( $modal.length ) {
				$modal.dialog( "open" );
			} else {
				var img = $( "<img alt='" + title + "' width='384' height='288' style='display: none; padding: 8px;' />" )
					.attr( "src", src ).appendTo( "body" );
				setTimeout(function() {
					img.dialog({
						title: title,
						width: 400,
						modal: true
					});
				}, 1 );
			}
		}

		// resolve the icons behavior with event delegation
		$( "ul.gallery > li" ).click(function( event ) {
			var $item = $( this ),
				$target = $( event.target );

			if ( $target.is( "a.ui-icon-cart" ) ) {
				deleteImage( $item );
			} else if ( $target.is( "a.ui-icon-zoomin" ) ) {
				viewLargerImage( $target );
			} else if ( $target.is( "a.ui-icon-refresh" ) ) {
				recycleImage( $item );
			}

			return false;
		});
    var loc = window.location.href;
  }, false);
</script>

</head>
<body>
	<ul id="gallery" class="gallery ui-helper-reset ui-helper-clearfix">
					<c:forEach items="${slides}" var="slide">
					
						<li id="<c:out escapeXml='false' value="${slide.id}"/>" class="ui-widget-content ui-corner-tr">
						<h5 class="ui-widget-header"><c:out escapeXml='false' value="${slide.description}"/></h5>
						<img
								src="uploadedFiles/<c:out escapeXml='false' value="${slide.fileName}"/>"
								alt="<c:out escapeXml='false' value="${slide.description}"/>"
								height="96" width="72">
								<a href="uploadedFiles/<c:out escapeXml='false' value="${slide.fileName}"/>" title="View larger image" class="ui-icon ui-icon-zoomin">View larger</a> 
								</li>
					</c:forEach>
				</ul>

<div id="cart" class="ui-widget-content ui-state-default">
	<h4 class="ui-widget-header"><span class="ui-icon ui-icon-cart">Selected Slides</span> Selected Slides</h4>
</div>


	<div id="_c_ch_epfl_psytest_domain_Story_question_id">
		<label for="_question_id">Question : </label><select id="_question_id"
			name="question">
			<c:forEach items="${questions}" var="question">
				<option value="<c:out escapeXml='false' value="${question.id}"/>">
					<c:out escapeXml='false' value="${question.statement}" />
				</option>
			</c:forEach>
		</select> <br />
		<script type="text/javascript">
      Spring.addDecoration(new Spring.ElementDecoration({
        elementId : '_question_id',
        widgetType : 'dijit.form.FilteringSelect',
        widgetAttrs : {
          hasDownArrow : true
        }
      }));
    </script>
	</div>
	<br />
	<div id="_c_ch_epfl_psytest_domain_Story_title_id">
		<label for="_title_id">Title : </label><input id="_title_id"
			name="title" type="text" value="" /><br />
		<script type="text/javascript">
      Spring.addDecoration(new Spring.ElementDecoration({
        elementId : '_title_id',
        widgetType : 'dijit.form.ValidationTextBox',
        widgetAttrs : {
          promptMessage : 'Enter Title',
          invalidMessage : 'Please enter valid Title',
          required : false,
          missingMessage : ''
        }
      }));
    </script>
	</div>
	<br />
	<div id="fc_ch_epfl_psytest_domain_Story_submit" class="submit">
		<script type="text/javascript">
      Spring.addDecoration(new Spring.ValidateAllDecoration({
        elementId : 'proceed',
        event : 'onclick'
      }));
    </script>
		<input value="Save" type="submit" id="proceed" />
	</div>
	<?xml version="1.0" encoding="UTF-8"?>
</body>
</html>