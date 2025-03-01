/decl/security_state
	abstract_type = /decl/security_state
	// When defining any of these values type paths should be used, not instances. Instances will be acquired in /New()

	var/decl/security_level/severe_security_level // At which security level (and higher) the use of nuclear fission devices and other extreme measures are allowed. Defaults to the last entry in all_security_levels if unset.
	var/decl/security_level/high_security_level   // At which security level (and higher) transfer votes are disabled, ERT may be requested, and other similar high alert implications. Defaults to the second to last entry in all_security_levels if unset.
	// All security levels within the above convention: Low, Guarded, Elevated, High, Severe


	// Under normal conditions the crew may not raise the current security level higher than the highest_standard_security_level
	// The crew may also not adjust the security level once it is above the highest_standard_security_level.
	// Defaults to the second to last entry in all_security_levels if unset/null.
	// Set to FALSE/0 if there should be no restrictions.
	var/decl/security_level/highest_standard_security_level

	var/decl/security_level/current_security_level  // The current security level. Defaults to the first entry in all_security_levels if unset.
	var/decl/security_level/stored_security_level   // The security level that we are escalating to high security from - we will return to this level once we choose to revert.
	var/list/all_security_levels                    // List of all available security levels
	var/list/standard_security_levels               // List of all normally selectable security levels
	var/list/comm_console_security_levels           // List of all selectable security levels for the command and communication console - basically standard_security_levels - 1

/decl/security_state/Initialize()

	. = ..()

	// Setup the severe security level
	if(!(severe_security_level in all_security_levels))
		severe_security_level = all_security_levels[all_security_levels.len]
	severe_security_level = GET_DECL(severe_security_level)

	// Setup the high security level
	if(!(high_security_level in all_security_levels))
		high_security_level = all_security_levels[all_security_levels.len - 1]
	high_security_level = GET_DECL(high_security_level)

	// Setup the highest standard security level
	if(highest_standard_security_level || isnull(highest_standard_security_level))
		if(!(highest_standard_security_level in all_security_levels))
			highest_standard_security_level = all_security_levels[all_security_levels.len - 1]
		highest_standard_security_level = GET_DECL(highest_standard_security_level)
	else
		highest_standard_security_level = null

	// Setup the current security level
	if(current_security_level in all_security_levels)
		current_security_level = GET_DECL(current_security_level)
	else
		current_security_level = GET_DECL(all_security_levels[1])

	// Setup the full list of available security levels now that we no longer need to use "x in all_security_levels"
	var/list/security_level_instances = list()
	for(var/security_level_type in all_security_levels)
		security_level_instances += GET_DECL(security_level_type)
	all_security_levels = security_level_instances

	standard_security_levels = list()
	// Setup the list of normally selectable security levels
	for(var/security_level in all_security_levels)
		standard_security_levels += security_level
		if(security_level == highest_standard_security_level)
			break

	comm_console_security_levels = list()
	// Setup the list of selectable security levels available in the comm. console
	for(var/decl/security_level/security_level in all_security_levels)
		if(security_level == highest_standard_security_level)
			break
		if(security_level.selectable)
			comm_console_security_levels += security_level

	// Now we ensure the high security level is not above the severe one (but we allow them to be equal)
	var/severe_index = all_security_levels.Find(severe_security_level)
	var/high_index = all_security_levels.Find(high_security_level)
	if(high_index > severe_index)
		high_security_level = severe_security_level

	// Finally switch up to the default starting security level.
	current_security_level.switching_up_to()

/decl/security_state/proc/can_change_security_level()
	return current_security_level in standard_security_levels

/decl/security_state/proc/can_switch_to(var/given_security_level)
	if(!can_change_security_level())
		return FALSE
	return given_security_level in standard_security_levels

/decl/security_state/proc/current_security_level_is_lower_than(var/given_security_level)
	var/current_index = all_security_levels.Find(current_security_level)
	var/given_index   = all_security_levels.Find(given_security_level)

	return given_index && current_index < given_index

/decl/security_state/proc/current_security_level_is_same_or_higher_than(var/given_security_level)
	var/current_index = all_security_levels.Find(current_security_level)
	var/given_index   = all_security_levels.Find(given_security_level)

	return given_index && current_index >= given_index

