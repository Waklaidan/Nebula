#ifndef PSI_IMPLANT_AUTOMATIC
#define PSI_IMPLANT_AUTOMATIC "Security Level Derived"
#endif
#ifndef PSI_IMPLANT_SHOCK
#define PSI_IMPLANT_SHOCK     "Issue Neural Shock"
#endif
#ifndef PSI_IMPLANT_WARN
#define PSI_IMPLANT_WARN      "Issue Reprimand"
#endif
#ifndef PSI_IMPLANT_LOG
#define PSI_IMPLANT_LOG       "Log Incident"
#endif
#ifndef PSI_IMPLANT_DISABLED
#define PSI_IMPLANT_DISABLED  "Disabled"
#endif

/datum/map/torch // setting the map to use this list
	security_state = /decl/security_state/default/torchdept

//Torch map alert levels. Refer to security_state.dm.
/decl/security_state/default/torchdept
	all_security_levels = list(/decl/security_level/default/torchdept/code_green, /decl/security_level/default/torchdept/code_violet, /decl/security_level/default/torchdept/code_orange, /decl/security_level/default/code_yellow, /decl/security_level/default/torchdept/code_blue, /decl/security_level/default/torchdept/code_red, /decl/security_level/default/torchdept/code_delta)

	
/decl/security_level/default/torchdept
	icon = 'mods/content/hearth_maps/icons/security_state.dmi'
	alarm_appearance = /datum/alarm_appearance/green

/decl/security_level/default/torchdept/proc/lock_armory(var/list/alert_areas)
	for(var/atype in alert_areas)
		var/area/A = locate(atype)
		if(istype(A))
			for(var/obj/machinery/door/airlock/highsecurity/bolted/V in A.contents)
				if(V.locked)
					V.unlock()
				V.close()
				V.lock()

/decl/security_level/default/torchdept/proc/unlock_armory(var/list/alert_areas)
	for(var/AA in alert_areas)
		var/area/A = locate(AA)
		if(istype(A))
			for(var/obj/machinery/door/airlock/highsecurity/bolted/V in A.contents)
				if(V.locked)
					V.unlock()
				V.open()
				V.lock()



/decl/security_level/default/torchdept/code_green
	name = "code green"
	icon = 'icons/misc/security_state.dmi'

	light_color_alarm = COLOR_GREEN
	light_color_status_display = COLOR_GREEN

	overlay_alarm = "alarm_green"
	overlay_status_display = "status_display_green"
	alarm_appearance = /datum/alarm_appearance/green

	var/static/datum/announcement/priority/security/security_announcement_green = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/notice2.ogg'))

/decl/security_level/default/torchdept/code_green/switching_down_to()
	security_announcement_green.Announce("The situation has been resolved, and all crew are to return to their regular duties.", "Attention! Alert level lowered to code green.")
	notify_station()
	INVOKE_ASYNC(src, /decl/security_level/default/torchdept/proc/lock_armory, list(/area/security/armoury, /area/security/armoury/blue))

/decl/security_level/default/torchdept/code_violet
	name = "code violet"
	icon = 'icons/misc/security_state.dmi'

	light_color_alarm = COLOR_VIOLET
	light_color_status_display = COLOR_VIOLET

	psionic_control_level = PSI_IMPLANT_LOG

	overlay_alarm = "alarm_violet"
	overlay_status_display = "status_display_violet"
	alarm_appearance = /datum/alarm_appearance/violet

	up_description = "A major medical emergency has developed. Medical personnel are required to report to their supervisor for orders, and non-medical personnel are required to obey all relevant instructions from medical staff."
	down_description = "Code violet procedures are now in effect; Medical personnel are required to report to their supervisor for orders, and non-medical personnel are required to obey relevant instructions from medical staff."

/decl/security_level/default/torchdept/code_violet/switching_down_to()
	. = ..()
	INVOKE_ASYNC(src, /decl/security_level/default/torchdept/proc/lock_armory, list(/area/security/armoury, /area/security/armoury/blue))

/decl/security_level/default/torchdept/code_orange
	name = "code orange"
	icon = 'icons/misc/security_state.dmi'

	light_color_alarm = COLOR_ORANGE
	light_color_status_display = COLOR_ORANGE
	overlay_alarm = "alarm_orange"
	overlay_status_display = "status_display_orange"
	alarm_appearance = /datum/alarm_appearance/orange

	psionic_control_level = PSI_IMPLANT_LOG

	up_description = "A major engineering emergency has developed. Engineering personnel are required to report to their supervisor for orders, and non-engineering personnel are required to evacuate any affected areas and obey relevant instructions from engineering staff."
	down_description = "Code orange procedures are now in effect; Engineering personnel are required to report to their supervisor for orders, and non-engineering personnel are required to evacuate any affected areas and obey relevant instructions from engineering staff."

