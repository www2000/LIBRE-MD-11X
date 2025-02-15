# AUTOPUSH
# Visual entry of pushback route.
#
# Copyright (c) 2018 Autopush authors:
#  Michael Danilov <mike.d.ft402 -eh- gmail.com>
#  Joshua Davidson http://github.com/Octal450
#  Merspieler http://gitlab.com/merspieler
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

var _listener = nil;
var _view_listener = nil;
var _user_points = dynarr.dynarr.new(4);
var _user_point_modes = dynarr.dynarr.new(4); # Modes: 0 = Bezier node, 1 = Bezier end/start node, 2 = Reverse
var _route = [];
var _route_hdg = [];
var _route_reverse = [];
var _view_index = nil;
var _user_point_models = [];
var _waypoint_models = [];
var _N = 0;
var _show = 0;
var _view_changed_or_external = 0;
var _R_turn_min = 0;
var _invalid = 0;


var _add = func(pos) {
	if (_N) {
		var (A, S) = courseAndDistance(_user_points.arr[_N - 1], pos);
		S *= NM2M;
		if (S < _R_turn_min) {
			gui.popupTip("Too close to the previous point,\ntry again");
			return;
		}else if (S > 10000.0) {
			gui.popupTip("Too far from the previous point,\ntry again");
			return;
		}
	}
	_user_points.add(geo.Coord.new(pos));

	if (_user_point_modes.maxsize == 1 and _user_point_modes.size == 1) {
		_user_point_modes.arr[0] = 0;
	} else {
		_user_point_modes.add(0);
	}
	setsize(_user_point_models, _N + 1);
	_user_point_models[_N] = geo.put_model("Models/Autopush/cursor.xml", pos, 0.0);
	_N += 1;
	if (_N == 1) {
		gui.popupTip("Click waypoints, press \"Done\" to finish");
	} else {
		_calculate_route();
		_place_waypoint_models();
	}
}

var delete_last = func() {
	if (_listener == nil) {
		return;
	}
	if (_N > 1) {
		_N -= 1;
		_user_points.del(_N);
		_user_point_modes.del(_N);
		_user_point_models[_N].remove();
		_user_point_models[_N] = nil;
		setsize(_user_point_models, _N);
		_calculate_route();
		_place_waypoint_models();
	}
}

var _stop = func(fail = 0) {
	if (_listener != nil) {
		removelistener(_listener);
		_listener = nil;
		if (!fail) {
			settimer(func() {
				_reset_view();
				gui.popupTip("Done");
			}, 1.0);
		} else {
			_reset_view();
		}
	}
}

var _place_user_point_models = func() {
	_clear_user_point_models();
	setsize(_user_point_models, _N);
	var user_points = _user_points.get_sliced();
	for (var ii = 0; ii < _N; ii += 1) {
		var model = "Models/Autopush/cursor.xml";
		if (_user_point_modes.arr[ii] == 1) {
			model = "Models/Autopush/cursor_sharp.xml";
		} else if (_user_point_modes.arr[ii] == 2) {
			model = "Models/Autopush/cursor_reverse.xml";
		}
		_user_point_models[ii] = geo.put_model(model, user_points[ii], 0.0);
	}
}

var _clear_user_point_models = func() {
	for (var ii = 0; ii < size(_user_point_models); ii += 1) {
		if (_user_point_models[ii] != nil) {
			_user_point_models[ii].remove();
			_user_point_models[ii] = nil;
		}
	}
	setsize(_user_point_models, 0);
}

var _place_waypoint_models = func() {
	_clear_waypoint_models();
	setsize(_waypoint_models, size(_route));
	for (var ii = 0; ii < size(_route); ii += 1) {
		_waypoint_models[ii] = geo.put_model("Models/Autopush/waypoint.xml", _route[ii], _route_hdg[ii]);
	}
}

var _clear_waypoint_models = func() {
	for (var ii = 0; ii < size(_waypoint_models); ii += 1) {
		if (_waypoint_models[ii] != nil) {
			_waypoint_models[ii].remove();
			_waypoint_models[ii] = nil;
		}
	}
	setsize(_waypoint_models, 0);
}

