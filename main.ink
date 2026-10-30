// 302 — main story. Text is {t("中文", "English")}; ids and identifiers are English.
// The engine file is generated from game.md. Scene 1 (dusk to the knock) is a draft to play and rewrite.
INCLUDE _engine.ink

// What the player has seen or done (the later scenes read these).
VAR clue_frame = false   // counted the doors in the frozen movie frame
VAR tap_seen = false     // saw the wet basin in the water room
VAR window_open = false  // opened the window a crack
VAR answered = ""        // what was said through the door: four / three / none / open

-> dusk

// --- helpers -------------------------------------------------------------

=== function clamp(x, lo, hi) ===
{ x < lo:
    ~ return lo
}
{ x > hi:
    ~ return hi
}
~ return x

// A character's name, or "you" when it is the player's character.
=== function nm(c) ===
{ c == character:
    ~ return t("你", "you")
}
{ c == xin:
    ~ return t("昕", "Xin")
}
{ c == yanbo:
    ~ return t("烟波", "Yanbo")
}
{ c == zhiyong:
    ~ return t("志勇", "Zhiyong")
}
~ return t("怡", "Yi")

// English verb endings: "" for you, "s"/"es" for a named character ("lock{s(c)}", "go{es(c)}").
=== function s(c) ===
{ c == character:
    ~ return ""
}
~ return "s"

=== function es(c) ===
{ c == character:
    ~ return ""
}
~ return "es"

// "are" for you, "is" for a named character.
=== function be(c) ===
{ c == character:
    ~ return "are"
}
~ return "is"

// Same, for the start of a sentence.
=== function Nm(c) ===
{ c == character:
    ~ return t("你", "You")
}
~ return nm(c)

// Frighten someone: the player's own fear, or a companion's.
=== function scare(c, d) ===
{ c == character:
    ~ fear = clamp(fear + d, 0, 100)
- else:
    { c == xin:
        ~ fear_xin = clamp(fear_xin + d, 0, 100)
    }
    { c == yanbo:
        ~ fear_yanbo = clamp(fear_yanbo + d, 0, 100)
    }
    { c == zhiyong:
        ~ fear_zhiyong = clamp(fear_zhiyong + d, 0, 100)
    }
    { c == yi:
        ~ fear_yi = clamp(fear_yi + d, 0, 100)
    }
}

// Change how much a companion trusts the player.
=== function trust(c, d) ===
{ c == xin:
    ~ trust_xin = clamp(trust_xin + d, 0, 100)
}
{ c == yanbo:
    ~ trust_yanbo = clamp(trust_yanbo + d, 0, 100)
}
{ c == zhiyong:
    ~ trust_zhiyong = clamp(trust_zhiyong + d, 0, 100)
}
{ c == yi:
    ~ trust_yi = clamp(trust_yi + d, 0, 100)
}

// --- scene 1: dusk ---------------------------------------------------------