/decl/security_level/default/torchdept/code_orange/switching_down_to()
	. = ..()
	INVOKE_ASYNC(src, /decl/security_level/default/torchdept/proc/lock_armory, list(/area/security/armoury, /area/security/armoury/blue))

/decl/security_level/default/torchdept/code_blue
	name = "code blue"
	icon = 'icons/misc/security_state.dmi'

	light_color_alarm = COLOR_BLUE
	light_color_status_display = COLOR_BLUE
	overlay_alarm = "alarm_blue"
	overlay_status_display = "status_display_blue"
	alarm_appearance = /datum/alarm_appearance/blue

	psionic_control_level = PSI_IMPLANT_LOG

	up_description = "A major security emergency has developed. Security personnel are to report to their supervisor for orders, are permitted to search staff and facilities, and may have weapons visible on their person."
	down_description = "Code blue procedures are now in effect. Security personnel are to report to their supervisor for orders, are permitted to search staff and facilities, and may have weapons visible on their person."

/decl/security_level/default/torchdept/code_blue/switching_up_to()
	. = ..()
	INVOKE_ASYNC(src, /decl/security_level/default/torchdept/proc/unlock_armory, list(/area/security/armoury/blue))

/decl/security_level/default/torchdept/code_blue/switching_down_from()
	. = ..()
	INVOKE_ASYNC(src, /decl/security_level/default/torchdept/proc/lock_armory, list(/area/security/armoury/blue))

/decl/security_level/default/torchdept/code_red
	name = "code red"
	icon = 'icons/misc/security_state.dmi'

	light_power = 1
	light_range = 3
	light_color_alarm = COLOR_RED
	light_color_status_display = COLOR_RED
	overlay_alarm = "alarm_red"
	overlay_status_display = "status_display_red"
	alarm_appearance = /datum/alarm_appearance/red

	up_description = "A severe emergency has occurred. All staff are to report to their supervisor for orders. All crew should obey orders from relevant emergency personnel. Security personnel are permitted to search staff and facilities, and may have weapons unholstered at any time. Saferooms have been unbolted."
	psionic_control_level = PSI_IMPLANT_DISABLED

	var/static/datum/announcement/priority/security/security_announcement_red = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/redalert1.ogg'))

/decl/security_level/default/torchdept/code_red/switching_up_to()
	security_announcement_red.Announce(up_description, "Attention! Code red alert procedures now in effect!")
	notify_station()
	global.using_map.unbolt_saferooms()
	INVOKE_ASYNC(src, /decl/security_level/default/torchdept/proc/unlock_armory, list(/area/security/armoury, /area/security/armoury/blue))

/decl/security_level/default/torchdept/code_red/switching_down_from()
	. = ..()
	INVOKE_ASYNC(src, /decl/security_level/default/torchdept/proc/lock_armory, list(/area/security/armoury))

/decl/security_level/default/torchdept/code_red/switching_down_to()
	security_announcement_red.Announce("Code Delta has been disengaged. All staff are to report to their supervisor for orders. All crew should obey orders from relevant emergency personnel. Security personnel are permitted to search staff and facilities, and may have weapons unholstered at any time.", "Attention! Code red alert procedures now in effect!")
	notify_station()

/decl/security_level/default/torchdept/code_delta
	name = "code delta"
	icon = 'icons/misc/security_state.dmi'

	light_power = 1
	light_range = 3
	light_color_alarm = COLOR_RED
	light_color_status_display = COLOR_NAVY_BLUE

	overlay_alarm = "alarm_delta"
	overlay_status_display = "status_display_delta"
	alarm_appearance = /datum/alarm_appearance/delta

	var/static/datum/announcement/priority/security/security_announcement_delta = new(do_log = 0, do_newscast = 1, new_sound = sound('mods/content/hearth_maps/sounds/delta.ogg'))

/decl/security_level/default/torchdept/code_delta/switching_up_to()
	security_announcement_delta.Announce("Code Delta procedures have been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill.", "Attention! Delta security level reached!")
	notify_station()
	unlock_armory(list(/area/security/armoury/blue, /area/security/armoury))


/datum/alarm_appearance/orange
	display_icon = "status_display_lines"
	display_icon_color = COLOR_ORANGE

	display_emblem = "status_display_alert"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_normal"
	alarm_icon_color = COLOR_ORANGE

/datum/alarm_appearance/violet
	display_icon = "status_display_lines"
	display_icon_color = COLOR_VIOLET

	display_emblem = "status_display_alert"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_normal"
	alarm_icon_color = COLOR_VIOLET

#undef PSI_IMPLANT_AUTOMATIC
#undef PSI_IMPLANT_SHOCK
#undef PSI_IMPLANT_WARN
#undef PSI_IMPLANT_LOG
#undef PSI_IMPLANT_DISABLED