var _set_view = func() {
	if (!getprop("/sim/current-view/internal")){
		_view_changed_or_external = 1;
		return;
	}
	_view_index = getprop("/sim/current-view/view-number");
	# While "Chase View Without Yaw" would have looked better, only "Model View" resets its z-offset back to normal by itself.
	setprop("/sim/current-view/view-number", view.indexof("Model View"));
	setprop("/sim/current-view/z-offset-m", -500.0);
	setprop("/sim/current-view/pitch-offset-deg", 90.0);
	setprop("/sim/current-view/heading-offset-deg", 0.0);
	_view_changed_or_external = 0;
	_view_listener = setlistener("/sim/current-view/name", func {
		_view_changed_or_external = 1;
	});
}

var _reset_view = func() {
	if (!_view_changed_or_external) {
		setprop("/sim/current-view/view-number", _view_index);
	}
	if (_view_listener != nil) {
		removelistener(_view_listener);
		_view_listener = nil;
	}
	if (!_show) {
		_clear_user_point_models();
		_clear_waypoint_models();
	}
}

var _calculate_route = func() {
	_route = [];
	_route_reverse = [];
	var user_points = _user_points.get_sliced();
	var route = dynarr.dynarr.new();
	# add the first point cause it will be fix at this pos
	route.add(geo.Coord.new(user_points[0]));
	n = size(user_points);
	var base = 0;
	# Detect points where push/pull direction is reversed.
	for (var i = 0; i < n; i += 1) {
		if (i and (i < n - 1)) {
			if((_user_point_modes.arr[i] == 1) or (_user_point_modes.arr[i] == 2)) {
				var newmode = 1;
				var deltaA = abs(geo.normdeg180(user_points[i - 1].course_to(user_points[i]) - user_points[i].course_to(user_points[i + 1])));
				if (deltaA > 91.0) {
					newmode = 2;
				}
				if(newmode != _user_point_modes.arr[i]){
					_set_userpoint_mode(i, newmode);
				}
			}
		} else {
			# Clear reverse for first and last points.
			if(_user_point_modes.arr[i] == 2) {
				if(_user_point_modes.arr[i] != 1){
					_set_userpoint_mode(i, 1);
				}
			}
		}
	}
	for (var i = 0; i < n; i += 1) {
		if (_user_point_modes.arr[i] or (i == n - 1)) {
			if (i - base > 0) {
				var bezier = _calculate_bezier(user_points[base:i]);
				if (bezier != nil) {
					var m = size(bezier);
					for (var j = 0; j < m; j += 1) {
						route.add(geo.Coord.new(bezier[j]));
					}
				}
			}
			base = i;
			route.add(geo.Coord.new(user_points[i]));
			if (_user_point_modes.arr[i] == 2) {
				var route_size = size(route.get_sliced());
				setsize(_route_reverse, route_size);
				_route_reverse[route_size - 1] = 1;
			}
		}
	}
	var PNumber = size(user_points);
	_route = route.get_sliced();
	setsize(_route_reverse, size(_route));
	_check_turn_radius();
	_calculate_hdg();
}

var _calculate_bezier = func(user_points) {
	var route = dynarr.dynarr.new();

	var PNumber = size(user_points);

	if (PNumber > 1) {
		var pointList = [];
		setsize(pointList, PNumber);
		for (var i = 0; i < PNumber; i += 1) {
			pointList[i] = [];
			setsize(pointList[i], PNumber);
		}

		pointList[0] = user_points;

		var len = 0;
		for (var i = 0; i < PNumber - 1; i += 1) {
			len += user_points[i].distance_to(user_points[i + 1]);
		}

		var step = _R_turn_min / len;

		for (var i = step; i < 1 - step; i+= step) {
			# start iterating from 1 cause we don't need to iterate over Pn
			for (var j = 1; j < PNumber; j += 1) {
				for (var k = 0; k < PNumber - j; k += 1) {
					pointList[j][k] = geo.Coord.new(pointList[j - 1][k]);
					var dist = pointList[j - 1][k].distance_to(pointList[j - 1][k + 1]);
					var course = pointList[j - 1][k].course_to(pointList[j - 1][k + 1]);
					pointList[j][k].apply_course_distance(course, dist * i);
				}
			}
			pointList[PNumber - 1][0].set_alt(geo.elevation(pointList[PNumber - 1][0].lat(),pointList[PNumber - 1][0].lon()));
			route.add(geo.Coord.new(pointList[PNumber - 1][0]));
		}
	}

	return route.get_sliced();
}

var _calculate_hdg = func() {
	_route_hdg = [];
	var route_hdg = dynarr.dynarr.new();
	var ilast = size(_route) - 1;
	for (i = 0; i < ilast; i += 1) {
		var hdg = _route[i].course_to(_route[i + 1]);
		route_hdg.add(hdg);
	}
	# Last heading would be undefined, so just repeat the one before the last.
	route_hdg.add(route_hdg.get_sliced()[ilast - 1]);
	_route_hdg = route_hdg.get_sliced();
}

