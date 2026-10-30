// 302 — main story. Text is {t("中文", "English")}; ids and identifiers are English.
// The engine file is generated from game.md. Scene 1 (dusk to the knock) is a first draft to play and rewrite.
INCLUDE _engine.ink

// What the player has seen or done (the later scenes read these).
VAR clue_frame = false   // counted the doors in the frozen movie frame
VAR tap_seen = false     // saw the wet sink in the water room
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
{t("六点二十五分。", "Six twenty-five.")}
{t("走廊里是拖鞋拍地的声音,门一扇接一扇关上。整层楼在往晚自习走。302 没动。", "Slippers slap along the corridor; doors shut one after another. The whole floor is heading to evening study. Room 302 does not move.")}
{Nm(zhiyong)}{t("把门反锁了。", " lock{s(zhiyong)} the door from the inside.")}
{Nm(yanbo)}{t("伸手去够大灯的开关,又缩回来:开灯就等于告诉楼下的宿管,这屋有人。", " reach{es(yanbo)} for the main light switch and pull{s(yanbo)} the hand back: a lit window tells the warden downstairs that someone is home.")}
{t("于是黑着。四个人,三部手机的光,一台笔记本。", "So it stays dark. Four people, the glow of three phones, one laptop.")}
{reason >= 3: {t("逃一次晚自习不会怎么样。大概。", "Skipping one evening study is nothing. Probably.")} #voice:reason}
{insight >= 4: {t("楼安静得太快了。", "The building went quiet too fast.")} #voice:insight}
* [{t("去拉窗帘", "Draw the curtains")}]
    {t("你把窗帘拉严。屋里的黑变成了自己的黑,好受了一点。", "You pull the curtains shut. The dark becomes your own dark, which is a little easier.")}
    ~ fear = clamp(fear - 5, 0, 100)
    -> movie
* [{t("把门缝堵上", "Stuff the gap under the door")}]
    {t("你把一件校服塞进门缝。走廊那边的光没了,脚步声也闷了。", "You push a school jacket into the gap under the door. The corridor light is gone, and the footsteps go muffled.")}
    ~ scare(yi, -5)
    -> movie
* [{t("坐下", "Sit down")}]
    -> movie

=== movie ===
{Nm(yanbo)}{t("打开笔记本:一部老的日本鬼片,画质糊得像隔着水。", " open{s(yanbo)} the laptop: an old Japanese ghost film, the picture smeared as if seen through water.")}
{t("片子里,一个女生半夜走在学校的走廊上,一边走一边数门。", "On screen a girl walks a school corridor at night, counting the doors as she goes.")}
{Nm(yi)}{t("把被子拉到了下巴。", " pull{s(yi)} the blanket up to the chin.")}
{Nm(zhiyong)}{t("小声说:“这走廊跟咱们这层挺像。”", " say{s(zhiyong)}, quietly: ‘That corridor looks like ours.’")}
{t("女生数到第七扇门的时候,画面定住了。笔记本的电池灯闪了两下,屏幕黑了。", "At the seventh door the picture freezes. The laptop's battery light blinks twice and the screen goes black.")}
{Nm(yanbo)}{t("按了几下电源键,没反应:“明明充了的。”", " press{es(yanbo)} the power button a few times, nothing: ‘I charged it. I did.’")}
* [{t("盯着定住的那一帧", "Stare at the frozen frame")} #check:insight:easy]
    { check("insight", 8) >= 3:
        {t("黑屏之前,你把那条走廊看清了。门不是七扇。是八扇。", "Before the screen went black you got a clear look at that corridor. There were not seven doors. There were eight.")}
        ~ clue_frame = true
        ~ fear += 5
    - else:
        {t("黑屏上只有你自己的脸,和你身后的一片黑。", "On the black screen there is only your own face, and the dark behind you.")}
        ~ fear += 5
    }
    -> stories
* [{t("合上笔记本", "Close the laptop")}]
    {t("你把笔记本合上。屋里更黑了。", "You close the laptop. The room gets darker.")}
    -> stories

=== stories ===
{Nm(zhiyong)}{t("说:“片子没了,讲故事吧。一人一个,就讲咱们这栋楼的。”", " say{s(zhiyong)}: ‘Film's dead. Stories, then. One each, and it has to be about this building.’")}
{t("没人反对。黑屋子里的声音比白天的小。", "Nobody objects. Voices are smaller in a dark room than in daylight.")}
-> story_toilet

=== story_toilet ===
{Nm(zhiyong)}{t("先来。{character == zhiyong:你|他}讲得很差,但讲得很认真。", " go{es(zhiyong)} first, badly and in earnest.")}
{t("三楼的厕所,最里面那一格,门一直是关着的。熄灯以后你去敲三下,里面会有人应你。", "Third-floor toilets, the last stall, door always shut. Knock three times after lights-out and someone inside answers.")}
{t("“应什么?”", "‘Answers what?’")}
{t("“就应。”", "‘Just answers.’")}
{t("故事讲到这儿,水房那边传来了水声。哗的一下,又停了。", "That is as far as the story gets when water sounds from the water room. One rush of it, then it stops.")}
{t("四个人都没说话。然后", "Nobody speaks. Then ")}{nm(zhiyong)}{t("笑了:“龙头漏。”", " laugh{s(zhiyong)}: ‘Leaky tap.’")}
* [{t("去水房看看", "Go and look in the water room")} #check:insight:normal]
    {t("你开了手机的手电,出门,走廊黑得像没有尽头。水房的门开着。", "You switch on your phone's torch and step out. The corridor is dark the way a thing without an end is dark. The water-room door stands open.")}
    ~ battery -= 10
    { check("insight", 10) >= 3:
        {t("龙头关得死死的,下面的池子却是湿的。湿的不是水珠,是一整片,像刚有人在里面洗过什么。", "The tap is shut tight, but the basin under it is wet. Not drops: the whole of it, as if someone just washed something there.")}
        ~ tap_seen = true
        ~ fear += 10
    - else:
        {t("龙头关得死死的。你什么也没看出来,只是手电的光圈小得难受。", "The tap is shut tight. You see nothing else, only that the circle of torchlight is unbearably small.")}
        ~ fear += 10
    }
    {t("你回到 302,", "You come back to 302 and ")}{character == zhiyong:{nm(yanbo)}|{nm(zhiyong)}}{t("在笑你。", " laughs at you.")}
    -> story_door
* [{t("别管,龙头本来就漏", "Leave it. That tap always leaks.")}]
    {Nm(yi)}{t("没有笑。", " {be(yi)} not laughing.")}
    ~ scare(yi, 5)
    -> story_door

=== story_door ===
{Nm(yanbo)}{t("第二个。{character == yanbo:你|他}讲故事的时候像在交代一件真事。", " {be(yanbo)} next, and tell{s(yanbo)} it like a thing that happened.")}
{t("这一层,白天数是七扇门。半夜数,是八扇。", "This floor has seven doors if you count them by day. Count them at night and there are eight.")}
{t("数到第八扇的人,会想推开它。", "Whoever counts to the eighth will want to push it open.")}
{clue_frame: {t("片子里那条走廊,就是八扇。", "The corridor in the film had eight.")} #voice:insight}
{Nm(yi)}{t("说:“别讲了。”声音是抖的。", " say{s(yi)}: ‘Stop.’ The voice shakes.")}
* {character != yi} [{t("拍拍怡", "Nudge Yi")} #check:charm:easy]
    { check("charm", 8) >= 3:
        {t("你碰了碰她的胳膊,说这屋里最可怕的是志勇的脚。她笑了一下。", "You touch her arm and tell her the scariest thing in this room is Zhiyong's feet. She laughs, a little.")}
        ~ scare(yi, -10)
        ~ trust(yi, 5)
    - else:
        {t("“别碰我。”她把手缩回被子里。", "‘Don't.’ She pulls her hand back under the blanket.")}
        ~ scare(yi, 5)
    }
    -> story_tap
* {character == yi} [{t("说你没事", "Say you're fine")} #check:reason:easy]
    { check("reason", 8) >= 3:
        {t("你说你没事。说出来之后,好像真的没事了一点。", "You say you are fine. Once it is said, it is a little true.")}
        ~ fear = clamp(fear - 5, 0, 100)
    - else:
        {t("你说你没事。你的声音不这么认为。", "You say you are fine. Your voice disagrees.")}
        ~ fear += 10
    }
    -> story_tap
* [{t("让烟波讲完", "Let Yanbo finish")}]
    {t("第八扇门后面是什么,烟波说他也不知道。讲完的人不知道,是最差的那种讲法。", "What is behind the eighth door, Yanbo says, he does not know. A teller who does not know is the worst kind.")}
    ~ fear += 5
    -> story_tap

=== story_tap ===
{Nm(yi)}{t("第三个。{character == yi:你|她}是听别人说的,所以讲得很快,像想赶紧讲完。", " {be(yi)} third. It was heard from someone else, so it comes out fast, like something to be got rid of.")}
{t("水房的水龙头,半夜会自己开。水声像有人在里面洗东西。去关的人——", "The tap in the water room turns itself on at night. It sounds like someone washing something in there. Whoever goes to turn it off—")}
{t("她停了。“后面我忘了。”", "She stops. ‘I forget the rest.’")}
{tap_seen: {t("刚才那个池子是湿的。", "That basin was wet just now.")} #voice:insight}
{ tap_seen:
    ~ fear += 10
}
{t("你看了一眼手机。8:59。", "You glance at your phone. 8:59.")}
{t("该下课了。走廊里该有脚步声了。", "Study should be over. There should be footsteps in the corridor by now.")}
{t("没有。", "There are none.")}
-> story_knock

=== story_knock ===
{Nm(xin)}{t("最后一个。", " go{es(xin)} last.")}
{t("“咱们楼从来不查寝,对吧。”", "‘Nobody ever checks the rooms in this building, right.’")}
{t("“对。”", "‘Right.’")}
{t("“学长说,就因为不查寝。所以熄灯以后要是有人敲门,问屋里几个人——”", "‘A senior told me that's exactly why. If someone knocks after lights-out and asks how many people are in the room—’")}
{t("敲门声。三下。不急,也不轻。", "A knock. Three times. Not hurried, not soft.")}
{t("门外的声音像隔着很多层东西:几个人?", "The voice outside sounds as if it comes through many layers of something: how many of you?")}
{t("你又看了一眼手机。8:59。", "You look at your phone again. 8:59.")}
{reason >= 3: {t("现在不可能有人查寝。", "Nobody could be checking rooms now.")} #voice:reason}
{insight >= 4: {t("敲的是门板正中间。不是门把手那边。", "The knock came from the middle of the door. Not from the handle side.")} #voice:insight}
{strength >= 5: {t("顶住门。", "Brace the door.")} #voice:strength}
* [{t("答:四个", "Answer: four")}]
    ~ answered = "four"
    {t("你说了四个。门外没有再问。", "You say four. Outside, nothing more is asked.")}
    -> after_knock
* [{t("答:三个", "Answer: three")}]
    ~ answered = "three"
    {t("你说了三个。屋里有人倒抽了一口气,你不知道是谁。", "You say three. Someone in the room draws a breath, and you do not know who.")}
    ~ fear += 10
    -> after_knock
* [{t("不答,示意大家别出声", "Say nothing. Signal everyone to keep quiet.")}]
    ~ answered = "none"
    {t("没有人出声。门外的声音等了一会儿。然后又问了一遍:几个人?", "Nobody makes a sound. The voice outside waits a while. Then it asks again: how many of you?")}
    ~ fear += 10
    ~ scare(yi, 10)
    -> after_knock
* [{t("开门", "Open the door")}]
    ~ answered = "open"
    {t("你开了门。走廊里没有人。走廊里也没有灯。", "You open the door. There is nobody in the corridor. There is no light in the corridor either.")}
    ~ fear += 20
    -> after_knock

=== after_knock ===
{t("门外安静了。", "Outside, it is quiet.")}
{t("安静得不像一栋刚下课的楼。", "Quiet the way a building that just let out its students is not.")}
{t("(第一场到这里。后面还没写。)", "(End of scene one. The rest is not written yet.)")}
-> END
