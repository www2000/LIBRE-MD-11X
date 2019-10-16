# MD-11 FMS
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

setprop("/FMS/internal/v2", 163);

var CORE = {
	resetFMS: func() {
		setprop("/FMS/internal/v2", 163);
		afs.ITAF.init(1);
	},
	stateCheck: func() {
		if (getprop("/engines/engine[0]/state") == 0 and getprop("/engines/engine[1]/state") == 0 and getprop("/engines/engine[2]/state") == 0) {
			me.resetFMS();
		}
	},
};

setlistener("/engines/engine[0]/state", func {
	CORE.stateCheck();
}, 0, 0);

setlistener("/engines/engine[1]/state", func {
	CORE.stateCheck();
}, 0, 0);

setlistener("/engines/engine[2]/state", func {
	CORE.stateCheck();
}, 0, 0);
