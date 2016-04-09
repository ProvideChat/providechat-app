/*                  ______________________________________
           ________|                                      |_______
           \       |           SmartAdmin WebApp          |      /
            \      |      Copyright © 2015 MyOrange       |     /
            /      |______________________________________|     \
           /__________)                                (_________\

 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * =======================================================================
 * SmartAdmin is FULLY owned and LICENSED by MYORANGE INC.
 * This script may NOT be RESOLD or REDISTRUBUTED under any
 * circumstances (this extends the use of public repositories, which is
 * absolutely NOT ALLOWED under any circumstances), and is only to be used
 * with this purchased copy of SmartAdmin Template
 * =======================================================================`
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * =======================================================================
 * original filename  : app.js
 * filesize           : 62,499~ bytes
 * author             : Sunny (@bootstraphunt)
 * email              : info@myorange.ca
 * legal notice       : This script is part of a theme sold by
 *                      https://wrapbootstrap.com/?ref=myorange
 *
 * =======================================================================
 * INDEX (Note: line numbers for index items may not be up to date):
 *
 * 1. APP CONFIGURATION..................................[ app.config.js ]
 * 2. APP DOM REFERENCES.................................[ app.config.js ]
 * 3. DETECT MOBILE DEVICES...................................[line: 149 ]
 * 4. CUSTOM MENU PLUGIN......................................[line: 688 ]
 * 5. ELEMENT EXIST OR NOT....................................[line: 778 ]
 * 6. INITIALIZE FORMS........................................[line: 788 ]
 * 		6a. BOOTSTRAP SLIDER PLUGIN...........................[line: 794 ]
 * 		6b. SELECT2 PLUGIN....................................[line: 803 ]
 * 		6c. MASKING...........................................[line: 824 ]
 * 		6d. AUTOCOMPLETE......................................[line: 843 ]
 * 		6f. JQUERY UI DATE....................................[line: 862 ]
 * 		6g. AJAX BUTTON LOADING TEXT..........................[line: 884 ]
 * 7. INITIALIZE CHARTS.......................................[line: 902 ]
 * 		7a. SPARKLINES........................................[line: 907 ]
 * 		7b. LINE CHART........................................[line: 1026]
 * 		7c. PIE CHART.........................................[line: 1077]
 * 		7d. BOX PLOT..........................................[line: 1100]
 * 		7e. BULLET............................................[line: 1145]
 * 		7f. DISCRETE..........................................[line: 1169]
 * 		7g. TRISTATE..........................................[line: 1195]
 * 		7h. COMPOSITE: BAR....................................[line: 1223]
 * 		7i. COMPOSITE: LINE...................................[line: 1259]
 * 		7j. EASY PIE CHARTS...................................[line: 1339]
 * 8. INITIALIZE JARVIS WIDGETS...............................[line: 1379]
 * 		8a. SETUP DESKTOP WIDGET..............................[line: 1466]
 * 		8b. GOOGLE MAPS.......................................[line: 1478]
 * 		8c. LOAD SCRIPTS......................................[line: 1500]
 * 		8d. APP AJAX REQUEST SETUP............................[line: 1538]
 * 9. CHECK TO SEE IF URL EXISTS..............................[line: 1614]
 * 10.LOAD AJAX PAGES.........................................[line: 1669]
 * 11.UPDATE BREADCRUMB.......................................[line: 1775]
 * 12.PAGE SETUP..............................................[line: 1798]
 * 13.POP OVER THEORY.........................................[line: 1852]
 * 14.DELETE MODEL DATA ON HIDDEN.............................[line: 1991]
 * 15.HELPFUL FUNCTIONS.......................................[line: 2027]
 *
 * =======================================================================
 *       IMPORTANT: ALL CONFIG VARS IS NOW MOVED TO APP.CONFIG.JS
 * =======================================================================
 *
 *
 * GLOBAL: interval array (to be used with jarviswidget in ajax and
 * angular mode) to clear auto fetch interval
 */
	$.intervalArr = [];
