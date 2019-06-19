/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message = null)
	var/param = null
	var/ya = "&#255;"

//	var/datum/gender/T = gender_datums[get_visible_gender()]

	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/muzzled = is_muzzled()
	//var/m_type = 1

	for(var/obj/item/organ/O in src.organs)
		for (var/obj/item/weapon/implant/I in O)
			if (I.implanted)
				I.trigger(act, src)

	if(src.stat == 2.0 && (act != "deathgasp"))
		return
	if(attempt_vr(src,"handle_emote_vr",list(act,m_type,message))) return //VOREStation Add - Custom Emote Handler
	switch(act)

		if ("airguitar")
			if (!src.restrained())
				message = "is strumming the air and headbanging like a safari chimp."
				m_type = 1

		//Machine-only emotes
		if("ping", "beep", "buzz", "yes", "ye", "no", "rcough", "rsneeze")

			if(!isSynthetic())
				src << "<span class='warning'>You are not a synthetic.</span>"
				return

			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			var/display_msg = "�����."
			var/use_sound = 'sound/machines/twobeep.ogg'
			if(act == "buzz")
				display_msg = "������."
				use_sound = 'sound/machines/buzz-sigh.ogg'
			else if(act == "ping")
				display_msg = "������."
				use_sound = 'sound/machines/ping.ogg'
			else if(act == "yes" || act == "ye")
				display_msg = "����� �������������� ������."
				use_sound = 'sound/machines/synth_yes.ogg'
			else if(act == "no")
				display_msg = "����� ������������� ������."
				use_sound = 'sound/machines/synth_no.ogg'
			else if(act == "rcough")
				display_msg = "��������� ������."
				if(get_gender() == FEMALE)
					use_sound = pick('sound/effects/mob_effects/f_machine_cougha.ogg','sound/effects/mob_effects/f_machine_coughb.ogg')
				else
					use_sound = pick('sound/effects/mob_effects/m_machine_cougha.ogg','sound/effects/mob_effects/m_machine_coughb.ogg', 'sound/effects/mob_effects/m_machine_coughc.ogg')
			else if(act == "rsneeze")
				display_msg = "��������� �������."
				if(get_gender() == FEMALE)
					use_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
				else
					use_sound = 'sound/effects/mob_effects/f_machine_sneeze.ogg'

			if (param)
				message = "[display_msg] �� [param]."
			else
				message = "[display_msg]."
			playsound(src.loc, use_sound, 50, 0)
			m_type = 1

		//Promethean-only emotes
		if("squish")
			/* VOREStation Removal Start - Eh. People can squish maybe.
			if(species.bump_flag != SLIME) //This should definitely do it.
				src << "<span class='warning'>You are not a slime thing!</span>"
				return
			*/ //VOREStation Removal End
			playsound(src.loc, 'sound/effects/slime_squish.ogg', 50, 0) //Credit to DrMinky (freesound.org) for the sound.
			message = "�������."
			m_type = 1


		if ("blink")
			message = "�������."
			m_type = 1

		if ("blink_r")
			message = "������ �������."
			m_type = 1

		if ("bow")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "����[ya]���[ya] [param]."
				else
					message = "����[ya]���[ya]."
			m_type = 1

		if ("custom")
			var/input = sanitize(input("Choose an emote to display.") as text|null)
			if (!input)
				return
			var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
			if (input2 == "Visible")
				m_type = 1
			else if (input2 == "Hearable")
				if (src.miming)
					return
				m_type = 2
			else
				alert("Unable to use this emote, must be either hearable or visible.")
				return
			return custom_emote(m_type, message)

		if ("me")

			//if(silent && silent > 0 && findtext(message,"\"",1, null) > 0)
			//	return //This check does not work and I have no idea why, I'm leaving it in for reference.

			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "<font color='red'>You cannot send IC messages (muted).</font>"
					return
			if (stat)
				return
			if(!(message))
				return
			return custom_emote(m_type, message)

		if ("salute")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "����� ����� [param]."
				else
					message = "����� �����."
			m_type = 1

		if ("choke")
			if(miming)
				message = "����[ya]��� ��������[ya] �� �����!"
				m_type = 1
			else
				if (!muzzled)
					message = "���������[ya]!"
					m_type = 2
				else
					message = "������ �����."
					m_type = 2

		if ("clap")
			if (!src.restrained())
				message = "�����������."
				playsound(src.loc, 'sound/misc/clapping.ogg')
				m_type = 2
				if(miming)
					m_type = 1

		if ("flap")
			if (!src.restrained())
				message = "����� �����[ya]��."
				m_type = 2
				if(miming)
					m_type = 1

		if ("aflap")
			if (!src.restrained())
				message = "���������� ����� �����[ya]��!"
				m_type = 2
				if(miming)
					m_type = 1

		if ("drool")
			message = "������� �����."
			m_type = 1

		if ("eyebrow")
			message = "������������� ��������� �����."
			m_type = 1

		if ("chuckle")
			if(miming)
				message = "������[ya], �����������ya]."
				m_type = 1
			else
				if (!muzzled)
					message = "�����������[ya]."
					m_type = 2
				else
					message = "�����."
					m_type = 2

		if ("twitch")
			message = "�������[ya]."
			m_type = 1

		if ("twitch_v")
			message = "����� �������[ya]."
			m_type = 1

		if ("faint")
			message = "������ � �������."
			if(src.sleeping)
				return //Can't faint while asleep
			src.sleeping += 10 //Short-short nap
			m_type = 1

		if("cough", "coughs")
			if(miming)
				message = "������[ya], ����[ya]��!"
				m_type = 1
			else
				if(!muzzled)
					var/robotic = 0
					m_type = 2
					if(should_have_organ(O_LUNGS))
						var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
						if(L && L.robotic == 2)	//Hard-coded to 2, incase we add lifelike robotic lungs
							robotic = 1
					if(!robotic)
						message = "����[ya]��!"
						if(get_gender() == FEMALE)
							if(species.female_cough_sounds)
								playsound(src, pick(species.female_cough_sounds), 120)
						else
							if(species.male_cough_sounds)
								playsound(src, pick(species.male_cough_sounds), 120)
					else
						message = "��������� ������."
						var/use_sound
						if(get_gender() == FEMALE)
							use_sound = pick('sound/effects/mob_effects/f_machine_cougha.ogg','sound/effects/mob_effects/f_machine_coughb.ogg')
						else
							use_sound = pick('sound/effects/mob_effects/m_machine_cougha.ogg','sound/effects/mob_effects/m_machine_coughb.ogg', 'sound/effects/mob_effects/m_machine_coughc.ogg')
						playsound(src.loc, use_sound, 50, 0)
				else
					message = "������ �����."
					m_type = 2

		if ("frown")
			message = "�������[ya]."
			m_type = 1

		if ("nod")
			message = "������."
			m_type = 1

		if ("blush")
			message = "��������."
			m_type = 1

		if ("wave")
			message = "����� �����."
			m_type = 1

		if ("gasp")
			if(miming)
				message = "������[ya], ���������[ya]!"
				m_type = 1
			else
				if (!muzzled)
					message = "������� ���� ������!"
					m_type = 2
				else
					message = "���� �����."
					m_type = 2

		if ("deathgasp")
			message = "[species.get_death_message()]"
			m_type = 1

		if ("giggle")
			if(miming)
				message = "���� ��������!"
				m_type = 1
			else
				if (!muzzled)
					message = "��������."
					m_type = 2
				else
					message = "�����."
					m_type = 2

		if ("glare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "������ ������� �� [param]."
			else
				message = "������ ������� �� ���-��."

		if ("stare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "�[ya]����[ya] �� [param]."
			else
				message = "���������� ������� �� ���-��."

		if ("look")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break

			if (!M)
				param = null

			if (param)
				message = "������� �� [param]."
			else
				message = "������� �� ���-��."
			m_type = 1

		if ("grin")
			message = "�������[ya]."
			m_type = 1

		if ("cry")
			if(miming)
				message = "������."
				m_type = 1
			else
				if (!muzzled)
					message = "������."
					m_type = 2
				else
					message = "���� ����� � �������[ya]." // no good, non-unwieldy alternative to this ternary at the moment
					m_type = 2

		if ("sigh")
			if(miming)
				message = "��������."
				m_type = 1
			else
				if (!muzzled)
					message = "��������."
					m_type = 2
				else
					message = "���� �����."
					m_type = 2

		if ("laugh")
			if(miming)
				message = "����������� ����."
				m_type = 1
			else
				if (!muzzled)
					message = "�����[ya]."
					m_type = 2
				else
					message = "�����."
					m_type = 2

		if ("mumble")
			message = "�������� ���-��!"
			m_type = 2
			if(miming)
				m_type = 1

		if ("grumble")
			if(miming)
				message = "������!"
				m_type = 1
			if (!muzzled)
				message = "������!"
				m_type = 2
			else
				message = "�����."
				m_type = 2

		if ("groan")
			if(miming)
				message = "������[ya], ����[ya]��� ������!"
				m_type = 1
			else
				if (!muzzled)
					message = "����[ya]��� ������!"
					m_type = 2
				else
					message = "������ �����."
					m_type = 2

		if ("moan")
			if(miming)
				message = "������[ya], ������!"
				m_type = 1
			else
				message = "������!"
				m_type = 2

		if ("johnny")
			var/M
			if (param)
				M = param
			if (!M)
				param = null
			else
				if(miming)
					message = "takes a drag from a cigarette and blows \"[M]\" out in smoke."
					m_type = 1
				else
					message = "says, \"[M], please. He had a family.\" [src.name] takes a drag from a cigarette and blows his name out in smoke."
					m_type = 2

		if ("point")
			if (!src.restrained())
				var/mob/M = null
				if (param)
					for (var/atom/A as mob|obj|turf|area in view(null, null))
						if (param == A.name)
							M = A
							break

				if (!M)
					message = "��������� ����-��."
				else
					pointed(M)

				if (M)
					message = "��������� �� [M]."
				else
			m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "��������� ����."
			m_type = 1

		if("shake")
			message = "��[ya]�� �������."
			m_type = 1

		if ("shrug")
			message = "�������� �������."
			m_type = 1

		if ("signal")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "���������� [t1] �������."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "���������� [t1] �������."
			m_type = 1

		if ("smile")
			message = "��������[ya]."
			m_type = 1

		if ("shiver")
			message = "������."
			m_type = 2
			if(miming)
				m_type = 1

		if ("pale")
			message = "�� ������� ��������."
			m_type = 1

		if ("tremble")
			message = "������ �� ������!"
			m_type = 1

		if("sneeze", "sneezes")
			if(miming)
				message = "������."
				m_type = 1
			else
				if(!muzzled)
					var/robotic = 0
					m_type = 2
					if(should_have_organ(O_LUNGS))
						var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
						if(L && L.robotic == 2)	//Hard-coded to 2, incase we add lifelike robotic lungs
							robotic = 1
					if(!robotic)
						message = "������."
						if(get_gender() == FEMALE)
							playsound(src, species.female_sneeze_sound, 70)
						else
							playsound(src, species.male_sneeze_sound, 70)
						m_type = 2
					else
						message = "��������� �������."
						var/use_sound
						if(get_gender() == FEMALE)
							use_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
						else
							use_sound = 'sound/effects/mob_effects/f_machine_sneeze.ogg'
						playsound(src.loc, use_sound, 50, 0)
				else
					message = "������ �����."
					m_type = 2

		if ("sniff")
			message = "������������[ya]."
			m_type = 2
			if(miming)
				m_type = 1

		if ("snore")
			if (miming)
				message = "������ ����."
				m_type = 1
			else
				if (!muzzled)
					message = "������."
					m_type = 2
				else
					message = "�����."
					m_type = 2

		if ("whimper")
			if (miming)
				message = "������[ya], ��������."
				m_type = 1
			else
				if (!muzzled)
					message = "������."
					m_type = 2
				else
					message = "����� �����."
					m_type = 2

		if ("wink")
			message = "�����������."
			m_type = 1

		if ("yawn")
			if (!muzzled)
				message = "������."
				m_type = 2
				if(miming)
					m_type = 1

		if ("collapse")
			Paralyse(2)
			message = "������!"
			m_type = 2
			if(miming)
				m_type = 1

		if("hug")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					message = "�������� [M]."
				else
					message = "�������� ���[ya]."

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/living/M = null
				if (param)
					for (var/mob/living/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "��� ���� � [M]."
					else
						message = "����[ya]������ ���� [M] ��[ya] ����������[ya]."

		if("dap")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "��� �[ya]�� [M]."
				else
					message = "� ���������, �� ������� ������ ���������� � ��� �[ya]�� ����. ��������."

		if("slap", "slaps")
			m_type = 1
			if(!restrained())
				var/M = null
				if(param)
					for(var/mob/A in view(1, null))
						if(param == A.name)
							M = A
							break
				if(M)
					message = "<span class='danger'>��� [M] ��������. ��!</span>"
					playsound(loc, 'sound/effects/snap.ogg', 50, 1)
					if(ishuman(M)) //Snowflakey!
						var/mob/living/carbon/human/H = M
						if(istype(H.wear_mask,/obj/item/clothing/mask/smokable))
							H.drop_from_inventory(H.wear_mask)
				else
					message = "<span class='danger'>��� ���� ��������!</span>"
					playsound(loc, 'sound/effects/snap.ogg', 50, 1)

		if("scream", "screams")
			if(miming)
				message = "����������� ����!"
				m_type = 1
			else
				if(!muzzled)
					message = "[species.scream_verb]!"
					m_type = 2
					/* Removed, pending the location of some actually good, properly licensed sounds.
					if(get_gender() == FEMALE)
						playsound(loc, "[species.female_scream_sound]", 80, 1)
					else
						playsound(loc, "[species.male_scream_sound]", 80, 1) //default to male screams if no gender is present.
					*/
				else
					message = "����� ������ �����."
					m_type = 2

		if("snap", "snaps")
			m_type = 2
			var/mob/living/carbon/human/H = src
			var/obj/item/organ/external/L = H.get_organ("l_hand")
			var/obj/item/organ/external/R = H.get_organ("r_hand")
			var/left_hand_good = 0
			var/right_hand_good = 0
			if(L && (!(L.status & ORGAN_DESTROYED)) && (!(L.splinted)) && (!(L.status & ORGAN_BROKEN)))
				left_hand_good = 1
			if(R && (!(R.status & ORGAN_DESTROYED)) && (!(R.splinted)) && (!(R.status & ORGAN_BROKEN)))
				right_hand_good = 1

			if(!left_hand_good && !right_hand_good)
				to_chat(usr, "You need at least one hand in good working order to snap your fingers.")
				return

			message = "������� ��������."
			playsound(loc, 'sound/effects/fingersnap.ogg', 50, 1, -3)

		if("swish")
			src.animate_tail_once()

		if("wag", "sway")
			src.animate_tail_start()

		if("qwag", "fastsway")
			src.animate_tail_fast()

		if("swag", "stopsway")
			src.animate_tail_stop()

		if("vomit")
			if(isSynthetic())
				src << "<span class='warning'>You are unable to vomit.</span>"
				return
			vomit()
			return

		if("whistle" || "whistles")
			if(!muzzled)
				message = "������������ �������."
				playsound(loc, 'sound/misc/longwhistle.ogg') //praying this doesn't get abused
			else
				message = "����� ����� ���� � �������� ����������."

		if("qwhistle")
			if(!muzzled)
				message = "���� �������."
				playsound(loc, 'sound/misc/shortwhistle.ogg')
			else
				message = "����� ����� ���� � �������� ����������."

		if ("help")
			src << "blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough, cry, custom, deathgasp, drool, eyebrow, fastsway/qwag, \
					frown, gasp, giggle, glare-(none)/mob, grin, groan, grumble, handshake, hug-(none)/mob, laugh, look-(none)/mob, moan, mumble, nod, pale, point-atom, \
					raise, salute, scream, sneeze, shake, shiver, shrug, sigh, signal-#1-10, slap-(none)/mob, smile, sneeze, sniff, snore, stare-(none)/mob, stopsway/swag, sway/wag, swish, tremble, twitch, \
					twitch_v, vomit, whimper, wink, yawn. Synthetics: beep, buzz, yes, no, rcough, rsneeze, ping"

		else
			src << "<font color='blue'>Unusable emote '[act]'. Say *help for a list.</font>"

	if (message)
		custom_emote(m_type,message)

/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	var/datum/gender/T = gender_datums[get_visible_gender()]

	pose =  sanitize(input(usr, "This is [src]. [T.he]...", "Pose", null)  as text)

/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Update Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	src << browse(HTML, "window=flavor_changes;size=430x300")