# Checks each waypoint's turn radius and marks the route invalid if
# it is smaller than the aircraft's turn radius.
var _check_turn_radius = func() {
	# A waypoint's turn radius is the radius of a circle circumscribed around the waypoint, previous and next waypoints.
	# Formula source: https://math.stackexchange.com/questions/947882/radius-of-circumscribed-circle-of-triangle-as-function-of-the-sides

	var len = size(_route);
	_invalid = 0;

	# We can't calculate the radius for the first and last point
	for (i = 1; i < len - 2; i += 1) {
		# Disable check for push and pull points
		if (_route_reverse[i] != 1) {
			var a = _route[i].distance_to(_route[i + 1]);
			var b = _route[i].distance_to(_route[i - 1]);
			var c = _route[i - 1].distance_to(_route[i + 1]);


			var margin = _R_turn_min / 5000;

			# Stright line check with marging to prevent floating point error
			if (a + b + margin >= c and a + b - margin <= c) {
				var r = - 1;
			} else {
				var r = (a * b * c) / math.sqrt(
						2 * a * a * b * b
						+ 2 * a * a * c * c
						+ 2 * b * b * c * c
						- a * a * a * a
						- b * b * b * b
						- c * c * c * c
					);
			}

			if ((r < _R_turn_min) and (r != -1)) {
				_invalid = 1;
			}
		}
	}

	setprop("/sim/model/autopush/route/invalid", _invalid);
}

setlistener("/sim/model/autopush/route/show", func(p) {
	var show = p.getValue();
	if (_listener == nil) {
		if (show > _show) {
			_place_user_point_models();
			_place_waypoint_models();
		} else if (show < _show) {
			_clear_user_point_models();
			_clear_waypoint_models();
		}
	}
	_show = show;
});


var enter = func() {
	clear();
	_set_view();
	_R_turn_min = getprop("/sim/model/autopush/min-turn-radius-m");
	var wp = geo.aircraft_position();
	var H = geo.elevation(wp.lat(), wp.lon());
	if (H != nil) {
		wp.set_alt(H);
	}
	_add(wp);
	_listener = setlistener("/sim/signals/click", func {
		_add(geo.click_position());
	});
	# This property can be overridden manually, if needed.
	var wingspan = getprop("/sim/model/autopush/route/wingspan-m");
	if ((wingspan == nil) or (wingspan == 0.0)) {
		# JSBSim
		wingspan = getprop("/fdm/jsbsim/metrics/bw-ft");
		if (wingspan != nil) {
			wingspan *= FT2M;
		} else {
			# YAsim
			wingspan = getprop("/fdm/yasim/model/wings/wing/wing-span");
		}
		setprop("/sim/model/autopush/route/wingspan-m", wingspan);
	}
}

var _set_userpoint_mode = func(id, mode) {
	if (_user_point_modes.arr[id] != mode) {
		_user_point_modes.arr[id] = mode;
	}
	if (_user_point_models[id] != nil) {
		_user_point_models[id].remove();
		var model = "Models/Autopush/cursor.xml";
		if (_user_point_modes.arr[id] == 1) {
			model = "Models/Autopush/cursor_sharp.xml";
		} else if (_user_point_modes.arr[id] == 2) {
			model = "Models/Autopush/cursor_reverse.xml";
		}
		_user_point_models[id] = geo.put_model(model, _user_points.get_sliced()[id], 0.0);
	}
}

var toggle_sharp = func() {
	if (_listener == nil) {
		return;
	}
	id = _N - 1;
	if (_user_point_modes.arr[id]) {
		_set_userpoint_mode(id, 0);
	} else {
		_set_userpoint_mode(id, 1);
	}
}

var done = func() {
	_stop(0);
}

var clear = func() {
	autopush_driver.stop();
	_stop(1);
	_clear_user_point_models();
	_clear_waypoint_models();
	_N = 0;
	_user_points = dynarr.dynarr.new(4);
	_user_point_modes = dynarr.dynarr.new(1);
}

var route = func() {
	if (_invalid or (_N < 2)) {
		return nil;
	}
	return _route;
}

var route_reverse = func() {
	if (_invalid or (_N < 2)) {
		return nil;
	}
	return _route_reverse;
}