/*
 * Calculate nav height
 */
var calc_navbar_height = function() {
		var height = null;

		if ($('#header').length)
			height = $('#header').height();

		if (height === null)
			height = $('<div id="header"></div>').height();

		if (height === null)
			return 49;
		// default
		return height;
	},

	navbar_height = calc_navbar_height,
/*
 * APP DOM REFERENCES
 * Description: Obj DOM reference, please try to avoid changing these
 */
	shortcut_dropdown = $('#shortcut'),

	bread_crumb = $('#ribbon ol.breadcrumb'),
/*
 * Top menu on/off
 */
	topmenu = false,
/*
 * desktop or mobile
 */
	thisDevice = null,
/*
 * DETECT MOBILE DEVICES
 * Description: Detects mobile device - if any of the listed device is
 * detected a class is inserted to $.root_ and the variable thisDevice
 * is decleard. (so far this is covering most hand held devices)
 */
	ismobile = (/iphone|ipad|ipod|android|blackberry|mini|windows\sce|palm/i.test(navigator.userAgent.toLowerCase())),
/*
 * JS ARRAY SCRIPT STORAGE
 * Description: used with loadScript to store script path and file name
 * so it will not load twice
 */
	jsArray = {},
/*
 * App Initialize
 * Description: Initializes the app with intApp();
 */
	initApp = (function(app) {

		/*
		 * ADD DEVICE TYPE
		 * Detect if mobile or desktop
		 */
		app.addDeviceType = function() {

			if (!ismobile) {
				// Desktop
				$.root_.addClass("desktop-detected");
				thisDevice = "desktop";
				return false;
			} else {
				// Mobile
				$.root_.addClass("mobile-detected");
				thisDevice = "mobile";

				if (fastClick) {
					// Removes the tap delay in idevices
					// dependency: js/plugin/fastclick/fastclick.js
					$.root_.addClass("needsclick");
					FastClick.attach(document.body);
					return false;
				}

			}

		};
		/* ~ END: ADD DEVICE TYPE */

		/*
		 * CHECK FOR MENU POSITION
		 * Scans localstroage for menu position (vertical or horizontal)
		 */
		app.menuPos = function() {

		 	if ($.root_.hasClass("menu-on-top") || localStorage.getItem('sm-setmenu')=='top' ) {
		 		topmenu = true;
		 		$.root_.addClass("menu-on-top");
		 	}
		};
		/* ~ END: CHECK MOBILE DEVICE */

		/*
		 * SMART ACTIONS
		 */
		app.SmartActions = function(){

			var smartActions = {

			    // LOGOUT MSG
			    userLogout: function($this){

					// ask verification
					$.SmartMessageBox({
						title : "<i class='fa fa-sign-out txt-color-orangeDark'></i> Logout <span class='txt-color-orangeDark'><strong>" + $('#show-shortcut').text() + "</strong></span> ?",
						content : $this.data('logout-msg') || "You can improve your security further after logging out by closing this opened browser",
						buttons : '[No][Yes]'

					}, function(ButtonPressed) {
						if (ButtonPressed == "Yes") {
							$.root_.addClass('animated fadeOutUp');
							setTimeout(logout, 1000);
						}
					});
					function logout() {
						window.location = $this.attr('href');
					}

				},

				// RESET WIDGETS
			    resetWidgets: function($this){

					$.SmartMessageBox({
						title : "<i class='fa fa-refresh' style='color:green'></i> Clear Local Storage",
						content : $this.data('reset-msg') || "Would you like to RESET all your saved widgets and clear LocalStorage?1",
						buttons : '[No][Yes]'
					}, function(ButtonPressed) {
						if (ButtonPressed == "Yes" && localStorage) {
							localStorage.clear();
							location.reload();
						}

					});
			    },

			    // LAUNCH FULLSCREEN
			    launchFullscreen: function(element){

					if (!$.root_.hasClass("full-screen")) {

						$.root_.addClass("full-screen");

						if (element.requestFullscreen) {
							element.requestFullscreen();
						} else if (element.mozRequestFullScreen) {
							element.mozRequestFullScreen();
						} else if (element.webkitRequestFullscreen) {
							element.webkitRequestFullscreen();
						} else if (element.msRequestFullscreen) {
							element.msRequestFullscreen();
						}

					} else {

						$.root_.removeClass("full-screen");

						if (document.exitFullscreen) {
							document.exitFullscreen();
						} else if (document.mozCancelFullScreen) {
							document.mozCancelFullScreen();
						} else if (document.webkitExitFullscreen) {
							document.webkitExitFullscreen();
						}

					}

			   },

			   // MINIFY MENU
			    minifyMenu: function($this){
			    	if (!$.root_.hasClass("menu-on-top")){
						$.root_.toggleClass("minified");
						$.root_.removeClass("hidden-menu");
						$('html').removeClass("hidden-menu-mobile-lock");
						$this.effect("highlight", {}, 500);
					}
			    },

			    // TOGGLE MENU
			    toggleMenu: function(){
			    	if (!$.root_.hasClass("menu-on-top")){
						$('html').toggleClass("hidden-menu-mobile-lock");
						$.root_.toggleClass("hidden-menu");
						$.root_.removeClass("minified");
			    	//} else if ( $.root_.hasClass("menu-on-top") && $.root_.hasClass("mobile-view-activated") ) {
			    	// suggested fix from Christian Jäger
			    	} else if ( $.root_.hasClass("menu-on-top") && $(window).width() < 979 ) {
			    		$('html').toggleClass("hidden-menu-mobile-lock");
						$.root_.toggleClass("hidden-menu");
						$.root_.removeClass("minified");
			    	}
			    },

			    // TOGGLE SHORTCUT
			    toggleShortcut: function(){

					if (shortcut_dropdown.is(":visible")) {
						shortcut_buttons_hide();
					} else {
						shortcut_buttons_show();
					}

					// SHORT CUT (buttons that appear when clicked on user name)
					shortcut_dropdown.find('a').click(function(e) {
						e.preventDefault();
						window.location = $(this).attr('href');
						setTimeout(shortcut_buttons_hide, 300);

					});

					// SHORTCUT buttons goes away if mouse is clicked outside of the area
					$(document).mouseup(function(e) {
						if (!shortcut_dropdown.is(e.target) && shortcut_dropdown.has(e.target).length === 0) {
							shortcut_buttons_hide();
						}
					});

					// SHORTCUT ANIMATE HIDE
					function shortcut_buttons_hide() {
						shortcut_dropdown.animate({
							height : "hide"
						}, 300, "easeOutCirc");
						$.root_.removeClass('shortcut-on');

					}

					// SHORTCUT ANIMATE SHOW
					function shortcut_buttons_show() {
						shortcut_dropdown.animate({
							height : "show"
						}, 200, "easeOutCirc");
						$.root_.addClass('shortcut-on');
					}

			    }

			};

			$.root_.on('click', '[data-action="userLogout"]', function(e) {
				var $this = $(this);
				smartActions.userLogout($this);
				e.preventDefault();

				//clear memory reference
				$this = null;

			});

			/*
			 * BUTTON ACTIONS
			 */
			$.root_.on('click', '[data-action="resetWidgets"]', function(e) {
				var $this = $(this);
				smartActions.resetWidgets($this);
				e.preventDefault();

				//clear memory reference
				$this = null;
			});

			$.root_.on('click', '[data-action="launchFullscreen"]', function(e) {
				smartActions.launchFullscreen(document.documentElement);
				e.preventDefault();
			});

			$.root_.on('click', '[data-action="minifyMenu"]', function(e) {
				var $this = $(this);
				smartActions.minifyMenu($this);
				e.preventDefault();

				//clear memory reference
				$this = null;
			});

			$.root_.on('click', '[data-action="toggleMenu"]', function(e) {
				smartActions.toggleMenu();
				e.preventDefault();
			});

			$.root_.on('click', '[data-action="toggleShortcut"]', function(e) {
				smartActions.toggleShortcut();
				e.preventDefault();
			});

		};
		/* ~ END: SMART ACTIONS */

		/*
		 * ACTIVATE NAVIGATION
		 * Description: Activation will fail if top navigation is on
		 */
		app.leftNav = function(){

			// INITIALIZE LEFT NAV
			if (!topmenu) {
				if (!null) {
					$('nav ul').jarvismenu({
						accordion : menu_accordion || true,
						speed : menu_speed || true,
						closedSign : '<em class="fa fa-plus-square-o"></em>',
						openedSign : '<em class="fa fa-minus-square-o"></em>'
					});
				} else {
					alert("Error - menu anchor does not exist");
				}
			}

		};
		/* ~ END: ACTIVATE NAVIGATION */

		/*
		 * MISCELANEOUS DOM READY FUNCTIONS
		 * Description: fire with jQuery(document).ready...
		 */
		app.domReadyMisc = function() {

			/*
			 * FIRE TOOLTIPS
			 */
			if ($("[rel=tooltip]").length) {
				$("[rel=tooltip]").tooltip();
			}

			// SHOW & HIDE MOBILE SEARCH FIELD
			$('#search-mobile').click(function() {
				$.root_.addClass('search-mobile');
			});

			$('#cancel-search-js').click(function() {
				$.root_.removeClass('search-mobile');
			});

			// ACTIVITY
			// ajax drop
			$('#activity').click(function(e) {
				var $this = $(this);

				if ($this.find('.badge').hasClass('bg-color-red')) {
					$this.find('.badge').removeClassPrefix('bg-color-');
					$this.find('.badge').text("0");
				}

				if (!$this.next('.ajax-dropdown').is(':visible')) {
					$this.next('.ajax-dropdown').fadeIn(150);
					$this.addClass('active');
				} else {
					$this.next('.ajax-dropdown').fadeOut(150);
					$this.removeClass('active');
				}

				var theUrlVal = $this.next('.ajax-dropdown').find('.btn-group > .active > input').attr('id');

				//clear memory reference
				$this = null;
				theUrlVal = null;

				e.preventDefault();
			});

			$('input[name="activity"]').change(function() {
				var $this = $(this);

				url = $this.attr('id');
				container = $('.ajax-notifications');

				loadURL(url, container);

				//clear memory reference
				$this = null;
			});

			// close dropdown if mouse is not inside the area of .ajax-dropdown
			$(document).mouseup(function(e) {
				if (!$('.ajax-dropdown').is(e.target) && $('.ajax-dropdown').has(e.target).length === 0) {
					$('.ajax-dropdown').fadeOut(150);
					$('.ajax-dropdown').prev().removeClass("active");
				}
			});

			// loading animation (demo purpose only)
			$('button[data-btn-loading]').on('click', function() {
				var btn = $(this);
				btn.button('loading');
				setTimeout(function() {
					btn.button('reset');
				}, 3000);
			});

			// NOTIFICATION IS PRESENT
			// Change color of lable once notification button is clicked

			$this = $('#activity > .badge');

			if (parseInt($this.text()) > 0) {
				$this.addClass("bg-color-red bounceIn animated");

				//clear memory reference
				$this = null;
			}


		};
		/* ~ END: MISCELANEOUS DOM */

		/*
		 * MISCELANEOUS DOM READY FUNCTIONS
		 * Description: fire with jQuery(document).ready...
		 */
		app.mobileCheckActivation = function(){

			if ($(window).width() < 979) {
				$.root_.addClass('mobile-view-activated');
				$.root_.removeClass('minified');
			} else if ($.root_.hasClass('mobile-view-activated')) {
				$.root_.removeClass('mobile-view-activated');
			}

			if (debugState){
				console.log("mobileCheckActivation");
			}

		}
		/* ~ END: MISCELANEOUS DOM */

		return app;

	})({});

	initApp.addDeviceType();
	initApp.menuPos();