=== dusk ===
{t("六点二十五。", "Six twenty-five.")}
{t("走廊里拖鞋啪嗒啪嗒,门一扇一扇关。整层楼往晚自习走。", "Slippers slap down the corridor, doors bang shut one after another. The whole floor is heading to evening study.")}
{t("302 没动。", "302 doesn't move. ")}{Nm(zhiyong)}{t("和", " and ")}{nm(yi)}{t("是来串门的,一串就串过了六点半。", " came over after class and never left, and now it's past half six.")}
{Nm(zhiyong)}{t("把门反锁了,啧了一声:“都别说话。”", " lock{s(zhiyong)} the door and click{s(zhiyong)} {character == zhiyong:your|his} tongue. ‘Nobody talk.’")}
{Nm(yanbo)}{t("去够大灯开关,手停在半空,又拿回来。“开灯楼下看得见。”", " reach{es(yanbo)} for the big light, stop{s(yanbo)} halfway, pull{s(yanbo)} the hand back. ‘They'd see it from downstairs.’")}
{Nm(xin)}{t("从枕头底下摸出一包辣条。“黑着吃也一样。”", " dig{s(xin)} a bag of spicy strips out from under the pillow. ‘Tastes the same in the dark.’")}
{Nm(yi)}{t("把鞋脱了,盘腿坐到床上。", " take{s(yi)} {character == yi:your|his} shoes off and sit{s(yi)} cross-legged on the bed.")}
{t("过了三秒。", "Three seconds pass.")}
{Nm(xin)}{t(":“怡。”", ": ‘Yi.’")}
{t("“嗯?”", "‘Hm?’")}
{t("“你袜子。”", "‘Your socks.’")}
{Nm(yi)}{t("推了推眼镜。{character == yi:你|他}没戴眼镜。“我倾向于……开个窗。”", " push{es(yi)} {character == yi:your|his} glasses up. {character == yi:You|He} {be(yi)}n't wearing glasses. ‘I'd lean towards... opening a window.’")}
{reason >= 3: {t("逃一次晚自习,没事。大概。", "One skipped evening study. Nothing. Probably.")} #voice:reason}
{insight >= 4: {t("走廊的灯灭了。晚自习的时候走廊灯是不灭的。", "The corridor light went off. It never goes off during evening study.")} #voice:insight}
* [{t("去拉窗帘", "Draw the curtains")}]
    {t("你把窗帘拉严。", "You pull the curtains shut.")}
    {Nm(yanbo)}{t(":“这下跟棺材一样了。”", ": ‘Now it's a coffin.’")}
    {Nm(zhiyong)}{t(":“啧。”", ": ‘Tch.’")}
    ~ fear = clamp(fear - 5, 0, 100)
    -> movie
* [{t("把门缝堵上", "Stuff the gap under the door")}]
    { character == yi:
        {t("你拿起离你最近的东西塞进门缝。是你自己的鞋。", "You grab the nearest thing and jam it into the gap under the door. It's your own shoe.")}
        {Nm(zhiyong)}{t("乐了:“行,有觉悟。”", " laugh{s(zhiyong)}. ‘Good man.’")}
    - else:
        {t("你拿起离你最近的东西塞进门缝。是怡的鞋。", "You grab the nearest thing and jam it into the gap under the door. It's Yi's shoe.")}
        {Nm(yi)}{t(":“……那是我的鞋。”", ": ‘...That's my shoe.’")}
        {Nm(zhiyong)}{t("乐了。", " laugh{s(zhiyong)}.")}
    }
    ~ scare(zhiyong, -5)
    -> movie
* [{t("开条窗缝", "Open the window a crack")}]
    {t("风进来了。袜子味淡了一点,走廊里的声音也进来了。", "Air comes in. The sock smell thins out a bit. So do the sounds from the corridor.")}
    ~ window_open = true
    -> movie

=== movie ===
{Nm(yanbo)}{t("把笔记本抱过来。“看片。”", " drag{s(yanbo)} the laptop over. ‘Film.’")}
{Nm(xin)}{t(":“看哪个?”", ": ‘Which one?’")}
{t("“你拷我硬盘里那个。日本的。”", "‘The one you copied onto my drive. The Japanese one.’")}
{Nm(zhiyong)}{t(":“不看恐怖片。”", ": ‘No horror.’")}
{Nm(xin)}{t(":“老片子,不吓人。”", ": ‘It's old. It's not scary.’")}
{Nm(zhiyong)}{t("把椅子转过去,背对屏幕。过了一分钟又转回来一半。", " turn{s(zhiyong)} the chair round, back to the screen. A minute later it's turned halfway back.")}
{t("片子里一个女生半夜走在学校走廊上,一边走一边数门。", "In the film a girl walks down a school corridor at night, counting doors as she goes.")}
{Nm(yi)}{t(":“……等等。她为什么要数门?”", ": ‘...Wait. Why is she counting doors?’")}
{Nm(yanbo)}{t(":“你看就完了。”", ": ‘Just watch.’")}
{Nm(zhiyong)}{t("从椅背上面看了一眼。“这走廊——”没说完。", " look{s(zhiyong)} over the back of the chair. ‘That corridor—’ and {character == zhiyong:don't|doesn't} finish.")}
{t("女生数到第七扇门,画面定住了。笔记本的电池灯闪了两下,黑了。", "The girl gets to the seventh door and the picture freezes. The laptop's battery light blinks twice and goes out.")}
{Nm(yanbo)}{t(":“充电宝呢。”", ": ‘Power bank.’")}
{Nm(yi)}{t("从包里掏出充电宝。“满的。”插上。没反应。“接口不对。”", " fish{es(yi)} a power bank out of {character == yi:your|his} bag. ‘Full charge.’ Plugs it in. Nothing. ‘Wrong port.’")}
* [{t("盯着定住的那一帧", "Stare at the frozen frame")} #check:insight:easy]
    { check("insight", 8) >= 3:
        {t("黑屏之前你数了一遍。那条走廊不是七扇门。八扇。", "You counted before the screen went black. That corridor doesn't have seven doors. It has eight.")}
        ~ clue_frame = true
        ~ fear += 5
    - else:
        {t("黑屏上就你自己的脸。", "On the black screen there's just your own face.")}
        ~ fear += 5
    }
    -> stories
* [{t("合上笔记本", "Close the laptop")}]
    {t("你把笔记本合上。", "You close the laptop.")}
    {Nm(zhiyong)}{t("长出了一口气,被", " let{s(zhiyong)} out a long breath, and ")}{character == xin:{nm(yanbo)}|{nm(xin)}}{t("听见了。“你怕啦?”“你想啥呢。”", " hears it. ‘Scared?’ ‘What are you on about.’")}
    -> stories

=== stories ===
{Nm(xin)}{t(":“片子没了,讲故事吧。一人一个,就讲咱们这栋楼的。”", ": ‘Film's dead. Stories then. One each, and it has to be about this building.’")}
{Nm(zhiyong)}{t(":“不讲。”", ": ‘Not doing it.’")}
{t("“你先。”", "‘You first.’")}
{t("“……啧。”", "‘...Tch.’")}
-> story_toilet

=== story_toilet ===
{Nm(zhiyong)}{t("讲得短。", " keep{s(zhiyong)} it short.")}
{t("“三楼厕所。最里面那格。门老关着。熄灯以后敲三下,里面有人应。完了。”", "‘Third-floor toilets. Last stall. Door's always shut. Knock three times after lights-out, someone inside answers. Done.’")}
{Nm(yi)}{t(":“……应什么?”", ": ‘...Answers what?’")}
{t("“就应。”", "‘Just answers.’")}
{Nm(yanbo)}{t(":“你这讲的什么玩意。”", ": ‘What kind of story is that.’")}
{t("“爱听不听。”", "‘Don't listen then.’")}
{t("正好这时候,水房那边哗的一声。像有人拧开龙头,又关上。", "Right then, from the water room: a rush of water. Like someone opening a tap and shutting it again.")}
{Nm(yi)}{t(":“……等等。刚才那个声音,是水房的方向?”", ": ‘...Wait. That sound. Was that from the water room?’")}
{Nm(xin)}{t(":“有味。”", ": ‘There's a smell.’")}
{Nm(zhiyong)}{t(":“是你哥们的袜子。”", ": ‘That's your mate's socks.’")}
{Nm(xin)}{t(":“不是袜子。是湿的那种味。”", ": ‘Not socks. A wet kind of smell.’")}
{Nm(zhiyong)}{t(":“龙头漏。磨叽什么。”", ": ‘Leaky tap. Stop dithering.’")}
* [{t("去水房看看", "Go and look in the water room")} #check:insight:normal]
    {t("你开了手机手电,出门。走廊的灯全灭了。水房门开着。", "You turn on your phone's torch and go out. Every light in the corridor is off. The water-room door is open.")}
    ~ battery -= 10
    { check("insight", 10) >= 3:
        {t("龙头拧得死紧。池子是湿的,一整片,排水口边上有一圈白的东西,像肥皂沫,不是肥皂沫。", "The tap is shut tight. The basin is wet, all of it, and round the drain there's a ring of something white, like soap scum, that isn't soap scum.")}
        ~ tap_seen = true
        ~ fear += 10
    - else:
        {t("龙头拧得死紧。你照了一圈,手电的光圈太小,什么也看不出来。", "The tap is shut tight. You sweep the torch round. The circle of light is too small to show you anything.")}
        ~ fear += 10
    }
    {t("你回到 302。", "You come back to 302. ")}{character == zhiyong:{nm(yanbo)}{t("头都没抬:“没死就行。”", " doesn't look up. ‘Not dead. Good.’")}|{nm(zhiyong)}{t(":“行了,回来了,没死。”", ": ‘Right. You're back. Not dead.’")}}
    -> story_door
* [{t("别管", "Leave it")}]
    {Nm(yi)}{t("没说话,推了推不存在的眼镜。", " say{s(yi)} nothing and push{es(yi)} the glasses that aren't there.")}
    ~ scare(yi, 5)
    -> story_door

=== story_door ===
{Nm(yanbo)}{t("讲得好。{character == yanbo:你|他}讲的时候不看人,看天花板。", " tell{s(yanbo)} it well, eyes on the ceiling the whole time, not on anyone.")}
{t("“这一层,白天数,七扇门。半夜数,八扇。”", "‘This floor. Count the doors by day, seven. Count them at night, eight.’")}
{t("“多出来那扇在哪一头,没人说得清。因为数到第八扇的人,都推开过。”", "‘Nobody can say which end the extra one's at. Because everyone who counted to eight pushed it open.’")}
{clue_frame: {t("片子里那条走廊,就是八扇。", "The corridor in the film. Eight.")} #voice:insight}
{Nm(xin)}{t(":“别讲了。”声音小下去,手已经揪住了身边人的袖子。", ": ‘Stop.’ The voice goes small, and a hand has already got hold of somebody's sleeve.")}
* {character != xin} [{t("拍拍昕", "Nudge Xin")} #check:charm:easy]
    { check("charm", 8) >= 3:
        {t("你说这屋里最吓人的是{character == yi:你自己|怡}的脚。昕笑了,松开了你的袖子。", "You say the scariest thing in this room is {character == yi:your own|Yi's} feet. Xin laughs and lets go of your sleeve.")}
        ~ scare(xin, -10)
        ~ trust(xin, 5)
    - else:
        {t("“我没事我没事。”昕抓得更紧了。", "‘I'm fine I'm fine.’ Xin's grip gets tighter.")}
        ~ scare(xin, 5)
    }
    -> story_tap
* {character == xin} [{t("说你没事", "Say you're fine")} #check:reason:easy]
    { check("reason", 8) >= 3:
        {t("你说你没事。说出来以后好像真的好了一点。你把手松开了。", "You say you're fine. Saying it helps, a bit. You let go of the sleeve.")}
        ~ fear = clamp(fear - 5, 0, 100)
    - else:
        {t("你说你没事。你没松手。", "You say you're fine. You don't let go.")}
        ~ fear += 10
    }
    -> story_tap
* [{t("让烟波讲完", "Let Yanbo finish")}]
    {t("第八扇门后面是什么,烟波说,他也不知道。“讲完了。”", "What's behind the eighth door, Yanbo says, he doesn't know either. ‘That's it.’")}
    ~ fear += 5
    -> story_tap

=== story_tap ===
{Nm(yi)}{t("讲得慢,每句话前面都带一个“有可能”。", " {be(yi)} slow about it. Every sentence starts with ‘possibly’.")}
{t("“水房的龙头,有可能,半夜会自己开。听着像有人在洗东西。我倾向于……去关的人——”", "‘The tap in the water room, possibly, turns itself on at night. Sounds like someone washing something. I'd lean towards... whoever goes to turn it off—’")}
{t("停了。推眼镜。“后面我忘了。”", "A stop. The glasses get pushed up. ‘I forget the rest.’")}
{Nm(zhiyong)}{t(":“啧。”", ": ‘Tch.’")}
{tap_seen: {t("排水口那一圈白的。", "That white ring round the drain.")} #voice:insight}
{ tap_seen:
    ~ fear += 10
}
{Nm(xin)}{t("看手机。“八点五十九。”", " check{s(xin)} the phone. ‘Eight fifty-nine.’")}
{Nm(yanbo)}{t(":“该下课了。”", ": ‘Study's over.’")}
{t("走廊里该有脚步声了。", "There should be footsteps in the corridor by now.")}
{t("没有。", "There aren't.")}
{Nm(zhiyong)}{t("看了眼自己的手机。“23%。”没人接话。", " look{s(zhiyong)} at {character == zhiyong:your|his} own phone. ‘Twenty-three percent.’ Nobody picks that up.")}
-> story_knock

=== story_knock ===
{Nm(xin)}{t("最后一个。四个人里只有{character == xin:你|他}讲得起劲。", " go{es(xin)} last, the only one of the four who's enjoying this.")}
{t("“咱们楼不查寝,对吧。”", "‘Nobody checks rooms in this building, right.’")}
{t("“对。”", "‘Right.’")}
{t("“学长说,就因为不查寝。所以熄灯以后要是有人敲门,问屋里几个人——”", "‘A senior told me that's exactly why. So if someone knocks after lights-out and asks how many are in the room—’")}
{t("敲门。三下。", "A knock. Three times.")}
{t("门外:“几个人?”", "Outside the door: ‘How many of you?’")}
{Nm(zhiyong)}{t("已经站起来了,攥着拳头,挡在门和你们中间。没动。", " {be(zhiyong)} already up, fists closed, between the door and the rest of you. Not moving.")}
{Nm(yi)}{t(":“……等等。现在几点?”", ": ‘...Wait. What time is it?’")}
{t("你看手机。8:59。", "You check your phone. 8:59.")}
{reason >= 3: {t("现在不可能有人查寝。", "Nobody could be checking rooms now.")} #voice:reason}
{insight >= 4: {t("敲的是门板正中间。不是门把手那边。", "The knock was in the middle of the door. Not by the handle.")} #voice:insight}
{strength >= 5: {t("顶住门。", "Hold the door.")} #voice:strength}
* [{t("答:四个", "Answer: four")}]
    ~ answered = "four"
    {t("你说了四个。门外没再问。", "You say four. Outside, nothing more.")}
    {Nm(zhiyong)}{t("回头看你,像你答错了题。", " look{s(zhiyong)} back at you like you got the answer wrong.")}
    -> after_knock
* [{t("答:三个", "Answer: three")}]
    ~ answered = "three"
    {t("你说了三个。屋里有人倒抽了一口气,你不知道是谁。", "You say three. Someone in the room sucks in a breath, and you don't know who.")}
    ~ fear += 10
    -> after_knock
* [{t("不答,示意大家别出声", "Say nothing. Signal everyone to keep quiet.")}]
    ~ answered = "none"
    {t("没人出声。门外等了一会儿。又问了一遍:几个人?", "Nobody makes a sound. Outside, it waits. Then asks again: how many of you?")}
    {Nm(zhiyong)}{t("的拳头攥得咔咔响。", "'s knuckles crack.")}
    ~ fear += 10
    ~ scare(xin, 10)
    -> after_knock
* [{t("开门", "Open the door")}]
    ~ answered = "open"
    {t("你开了门。走廊里没人,也没灯。", "You open the door. Nobody in the corridor. No light either.")}
    {Nm(zhiyong)}{t("一把把你拽了回来。", " yank{s(zhiyong)} you back in.")}
    ~ fear += 20
    -> after_knock

=== after_knock ===
{t("门外安静了。", "Outside, it's quiet.")}
{t("安静得不像一栋刚下课的楼。", "Not the kind of quiet a building has just after study lets out.")}
{Nm(yi)}{t("小声:“我倾向于……先排除一下是不是宿管。”", ", quietly: ‘I'd lean towards... ruling out the warden first.’")}
{t("没人接话。", "Nobody answers.")}
{t("(第一场到这里。后面还没写。)", "(End of scene one. The rest isn't written yet.)")}
-> END
