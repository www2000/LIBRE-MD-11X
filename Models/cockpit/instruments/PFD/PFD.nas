# MD-11 PFD

# Copyright (c) 2019 Joshua Davidson (Octal450)

var PFD_1 = nil;
var PFD_2 = nil;
var PFD_1_mismatch = nil;
var PFD_2_mismatch = nil;
var PFD1_display = nil;
var PFD2_display = nil;
var updateL = 0;
var updateR = 0;
var ASI = 0;
var ASImax = 0;
var ASIflapmax = 0;
var ASIpresel = 0;
var ASIpreseldiff = 0;
var ASIsel = 0;
var ASIseldiff = 0;
var ASItrend = 0;
var pitch = 0;
var roll = 0;
var alpha = 0;
var altTens = 0;
var altPolarity = "";
var HDG = "000";
var HDGraw = 0;
var HDGpresel = 0;
var HDGsel = 0;
var LOC = 0;
var GS = 0;
var FMAAlt = 0;

# Fetch nodes:
var ap1 = props.globals.getNode("/it-autoflight/output/ap1", 1);
var ap2 = props.globals.getNode("/it-autoflight/output/ap2", 1);
var ats = props.globals.getNode("/it-autoflight/output/athr", 1);
var fd1 = props.globals.getNode("/it-autoflight/output/fd1", 1);
var fd2 = props.globals.getNode("/it-autoflight/output/fd2", 1);
var apvert = props.globals.getNode("/it-autoflight/output/vert", 1);
var apwarn = props.globals.getNode("/it-autoflight/custom/apwarn", 1);
var apsound = props.globals.getNode("/it-autoflight/sound/apoffsound", 1);
var atswarn = props.globals.getNode("/it-autoflight/custom/atswarn", 1);
var atsflash = props.globals.getNode("/it-autoflight/custom/atsflash", 1);
var ovrd1 = props.globals.getNode("/it-autoflight/input/ovrd1");
var ovrd2 = props.globals.getNode("/it-autoflight/input/ovrd2");
var apdiscbtn1 = props.globals.getNode("/controls/switches/ap-yoke-button1", 1);
var apdiscbtn2 = props.globals.getNode("/controls/switches/ap-yoke-button2", 1);
var throttle_mode = props.globals.getNode("/it-autoflight/mode/thr", 1);
var roll_mode = props.globals.getNode("/modes/pfd/fma/roll-mode", 1);
var roll_mode_armed = props.globals.getNode("/modes/pfd/fma/roll-mode-armed", 1);
var pitch_mode = props.globals.getNode("/modes/pfd/fma/pitch-mode", 1);
var pitch_mode_armed = props.globals.getNode("/modes/pfd/fma/pitch-mode-armed", 1);
var land_mode = props.globals.getNode("/it-autoflight/mode/land", 1);
var speed = props.globals.getNode("/instrumentation/airspeed-indicator/indicated-speed-kt", 1);
var mach = props.globals.getNode("/instrumentation/airspeed-indicator/indicated-mach", 1);
var IASmax = props.globals.getNode("/controls/fctl/vmo-mmo", 1);
var IASpresel = props.globals.getNode("/it-autoflight/internal/ias-presel", 1);
var IASsel = props.globals.getNode("/it-autoflight/internal/ias-sel", 1);
var altpresel = props.globals.getNode("/instrumentation/pfd/alt-presel", 1);
var altsel = props.globals.getNode("/instrumentation/pfd/alt-sel", 1);
var ASItrend = props.globals.getNode("/instrumentation/pfd/speed-lookahead", 1);
var IASflapmax = props.globals.getNode("/controls/fctl/flap-gear-max", 1);
var pitch = props.globals.getNode("/orientation/pitch-deg", 1);
var roll = props.globals.getNode("/orientation/roll-deg", 1);
var alpha = props.globals.getNode("/fdm/jsbsim/aero/alpha-deg-damped", 1);
var banklimit = props.globals.getNode("/instrumentation/pfd/bank-limit", 1);
var wow1 = props.globals.getNode("/gear/gear[1]/wow", 1);
var wow2 = props.globals.getNode("/gear/gear[2]/wow", 1);
var apmode = props.globals.getNode("/modes/pfd/fma/ap-mode", 1);
var showhdg = props.globals.getNode("/it-autoflight/custom/show-hdg", 1);
var hdgscale = props.globals.getNode("/instrumentation/pfd/heading-scale", 1);
var aplat = props.globals.getNode("/it-autoflight/output/lat", 1);
var vspfd = props.globals.getNode("/it-autoflight/internal/vert-speed-fpm-pfd", 1);
var internalvs = props.globals.getNode("/it-autoflight/internal/vert-speed-fpm", 1);
var gs = props.globals.getNode("/velocities/groundspeed-kt", 1);
var altitude = props.globals.getNode("/instrumentation/altimeter/indicated-altitude-ft", 1);
var IR0align = props.globals.getNode("/controls/irs/ir[0]/align", 1);
var IR1align = props.globals.getNode("/controls/irs/ir[1]/align", 1);
var IR2align = props.globals.getNode("/controls/irs/ir[2]/align", 1);
var IR0aligned = props.globals.getNode("/instrumentation/irs/ir[0]/aligned", 1);
var IR1aligned = props.globals.getNode("/instrumentation/irs/ir[1]/aligned", 1);
var IR2aligned = props.globals.getNode("/instrumentation/irs/ir[2]/aligned", 1);
var eng0state = props.globals.getNode("/engines/engine[0]/state", 1);
var eng1state = props.globals.getNode("/engines/engine[1]/state", 1);
var eng2state = props.globals.getNode("/engines/engine[2]/state", 1);
var gearagl = props.globals.getNode("/position/gear-agl-ft", 1);
var ktsmach = props.globals.getNode("/it-autoflight/input/kts-mach", 1);
var aphdg = props.globals.getNode("/it-autoflight/input/hdg", 1);
var apspd = props.globals.getNode("/it-autoflight/input/spd-kts", 1);
var apmach = props.globals.getNode("/it-autoflight/input/spd-mach", 1);
var apalt = props.globals.getNode("/it-autoflight/internal/alt", 1);
var slat = props.globals.getNode("/controls/flight/slats-cmd", 1);
var flap = props.globals.getNode("/controls/flight/flaps-cmd", 1);
var flapmaxdeg = props.globals.getNode("/fdm/jsbsim/fcc/flap/max-deg", 1);
var slip_skid = props.globals.getNode("/instrumentation/pfd/slip-skid", 1);
var fdroll = props.globals.getNode("/it-autoflight/fd/roll-bar", 1);
var fdpitch = props.globals.getNode("/it-autoflight/fd/pitch-bar", 1);
var qnhinhg = props.globals.getNode("/modes/altimeter/inhg", 1);
var qnhstd = props.globals.getNode("/modes/altimeter/std", 1);
var altin = props.globals.getNode("/instrumentation/altimeter/setting-inhg", 1);
var althp = props.globals.getNode("/instrumentation/altimeter/setting-hpa", 1);
var fpa = props.globals.getNode("/it-autoflight/input/fpa", 1);
var apfpa = props.globals.getNode("/it-autoflight/custom/vs-fpa", 1);
var pfdrate = props.globals.getNode("/systems/acconfig/options/pfd-rate", 1);
var mismatch = props.globals.getNode("/systems/acconfig/mismatch-code", 1);
var nav0defl = props.globals.getNode("/instrumentation/nav[0]/heading-needle-deflection-norm", 1);
var gs0defl = props.globals.getNode("/instrumentation/nav[0]/gs-needle-deflection-norm", 1);
var nav0range = props.globals.getNode("/instrumentation/nav[0]/in-range", 1);
var gs0range = props.globals.getNode("/instrumentation/nav[0]/gs-in-range", 1);
var nav0signal = props.globals.getNode("/instrumentation/nav[0]/signal-quality-norm", 1);
var hasgs = props.globals.getNode("/instrumentation/nav[0]/has-gs", 1);
var navloc = props.globals.getNode("/instrumentation/nav[0]/nav-loc", 1);
var rev1 = props.globals.getNode("/engines/engine[0]/reverser-pos-norm");
var rev2 = props.globals.getNode("/engines/engine[1]/reverser-pos-norm");
var rev3 = props.globals.getNode("/engines/engine[2]/reverser-pos-norm");
var minimums = props.globals.getNode("/controls/switches/minimums", 1);