/*
 * DOCUMENT LOADED EVENT
 * Description: Fire when DOM is ready
 */
	jQuery(document).ready(function() {

		initApp.SmartActions();
		initApp.leftNav();
		initApp.domReadyMisc();

	});
/*
 * RESIZER WITH THROTTLE
 * Source: http://benalman.com/code/projects/jquery-resize/examples/resize/
 */
	(function ($, window, undefined) {

	    var elems = $([]),
	        jq_resize = $.resize = $.extend($.resize, {}),
	        timeout_id, str_setTimeout = 'setTimeout',
	        str_resize = 'resize',
	        str_data = str_resize + '-special-event',
	        str_delay = 'delay',
	        str_throttle = 'throttleWindow';

	    jq_resize[str_delay] = throttle_delay;

	    jq_resize[str_throttle] = true;

	    $.event.special[str_resize] = {

	        setup: function () {
	            if (!jq_resize[str_throttle] && this[str_setTimeout]) {
	                return false;
	            }

	            var elem = $(this);
	            elems = elems.add(elem);
	            try {
	                $.data(this, str_data, {
	                    w: elem.width(),
	                    h: elem.height()
	                });
	            } catch (e) {
	                $.data(this, str_data, {
	                    w: elem.width, // elem.width();
	                    h: elem.height // elem.height();
	                });
	            }

	            if (elems.length === 1) {
	                loopy();
	            }
	        },
	        teardown: function () {
	            if (!jq_resize[str_throttle] && this[str_setTimeout]) {
	                return false;
	            }

	            var elem = $(this);
	            elems = elems.not(elem);
	            elem.removeData(str_data);
	            if (!elems.length) {
	                clearTimeout(timeout_id);
	            }
	        },

	        add: function (handleObj) {
	            if (!jq_resize[str_throttle] && this[str_setTimeout]) {
	                return false;
	            }
	            var old_handler;

	            function new_handler(e, w, h) {
	                var elem = $(this),
	                    data = $.data(this, str_data);
	                data.w = w !== undefined ? w : elem.width();
	                data.h = h !== undefined ? h : elem.height();

	                old_handler.apply(this, arguments);
	            }
	            if ($.isFunction(handleObj)) {
	                old_handler = handleObj;
	                return new_handler;
	            } else {
	                old_handler = handleObj.handler;
	                handleObj.handler = new_handler;
	            }
	        }
	    };

	    function loopy() {
	        timeout_id = window[str_setTimeout](function () {
	            elems.each(function () {
	                var width;
	                var height;

	                var elem = $(this),
	                    data = $.data(this, str_data); //width = elem.width(), height = elem.height();

	                // Highcharts fix
	                try {
	                    width = elem.width();
	                } catch (e) {
	                    width = elem.width;
	                }

	                try {
	                    height = elem.height();
	                } catch (e) {
	                    height = elem.height;
	                }
	                //fixed bug


	                if (width !== data.w || height !== data.h) {
	                    elem.trigger(str_resize, [data.w = width, data.h = height]);
	                }

	            });
	            loopy();

	        }, jq_resize[str_delay]);

	    }

	})(jQuery, this);
