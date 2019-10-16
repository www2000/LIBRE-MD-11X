# MD-11 EFIS controller by Joshua Davidson (Octal450).

# Copyright (c) 2019 Joshua Davidson (Octal450)
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

setlistener("sim/signals/fdm-initialized", func {
	setprop("/instrumentation/efis[0]/mfd/display-mode", "MAP");
	setprop("/instrumentation/efis[0]/inputs/nd-centered", 0);
	setprop("/instrumentation/efis[0]/inputs/range-nm", 10);
	setprop("/instrumentation/efis[0]/inputs/tfc", 0);
	setprop("/instrumentation/efis[0]/inputs/data", 0);
	setprop("/instrumentation/efis[0]/inputs/wpt", 0);
	setprop("/instrumentation/efis[0]/inputs/sta", 0);
	setprop("/instrumentation/efis[0]/inputs/arpt", 0);
	setprop("/instrumentation/efis[0]/inputs/lh-vor-adf", 0);
	setprop("/instrumentation/efis[0]/inputs/rh-vor-adf", 0);
	setprop("/instrumentation/efis[1]/mfd/display-mode", "MAP");
	setprop("/instrumentation/efis[1]/inputs/nd-centered", 0);
	setprop("/instrumentation/efis[1]/inputs/range-nm", 10);
	setprop("/instrumentation/efis[1]/inputs/tfc", 0);
	setprop("/instrumentation/efis[1]/inputs/data", 0);
	setprop("/instrumentation/efis[1]/inputs/wpt", 0);
	setprop("/instrumentation/efis[1]/inputs/sta", 0);
	setprop("/instrumentation/efis[1]/inputs/arpt", 0);
	setprop("/instrumentation/efis[1]/inputs/lh-vor-adf", 0);
	setprop("/instrumentation/efis[1]/inputs/rh-vor-adf", 0);
});

var setCptND = func(m) {
	setprop("/instrumentation/efis[0]/mfd/display-mode", m);
	if (m == "MAP") {
		setprop("/instrumentation/efis[0]/inputs/nd-centered", 0);
	} else {
		setprop("/instrumentation/efis[0]/inputs/nd-centered", 1);
	}
}

var setFoND = func(m) {
	setprop("/instrumentation/efis[1]/mfd/display-mode", m);
	if (m == "MAP") {
		setprop("/instrumentation/efis[1]/inputs/nd-centered", 0);
	} else {
		setprop("/instrumentation/efis[1]/inputs/nd-centered", 1);
	}
}

var setNDRange = func(n, d) {
	var rng = getprop("/instrumentation/efis[" ~ n ~ "]/inputs/range-nm");
	if (d == 1) {
		rng = rng * 2;
		if (rng > 640) {
			rng = 640;
		}
	} else if (d == -1){
		rng = rng / 2;
		if (rng < 5) {
			rng = 5;
		}
	}
	setprop("/instrumentation/efis[" ~ n ~ "]/inputs/range-nm", rng);
}

var setCptNDRadio = func(b) {
	var lh = getprop("/instrumentation/efis[0]/inputs/lh-vor-adf");
	var rh = getprop("/instrumentation/efis[0]/inputs/rh-vor-adf");

	if (b == "VOR1") {
		if (lh == 1) {
			setprop("/instrumentation/efis[0]/inputs/lh-vor-adf", 0);
		} else {
			setprop("/instrumentation/efis[0]/inputs/lh-vor-adf", 1);
		}
	} else if (b == "ADF1") {
		if (lh == -1) {
			setprop("/instrumentation/efis[0]/inputs/lh-vor-adf", 0);
		} else {
			setprop("/instrumentation/efis[0]/inputs/lh-vor-adf", -1);
		}
	} else if (b == "VOR2") {
		if (rh == 1) {
			setprop("/instrumentation/efis[0]/inputs/rh-vor-adf", 0);
		} else {
			setprop("/instrumentation/efis[0]/inputs/rh-vor-adf", 1);
		}
	} else if (b == "ADF2") {
		if (rh == -1) {
			setprop("/instrumentation/efis[0]/inputs/rh-vor-adf", 0);
		} else {
			setprop("/instrumentation/efis[0]/inputs/rh-vor-adf", -1);
		}
	}
}

var setFoNDRadio = func(b) {
	var lh = getprop("/instrumentation/efis[1]/inputs/lh-vor-adf");
	var rh = getprop("/instrumentation/efis[1]/inputs/rh-vor-adf");

	if (b == "VOR1") {
		if (lh == 1) {
			setprop("/instrumentation/efis[1]/inputs/lh-vor-adf", 0);
		} else {
			setprop("/instrumentation/efis[1]/inputs/lh-vor-adf", 1);
		}
	} else if (b == "ADF1") {
		if (lh == -1) {
			setprop("/instrumentation/efis[1]/inputs/lh-vor-adf", 0);
		} else {
			setprop("/instrumentation/efis[1]/inputs/lh-vor-adf", -1);
		}
	} else if (b == "VOR2") {
		if (rh == 1) {
			setprop("/instrumentation/efis[1]/inputs/rh-vor-adf", 0);
		} else {
			setprop("/instrumentation/efis[1]/inputs/rh-vor-adf", 1);
		}
	} else if (b == "ADF2") {
		if (rh == -1) {
			setprop("/instrumentation/efis[1]/inputs/rh-vor-adf", 0);
		} else {
			setprop("/instrumentation/efis[1]/inputs/rh-vor-adf", -1);
		}
	}
}