# Create Nodes:
var vsup = props.globals.initNode("/instrumentation/pfd/vs-needle-up", 0.0, "DOUBLE");
var vsdn = props.globals.initNode("/instrumentation/pfd/vs-needle-dn", 0.0, "DOUBLE");
var hdgprediff = props.globals.initNode("/instrumentation/pfd/hdg-pre-diff", 0.0, "DOUBLE");
var hdgdiff = props.globals.initNode("/instrumentation/pfd/hdg-diff", 0.0, "DOUBLE");
var trackdiff = props.globals.initNode("/instrumentation/pfd/track-hdg-diff", 0.0, "DOUBLE");

var canvas_PFD_base = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);

			var clip_el = canvas_group.getElementById(key ~ "_clip");
			if (clip_el != nil) {
				clip_el.setVisible(0);
				var tran_rect = clip_el.getTransformedBounds();

				var clip_rect = sprintf("rect(%d,%d, %d,%d)", 
				tran_rect[1], # 0 ys
				tran_rect[2], # 1 xe
				tran_rect[3], # 2 ye
				tran_rect[0]); #3 xs
				#   coordinates are top,right,bottom,left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
				me[key].set("clip", clip_rect);
				me[key].set("clip-frame", canvas.Element.PARENT);
			}
		}
		
		me.AI_horizon_trans = me["AI_horizon"].createTransform();
		me.AI_horizon_rot = me["AI_horizon"].createTransform();
		
		me.AI_fpd_trans = me["AI_fpd"].createTransform();
		me.AI_fpd_rot = me["AI_fpd"].createTransform();
		
		me.page = canvas_group;
		
		return me;
	},
	getKeys: func() {
		return ["FMA_Speed","FMA_Thrust","FMA_Roll","FMA_Roll_Arm","FMA_Pitch","FMA_Pitch_Land","FMA_Land","FMA_Pitch_Arm","FMA_Altitude_Thousand","FMA_Altitude","FMA_ATS_Thrust_Off","FMA_ATS_Pitch_Off","FMA_AP_Pitch_Off_Box","FMA_AP_Thrust_Off_Box","FMA_AP",
		"ASI_v_speed","ASI_Taxi","ASI_GroundSpd","ASI_scale","ASI_bowtie","ASI_bowtie_mach","ASI","ASI_mach","ASI_mach_decimal","ASI_bowtie_L","ASI_bowtie_R","ASI_presel","ASI_sel","ASI_trend_up","ASI_trend_down","ASI_max","ASI_max_bar","ASI_max_bar2",
		"ASI_max_flap","AI_center","AI_horizon","AI_bank","AI_slipskid","AI_overbank_index","AI_banklimit_L","AI_banklimit_R","AI_alphalim","AI_group","AI_group2","AI_group3","AI_error","AI_fpv","AI_fpd","AI_arrow_up","AI_arrow_dn","FD_roll","FD_pitch",
		"ALT_thousands","ALT_hundreds","ALT_tens","ALT_scale","ALT_scale_num","ALT_one","ALT_two","ALT_three","ALT_four","ALT_five","ALT_one_T","ALT_two_T","ALT_three_T","ALT_four_T","ALT_five_T","ALT_presel","ALT_sel","ALT_agl","ALT_bowtie","VSI_needle_up",
		"VSI_needle_dn","VSI_up","VSI_down","VSI_group","VSI_error","HDG","HDG_dial","HDG_presel","HDG_sel","HDG_group","HDG_error","TRK_pointer","TCAS_OFF","Slats","Flaps","Flaps_num","Flaps_num2","Flaps_num_boxes","QNH","LOC_scale","LOC_pointer","LOC_no",
		"GS_scale","GS_pointer","GS_no","RA","RA_box","Minimums"];
	},
	update: func() {
		if (mismatch.getValue() == "0x000") {
			PFD_1_mismatch.page.hide();
			PFD_2_mismatch.page.hide();
			if (systems.ELEC.Bus.lEmerAc.getValue() >= 110) {
				PFD_1.updateFast();
				PFD_1.update();
				updateL = 1;
				PFD_1.page.show();
			} else {
				updateL = 0;
				PFD_1.page.hide();
			}
			if (systems.ELEC.Bus.ac3.getValue() >= 110) {
				PFD_2.updateFast();
				PFD_2.update();
				updateR = 1;
				PFD_2.page.show();
			} else {
				updateR = 0;
				PFD_2.page.hide();
			}
		} else {
			updateL = 0;
			updateR = 0;
			PFD_1.page.hide();
			PFD_2.page.hide();
			PFD_1_mismatch.update();
			PFD_2_mismatch.update();
			PFD_1_mismatch.page.show();
			PFD_2_mismatch.page.show();
		}
	},
	updateSlow: func() {
		if (updateL) {
			PFD_1.update();
		}
		if (updateR) {
			PFD_2.update();
		}
	},
	updateCommon: func () {
		# FMA
		if (land_mode.getValue() == "DUAL") {
			me["FMA_Altitude_Thousand"].hide();
			me["FMA_Altitude"].hide();
			me["FMA_Land"].setColor(0,1,0);
			me["FMA_Pitch_Land"].setColor(0,1,0);
			me["FMA_Land"].setText("DUAL LAND");
			me["FMA_Land"].show();
			me["FMA_Pitch_Land"].setText(sprintf("%s", pitch_mode.getValue()));
			me["FMA_Pitch_Land"].show();
		} else if (land_mode.getValue() == "SINGLE") {
			me["FMA_Altitude_Thousand"].hide();
			me["FMA_Altitude"].hide();
			me["FMA_Land"].setColor(1,1,1);
			me["FMA_Pitch_Land"].setColor(1,1,1);
			me["FMA_Land"].setText("SINGLE LAND");
			me["FMA_Land"].show();
			me["FMA_Pitch_Land"].setText(sprintf("%s", pitch_mode.getValue()));
			me["FMA_Pitch_Land"].show();
		} else if (land_mode.getValue() == "APPR") {
			me["FMA_Altitude_Thousand"].hide();
			me["FMA_Altitude"].hide();
			me["FMA_Land"].setColor(1,1,1);
			me["FMA_Pitch_Land"].setColor(1,1,1);
			me["FMA_Land"].setText("APPR ONLY");
			me["FMA_Land"].show();
			me["FMA_Pitch_Land"].setText(sprintf("%s", pitch_mode.getValue()));
			me["FMA_Pitch_Land"].show();
		} else if (land_mode.getValue() == "OFF") {
			me["FMA_Land"].hide();
			me["FMA_Pitch_Land"].hide();
			FMAAlt = apalt.getValue();
			if (FMAAlt < 1000) {
				me["FMA_Altitude_Thousand"].hide();
			} else {
				me["FMA_Altitude_Thousand"].setText(sprintf("%2.0f", math.floor(FMAAlt / 1000)));
				me["FMA_Altitude_Thousand"].show();
			}
			me["FMA_Altitude"].setText(right(sprintf("%03d", FMAAlt), 3));
			me["FMA_Altitude"].show();
		}
		
		if (pitch_mode.getValue() == "ROLLOUT") {
			me["FMA_Pitch_Land"].setTranslation(-20, 0);
		} else {
			me["FMA_Pitch_Land"].setTranslation(0, 0);
		}
		
		if (atsflash.getValue() == 1) {
			me["FMA_ATS_Pitch_Off"].setColor(1,0,0);
			me["FMA_ATS_Thrust_Off"].setColor(1,0,0);
		} else if (ovrd1.getBoolValue() and ovrd2.getBoolValue()) {
			me["FMA_ATS_Pitch_Off"].setColor(0.9412,0.7255,0);
			me["FMA_ATS_Thrust_Off"].setColor(0.9412,0.7255,0);
		} else if ((eng0state.getValue() != 3 and eng1state.getValue() != 3 and eng2state.getValue() != 3) or rev1.getValue() >= 0.01 or rev2.getValue() >= 0.01 or rev3.getValue() >= 0.01) {
			me["FMA_ATS_Pitch_Off"].setColor(0.9412,0.7255,0);
			me["FMA_ATS_Thrust_Off"].setColor(0.9412,0.7255,0);
		} else {
			me["FMA_ATS_Pitch_Off"].setColor(1,1,1);
			me["FMA_ATS_Thrust_Off"].setColor(1,1,1);
		}
		
		if (apsound.getValue() == 1) {
			me["FMA_AP_Pitch_Off_Box"].setColor(1,0,0);
			me["FMA_AP_Thrust_Off_Box"].setColor(1,0,0);
		} else if (ovrd1.getBoolValue() and ovrd2.getBoolValue()) {
			me["FMA_AP_Pitch_Off_Box"].setColor(0.9412,0.7255,0);
			me["FMA_AP_Thrust_Off_Box"].setColor(0.9412,0.7255,0);
		} else if ((apdiscbtn1.getBoolValue() or apdiscbtn2.getBoolValue()) and !ap1.getBoolValue() and !ap2.getBoolValue()) {
			me["FMA_AP_Pitch_Off_Box"].setColor(0.9412,0.7255,0);
			me["FMA_AP_Thrust_Off_Box"].setColor(0.9412,0.7255,0);
		} else if (IR0aligned.getValue() == 0 and IR1aligned.getValue() == 0 and IR2aligned.getValue() == 0) {
			me["FMA_AP_Pitch_Off_Box"].setColor(0.9412,0.7255,0);
			me["FMA_AP_Thrust_Off_Box"].setColor(0.9412,0.7255,0);
		} else if (eng0state.getValue() != 3 and eng1state.getValue() != 3 and eng2state.getValue() != 3 and wow1.getValue() != 0 and wow2.getValue() != 0) {
			me["FMA_AP_Pitch_Off_Box"].setColor(0.9412,0.7255,0);
			me["FMA_AP_Thrust_Off_Box"].setColor(0.9412,0.7255,0);
		} else {
			me["FMA_AP_Pitch_Off_Box"].setColor(1,1,1);
			me["FMA_AP_Thrust_Off_Box"].setColor(1,1,1);
		}
		
		if (ats.getValue() == 1) {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].hide();
		} else if (atsflash.getValue() == 1 and atswarn.getValue() != 1) {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].hide();
		} else if (atsflash.getValue() == 1 and atswarn.getValue() == 1 and throttle_mode.getValue() == "PITCH") {
			me["FMA_ATS_Pitch_Off"].show();
			me["FMA_ATS_Thrust_Off"].hide();
		} else if (atsflash.getValue() == 1 and atswarn.getValue() == 1 and throttle_mode.getValue() != "PITCH") {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].show();
		} else if (throttle_mode.getValue() == "PITCH") {
			me["FMA_ATS_Pitch_Off"].show();
			me["FMA_ATS_Thrust_Off"].hide();
		} else {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].show();
		}
		
		if (ap1.getValue() == 1 or ap2.getValue() == 1) {
			me["FMA_AP"].setColor(0.3215,0.8078,1);
			me["FMA_AP"].setText(sprintf("%s", apmode.getValue()));
			me["FMA_AP"].show();
		} else if (apsound.getValue() == 1 and apwarn.getValue() != 1) {
			me["FMA_AP"].hide();
		} else if (apsound.getValue() == 1 and apwarn.getValue() == 1) {
			me["FMA_AP"].setColor(1,0,0);
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP"].show();
		} else if (apdiscbtn1.getBoolValue() or apdiscbtn2.getBoolValue() or (ovrd1.getBoolValue() and ovrd2.getBoolValue())) {
			me["FMA_AP"].setColor(0.9412,0.7255,0);
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP"].show();
		} else if (throttle_mode.getValue() == "PITCH") {
			if (IR0aligned.getValue() == 0 and IR1aligned.getValue() == 0 and IR2aligned.getValue() == 0) {
				me["FMA_AP"].setColor(0.9412,0.7255,0);
			} else if (eng0state.getValue() != 3 and eng1state.getValue() != 3 and eng2state.getValue() != 3 and wow1.getValue() != 0 and wow2.getValue() != 0) {
				me["FMA_AP"].setColor(0.9412,0.7255,0);
			} else {
				me["FMA_AP"].setColor(1,1,1);
			}
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP"].show();
		} else {
			if (IR0aligned.getValue() == 0 and IR1aligned.getValue() == 0 and IR2aligned.getValue() == 0) {
				me["FMA_AP"].setColor(0.9412,0.7255,0);
			} else if (eng0state.getValue() != 3 and eng1state.getValue() != 3 and eng2state.getValue() != 3 and wow1.getValue() != 0 and wow2.getValue() != 0) {
				me["FMA_AP"].setColor(0.9412,0.7255,0);
			} else {
				me["FMA_AP"].setColor(1,1,1);
			}
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP"].show();
		}
		
		if (ap1.getValue() == 1 or ap2.getValue() == 1) {
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} else if (apsound.getValue() == 1 and apwarn.getValue() != 1) {
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} else if (apsound.getValue() == 1 and apwarn.getValue() == 1 and throttle_mode.getValue() == "PITCH") {
			me["FMA_AP_Pitch_Off_Box"].show();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} else if (apsound.getValue() == 1 and apwarn.getValue() == 1 and throttle_mode.getValue() != "PITCH") {
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].show();
		} else if (throttle_mode.getValue() == "PITCH") {
			me["FMA_AP_Pitch_Off_Box"].show();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} else {
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].show();
		}
		
		if (throttle_mode.getValue() == "RETARD") {
			me["FMA_Speed"].hide();
		} else {
			if (ktsmach.getValue() == 1) {
				me["FMA_Speed"].setText(sprintf("%0.3f", apmach.getValue()));
			} else {
				me["FMA_Speed"].setText(sprintf("%3.0f", apspd.getValue()));
			}
			me["FMA_Speed"].show();
		}
		
		me["FMA_Thrust"].setText(sprintf("%s", throttle_mode.getValue()));
		if (roll_mode.getValue() == "HEADING") {
			me["FMA_Roll"].setText(sprintf("%s", roll_mode.getValue() ~ " " ~ sprintf("%03d", aphdg.getValue())));
		} else {
			me["FMA_Roll"].setText(sprintf("%s", roll_mode.getValue()));
		}
		me["FMA_Roll_Arm"].setText(sprintf("%s", roll_mode_armed.getValue()));
		me["FMA_Pitch"].setText(sprintf("%s", pitch_mode.getValue()));
		me["FMA_Pitch_Arm"].setText(sprintf("%s", pitch_mode_armed.getValue()));
		
		if (land_mode.getValue() == "DUAL") {
			me["FMA_Roll"].setColor(0,1,0);
		} else if (roll_mode.getValue() == "NAV1" or roll_mode.getValue() == "NAV2") {
			me["FMA_Roll"].setColor(0.9607,0,0.7764);
		} else {
			me["FMA_Roll"].setColor(1,1,1);
		}
		
		if (roll_mode_armed.getValue() == "NAV ARMED") {
			me["FMA_Roll_Arm"].setColor(0.9607,0,0.7764);
		} else {
			me["FMA_Roll_Arm"].setColor(1,1,1);
		}
		
		# QNH
		qnhinhgx = qnhinhg.getValue();
		if (qnhstd.getValue() == 1) {
			if (qnhinhgx == 0) {
				me["QNH"].setText("1013");
			} else if (qnhinhgx == 1) {
				me["QNH"].setText("29.92");
			}
		} else if (qnhinhgx == 0) {
			me["QNH"].setText(sprintf("%4.0f", althp.getValue()));
		} else if (qnhinhgx == 1) {
			me["QNH"].setText(sprintf("%2.2f", altin.getValue()));
		}
		
		# Slats/Flaps
		flapx = flap.getValue();
		if (slat.getValue() > 0.1 and flapx <= 0.1) {
			me["Slats"].show();
		} else {
			me["Slats"].hide();
		}
		
		if (flapx > 0.1) {
			me["Flaps"].show();
			me["Flaps_num"].setText(sprintf("%2.0f", flapx));
			me["Flaps_num"].show();
		} else {
			me["Flaps"].hide();
			me["Flaps_num"].hide();
		}
		
		if (flapx > 0.1 and flapx - 0.1 > flapmaxdeg.getValue()) {
			me["Flaps_num"].setColor(0.9647,0.8196,0.0784);
			me["Flaps_num_boxes"].show();
			me["Flaps_num2"].setText(sprintf("%2.0f", flapx));
			me["Flaps_num2"].show();
		} else {
			me["Flaps_num"].setColor(1,1,1);
			me["Flaps_num_boxes"].hide();
			me["Flaps_num2"].hide();
		}
		
		# Misc
		me["Minimums"].setText(sprintf("%4.0f", minimums.getValue()));
		if (gearagl.getValue() <= minimums.getValue()) {
			me["Minimums"].setColor(0.9412,0.7255,0);
			me["RA"].setColor(0.9412,0.7255,0);
			me["RA_box"].setColor(0.9412,0.7255,0);
		} else {
			me["Minimums"].setColor(1,1,1);
			me["RA"].setColor(1,1,1);
			me["RA_box"].setColor(1,1,1);
		}
		
		me["TCAS_OFF"].hide();
	},
	updateCommonFast: func() {
		# Airspeed
		me["ASI_v_speed"].hide();
		
		speedx = speed.getValue();
		if (speedx >= 50) {
			me["ASI_GroundSpd"].hide();
			me["ASI_Taxi"].hide();
			me["ASI_bowtie"].show();
			me["ASI_scale"].show();
			me["ASI_presel"].show();
			me["ASI_sel"].show();
			me["ASI_max"].show();
			me["ASI_max_flap"].show();
		} else {
			if (IR0align.getValue() == 1 or IR1align.getValue() == 1 or IR2align.getValue() == 1) {
				me["ASI_Taxi"].setColor(0.9412,0.7255,0);
				me["ASI_GroundSpd"].setColor(0.9412,0.7255,0);
				me["ASI_GroundSpd"].setText("NO");
			} else if (IR0aligned.getValue() != 1 and IR1aligned.getValue() != 1 and IR2aligned.getValue() != 1) {
				me["ASI_Taxi"].setColor(1,1,1);
				me["ASI_GroundSpd"].setColor(1,1,1);
				me["ASI_GroundSpd"].setText("--");
			} else {
				me["ASI_Taxi"].setColor(1,1,1);
				me["ASI_GroundSpd"].setColor(1,1,1);
				me["ASI_GroundSpd"].setText(sprintf("%3.0f", gs.getValue()));
			}
			me["ASI_GroundSpd"].show();
			me["ASI_Taxi"].show();
			me["ASI_bowtie"].hide();
			me["ASI_scale"].hide();
			me["ASI_presel"].hide();
			me["ASI_sel"].hide();
			me["ASI_max"].hide();
			me["ASI_max_flap"].hide();
		}
		
		# Subtract 50, since the scale starts at 50, but don"t allow less than 0, or more than 500 situations
		if (speedx <= 50) {
			ASI = 0;
		} else if (speedx >= 500) {
			ASI = 450;
		} else {
			ASI = speedx - 50;
		}
		
		if (IASmax.getValue() <= 50) {
			ASImax = 0 - ASI;
		} else if (IASmax.getValue() >= 500) {
			ASImax = 450 - ASI;
		} else {
			ASImax = IASmax.getValue() - 50 - ASI;
		}
		
		if (IASflapmax.getValue() < 0) {
			ASIflapmax = 0;
			me["ASI_max_bar"].show();
			me["ASI_max_bar2"].hide();
			me["ASI_max_flap"].hide();
		} else if (IASflapmax.getValue() <= 50) {
			ASIflapmax = 0 - ASI;
			me["ASI_max_bar"].hide();
			me["ASI_max_bar2"].show();
			me["ASI_max_flap"].show();
		} else if (IASflapmax.getValue() >= 500) {
			ASIflapmax = 450 - ASI;
			me["ASI_max_bar"].hide();
			me["ASI_max_bar2"].show();
			me["ASI_max_flap"].show();
		} else {
			ASIflapmax = IASflapmax.getValue() - 50 - ASI;
			me["ASI_max_bar"].hide();
			me["ASI_max_bar2"].show();
			me["ASI_max_flap"].show();
		}
		
		me["ASI_scale"].setTranslation(0, ASI * 4.48656);
		me["ASI_max"].setTranslation(0, ASImax * -4.48656);
		me["ASI_max_flap"].setTranslation(0, ASIflapmax * -4.48656);
		me["ASI"].setText(sprintf("%3.0f", speedx));
		
		if (speedx > IASmax.getValue() + 0.5) {
			me["ASI"].setColor(1,0,0);
			me["ASI_mach"].setColor(1,0,0);
			me["ASI_mach_decimal"].setColor(1,0,0);
			me["ASI_bowtie_L"].setColor(1,0,0);
			me["ASI_bowtie_R"].setColor(1,0,0);
		} else if (speedx > IASflapmax.getValue() + 0.5 and IASflapmax.getValue() >= 0) {
			me["ASI"].setColor(0.9647,0.8196,0.07843);
			me["ASI_mach"].setColor(0.9647,0.8196,0.0784);
			me["ASI_mach_decimal"].setColor(0.9647,0.8196,0.0784);
			me["ASI_bowtie_L"].setColor(0.9647,0.8196,0.0784);
			me["ASI_bowtie_R"].setColor(0.9647,0.8196,0.0784);
		} else {
			me["ASI"].setColor(1,1,1);
			me["ASI_mach"].setColor(1,1,1);
			me["ASI_mach_decimal"].setColor(1,1,1);
			me["ASI_bowtie_L"].setColor(1,1,1);
			me["ASI_bowtie_R"].setColor(1,1,1);
		}
		
		if (mach.getValue() >= 0.5) {
			me["ASI_bowtie_mach"].show();
		} else {
			me["ASI_bowtie_mach"].hide();
		}
		
		if (mach.getValue() >= 0.999) {
			me["ASI_mach"].setText("999");
		} else {
			me["ASI_mach"].setText(sprintf("%3.0f", mach.getValue() * 1000));
		}
		
		if (IASpresel.getValue() <= 50) {
			ASIpresel = 0 - ASI;
		} else if (IASpresel.getValue() >= 500) {
			ASIpresel = 450 - ASI;
		} else {
			ASIpresel = IASpresel.getValue() - 50 - ASI;
		}
		
		me["ASI_presel"].setTranslation(0, ASIpresel * -4.48656);
		
		if (IASsel.getValue() <= 50) {
			ASIsel = 0 - ASI;
		} else if (IASsel.getValue() >= 500) {
			ASIsel = 450 - ASI;
		} else {
			ASIsel = IASsel.getValue() - 50 - ASI;
		}
		
		me["ASI_sel"].setTranslation(0, ASIsel * -4.48656);
		
		ASItrendx = ASItrend.getValue() - ASI;
		me["ASI_trend_up"].setTranslation(0, math.clamp(ASItrendx, 0, 60) * -4.48656);
		me["ASI_trend_down"].setTranslation(0, math.clamp(ASItrendx, -60, 0) * -4.48656);
		
		if (ASItrendx >= 2) {
			me["ASI_trend_up"].show();
			me["ASI_trend_down"].hide();
		} else if (ASItrendx <= -2) {
			me["ASI_trend_down"].show();
			me["ASI_trend_up"].hide();
		} else {
			me["ASI_trend_up"].hide();
			me["ASI_trend_down"].hide();
		}
		
		# Attitude
		pitchx = pitch.getValue() or 0;
		rollx = roll.getValue() or 0;
		alphax = alpha.getValue() or 0;
		
		me.AI_horizon_trans.setTranslation(0, pitchx * 10.246);
		me.AI_horizon_rot.setRotation(-rollx * D2R, me["AI_center"].getCenter());
		
		trackdiffx = trackdiff.getValue();
		me["AI_fpv"].setTranslation(math.clamp(trackdiffx, -20, 20) * 10.246, math.clamp(alphax, -20, 20) * 10.246);
		if (apfpa.getValue() == 1) {
			me["AI_fpv"].show();
		} else {
			me["AI_fpv"].hide();
		}
		
		if (apvert.getValue() == 5) {
			me.AI_fpd_trans.setTranslation(0, (pitchx - alphax + (alphax * math.cos(rollx / 57.2957795131)) - fpa.getValue()) * 10.246);
			me.AI_fpd_rot.setRotation(-rollx * D2R, me["AI_center"].getCenter());
			me["AI_fpd"].show();
		} else {
			me["AI_fpd"].hide();
		}
		
		me["AI_arrow_up"].setRotation(math.clamp(-rollx, -45, 45) * D2R);
		me["AI_arrow_dn"].setRotation(math.clamp(-rollx, -45, 45) * D2R);
		if (pitchx > 25) {
			me["AI_arrow_up"].show();
			me["AI_arrow_dn"].hide();
		} else if (pitchx < -15) {
			me["AI_arrow_up"].hide();
			me["AI_arrow_dn"].show();
		} else {
			me["AI_arrow_up"].hide();
			me["AI_arrow_dn"].hide();
		}
		
		me["AI_alphalim"].setTranslation(0, math.clamp(16 - alphax, -20, 20) * -10.246);
		if (alphax >= 15.5) {
			me["AI_alphalim"].setColor(1,0,0);
		} else {
			me["AI_alphalim"].setColor(0.2156,0.5019,0.6627);
		}
		
		fdrollx = fdroll.getValue();
		fdpitchx = fdpitch.getValue();
		if (fdrollx != nil) {
			me["FD_roll"].setTranslation((fdrollx) * 2.2, 0);
		}
		if (fdpitchx != nil) {
			me["FD_pitch"].setTranslation(0, -(fdpitchx) * 3.8);
		}
		
		me["AI_slipskid"].setTranslation(math.clamp(slip_skid.getValue(), -15, 15) * 7, 0);
		me["AI_bank"].setRotation(-rollx * D2R);
		
		if (abs(rollx) >= 30.5) {
			me["AI_overbank_index"].show();
		} else {
			me["AI_overbank_index"].hide();
		}
		
		me["AI_banklimit_L"].setRotation(banklimit.getValue() * -D2R);
		me["AI_banklimit_R"].setRotation(banklimit.getValue() * D2R);
		
		# Altitude
		me.altitudeInput = altitude.getValue();
		me.altOffset = me.altitudeInput / 500 - int(me.altitudeInput / 500);
		me.middleAltText = roundaboutAlt(me.altitudeInput / 100) * 100;
		me.middleAltOffset = nil;
		if (me.altOffset > 0.5) {
			me.middleAltOffset = -(me.altOffset - 1) * 254.508;
		} else {
			me.middleAltOffset = -me.altOffset * 254.508;
		}
		me["ALT_scale"].setTranslation(0, -me.middleAltOffset);
		me["ALT_scale_num"].setTranslation(0, -me.middleAltOffset);
		me["ALT_scale"].update();
		me["ALT_scale_num"].update();
		me.five = int((me.middleAltText + 1000) * 0.001);
		me["ALT_five"].setText(sprintf("%03d", abs(1000 * (((me.middleAltText + 1000) * 0.001) - me.five))));
		me.fiveT = sprintf("%01d", abs(me.five));
		if (me.fiveT == 0) {
			me["ALT_five_T"].setText(" ");
		} else {
			me["ALT_five_T"].setText(me.fiveT);
		}
		me.four = int((me.middleAltText + 500) * 0.001);
		me["ALT_four"].setText(sprintf("%03d", abs(1000 * (((me.middleAltText + 500) * 0.001) - me.four))));
		me.fourT = sprintf("%01d", abs(me.four));
		if (me.fourT == 0) {
			me["ALT_four_T"].setText(" ");
		} else {
			me["ALT_four_T"].setText(me.fourT);
		}
		me.three = int(me.middleAltText * 0.001);
		me["ALT_three"].setText(sprintf("%03d", abs(1000 * ((me.middleAltText  * 0.001) - me.three))));
		me.threeT = sprintf("%01d", abs(me.three));
		if (me.threeT == 0) {
			me["ALT_three_T"].setText(" ");
		} else {
			me["ALT_three_T"].setText(me.threeT);
		}
		me.two = int((me.middleAltText - 500) * 0.001);
		me["ALT_two"].setText(sprintf("%03d", abs(1000 * (((me.middleAltText - 500) * 0.001) - me.two))));
		me.twoT = sprintf("%01d", abs(me.two));
		if (me.twoT == 0) {
			me["ALT_two_T"].setText(" ");
		} else {
			me["ALT_two_T"].setText(me.twoT);
		}
		me.one = int((me.middleAltText - 1000) * 0.001);
		me["ALT_one"].setText(sprintf("%03d", abs(1000 * (((me.middleAltText - 1000) * 0.001) - me.one))));
		me.oneT = sprintf("%01d", abs(me.one));
		if (me.oneT == 0) {
			me["ALT_one_T"].setText(" ");
		} else {
			me["ALT_one_T"].setText(me.oneT);
		}
		
		altitudex = altitude.getValue();
		if (altitudex < 0) {
			altPolarity = "-";
		} else {
			altPolarity = "";
		}
		me["ALT_thousands"].setText(sprintf("%s%d", altPolarity, math.abs(int(altitudex / 1000))));
		me["ALT_hundreds"].setText(sprintf("%d", math.floor(num(right(sprintf("%03d", abs(altitudex)), 3)) / 100)));
		altTens = num(right(sprintf("%02d", altitudex), 2));
		me["ALT_tens"].setTranslation(0, altTens * 2.1325);
		
		me["ALT_presel"].setTranslation(0, (altpresel.getValue() / 100) * -50.9016);
		me["ALT_sel"].setTranslation(0, (altsel.getValue() / 100) * -50.9016);
		me["ALT_agl"].setTranslation(0, (math.clamp(gearagl.getValue(), -700, 700) / 100) * 50.9016);
		
		if (afs.Internal.altAlert.getBoolValue()) {
			me["ALT_bowtie"].setColor(0.9412,0.7255,0);
		} else {
			me["ALT_bowtie"].setColor(1,1,1);
		}
		
		# Vertical Speed
		if (internalvs.getValue() <= -50) {
			me["VSI_needle_up"].hide();
		} else {
			me["VSI_needle_up"].show();
		}
		if (internalvs.getValue() >= 50) {
			me["VSI_needle_dn"].hide();
		} else {
			me["VSI_needle_dn"].show();
		}
		
		if (internalvs.getValue() > 10 and vspfd.getValue() > 0) {
			me["VSI_up"].show();
		} else {
			me["VSI_up"].hide();
		}
		if (internalvs.getValue() < -10 and vspfd.getValue() > 0) {
			me["VSI_down"].show();
		} else {
			me["VSI_down"].hide();
		}
		
		me["VSI_up"].setText(sprintf("%1.1f", vspfd.getValue()));
		me["VSI_down"].setText(sprintf("%1.1f", vspfd.getValue()));
		me["VSI_needle_up"].setTranslation(0, vsup.getValue());
		me["VSI_needle_dn"].setTranslation(0, vsdn.getValue());
		
		# Heading
		HDGraw = hdgscale.getValue() + 0.5;
		if (HDGraw > 359) {
			HDGraw = HDGraw - 360;
		}
		if (HDGraw < 0) {
			HDGraw = HDGraw + 360;
		}
		HDG = sprintf("%03d", HDGraw);
		if (HDG == "360") {
			HDG == "000";
		}
		me["HDG"].setText(HDG);
		me["HDG_dial"].setRotation(hdgscale.getValue() * -D2R);
		
		if (showhdg.getValue() == 1) {
			me["HDG_presel"].show();
		} else {
			me["HDG_presel"].hide();
		}
		if (showhdg.getValue() == 1 and aplat.getValue() == 0) {
			me["HDG_sel"].show();
		} else {
			me["HDG_sel"].hide();
		}
		
		if (hdgprediff.getValue() <= 35 and hdgprediff.getValue() >= -35) {
			HDGpresel = hdgprediff.getValue();
		} else if (hdgprediff.getValue() > 35) {
			HDGpresel = 35;
		} else if (hdgprediff.getValue() < -35) {
			HDGpresel = -35;
		}
		me["HDG_presel"].setRotation(HDGpresel * D2R);
		
		if (hdgdiff.getValue() <= 35 and hdgdiff.getValue() >= -35) {
			HDGsel = hdgdiff.getValue();
		} else if (hdgdiff.getValue() > 35) {
			HDGsel = 35;
		} else if (hdgdiff.getValue() < -35) {
			HDGsel = -35;
		}
		me["HDG_sel"].setRotation(HDGsel * D2R);
		
		me["TRK_pointer"].setRotation(trackdiffx * D2R);
		
		# ILS
		LOC = nav0defl.getValue() or 0;
		GS = gs0defl.getValue() or 0;
		me["LOC_pointer"].setTranslation(LOC * 200, 0);
		me["GS_pointer"].setTranslation(0, GS * -204);
		
		if (nav0range.getValue() == 1) {
			me["LOC_scale"].show();
			if (navloc.getValue() == 1 and nav0signal.getValue() > 0.99) {
				me["LOC_pointer"].show();
				me["LOC_no"].hide();
			} else {
				me["LOC_pointer"].hide();
				me["LOC_no"].show();
			}
		} else {
			me["LOC_scale"].hide();
			me["LOC_pointer"].hide();
			me["LOC_no"].hide();
		}
		if (gs0range.getValue() == 1) {
			me["GS_scale"].show();
			if (hasgs.getValue() == 1 and nav0signal.getValue() > 0.99) {
				me["GS_pointer"].show();
				me["GS_no"].hide();
			} else {
				me["GS_pointer"].hide();
				me["GS_no"].show();
			}
		} else {
			me["GS_scale"].hide();
			me["GS_pointer"].hide();
			me["GS_no"].hide();
		}
		
		# Misc
		if (gearagl.getValue() <= 2500) {
			me["RA"].setText(sprintf("%4.0f", gearagl.getValue()));
			me["RA"].show();
			me["RA_box"].show();
		} else {
			me["RA"].hide();
			me["RA_box"].hide();
		}
	},
};