/*
* ADD CLASS WHEN BELOW CERTAIN WIDTH (MOBILE MENU)
* Description: tracks the page min-width of #CONTENT and NAV when navigation is resized.
* This is to counter bugs for minimum page width on many desktop and mobile devices.
* Note: This script utilizes JSthrottle script so don't worry about memory/CPU usage
*/
	$('#main').resize(function() {

		initApp.mobileCheckActivation();

	});

/* ~ END: NAV OR #LEFT-BAR RESIZE DETECT */

/*
 * DETECT IE VERSION
 * Description: A short snippet for detecting versions of IE in JavaScript
 * without resorting to user-agent sniffing
 * RETURNS:
 * If you're not in IE (or IE version is less than 5) then:
 * //ie === undefined
 *
 * If you're in IE (>=5) then you can determine which version:
 * // ie === 7; // IE7
 *
 * Thus, to detect IE:
 * // if (ie) {}
 *
 * And to detect the version:
 * ie === 6 // IE6
 * ie > 7 // IE8, IE9 ...
 * ie < 9 // Anything less than IE9
 */
// TODO: delete this function later on - no longer needed (?)
	var ie = ( function() {

		var undef, v = 3, div = document.createElement('div'), all = div.getElementsByTagName('i');

		while (div.innerHTML = '<!--[if gt IE ' + (++v) + ']><i></i><![endif]-->', all[0]);

		return v > 4 ? v : undef;

	}());
