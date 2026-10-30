// 302 — main story. Text is {t("中文", "English")}; ids and identifiers are English.
// The player is always Xin ("你"); Yanbo, Zhiyong and Yi are companions. The engine file is
// generated from game.md. Scene 1 (dusk to the knock) is a draft to play and rewrite.
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

// Frighten a companion (negative d calms him).
=== function scare(c, d) ===
{ c == yanbo:
    ~ fear_yanbo = clamp(fear_yanbo + d, 0, 100)
}
{ c == zhiyong:
    ~ fear_zhiyong = clamp(fear_zhiyong + d, 0, 100)
}
{ c == yi:
    ~ fear_yi = clamp(fear_yi + d, 0, 100)
}

// Change how much a companion trusts you.
=== function trust(c, d) ===
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
{t("302 没动。志勇和怡是来串门的,一串就串过了点,现在走也来不及了。", "302 doesn't move. Zhiyong and Yi came over after class and lost track of time, and now it's too late to go.")}
{t("志勇把门反锁了,啧了一声:“都别说话。老周要是上来,寄。”", "Zhiyong locks the door and clicks his tongue. ‘Nobody talk. If Old Zhou comes up, we're done.’")}
{t("烟波去够大灯开关,手停在半空,又拿回来。“开灯楼下看得见。你想让老周拿手电上来照脸?”", "Yanbo reaches for the big light, stops halfway, pulls the hand back. ‘They'd see it from downstairs. You want Old Zhou up here with a torch in your face?’")}
{t("你从枕头底下摸出一包辣条,撕开。“黑着吃也一样。”", "You dig a bag of spicy strips out from under the pillow and tear it open. ‘Tastes the same in the dark.’")}
{t("“你是真能吃。”志勇说。", "‘You never stop eating,’ Zhiyong says.")}
{t("“我这叫情绪稳定。”", "‘It's called being emotionally stable.’")}
{t("怡把鞋脱了,盘腿坐到你床上。", "Yi takes his shoes off and sits cross-legged on your bed.")}
{t("过了三秒。", "Three seconds pass.")}
{t("“怡。”", "‘Yi.’")}
{t("“嗯?”", "‘Hm?’")}
{t("“你袜子。”", "‘Your socks.’")}
{t("“……啊。”", "‘...Ah.’")}
{t("“不是‘啊’。你袜子。”", "‘Not “ah”. Your socks.’")}
{t("志勇:“傻屌,你多久没洗了。”", "Zhiyong: ‘Dumbass, when did you last wash those.’")}
{t("怡推了推眼镜。他没戴眼镜。“我倾向于……开个窗。”", "Yi pushes his glasses up. He isn't wearing glasses. ‘I'd lean towards... opening a window.’")}
{t("烟波:“你倾向于洗一下。”", "Yanbo: ‘Lean towards washing them.’")}
{reason >= 3: {t("逃一次晚自习,没事。大概。", "One skipped evening study. Nothing. Probably.")} #voice:reason}
{insight >= 4: {t("走廊的灯灭了。晚自习的时候走廊灯是不灭的。", "The corridor light went off. It never goes off during evening study.")} #voice:insight}
* [{t("去拉窗帘", "Draw the curtains")}]
    {t("你把窗帘拉严。", "You pull the curtains shut.")}
    {t("烟波:“这下跟棺材一样了。”", "Yanbo: ‘Now it's a coffin.’")}
    {t("志勇:“你能不能别提这个字。”", "Zhiyong: ‘Can you not say that word.’")}
    {t("“哪个字?棺材?”", "‘Which word? Coffin?’")}
    {t("“啧。”", "‘Tch.’")}
    ~ fear = clamp(fear - 5, 0, 100)
    -> movie
* [{t("把门缝堵上", "Stuff the gap under the door")}]
    {t("你拿起离你最近的东西塞进门缝。是怡的鞋。", "You grab the nearest thing and jam it into the gap under the door. It's Yi's shoe.")}
    {t("怡:“……那是我的鞋。”", "Yi: ‘...That's my shoe.’")}
    {t("志勇乐了:“绝了,物尽其用。”", "Zhiyong cracks up. ‘Perfect. Nothing wasted.’")}
    {t("怡:“……行吧。”", "Yi: ‘...Fine.’")}
    ~ scare(zhiyong, -5)
    -> movie
* [{t("开条窗缝", "Open the window a crack")}]
    {t("风进来了。袜子味淡了一点,走廊里的声音也进来了。", "Air comes in. The sock smell thins out a bit. So do the sounds from the corridor.")}
    {t("怡:“谢谢。”", "Yi: ‘Thanks.’")}
    {t("志勇:“你还挺有礼貌。”", "Zhiyong: ‘Look at him, manners and everything.’")}
    ~ window_open = true
    -> movie

=== movie ===
{t("烟波把笔记本抱过来,屏幕上一层指纹。“看片。”", "Yanbo drags the laptop over, the screen a sheet of fingerprints. ‘Film.’")}
{t("“看哪个?”", "‘Which one?’")}
{t("“你拷我硬盘里那个。日本的。”", "‘The one you copied onto my drive. The Japanese one.’")}
{t("志勇:“不看恐怖片。”", "Zhiyong: ‘No horror.’")}
{t("“老片子,不吓人,我看过八遍了。”", "‘It's old. It's not scary. I've seen it eight times.’")}
{t("“你看过八遍你看,我不看。”", "‘You've seen it eight times, you watch it. I'm not.’")}
{t("“你一米九你怕什么。”", "‘You're one ninety. What are you scared of.’")}
{t("“一米九跟这有什么关系。”他把椅子转过去,背对屏幕。过了一分钟,又转回来一半。", "‘What's one ninety got to do with it.’ He turns the chair round, back to the screen. A minute later it's turned halfway back.")}
{t("片子里一个女生半夜走在学校走廊上,一边走一边数门。画质糊得像隔着水。", "In the film a girl walks down a school corridor at night, counting doors as she goes. The picture's so smeared it looks underwater.")}
{t("怡:“……等等。她为什么要数门?”", "Yi: ‘...Wait. Why is she counting doors?’")}
{t("烟波:“你看就完了。”", "Yanbo: ‘Just watch.’")}
{t("“不是,我是说从逻辑上——”", "‘No, I mean logically—’")}
{t("“怡。看就完了。”", "‘Yi. Just watch.’")}
{t("志勇从椅背上面看了一眼。“这走廊——”没说完。", "Zhiyong looks over the back of the chair. ‘That corridor—’ He doesn't finish.")}
{t("“这走廊怎么了?”", "‘What about the corridor?’")}
{t("“没事。”", "‘Nothing.’")}
{t("女生数到第七扇门,画面定住了。笔记本的电池灯闪了两下,黑了。", "The girl gets to the seventh door and the picture freezes. The laptop's battery light blinks twice and goes out.")}
{t("“卧槽。”你说。", "‘Oh, come on,’ you say.")}
{t("烟波:“没电了。充电宝呢。”", "Yanbo: ‘Dead. Power bank.’")}
{t("“你自己的呢?”", "‘Where's yours?’")}
{t("“没充。”", "‘Didn't charge it.’")}
{t("“你充电宝就没充过电。”", "‘Your power bank has never once been charged.’")}
{t("怡从包里掏出充电宝。“满的。”插上。没反应。“接口不对。”", "Yi fishes a power bank out of his bag. ‘Full.’ Plugs it in. Nothing. ‘Wrong port.’")}
{t("烟波:“典。”", "Yanbo: ‘Classic.’")}
* [{t("盯着定住的那一帧", "Stare at the frozen frame")} #check:insight:easy]
    { check("insight", 8) >= 3:
        {t("黑屏之前你数了一遍。那条走廊不是七扇门。八扇。你没说。", "You counted before the screen went black. That corridor doesn't have seven doors. It has eight. You don't say so.")}
        ~ clue_frame = true
        ~ fear += 5
    - else:
        {t("黑屏上就你自己的脸,和你身后志勇的半个脑袋。", "On the black screen there's just your own face, and half of Zhiyong's head behind you.")}
        ~ fear += 5
    }
    -> stories
* [{t("合上笔记本", "Close the laptop")}]
    {t("你把笔记本合上。志勇长出了一口气。", "You close the laptop. Zhiyong lets out a long breath.")}
    {t("“你怕啦?”", "‘Scared?’")}
    {t("“你想啥呢。我是觉得这片拍得烂。”", "‘What are you on about. I just think it's a bad film.’")}
    -> stories

=== stories ===
{t("“片子没了。”你说,“讲故事吧。一人一个,就讲咱们这栋楼的。”", "‘Film's dead,’ you say. ‘Stories then. One each, and it has to be about this building.’")}
{t("志勇:“不讲。”", "Zhiyong: ‘Not doing it.’")}
{t("“你先。”", "‘You first.’")}
{t("“我说了不讲。”", "‘I said I'm not doing it.’")}
{t("“志勇先。”烟波说。怡也点头。", "‘Zhiyong first,’ Yanbo says. Yi nods too.")}
{t("“……啧。”", "‘...Tch.’")}
-> story_toilet

=== story_toilet ===
{t("志勇讲得短。", "Zhiyong keeps it short.")}
{t("“三楼厕所。最里面那格。门老关着。熄灯以后你去敲三下,里面有人应。完了。”", "‘Third-floor toilets. Last stall. Door's always shut. Knock three times after lights-out, someone inside answers. Done.’")}
{t("怡:“……应什么?”", "Yi: ‘...Answers what?’")}
{t("“就应。”", "‘Just answers.’")}
{t("烟波:“你这讲的什么玩意,一句话故事?”", "Yanbo: ‘What kind of story is that. One sentence?’")}
{t("“爱听不听。”", "‘Don't listen then.’")}
{t("“有一说一,还挺吓人的。”你说。", "‘Honestly though, that's kind of creepy,’ you say.")}
{t("“你闭嘴。”", "‘Shut up.’")}
{t("正好这时候,水房那边哗的一声。像有人拧开龙头,又关上。", "Right then, from the water room: a rush of water. Like someone opening a tap and shutting it again.")}
{t("没人说话。", "Nobody says anything.")}
{t("怡:“……等等。刚才那个声音,是水房的方向?”", "Yi: ‘...Wait. That sound. Was that from the water room?’")}
{t("“有味。”你说。", "‘There's a smell,’ you say.")}
{t("志勇:“是你哥们的袜子。”", "Zhiyong: ‘That's your mate's socks.’")}
{t("“不是袜子。是湿的那种味。像……”你想了想,“像梅雨天的拖把。”", "‘Not socks. A wet kind of smell. Like...’ you think about it, ‘like a mop in the rainy season.’")}
{t("“你鼻子是狗吗。”", "‘Are you a dog.’")}
{t("“龙头漏。”志勇说,“磨叽什么。”", "‘Leaky tap,’ Zhiyong says. ‘Stop dithering.’")}
* [{t("去水房看看", "Go and look in the water room")} #check:insight:normal]
    {t("你开了手机手电,出门。走廊的灯全灭了。平时晚自习走廊灯是不灭的。水房门开着。", "You turn on your phone's torch and go out. Every light in the corridor is off. They never go off during evening study. The water-room door is open.")}
    ~ battery -= 10
    { check("insight", 10) >= 3:
        {t("龙头拧得死紧。池子是湿的,一整片,排水口边上有一圈白的东西,像肥皂沫,不是肥皂沫。你没碰。", "The tap is shut tight. The basin is wet, all of it, and round the drain there's a ring of something white, like soap scum, that isn't soap scum. You don't touch it.")}
        ~ tap_seen = true
        ~ fear += 10
    - else:
        {t("龙头拧得死紧。你照了一圈,手电的光圈太小,什么也看不出来。你站了十秒钟,后脖子凉。", "The tap is shut tight. You sweep the torch round. The circle of light is too small to show you anything. You stand there ten seconds. The back of your neck goes cold.")}
        ~ fear += 10
    }
    {t("你回到 302。", "You come back to 302.")}
    {t("志勇:“行了,回来了,没死。”", "Zhiyong: ‘Right. You're back. Not dead.’")}
    {t("烟波:“看见什么了?”", "Yanbo: ‘See anything?’")}
    { tap_seen:
        {t("“……池子是湿的。”", "‘...The basin's wet.’")}
        {t("怡:“哪个池子?”你没回答。", "Yi: ‘Which basin?’ You don't answer.")}
    - else:
        {t("“……没什么。”", "‘...Nothing.’")}
    }
    -> story_door
* [{t("别管", "Leave it")}]
    {t("“那就别管。”烟波说。", "‘Then leave it,’ Yanbo says.")}
    {t("怡没说话,推了推不存在的眼镜。", "Yi says nothing and pushes the glasses that aren't there.")}
    ~ scare(yi, 5)
    -> story_door

=== story_door ===
{t("烟波讲得好。他讲的时候不看人,看天花板,声音压得低。", "Yanbo tells it well. Eyes on the ceiling the whole time, not on anyone, voice kept low.")}
{t("“这一层,白天数,七扇门。半夜数,八扇。”", "‘This floor. Count the doors by day, seven. Count them at night, eight.’")}
{t("“多出来那扇在哪一头,没人说得清。因为数到第八扇的人,都推开过。”", "‘Nobody can say which end the extra one's at. Because everyone who counted to eight pushed it open.’")}
{t("“推开以后呢?”怡问。", "‘And after they pushed it?’ Yi asks.")}
{t("“推开以后就没有以后了。”", "‘After that there's no after.’")}
{clue_frame: {t("片子里那条走廊,就是八扇。", "The corridor in the film. Eight.")} #voice:insight}
{t("“别讲了。”你听见自己说。声音小下去了,手已经揪住了志勇的袖子。", "‘Stop,’ you hear yourself say. Your voice has gone small, and your hand has already got hold of Zhiyong's sleeve.")}
{t("志勇:“松手。”", "Zhiyong: ‘Let go.’")}
{t("你松了。“对不起。”", "You let go. ‘Sorry.’")}
{t("“……你怕个屁,一片子看八遍的人。”", "‘...What are you scared of. You've seen the film eight times.’")}
* [{t("拿怡的脚开玩笑", "Make a joke about Yi's feet")} #check:charm:easy]
    { check("charm", 8) >= 3:
        {t("你说这屋里最吓人的是怡的脚。志勇笑喷了。", "You say the scariest thing in this room is Yi's feet. Zhiyong loses it.")}
        {t("怡:“……有一说一,这个梗可以结束了。”", "Yi: ‘...Honestly, this joke can end now.’")}
        ~ fear = clamp(fear - 10, 0, 100)
        ~ scare(zhiyong, -5)
    - else:
        {t("你说这屋里最吓人的是怡的脚。没人笑。", "You say the scariest thing in this room is Yi's feet. Nobody laughs.")}
        {t("怡:“……不好笑。”", "Yi: ‘...Not funny.’")}
        ~ fear += 5
        ~ trust(yi, -5)
    }
    -> story_tap
* [{t("说你没事", "Say you're fine")} #check:reason:easy]
    { check("reason", 8) >= 3:
        {t("你说你没事。说出来以后好像真的好了一点。", "You say you're fine. Saying it helps, a bit.")}
        ~ fear = clamp(fear - 5, 0, 100)
    - else:
        {t("你说你没事。志勇看了你一眼,没拆穿。", "You say you're fine. Zhiyong gives you a look and lets it go.")}
        ~ fear += 10
    }
    -> story_tap
* [{t("让烟波讲完", "Let Yanbo finish")}]
    {t("“第八扇门后面是什么?”你问。", "‘What's behind the eighth door?’ you ask.")}
    {t("烟波想了想。“不知道。讲完了。”", "Yanbo thinks about it. ‘Don't know. That's it.’")}
    {t("志勇:“你讲完了?”", "Zhiyong: ‘That's it?’")}
    {t("“讲完了。”", "‘That's it.’")}
    {t("“寄。”", "‘We're so dead.’")}
    ~ fear += 5
    -> story_tap

=== story_tap ===
{t("怡讲得慢,每句话前面都带一个“有可能”。", "Yi is slow about it. Every sentence starts with ‘possibly’.")}
{t("“水房的龙头,有可能,半夜会自己开。听着像有人在洗东西。我倾向于……去关的人——”", "‘The tap in the water room, possibly, turns itself on at night. Sounds like someone washing something. I'd lean towards... whoever goes to turn it off—’")}
{t("停了。推眼镜。", "He stops. Pushes the glasses up.")}
{t("“去关的人怎么了?”", "‘What about whoever goes to turn it off?’")}
{t("“……后面我忘了。”", "‘...I forget the rest.’")}
{t("志勇:“啧。”", "Zhiyong: ‘Tch.’")}
{t("“不是,我真忘了。高一的时候听隔壁楼的人说的。”", "‘No, I really did forget. Someone from the next building told me in first year.’")}
{tap_seen: {t("排水口那一圈白的。", "That white ring round the drain.")} #voice:insight}
{ tap_seen:
    ~ fear += 10
}
{t("你看手机。八点五十九。“该下课了。”", "You check your phone. Eight fifty-nine. ‘Study's over.’")}
{t("烟波:“嗯。”", "Yanbo: ‘Mm.’")}
{t("走廊里该有脚步声了。", "There should be footsteps in the corridor by now.")}
{t("没有。", "There aren't.")}
{t("志勇看了眼自己的手机。“23%。”", "Zhiyong looks at his own phone. ‘Twenty-three percent.’")}
{t("没人接话。", "Nobody picks that up.")}
{t("怡:“我这有充电宝。”", "Yi: ‘I've got the power bank.’")}
{t("“接口对吗。”", "‘Right port this time?’")}
{t("“……对的。”", "‘...Yes.’")}
-> story_knock

=== story_knock ===
{t("你最后一个。四个人里只有你讲得起劲。", "You go last, the only one of the four who's enjoying this.")}
{t("“咱们楼不查寝,对吧。”", "‘Nobody checks rooms in this building, right.’")}
{t("“对。”", "‘Right.’")}
{t("“老周从来不上来。”", "‘Old Zhou never comes up.’")}
{t("“对。”", "‘Right.’")}
{t("“学长说,就因为不查寝。所以熄灯以后要是有人敲门,问屋里几个人——”", "‘A senior told me that's exactly why. So if someone knocks after lights-out and asks how many are in the room—’")}
{t("敲门。三下。", "A knock. Three times.")}
{t("门外:“几个人?”", "Outside the door: ‘How many of you?’")}
{t("志勇已经站起来了,攥着拳头,挡在门和你们中间。没动。", "Zhiyong is already up, fists closed, between the door and the rest of you. Not moving.")}
{t("怡:“……等等。现在几点?”", "Yi: ‘...Wait. What time is it?’")}
{t("你看手机。8:59。", "You check your phone. 8:59.")}
{reason >= 3: {t("现在不可能有人查寝。", "Nobody could be checking rooms now.")} #voice:reason}
{insight >= 4: {t("敲的是门板正中间。不是门把手那边。", "The knock was in the middle of the door. Not by the handle.")} #voice:insight}
{strength >= 5: {t("顶住门。", "Hold the door.")} #voice:strength}
* [{t("答:四个", "Answer: four")}]
    ~ answered = "four"
    {t("“四个。”你说。门外没再问。", "‘Four,’ you say. Outside, nothing more.")}
    {t("志勇回头看你,像你答错了题。", "Zhiyong looks back at you like you got the answer wrong.")}
    -> after_knock
* [{t("答:三个", "Answer: three")}]
    ~ answered = "three"
    {t("“三个。”你说。你不知道自己为什么说三个。", "‘Three,’ you say. You don't know why you said three.")}
    {t("屋里有人倒抽了一口气。", "Someone in the room sucks in a breath.")}
    ~ fear += 10
    -> after_knock
* [{t("不答,抬手让大家别出声", "Say nothing. Raise a hand: quiet.")}]
    ~ answered = "none"
    {t("没人出声。门外等了一会儿。又问了一遍:几个人?", "Nobody makes a sound. Outside, it waits. Then asks again: how many of you?")}
    {t("志勇的拳头攥得咔咔响。", "Zhiyong's knuckles crack.")}
    ~ fear += 10
    ~ scare(zhiyong, 10)
    -> after_knock
* [{t("开门", "Open the door")}]
    ~ answered = "open"
    {t("你开了门。走廊里没人,也没灯。", "You open the door. Nobody in the corridor. No light either.")}
    {t("志勇一把把你拽了回来:“你他妈有病吧。”", "Zhiyong yanks you back in. ‘What the hell is wrong with you.’")}
    ~ fear += 20
    -> after_knock

=== after_knock ===
{t("门外安静了。", "Outside, it's quiet.")}
{t("安静得不像一栋刚下课的楼。", "Not the kind of quiet a building has just after study lets out.")}
{t("怡小声:“我倾向于……先排除一下是不是老周。”", "Yi, quietly: ‘I'd lean towards... ruling out Old Zhou first.’")}
{t("“老周不上来。”烟波说。", "‘Old Zhou doesn't come up,’ Yanbo says.")}
{t("“……我知道。”", "‘...I know.’")}
{t("没人接话。", "Nobody answers.")}
{t("(第一场到这里。后面还没写。)", "(End of scene one. The rest isn't written yet.)")}
-> END