var canvas_PFD_1 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_1, canvas_PFD_base]};
		m.init(canvas_group, file);

		return m;
	},
	update: func() {
		# FMA
		if (fd1.getValue() == 1 or ap1.getValue() == 1 or ap2.getValue() == 1) {
			me["FMA_Thrust"].show();
			me["FMA_Roll"].show();
			if (land_mode.getValue() == "OFF") {
				me["FMA_Pitch"].show();
			} else {
				me["FMA_Pitch"].hide();
			}
		} else {
			if (throttle_mode.getValue() != "PITCH" and ats.getValue() == 1) {
				me["FMA_Thrust"].show();
			} else {
				me["FMA_Thrust"].hide();
			}
			me["FMA_Roll"].hide();
			if (throttle_mode.getValue() == "PITCH" and ats.getValue() == 1) {
				if (land_mode.getValue() == "OFF") {
					me["FMA_Pitch"].show();
				} else {
					me["FMA_Pitch"].hide();
				}
			} else {
				me["FMA_Pitch"].hide();
			}
		}
		
		if (fd1.getValue() == 1) {
			me["FD_roll"].show();
		} else {
			me["FD_roll"].hide();
		}
		
		if (fd1.getValue() == 1) {
			me["FD_pitch"].show();
		} else {
			me["FD_pitch"].hide();
		}
		
		if (IR0aligned.getValue() == 1) {
			me["AI_group"].show();
			me["AI_group2"].show();
			me["AI_group3"].show();
			me["HDG_group"].show();
			me["VSI_group"].show();
			me["AI_error"].hide();
			me["HDG_error"].hide();
			me["VSI_error"].hide();
		} else {
			me["AI_error"].show();
			me["HDG_error"].show();
			me["VSI_error"].show();
			me["AI_group"].hide();
			me["AI_group2"].hide();
			me["AI_group3"].hide();
			me["HDG_group"].hide();
			me["VSI_group"].hide();
		}
		
		me.updateCommon();
	},
	updateFast: func() {
		me.updateCommonFast();
	},
};