/* ~ END: DETECT IE VERSION */

/*
 * CUSTOM MENU PLUGIN
 */
	$.fn.extend({

		//pass the options variable to the function
		jarvismenu : function(options) {

			var defaults = {
				accordion : 'true',
				speed : 200,
				closedSign : '[+]',
				openedSign : '[-]'
			},

			// Extend our default options with those provided.
				opts = $.extend(defaults, options),
			//Assign current element to variable, in this case is UL element
				$this = $(this);

			//add a mark [+] to a multilevel menu
			$this.find("li").each(function() {
				if ($(this).find("ul").size() !== 0) {
					//add the multilevel sign next to the link
					$(this).find("a:first").append("<b class='collapse-sign'>" + opts.closedSign + "</b>");

					//avoid jumping to the top of the page when the href is an #
					if ($(this).find("a:first").attr('href') == "#") {
						$(this).find("a:first").click(function() {
							return false;
						});
					}
				}
			});

			//open active level
			$this.find("li.active").each(function() {
				$(this).parents("ul").slideDown(opts.speed);
				$(this).parents("ul").parent("li").find("b:first").html(opts.openedSign);
				$(this).parents("ul").parent("li").addClass("open");
			});

			$this.find("li a").click(function() {

				if ($(this).parent().find("ul").size() !== 0) {

					if (opts.accordion) {
						//Do nothing when the list is open
						if (!$(this).parent().find("ul").is(':visible')) {
							parents = $(this).parent().parents("ul");
							visible = $this.find("ul:visible");
							visible.each(function(visibleIndex) {
								var close = true;
								parents.each(function(parentIndex) {
									if (parents[parentIndex] == visible[visibleIndex]) {
										close = false;
										return false;
									}
								});
								if (close) {
									if ($(this).parent().find("ul") != visible[visibleIndex]) {
										$(visible[visibleIndex]).slideUp(opts.speed, function() {
											$(this).parent("li").find("b:first").html(opts.closedSign);
											$(this).parent("li").removeClass("open");
										});

									}
								}
							});
						}
					}// end if
					if ($(this).parent().find("ul:first").is(":visible") && !$(this).parent().find("ul:first").hasClass("active")) {
						$(this).parent().find("ul:first").slideUp(opts.speed, function() {
							$(this).parent("li").removeClass("open");
							$(this).parent("li").find("b:first").delay(opts.speed).html(opts.closedSign);
						});

					} else {
						$(this).parent().find("ul:first").slideDown(opts.speed, function() {
							/*$(this).effect("highlight", {color : '#616161'}, 500); - disabled due to CPU clocking on phones*/
							$(this).parent("li").addClass("open");
							$(this).parent("li").find("b:first").delay(opts.speed).html(opts.openedSign);
						});
					} // end else
				} // end if
			});
		} // end function
	});