/decl/security_state/proc/current_security_level_is_higher_than(var/given_security_level)
	var/current_index = all_security_levels.Find(current_security_level)
	var/given_index   = all_security_levels.Find(given_security_level)

	return given_index && current_index > given_index

/decl/security_state/proc/set_security_level(var/decl/security_level/new_security_level, var/force_change = FALSE)
	if(new_security_level == current_security_level)
		return FALSE
	if(!(new_security_level in all_security_levels))
		return FALSE
	if(!force_change && !can_switch_to(new_security_level))
		return FALSE

	var/decl/security_level/previous_security_level = current_security_level
	current_security_level = new_security_level

	var/previous_index = all_security_levels.Find(previous_security_level)
	var/new_index      = all_security_levels.Find(new_security_level)

	if(new_index > previous_index)
		previous_security_level.switching_up_from()
		new_security_level.switching_up_to()
	else
		previous_security_level.switching_down_from()
		new_security_level.switching_down_to()

	log_and_message_admins("has changed the security level from [previous_security_level.name] to [new_security_level.name].")
	return TRUE

// This proc decreases the current security level, if possible
/decl/security_state/proc/decrease_security_level(var/force_change = FALSE)
	var/current_index = all_security_levels.Find(current_security_level)
	if(current_index == 1)
		return FALSE
	return set_security_level(all_security_levels[current_index - 1], force_change)

/decl/security_level
	var/icon
	var/name

	// These values are primarily for station alarms and status displays, and which light colors and overlays to use
	var/light_range
	var/light_power
	var/light_color_alarm
	var/light_color_status_display

	var/overlay_alarm
	var/overlay_status_display

	var/up_description
	var/down_description

	var/selectable = TRUE

	var/datum/alarm_appearance/alarm_appearance

/decl/security_level/Initialize()
	. = ..()
	if(ispath(alarm_appearance, /datum/alarm_appearance))
		alarm_appearance = new alarm_appearance

// Called when we're switching from a lower security level to this one.
/decl/security_level/proc/switching_up_to()
	return

// Called when we're switching from a higher security level to this one.
/decl/security_level/proc/switching_down_to()
	return

// Called when we're switching from this security level to a higher one.
/decl/security_level/proc/switching_up_from()
	return

// Called when we're switching from this security level to a lower one.
/decl/security_level/proc/switching_down_from()
	return

/*
* The default security state and levels setup
*/
/decl/security_state/default
	all_security_levels = list(/decl/security_level/default/code_green, /decl/security_level/default/code_blue, /decl/security_level/default/code_red, /decl/security_level/default/code_delta)

/decl/security_level/default
	icon = 'icons/misc/security_state.dmi'

	var/static/datum/announcement/priority/security/security_announcement_up = new(do_log = 0, do_newscast = 1, new_sound = sound('mods/content/hearth_maps/sounds/minor_alert.ogg'))
	var/static/datum/announcement/priority/security/security_announcement_down = new(do_log = 0, do_newscast = 1, new_sound = sound('mods/content/hearth_maps/sounds/minor_alert.ogg'))

/decl/security_level/default/switching_up_to()
	if(up_description)
		security_announcement_up.Announce(up_description, "Attention! Alert level elevated to [name]!")
	notify_station()

/decl/security_level/default/switching_down_to()
	if(down_description)
		security_announcement_down.Announce(down_description, "Attention! Alert level changed to [name]!")
	notify_station()

/decl/security_level/default/proc/notify_station()
	for(var/obj/machinery/firealarm/FA in SSmachines.machinery)
		if(FA.z in global.using_map.contact_levels)
			FA.update_icon()
	post_status("alert")

/decl/security_level/default/code_green
	name = "code green"

	light_range = 2
	light_power = 1

	light_color_alarm = COLOR_GREEN
	light_color_status_display = COLOR_GREEN

	overlay_alarm = "alarm_green"
	overlay_status_display = "status_display_green"

	alarm_appearance = /datum/alarm_appearance/green

	down_description = "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced."