var canvas_PFD_2 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_2, canvas_PFD_base]};
		m.init(canvas_group, file);

		return m;
	},
	update: func() {
		# FMA
		if (fd2.getValue() == 1 or ap1.getValue() == 1 or ap2.getValue() == 1) {
			me["FMA_Thrust"].show();
			me["FMA_Roll"].show();
			if (land_mode.getValue() == "OFF") {
				me["FMA_Pitch"].show();
			} else {
				me["FMA_Pitch"].hide();
			}
		} else {
			if (throttle_mode.getValue() != "PITCH" and ats.getValue() == 1) {
				me["FMA_Thrust"].show();
			} else {
				me["FMA_Thrust"].hide();
			}
			me["FMA_Roll"].hide();
			if (throttle_mode.getValue() == "PITCH" and ats.getValue() == 1) {
				if (land_mode.getValue() == "OFF") {
					me["FMA_Pitch"].show();
				} else {
					me["FMA_Pitch"].hide();
				}
			} else {
				me["FMA_Pitch"].hide();
			}
		}
		
		if (fd2.getValue() == 1) {
			me["FD_roll"].show();
		} else {
			me["FD_roll"].hide();
		}
		
		if (fd2.getValue() == 1) {
			me["FD_pitch"].show();
		} else {
			me["FD_pitch"].hide();
		}
		
		if (IR1aligned.getValue() == 1) {
			me["AI_group"].show();
			me["AI_group2"].show();
			me["AI_group3"].show();
			me["HDG_group"].show();
			me["VSI_group"].show();
			me["AI_error"].hide();
			me["HDG_error"].hide();
			me["VSI_error"].hide();
		} else {
			me["AI_error"].show();
			me["HDG_error"].show();
			me["VSI_error"].show();
			me["AI_group"].hide();
			me["AI_group2"].hide();
			me["AI_group3"].hide();
			me["HDG_group"].hide();
			me["VSI_group"].hide();
		}
		
		me.updateCommon();
	},
	updateFast: func() {
		me.updateCommonFast();
	},
};