/* ~ END: CUSTOM MENU PLUGIN */

/*
 * ELEMENT EXIST OR NOT
 * Description: returns true or false
 * Usage: $('#myDiv').doesExist();
 */
	jQuery.fn.doesExist = function() {
		return jQuery(this).length > 0;
	};
/* ~ END: ELEMENT EXIST OR NOT */

/*
 * INITIALIZE FORMS
 * Description: Select2, Masking, Datepicker, Autocomplete
 */
	function runAllForms() {

		/*
		 * BOOTSTRAP SLIDER PLUGIN
		 * Usage:
		 * Dependency: js/plugin/bootstrap-slider
		 */
		if ($.fn.slider) {
			$('.slider').slider();
		}

		/*
		 * MASKING
		 * Dependency: js/plugin/masked-input/
		 */
		if ($.fn.mask) {
			$('[data-mask]').each(function() {

				var $this = $(this),
					mask = $this.attr('data-mask') || 'error...', mask_placeholder = $this.attr('data-mask-placeholder') || 'X';

				$this.mask(mask, {
					placeholder : mask_placeholder
				});

				//clear memory reference
				$this = null;
			});
		}

		/*
		 * AUTOCOMPLETE
		 * Dependency: js/jqui
		 */
		if ($.fn.autocomplete) {
			$('[data-autocomplete]').each(function() {

				var $this = $(this),
					availableTags = $this.data('autocomplete') || ["The", "Quick", "Brown", "Fox", "Jumps", "Over", "Three", "Lazy", "Dogs"];

				$this.autocomplete({
					source : availableTags
				});

				//clear memory reference
				$this = null;
			});
		}

		/*
		 * JQUERY UI DATE
		 * Dependency: js/libs/jquery-ui-1.10.3.min.js
		 * Usage: <input class="datepicker" />
		 */
		if ($.fn.datepicker) {
			$('.datepicker').each(function() {

				var $this = $(this),
					dataDateFormat = $this.attr('data-dateformat') || 'dd.mm.yy';

				$this.datepicker({
					dateFormat : dataDateFormat,
					prevText : '<i class="fa fa-chevron-left"></i>',
					nextText : '<i class="fa fa-chevron-right"></i>',
				});

				//clear memory reference
				$this = null;
			});
		}

		/*
		 * AJAX BUTTON LOADING TEXT
		 * Usage: <button type="button" data-loading-text="Loading..." class="btn btn-xs btn-default ajax-refresh"> .. </button>
		 */
		$('button[data-loading-text]').on('click', function() {
			var btn = $(this);
			btn.button('loading');
			setTimeout(function() {
				btn.button('reset');
				//clear memory reference
				btn = null;
			}, 3000);

		});

	}