/decl/security_level/default/code_blue
	name = "code blue"

	light_range = 2
	light_power = 1
	light_color_alarm = COLOR_BLUE
	light_color_status_display = COLOR_BLUE

	overlay_alarm = "alarm_blue"
	overlay_status_display = "status_display_blue"

	alarm_appearance = /datum/alarm_appearance/blue

	up_description = "The station has received reliable information about possible hostile activity on the station. Security staff may have weapons visible, random searches are permitted."
	down_description = "The immediate threat has passed. Security may no longer have weapons drawn at all times, but may continue to have them visible. Random searches are still allowed."

/decl/security_level/default/code_red
	name = "code red"

	light_range = 4
	light_power = 2
	light_color_alarm = COLOR_RED
	light_color_status_display = COLOR_RED

	overlay_alarm = "alarm_red"
	overlay_status_display = "status_display_red"

	alarm_appearance = /datum/alarm_appearance/red

	up_description = "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised."
	down_description = "The self-destruct mechanism has been deactivated, there is still however an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised."

/decl/security_level/default/code_delta
	name = "code delta"

	light_range = 4
	light_power = 2
	light_color_alarm = COLOR_RED
	light_color_status_display = COLOR_NAVY_BLUE

	alarm_appearance = /datum/alarm_appearance/delta

	overlay_alarm = "alarm_delta"
	overlay_status_display = "status_display_delta"

	var/static/datum/announcement/priority/security/security_announcement_delta = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/effects/siren.ogg'))

/decl/security_level/default/code_delta/switching_up_to()
	security_announcement_delta.Announce("The self-destruct mechanism has been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill.", "Attention! Delta security level reached!")
	notify_station()

/datum/alarm_appearance
	var/display_icon //The icon_state for the displays. Normally only one is used, unless uses_twotone_displays is TRUE.
	var/display_icon_color //The color for the display icon.

	var/display_icon_twotone //Used for two-tone displays.
	var/display_icon_twotone_color //The color for the display icon.

	var/display_emblem //The icon_state for the emblem, i.e for delta, a radstorm, alerts.
	var/display_emblem_color //The color for the emblem.

	var/alarm_icon //The icon_state for the alarms
	var/alarm_icon_color //the color for the icon_state

	var/alarm_icon_twotone //Used for two-tone alarms (i.e delta).
	var/alarm_icon_twotone_color //The color for the secondary tone icon.

/datum/alarm_appearance/green
	display_icon = "status_display_lines"
	display_icon_color = PIPE_COLOR_GREEN

	display_emblem = "status_display_alert"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_normal"
	alarm_icon_color = PIPE_COLOR_GREEN

/decl/security_level/default/code_yellow
	name = "code yellow"
	icon = 'icons/misc/security_state.dmi'

	light_color_alarm = COLOR_YELLOW_GRAY
	light_color_status_display = COLOR_YELLOW_GRAY
	overlay_alarm = "alarm_orange"
	overlay_status_display = "status_display_orange"
	alarm_appearance = /datum/alarm_appearance/yellow

	up_description = "Subsector FTL Procedures are now in effect; observe modified Code Orange protocols, secure all stations for superluminal transition. EVA Ban in effect."
	down_description = "Subsector FTL Procedures are now in effect; observe modified Code Orange protocols, secure all stations for superluminal transition. EVA Ban in effect."

	selectable = FALSE

/datum/alarm_appearance/blue
	display_icon = "status_display_lines"
	display_icon_color = COLOR_BLUE

	display_emblem = "status_display_alert"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_normal"
	alarm_icon_color = COLOR_BLUE

/datum/alarm_appearance/red
	display_icon = "status_display_lines"
	display_icon_color = COLOR_RED

	display_emblem = "status_display_alert"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_blinking"
	alarm_icon_color = COLOR_RED

/datum/alarm_appearance/delta
	display_icon = "status_display_twotone1"
	display_icon_color = COLOR_RED

	display_icon_twotone = "status_display_twotone2"
	display_icon_twotone_color = COLOR_YELLOW

	display_emblem = "delta"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_blinking_twotone1"
	alarm_icon_color = COLOR_RED

	alarm_icon_twotone = "alarm_blinking_twotone2"
	alarm_icon_twotone_color = PIPE_COLOR_YELLOW

/datum/alarm_appearance/yellow
	display_icon = "status_display_lines"
	display_icon_color = COLOR_YELLOW_GRAY

	display_emblem = "status_display_ftl"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_normal"
	alarm_icon_color = COLOR_YELLOW_GRAY