var canvas_PFD_1_mismatch = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_1_mismatch]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["ERRCODE"];
	},
	update: func() {
		me["ERRCODE"].setText(mismatch.getValue());
	},
};

var canvas_PFD_2_mismatch = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_2_mismatch]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["ERRCODE"];
	},
	update: func() {
		me["ERRCODE"].setText(mismatch.getValue());
	},
};

setlistener("sim/signals/fdm-initialized", func {
	PFD1_display = canvas.new({
		"name": "PFD1",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	PFD2_display = canvas.new({
		"name": "PFD2",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	PFD1_display.addPlacement({"node": "pfd1.screen"});
	PFD2_display.addPlacement({"node": "pfd2.screen"});
	var group_pfd1 = PFD1_display.createGroup();
	var group_pfd1_mismatch = PFD1_display.createGroup();
	var group_pfd2 = PFD2_display.createGroup();
	var group_pfd2_mismatch = PFD2_display.createGroup();

	PFD_1 = canvas_PFD_1.new(group_pfd1, "Aircraft/IDG-MD-11/Models/cockpit/instruments/PFD/res/pfd.svg");
	PFD_1_mismatch = canvas_PFD_1_mismatch.new(group_pfd1_mismatch, "Aircraft/IDG-MD-11/Models/cockpit/instruments/Common/res/mismatch.svg");
	PFD_2 = canvas_PFD_2.new(group_pfd2, "Aircraft/IDG-MD-11/Models/cockpit/instruments/PFD/res/pfd.svg");
	PFD_2_mismatch = canvas_PFD_2_mismatch.new(group_pfd2_mismatch, "Aircraft/IDG-MD-11/Models/cockpit/instruments/Common/res/mismatch.svg");
	
	PFD_update.start();
	PFD_update_fast.start();
	
	if (pfdrate.getValue() > 1) {
		rateApply();
	}
});

var rateApply = func {
	PFD_update.restart(0.15 * pfdrate.getValue());
	PFD_update_fast.restart(0.05 * pfdrate.getValue());
}

var PFD_update = maketimer(0.15, func {
	canvas_PFD_base.updateSlow();
});

var PFD_update_fast = maketimer(0.05, func {
	canvas_PFD_base.update();
});

var showPFD1 = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(PFD1_display);
	dlg.set("title", "Captain's PFD");
}

var showPFD2 = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(PFD2_display);
	dlg.set("title", "First Officer's PFD");
}

var roundabout = func(x) {
	var y = x - int(x);
	return y < 0.5 ? int(x) : 1 + int(x);
};

var roundaboutAlt = func(x) {
	var y = x * 0.2 - int(x * 0.2);
	return y < 0.5 ? 5 * int(x * 0.2) : 5 + 5 * int(x * 0.2);
};