/* ~ END: INITIALIZE FORMS */


/*
 * INITIALIZE JARVIS WIDGETS
 * Setup Desktop Widgets
 */
	function setup_widgets_desktop() {

		if ($.fn.jarvisWidgets && enableJarvisWidgets) {

			$('#widget-grid').jarvisWidgets({

				grid : 'article',
				widgets : '.jarviswidget',
				localStorage : localStorageJarvisWidgets,
				deleteSettingsKey : '#deletesettingskey-options',
				settingsKeyLabel : 'Reset settings?',
				deletePositionKey : '#deletepositionkey-options',
				positionKeyLabel : 'Reset position?',
				sortable : sortableJarvisWidgets,
				buttonsHidden : false,
				// toggle button
				toggleButton : true,
				toggleClass : 'fa fa-minus | fa fa-plus',
				toggleSpeed : 200,
				onToggle : function() {
				},
				// delete btn
				deleteButton : true,
				deleteMsg:'Warning: This action cannot be undone!',
				deleteClass : 'fa fa-times',
				deleteSpeed : 200,
				onDelete : function() {
				},
				// edit btn
				editButton : true,
				editPlaceholder : '.jarviswidget-editbox',
				editClass : 'fa fa-cog | fa fa-save',
				editSpeed : 200,
				onEdit : function() {
				},
				// color button
				colorButton : true,
				// full screen
				fullscreenButton : true,
				fullscreenClass : 'fa fa-expand | fa fa-compress',
				fullscreenDiff : 3,
				onFullscreen : function() {
				},
				// custom btn
				customButton : false,
				customClass : 'folder-10 | next-10',
				customStart : function() {
					alert('Hello you, this is a custom button...');
				},
				customEnd : function() {
					alert('bye, till next time...');
				},
				// order
				buttonOrder : '%refresh% %custom% %edit% %toggle% %fullscreen% %delete%',
				opacity : 1.0,
				dragHandle : '> header',
				placeholderClass : 'jarviswidget-placeholder',
				indicator : true,
				indicatorTime : 600,
				ajax : true,
				timestampPlaceholder : '.jarviswidget-timestamp',
				timestampFormat : 'Last update: %m%/%d%/%y% %h%:%i%:%s%',
				refreshButton : true,
				refreshButtonClass : 'fa fa-refresh',
				labelError : 'Sorry but there was a error:',
				labelUpdated : 'Last Update:',
				labelRefresh : 'Refresh',
				labelDelete : 'Delete widget:',
				afterLoad : function() {
				},
				rtl : false, // best not to toggle this!
				onChange : function() {
				},
				onSave : function() {
				},
			});

		}

	}
