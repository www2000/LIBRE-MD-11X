# McDonnell Douglas MD-11 Shaking
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

var sf = 0;

var theShakeEffect = func{
	sf = pts.Gear.rollspeedMs[0].getValue() / 94000;

	if (pts.Systems.Shake.effect.getBoolValue() and (pts.Gear.wow[0].getBoolValue() or pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue())) {
		interpolate("/systems/shake/shaking", sf, 0.03);
		settimer(func {
			interpolate("/systems/shake/shaking", -sf * 2, 0.03);
		}, 0.06);
		settimer(func {
			interpolate("/systems/shake/shaking", sf, 0.03);
		}, 0.12);
		settimer(theShakeEffect, 0.09);
	} else {
		pts.Systems.Shake.effect.setBoolValue(0);
		setprop("/systems/shake/shaking", 0); # Why do props.nas when I need interpolate above anyways...
	}
}

setlistener("/systems/shake/effect", func {
	if (pts.Systems.Shake.effect.getBoolValue()) {
		theShakeEffect();
	}
}, 0, 0);