/*
 * SETUP DESKTOP WIDGET
 */
	function setup_widgets_mobile() {

		if (enableMobileWidgets && enableJarvisWidgets) {
			setup_widgets_desktop();
		}

	}
/* ~ END: INITIALIZE JARVIS WIDGETS */

/*
 * LOAD SCRIPTS
 * Usage:
 * Define function = myPrettyCode ()...
 * loadScript("js/my_lovely_script.js", myPrettyCode);
 */
	function loadScript(scriptName, callback) {

		if (!jsArray[scriptName]) {
			jsArray[scriptName] = true;

			// adding the script tag to the head as suggested before
			var body = document.getElementsByTagName('body')[0],
				script = document.createElement('script');
			script.type = 'text/javascript';
			script.src = scriptName;

			// then bind the event to the callback function
			// there are several events for cross browser compatibility
			script.onload = callback;

			// fire the loading
			body.appendChild(script);

			// clear DOM reference
			//body = null;
			//script = null;

		} else if (callback) {
			// changed else to else if(callback)
			if (debugState){
				root.root.console.log("This script was already loaded %c: " + scriptName, debugStyle_warning);
			}
			//execute function
			callback();
		}

	}
/* ~ END: LOAD SCRIPTS */

/*
 * PAGE SETUP
 * Description: fire certain scripts that run through the page
 * to check for form elements, tooltip activation, popovers, etc...
 */
	function pageSetUp() {

		if (thisDevice === "desktop"){
			// is desktop

			// activate tooltips
			$("[rel=tooltip], [data-rel=tooltip]").tooltip();

			// activate popovers
			$("[rel=popover], [data-rel=popover]").popover();

			// activate popovers with hover states
			$("[rel=popover-hover], [data-rel=popover-hover]").popover({
				trigger : "hover"
			});

			// setup widgets
			setup_widgets_desktop();

			// run form elements
			runAllForms();

		} else {

			// is mobile

			// activate popovers
			$("[rel=popover], [data-rel=popover]").popover();

			// activate popovers with hover states
			$("[rel=popover-hover], [data-rel=popover-hover]").popover({
				trigger : "hover"
			});

			// setup widgets
			setup_widgets_mobile();

			// run form elements
			runAllForms();

		}

	}
/* ~ END: PAGE SETUP */

/*
 * ONE POP OVER THEORY
 * Keep only 1 active popover per trigger - also check and hide active popover if user clicks on document
 */
	$('body').on('click', function(e) {
		$('[rel="popover"], [data-rel="popover"]').each(function() {
			//the 'is' for buttons that trigger popups
			//the 'has' for icons within a button that triggers a popup
			if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
				$(this).popover('hide');
			}
		});
	});
/* ~ END: ONE POP OVER THEORY */

/*
 * HELPFUL FUNCTIONS
 * We have included some functions below that can be resued on various occasions
 *
 * Get param value
 * example: alert( getParam( 'param' ) );
 */
	function getParam(name) {
	    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
	    var regexS = "[\\?&]" + name + "=([^&#]*)";
	    var regex = new RegExp(regexS);
	    var results = regex.exec(window.location.href);
	    if (results == null)
	        return "";
	    else
	        return results[1];
	}
/* ~ END: HELPFUL FUNCTIONS */
