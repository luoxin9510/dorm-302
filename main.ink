// 302 — main story. Text is {t("中文", "English")}; ids and identifiers are English.
// The player is always Xin ("你"); Yanbo, Zhiyong and Yi are companions. The engine file is
// generated from game.md. Scene 1 (dusk to the knock) is a draft to play and rewrite.
INCLUDE _engine.ink
INCLUDE scene3.ink

// Items (LIST items, VAR inv) are declared in game.md and come in through _engine.ink.

// What the player has seen or done (the later scenes read these).
VAR clue_frame = false   // counted the doors in the frozen movie frame
VAR tap_seen = false     // saw the wet basin in the water room
VAR window_open = false  // opened the window a crack
VAR knife_known = false  // remembered what is at the back of the wardrobe
VAR bag_heavy = false    // noticed Zhiyong's bag has something heavy in it
VAR answered = ""        // what was said through the door: four / three / who / none / open
VAR looked = 0           // places poked around in the room before the film (a knot's own loop does not count as a visit)

// Scene 2 (after the knock): how the room was lit, what the answer did, what was seen.
VAR light = ""           // on (big light) / torch (phone) / wait (stayed dark, the corridor lit up)
VAR marked = false       // the building has noticed 302 (big light on, or the door was opened)
VAR erased = ""          // companion whose place the room cleared at the knock ("" or yi): he stays, his things do not
VAR hidden = ""          // companion the building does not know about (answered three: yi)
VAR fifth = false        // a fifth person is in the room and the others say he was always there
VAR counted = false      // the headcount after the knock has happened
VAR seen_window = false  // the window reflects the corridor, not the room
VAR seen_clock = false   // the wall clock stuck at 8:59
VAR seen_uniform = false // five uniforms on the balcony line
VAR seen_screen = false  // the dead laptop showing the frozen frame
VAR doors = 0            // doors counted in the corridor
VAR shone = 0            // things the torch was pointed at

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
{t("操场那边的喇叭放了晚自习的铃,放完以后整栋楼都是拖鞋声。啪嗒啪嗒,门一扇一扇关,楼梯间里有人喊“等我一下”。", "The loudspeaker over by the sports ground plays the evening-study bell, and after it the whole building is slippers. Slap slap, doors banging shut one after another, someone in the stairwell shouting ‘wait for me’.")}
{t("两分钟,没声了。", "Two minutes, and it's gone.")}
{t("302 没动。志勇和怡是来串门的,一串就串过了点,现在下楼正好撞上宿管阿姨。", "302 doesn't move. Zhiyong and Yi came over after class and lost track of time, and going down now means walking straight into the warden.")}
{t("志勇把门反锁了,啧了一声:“都别说话。阿姨要是上来,寄。”", "Zhiyong locks the door and clicks his tongue. ‘Nobody talk. If the warden comes up, we're done.’")}
{t("烟波去够大灯开关,手停在半空,又拿回来。“开灯楼下看得见。你想让阿姨拿手电上来照脸?”", "Yanbo reaches for the big light, stops halfway, pulls the hand back. ‘They'd see it from downstairs. You want her up here with a torch in your face?’")}
{t("于是黑着。窗帘没拉,对面教学楼一排一排的灯亮着,照得屋里的东西都有一层灰蓝的边。", "So it stays dark. The curtains are open, and the teaching block across the way is lit floor by floor, giving everything in the room a grey-blue edge.")}
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
-> settle

// Poking around the dark room before the film: items and small talk.
=== settle ===
{
    - looked == 0:
        {t("烟波在翻笔记本的充电线,一时半会儿翻不出来。黑着没事干。", "Yanbo is digging for the laptop charger and not finding it. Nothing to do in the dark.")}
    - looked < 3:
        {t("烟波还在翻。", "Yanbo's still digging.")}
    - else:
        {t("烟波翻到充电线了,在等你。", "Yanbo's found the charger and is waiting on you.")}
}
~ looked += 1
* [{t("翻自己的衣柜", "Go through your own wardrobe")}]
    {t("你摸黑拉开衣柜。最上面是一袋辣椒面和花椒,上次打火锅剩的,你顺手揣兜里。", "You open the wardrobe by feel. On top is a bag of chilli powder and Sichuan pepper, left over from the last hotpot. It goes in your pocket.")}
    ~ inv += pepper
    {t("衣柜最里面还有一样东西,用毛巾裹着。你知道是什么。现在不用拿。", "There's one more thing at the very back, wrapped in a towel. You know what it is. No need for it now.")}
    ~ knife_known = true
    {t("志勇:“你翻什么呢。”“找吃的。”", "Zhiyong: ‘What are you rummaging for.’ ‘Food.’")}
    -> settle
* [{t("去烟波床上找东西", "Look through Yanbo's bed")}]
    {t("烟波的床是一个地形。脏衣服堆成山,山脚下两个哑铃,蛋白粉罐子空了三个。", "Yanbo's bed is a landscape. Dirty clothes piled into hills, two dumbbells at the foot, three empty protein tubs.")}
    {t("你从衣服堆里抽出一根弹力带。“这个借我。”", "You pull a resistance band out of the pile. ‘Borrowing this.’")}
    {t("烟波头都没抬:“别拉断。”", "Yanbo doesn't look up. ‘Don't snap it.’")}
    ~ inv += band
    {t("怡:“……有一说一,这床上有东西在长。”", "Yi: ‘...Honestly, something is growing on that bed.’")}
    -> settle
* [{t("问怡要充电宝", "Ask Yi for the power bank")}]
    {t("怡从包里掏出充电宝,顺手把草稿本也掏出来了,上面全是数。“充电宝满的。本子……也给你吧,记东西。”", "Yi fishes the power bank out of his bag, and the maths notebook comes out with it, pages of numbers. ‘Bank's full. You can have the notebook too... for writing things down.’")}
    ~ inv += bank
    ~ inv += notebook
    {t("“你这本子上写的什么。”", "‘What's all this in here.’")}
    {t("“……规律。”", "‘...Patterns.’")}
    ~ trust(yi, 5)
    -> settle
* [{t("翻志勇的书包", "Go through Zhiyong's bag")} #check:insight:normal]
    {t("你刚碰到拉链,志勇的手就按上来了。“别动我包。”", "Your fingers get as far as the zip before Zhiyong's hand lands on it. ‘Leave my bag.’")}
    { check("insight", 10) >= 3:
        {t("包比三本书该有的重。你没说。", "The bag is heavier than three textbooks should be. You don't say so.")}
        ~ bag_heavy = true
    - else:
        {t("“紧张什么。”“没紧张。”", "‘Why so jumpy.’ ‘I'm not.’")}
        ~ scare(zhiyong, 5)
    }
    ~ trust(zhiyong, -5)
    -> settle
* [{t("去阳台", "Go out on the balcony")}]
    {t("阳台上晾着四个人的校服,风一吹全往一个方向摆。楼下宿管阿姨的窗户亮着,电视声隔着两层楼飘上来。", "Four sets of school uniform hang on the balcony, all swinging the same way in the wind. Downstairs the warden's window is lit, and her television drifts up two floors.")}
    {t("你把晾衣杆摘下来拿进屋。“干什么?”“顺手。”", "You unhook the clothes pole and bring it in. ‘What's that for?’ ‘Just in case.’")}
    ~ inv += pole
    ~ window_open = true
    {t("风从阳台门进来,袜子味淡了一点。", "Air comes in through the balcony door. The sock smell thins out a bit.")}
    -> settle
+ [{t("看片", "Watch the film")}]
    -> movie

=== movie ===
{t("烟波找到充电线了,插上。屏幕亮起来,一层指纹。", "Yanbo finds the charger and plugs in. The screen comes on, a sheet of fingerprints.")}
{t("“看片。”", "‘Film.’")}
{t("“看哪个?”", "‘Which one?’")}
{t("“你拷我硬盘里那个。日本的。”", "‘The one you copied onto my drive. The Japanese one.’")}
{t("志勇:“不看恐怖片。”", "Zhiyong: ‘No horror.’")}
{t("“《第七扇门》,九八年的,VHS 转的,我看过八遍了,不吓人。”", "‘The Seventh Door. Ninety-eight. Ripped off a VHS. I've seen it eight times, it's not scary.’")}
{t("“你看过八遍你看,我不看。”", "‘You've seen it eight times, you watch it. I'm not.’")}
{t("“你一米九你怕什么。”", "‘You're one ninety. What are you scared of.’")}
{t("“一米九跟这有什么关系。”他把椅子转过去,背对屏幕。过了一分钟,又转回来一半。", "‘What's one ninety got to do with it.’ He turns the chair round, back to the screen. A minute later it's turned halfway back.")}
{t("片子开始了。画面右下角有一串跳动的时间码,画质糊得像隔着水,颜色偏绿。一个穿校服的女生半夜走在学校的走廊上,一边走一边数门。她穿拖鞋,啪嗒,啪嗒。", "The film starts. A timecode ticks in the bottom corner, the picture smeared like it's underwater, everything tinted green. A girl in school uniform walks down a school corridor at night, counting doors as she goes. She's wearing slippers. Slap. Slap.")}
{t("“导演就拍了这一部。”你说,“后来人没了。”", "‘The director only ever made this one,’ you say. ‘Then he disappeared.’")}
{t("志勇:“你能不能别说话。”", "Zhiyong: ‘Can you not.’")}
{t("烟波:“这镜头是故意的,一直不给她的脸。”", "Yanbo: ‘The shot's deliberate. It never gives you her face.’")}
{t("怡:“……等等。她为什么要数门?”", "Yi: ‘...Wait. Why is she counting doors?’")}
{t("“你看就完了。”", "‘Just watch.’")}
{t("“不是,我是说从逻辑上——”", "‘No, I mean logically—’")}
{t("“怡。看就完了。”", "‘Yi. Just watch.’")}
{t("片子里的走廊尽头有一个绿色的安全出口灯。窗户外面是黑的,什么都没有。", "At the end of the corridor in the film there's a green exit light. The windows are black. Nothing outside them.")}
{t("楼下阿姨的电视换台了,新闻联播的开头曲从楼板底下钻上来。七点了。", "Downstairs the warden changes channel. The evening news theme comes up through the floor. Seven o'clock.")}
{t("志勇从椅背上面看了一眼。“这走廊——”没说完。", "Zhiyong looks over the back of the chair. ‘That corridor—’ He doesn't finish.")}
{t("“这走廊怎么了?”", "‘What about the corridor?’")}
{t("“没事。”", "‘Nothing.’")}
{t("女生数到第七扇门,停下了。镜头终于转过来,要给她的脸——", "The girl gets to the seventh door and stops. The camera finally starts to come round, to give you her face—")}
{t("画面定住了。笔记本的电池灯闪了两下,黑了。", "The picture freezes. The laptop's battery light blinks twice and goes out.")} #fx:dark
{t("“卧槽。”你说。", "‘Oh, come on,’ you say.")}
{t("烟波拔下充电线看了看,插头是好的。“线接着的。”", "Yanbo pulls the charger out and looks at it. The plug's fine. ‘It was plugged in.’")}
{t("“那它怎么没电。”", "‘Then how is it dead.’")}
{t("“我怎么知道。”", "‘How should I know.’")}
{inv ? bank: {t("怡:“充电宝插上试试。”插上。没反应。“……接口不对。”烟波:“典。”", "Yi: ‘Try the power bank.’ It goes in. Nothing. ‘...Wrong port.’ Yanbo: ‘Classic.’")}}
* [{t("盯着定住的那一帧", "Stare at the frozen frame")} #check:insight:easy]
    { check("insight", 8) >= 3:
        {t("黑屏之前你数了一遍。那条走廊不是七扇门。八扇。最后那扇比别的矮一点。你没说。", "You counted before the screen went black. That corridor doesn't have seven doors. It has eight, and the last one is a little shorter than the rest. You don't say so.")}
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
* [{t("再按一下电源键", "Try the power button again")}]
    {t("你按了三下。第三下的时候屏幕闪了一下,白的,像照相。然后彻底黑了。", "You press it three times. On the third the screen flashes once, white, like a camera. Then it's dead for good.")} #fx:flash
    {t("怡:“……刚才那个是什么?”", "Yi: ‘...What was that?’")}
    {t("没人回答。", "Nobody answers.")}
    ~ fear += 5
    ~ scare(yi, 5)
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
{t("正好这时候,水房那边哗的一声。像有人拧开龙头,又关上。水管在墙里面响了一阵,停了。", "Right then, from the water room: a rush of water. Like someone opening a tap and shutting it again. The pipe knocks inside the wall for a while, then stops.")}
{t("没人说话。楼下的电视声还在。", "Nobody says anything. The television downstairs is still going.")}
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
* [{t("让志勇去看", "Send Zhiyong to look")} #check:charm:normal]
    { check("charm", 10) >= 3:
        {t("“你去。你一米九。”", "‘You go. You're one ninety.’")}
        {t("志勇骂了一句,还是去了。回来的时候脸上没表情。“龙头关着的。”", "Zhiyong swears, and goes anyway. When he comes back there's nothing on his face. ‘Tap's off.’")}
        ~ scare(zhiyong, 10)
        ~ trust(zhiyong, 5)
    - else:
        {t("“你去。你一米九。”", "‘You go. You're one ninety.’")}
        {t("“你想啥呢。你的鼻子你去。”", "‘What are you on about. Your nose, you go.’")}
        {t("没人去。", "Nobody goes.")}
        ~ trust(zhiyong, -5)
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
{clue_frame: {t("片子里那条走廊,就是八扇。最后那扇矮一点。", "The corridor in the film. Eight. The last one shorter.")} #voice:insight}
{t("阳台上的校服在风里摆。楼下的电视在放广告。", "The uniforms swing on the balcony. The television downstairs is on adverts.")}
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
* [{t("去数一数门", "Go and count the doors")} #check:stamina:normal]
    {t("“我去数。”", "‘I'll go count.’")}
    {t("“你有病吧。”志勇说。你已经开门了。", "‘Are you ill,’ Zhiyong says. You're already at the door.")}
    ~ battery -= 10
    { check("stamina", 10) >= 3:
        {t("走廊黑的。你从这头走到那头,手电照着门牌。301,302,303,304,305,306,307。七扇。你没回头,直接走回来。", "The corridor's dark. You walk it end to end with the torch on the door numbers. 301, 302, 303, 304, 305, 306, 307. Seven. You don't look back. You walk straight back.")}
        ~ fear += 5
        ~ trust(zhiyong, 5)
    - else:
        {t("走廊黑的。你数到 305 的时候手电晃了一下,你就回来了。没数完。", "The corridor's dark. At 305 the torch wobbles and you turn back. You didn't finish.")}
        ~ fear += 15
    }
    {t("“几扇?”烟波问。", "‘How many?’ Yanbo asks.")}
    {t("“七扇。”你说。你也不知道算不算数。", "‘Seven,’ you say. You're not sure it counts.")}
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
{t("走廊里该有脚步声了。楼梯间该有人喊了。", "There should be footsteps in the corridor by now. Someone should be shouting in the stairwell.")}
{t("没有。", "There's nothing.")}
{t("楼下的电视声不知道什么时候停的。", "The television downstairs stopped at some point. None of you noticed when.")}
{t("志勇看了眼自己的手机。“23%。”", "Zhiyong looks at his own phone. ‘Twenty-three percent.’")}
{t("没人接话。", "Nobody picks that up.")}
{inv ? bank: {t("“我这有充电宝。”你说。“接口对吗。”“……手机的,对。”", "‘I've got the power bank,’ you say. ‘Right port this time?’ ‘...It's a phone one. Yes.’")}}
-> story_knock

=== story_knock ===
{t("你最后一个。四个人里只有你讲得起劲。", "You go last, the only one of the four who's enjoying this.")}
{t("“阿姨从来不上来,这个你们知道。”", "‘The warden never comes up. You all know that.’")}
{t("“嗯。”", "‘Mm.’")}
{t("“但是学长说,有一年上来过一次。熄灯以后。敲门,问屋里几个人。”", "‘But a senior told me she did once. After lights-out. A knock, and she asks how many in the room.’")}
{t("“那屋四个人,答了四个。门外说:不对。五个。”", "‘Four in that room. They said four. From outside: wrong. Five.’")}
{t("怡:“……等等。”", "Yi: ‘...Wait.’")}
{t("“后来那屋就剩三个了。”", "‘After that there were three in that room.’")}
{t("志勇:“你编的。”", "Zhiyong: ‘You made that up.’")}
{t("“学长说的!”", "‘The senior said it!’")}
{t("敲门。三下。", "A knock. Three times.")} #fx:shake
{t("门外:“几个人?”", "Outside the door: ‘How many of you?’")}
{t("不是阿姨的声音。你说不上来是谁的声音。", "Not the warden's voice. You couldn't say whose.")}
{t("志勇已经站起来了,攥着拳头,挡在门和你们中间。没动。", "Zhiyong is already up, fists closed, between the door and the rest of you. Not moving.")}
{t("怡小声:“……现在几点?”", "Yi, quietly: ‘...What time is it?’")}
{t("你看手机。8:59。", "You check your phone. 8:59.")}
{reason >= 3: {t("阿姨不上来。谁都不上来。", "The warden doesn't come up. Nobody comes up.")} #voice:reason}
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
* [{t("问回去:你谁啊", "Ask back: who's that")}]
    ~ answered = "who"
    {t("“你谁啊?”", "‘Who's that?’")}
    {t("门外安静了一下。然后又问了一遍,一个字一个字的:几、个、人?", "A pause outside. Then it asks again, one word at a time: how. Many. Of you?")}
    ~ fear += 10
    ~ scare(yi, 10)
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
{t("安静得不像一栋刚下课的楼。水管不响了,阳台上的校服也不摆了。", "Not the kind of quiet a building has just after study lets out. The pipes have stopped. The uniforms on the balcony have stopped swinging.")}
{t("怡小声:“我倾向于……先排除一下是不是阿姨。”", "Yi, quietly: ‘I'd lean towards... ruling out the warden first.’")}
{t("“阿姨不上来。”烟波说。", "‘She doesn't come up,’ Yanbo says.")}
{t("“……我知道。”", "‘...I know.’")}
{t("没人接话。", "Nobody answers.")}
// What the answer did. Nobody can see it yet.
{ answered == "four":
    ~ erased = "yi"
}
{ answered == "three":
    ~ hidden = "yi"
}
{ answered == "who" || answered == "none":
    ~ fifth = true
}
{ answered == "open":
    ~ marked = true
}
-> light_choice

// --- scene 2: the light -----------------------------------------------------

=== light_choice ===
{t("志勇站起来,摸着墙往门边走。你知道他要干什么,大灯开关就在门边上。", "Zhiyong gets up and feels his way along the wall towards the door. You know what he's after. The switch for the big light is right by the door.")}
{t("“别开。”烟波说。", "‘Don't,’ Yanbo says.")}
{t("“黑着我待不下去了。”志勇的声音不对,有点高。“要看就看清楚。”", "‘I can't sit in the dark any more.’ Zhiyong's voice is off, pitched high. ‘If we're going to look, look properly.’")}
{t("“开了楼下就看得见。”", "‘Turn it on and they see us from downstairs.’")}
{t("“楼下还有人吗?”", "‘Is there anyone downstairs?’")}
{t("没人答得上来。志勇的手已经在墙上找到开关了,你听见指甲刮过塑料的声音。", "Nobody has an answer. Zhiyong's hand has found the switch; you hear a fingernail scrape plastic.")}
{reason >= 3: {t("开了灯就知道了。不开,也拖不过今晚。", "Turn it on and you'll know. Leave it off and you still won't get through the night.")} #voice:reason}
{insight >= 4: {t("门缝底下一点光都没有。刚才还有一点。", "Not a trace of light under the door. There was some a minute ago.")} #voice:insight}
* [{t("抢先一步,自己按下开关", "Get there first and hit the switch yourself")}]
    ~ light = "on"
    ~ marked = true
    {t("你从他胳膊底下伸过去,按了。要开也是你开。", "You reach under his arm and press it. If anyone turns it on, it's you.")}
    ~ trust(zhiyong, 5)
    -> lit
* [{t("“开吧。”让志勇按", "‘Go on.’ Let Zhiyong press it")}]
    ~ light = "on"
    ~ marked = true
    {t("“开吧。”你说。志勇按了。", "‘Go on,’ you say. Zhiyong presses it.")}
    ~ scare(zhiyong, -5)
    -> lit
* [{t("拉住他的手腕,打开手机电筒", "Grab his wrist and turn on your phone torch")}]
    ~ light = "torch"
    {t("你抓住他手腕。“别开大灯。用这个。”手机电筒亮了,白得刺眼,照在志勇脸上。他眯着眼看你,没甩开。", "You catch his wrist. ‘Not the big light. Use this.’ The phone torch comes on, white and harsh, straight in Zhiyong's face. He squints at you and doesn't shake you off.")}
    ~ battery = clamp(battery - 5, 0, 100)
    ~ trust(zhiyong, 5)
    -> torch
* [{t("“谁都别动。先听。”", "‘Nobody move. Listen first.’")}]
    ~ light = "wait"
    {t("“谁都别动。”你说,“先听。”", "‘Nobody move,’ you say. ‘Listen first.’")}
    {t("志勇的手停在开关上。没按。", "Zhiyong's hand stays on the switch. Doesn't press.")}
    -> wait

// The big light: everything at once.
=== lit ===
{t("灯亮了。", "The light comes on.")} #fx:flash
{t("日光灯闪了两下才稳住,屋里一下子全白了:辣条袋子、烟波床上的衣服山、床边一双鞋。", "The fluorescent tube flickers twice before it holds, and the room goes white all at once: the spicy-strip bag, the clothes pile on Yanbo's bed, a pair of shoes by the bed.")}
-> headcount ->
{t("然后你看见窗户。", "Then you see the window.")}
{t("对面教学楼的灯没了。一盏都没有。窗玻璃黑得像墙,玻璃里映着一屋子人,还有……", "The teaching block's lights are gone. Not one left. The glass is black as a wall, and in it a room full of people, and...")}
{t("映出来的不是这间屋子。是走廊。你们站在一条走廊里,身后一排门。", "It isn't this room in the glass. It's the corridor. You're all standing in a corridor, a row of doors behind you.")}
~ seen_window = true
~ fear += 10
{t("“别看窗户。”烟波说。他自己也在看。", "‘Don't look at the window,’ Yanbo says. He's looking too.")}
{t("墙上的钟,8:59。秒针在 12 上面抖,过不去。", "The clock on the wall: 8:59. The second hand shivers at the 12 and can't get past.")}
~ seen_clock = true
{t("桌上那台没电的笔记本,屏幕亮着。停在那一帧:走廊,尽头绿色的安全出口灯,最后那扇门矮一点。", "The dead laptop on the desk has its screen on. Frozen on that frame: the corridor, the green exit sign at the end, the last door a little lower than the others.")}
~ seen_screen = true
{clue_frame: {t("八扇。你数过。", "Eight. You counted.")} #voice:insight}
{t("阳台上的校服还在。你数了一遍。五件。", "The uniforms are still on the balcony line. You count. Five.")}
{window_open: {t("刚才你出去拿晾衣杆的时候是四件。", "When you went out for the pole there were four.")}}
~ seen_uniform = true
~ fear += 5
~ scare(yi, 10)
~ scare(zhiyong, 10)
~ scare(yanbo, 5)
{t("“楼外看得见了。”烟波说。没人问看得见什么。", "‘Now it can be seen from outside,’ Yanbo says. Nobody asks by what.")}
-> corridor

// The phone torch: one circle of light at a time.
=== torch ===
{
    - shone == 0:
        {t("电筒的光一小圈,照到哪儿哪儿是白的,别的地方更黑。", "The torch is one small circle. Wherever it lands goes white; everywhere else gets darker.")}
    - shone < 3:
        {t("电量 {battery}%。", "Battery {battery}%.")}
    - else:
        {t("志勇:“差不多了吧。”", "Zhiyong: ‘That's enough, isn't it.’")}
}
~ shone += 1
* [{t("照一圈人", "Shine it round at everyone")}]
    ~ battery = clamp(battery - 5, 0, 100)
    -> headcount ->
    -> torch
* [{t("照窗户", "Shine it at the window")} #check:insight:easy]
    ~ battery = clamp(battery - 5, 0, 100)
    {t("光打在玻璃上,反回来一个白点。", "The beam hits the glass and comes back as a white spot.")}
    { check("insight", 8) >= 3:
        {t("白点后面,对面教学楼一盏灯都没有。玻璃里映出来的东西,你看了两遍才明白:不是这间屋子。是走廊,一排门。", "Behind the spot, not one light in the teaching block. What the glass reflects takes you two looks: not this room. A corridor, a row of doors.")}
        ~ seen_window = true
        ~ fear += 10
    - else:
        {t("光太晃,你只看见自己举着手机的影子。", "Too much glare; all you see is your own shadow holding the phone.")}
        ~ fear += 5
    }
    -> torch
* [{t("照墙上的钟", "Shine it at the clock")}]
    ~ battery = clamp(battery - 5, 0, 100)
    {t("8:59。秒针在 12 上面抖,过不去。", "8:59. The second hand shivers at the 12 and can't get past.")}
    ~ seen_clock = true
    {t("怡:“……它一直是这个时间?”“手机也是。”", "Yi: ‘...Has it said that the whole time?’ ‘Phone says the same.’")}
    ~ fear += 5
    -> torch
* [{t("照阳台", "Shine it at the balcony")} #check:insight:normal]
    ~ battery = clamp(battery - 5, 0, 100)
    {t("光穿过阳台门,照在晾衣绳上。校服在光里一动不动。", "The beam goes through the balcony door onto the line. The uniforms hang dead still in it.")}
    { check("insight", 10) >= 3:
        {t("你数了一遍。五件。", "You count. Five.")}
        {window_open: {t("刚才是四件。你出去拿晾衣杆的时候数过。", "There were four. You counted when you went out for the pole.")}}
        ~ seen_uniform = true
        ~ fear += 10
    - else:
        {t("数到一半光晃了一下,你没数清,也不想再数一遍。", "Halfway through the count the beam wavers and you lose it. You don't want to count again.")}
        ~ fear += 5
    }
    -> torch
* [{t("照桌上的笔记本", "Shine it at the laptop")}]
    ~ battery = clamp(battery - 5, 0, 100)
    {t("不用照。屏幕自己亮着。停在那一帧:走廊,尽头绿色的安全出口灯,最后那扇门矮一点。", "No need. The screen is on by itself. Frozen on that frame: the corridor, the green exit sign at the end, the last door a little lower.")}
    ~ seen_screen = true
    {clue_frame: {t("八扇。你数过。", "Eight. You counted.")} #voice:insight}
    {t("烟波伸手合上了它。光从盖子缝里漏出来。", "Yanbo reaches over and closes the lid. Light leaks out of the gap.")}
    ~ fear += 5
    -> torch
+ [{t("去门口", "Go to the door")}]
    -> corridor

// Staying dark: the building moves first.
=== wait ===
{t("黑着。谁都没动。", "Dark. Nobody moves.")}
{t("你听见自己的呼吸,听见志勇抖腿,听见怡吞了一口口水。", "You hear your own breathing, Zhiyong's leg jiggling, Yi swallowing.")}
{t("楼里什么声音都没有。没有水管,没有电视,没有拖鞋。", "The building makes no sound at all. No pipes, no television, no slippers.")}
{t("然后门缝底下亮了。", "Then the gap under the door lights up.")}
{t("一条黄绿色的光,从门底下进来,躺在地板上。走廊灯亮了。", "A strip of yellow-green light comes in under the door and lies on the floor. The corridor light is on.")}
~ fear += 10
~ scare(yi, 10)
~ scare(zhiyong, 10)
~ scare(yanbo, 10)
{insight >= 4: {t("晚自习的时候走廊灯是不灭的。现在是晚自习吗。", "The corridor light never goes off during evening study. Is it evening study now.")} #voice:insight}
{t("志勇的手还在开关上。“开不开。”", "Zhiyong's hand is still on the switch. ‘On or not.’")}
{t("“不开。”烟波说,“外面亮了,里面别亮。”", "‘Not,’ Yanbo says. ‘It's lit out there. Keep it dark in here.’")}
-> headcount ->
{t("地板上那条光一直在。没人去踩它。", "The strip of light stays on the floor. Nobody steps on it.")}
-> corridor

// Who is in the room now. A tunnel: the caller goes on from where it was.
=== headcount ===
~ counted = true
{
    - erased == "yi":
        { light == "wait":
            {t("“都在吧?”你小声问。“在。”志勇。“在。”烟波。慢半拍,“在。”怡。", "‘Everyone here?’ you ask under your breath. ‘Here.’ Zhiyong. ‘Here.’ Yanbo. Half a beat late: ‘Here.’ Yi.")}
            {t("四个。你松了一口气,没松完。", "Four. You let out a breath, not all of it.")}
            {t("黑暗里怡在床边摸来摸去。“……我包呢。”又摸。“我鞋呢。”", "In the dark Yi pats around by the bed. ‘...Where's my bag.’ More patting. ‘Where are my shoes.’")}
            {t("你伸手过去。床边的地板是空的。他坐过的地方,被子平平整整,像没人坐过。", "You reach over. The floor by the bed is bare. Where he sat, the quilt lies smooth, as if nobody ever had.")}
        - else:
            {t("怡就站在你床边,手里攥着手机,人好好的。脚上只有袜子。", "Yi is standing right by your bed, phone clutched in his hand, all in one piece. Socks, no shoes.")}
            {t("他的鞋没了。椅背上的外套没了,桌上那杯水没了,包也没了。你床上他坐出来的坑,平了。", "His shoes are gone. The jacket on the chair back is gone, the cup of water on the desk, the bag. The dent he sat into your quilt has smoothed out.")}
            {t("屋里没有一样东西说他来过。", "Nothing in the room says he was ever here.")}
            {t("怡低头看自己的脚,说得很轻:“我没走。”", "Yi looks down at his feet. Very quietly: ‘I didn't leave.’")}
        }
        {t("门外说五个。你答了四个。屋里是四个,一个不少。可这屋已经把他送走了。", "Outside said five. You said four. Four in the room, nobody missing. But the room has already seen him out.")}
        {inv ? bank: {t("充电宝还在你兜里。他带来的东西,就剩你手里这几样。", "The power bank is still in your pocket. Of what he brought, only what's in your hands is left.")}}
        ~ fear += 20
        ~ scare(yi, 25)
        ~ scare(zhiyong, 10)
        ~ scare(yanbo, 10)
        {t("志勇:“谁他妈动他东西了。”没人答。", "Zhiyong: ‘Who the fuck touched his stuff.’ Nobody answers.")}
        {reason >= 3: {t("楼下登记本。今晚来 302 的,写的谁。", "The visitors' book downstairs. Who's written in for 302 tonight.")} #voice:reason}
    - fifth:
        { light == "wait":
            {t("“都在吧?”你小声问。“在。”志勇。“在。”烟波。“在。”怡。", "‘Everyone here?’ you ask under your breath. ‘Here.’ Zhiyong. ‘Here.’ Yanbo. ‘Here.’ Yi.")}
            {t("“在。”", "‘Here.’")}
            {t("第五个声音。从烟波床那边来的,很近。", "A fifth voice. From over by Yanbo's bed, close.")}
            {t("没有人问那是谁。", "Nobody asks who that is.")}
        - else:
            {t("烟波床上的衣服堆里坐着一个人。校服,短头发,低着头看地。", "Someone is sitting in the clothes pile on Yanbo's bed. School uniform, cropped hair, looking at the floor.")}
            {t("你不认识他。", "You don't know him.")}
            {t("“阿泽你别坐那儿,”志勇说,“那床上有东西在长。”", "‘Aze, don't sit there,’ Zhiyong says. ‘Something's growing on that bed.’")}
            {t("“……谁?”", "‘...Who?’")}
            {t("烟波看你一眼:“阿泽啊。你傻了?”", "Yanbo gives you a look. ‘Aze. Have you lost it?’")}
            {t("那个人没抬头。", "He doesn't look up.")}
        }
        {t("门外说五个。现在五个了。", "Outside said five. Now there are five.")} #fx:pulse
        ~ fear += 25
        {insight >= 4: {t("另外三个人谁也没觉得不对。只有你记得屋里本来几个人。", "None of the other three think anything is wrong. Only you remember how many there were.")} #voice:insight}
    - hidden == "yi":
        {t("四个人,一个不少。", "Four. Nobody missing.")}
        {t("怡坐在你床上,两只手夹在膝盖中间。“刚才你说三个的时候,”他说得很慢,“我有一种……被跳过去的感觉。像点名点到我,没停。”", "Yi sits on your bed with his hands pressed between his knees. ‘When you said three,’ he says slowly, ‘I had this... feeling of being skipped. Like roll call got to me and didn't stop.’")}
        {t("“什么意思。”", "‘Meaning what.’")}
        {t("“不知道。先排除一下是我多想。”", "‘I don't know. Let's rule out that I'm imagining it.’")}
        ~ fear += 5
        ~ scare(yi, 10)
        {reason >= 3: {t("它数的是三个。它不知道第四个是谁。", "It counted three. It doesn't know who the fourth is.")} #voice:reason}
    - else:
        {t("四个人,一个不少。志勇、烟波、怡。都在。", "Four. Nobody missing. Zhiyong, Yanbo, Yi. All here.")}
        { answered == "open":
            {t("可是你开过门了。走廊看见你们了。", "But you opened the door. The corridor has seen you.")}
            ~ fear += 5
        }
}
->->

// The corridor: counting the doors. End of scene two.
=== corridor ===
{ not counted:
    -> headcount ->
}
{t("{fifth:五|四}个人挤在门边。志勇拧开反锁,把门拉开一条缝。", "{fifth:Five|Four} of you bunch up at the door. Zhiyong turns the lock and pulls it open a crack.")}
{ light == "wait":
    {t("门缝里的光一下子宽了。", "The strip of light widens all at once.")}
- else:
    {t("走廊里的灯亮着。刚才门底下明明一点光都没有。", "The corridor lights are on. A minute ago there was no light under the door at all.")}
}
{t("黄绿色的日光灯,一根接一根,照到走廊尽头。尽头一个绿色的安全出口灯。", "Yellow-green tubes, one after another, all the way down. A green exit sign at the end.")}
{t("没有人。没有声音。每扇门都关着。", "Nobody. No sound. Every door shut.")}
{t("你数门。", "You count the doors.")}
{t("三〇一。三〇二,你们的。三〇三,封条还在。三〇四。三〇五。三〇六。三〇七。", "301. 302, yours. 303, the seal still on it. 304. 305. 306. 307.")}
{t("走廊尽头,安全出口灯底下,还有一扇。矮一点。门上没有牌子。", "At the end, under the exit sign, one more. A little lower. No number on it.")}
{t("第八扇。", "The eighth.")}
~ doors = 8
~ fear += 10
{clue_frame: {t("片子里那条走廊。你现在站在门口。", "The corridor from the film. You're standing at the mouth of it.")} #voice:insight}
{t("“白天是七扇。”烟波说。他讲的故事。他的声音也不对了。", "‘Seven in the daytime,’ Yanbo says. His story. His voice isn't right either.")}
{ erased == "yi":
    {t("怡:“……我倾向于先回屋。”停了一下。“……如果它还让我进。”", "Yi: ‘...I'd lean towards going back in first.’ A pause. ‘...If it still lets me in.’")}
- else:
    {t("怡:“……我倾向于先回屋。”", "Yi: ‘...I'd lean towards going back in first.’")}
}
{ fifth:
    {t("“阿泽,进来。”志勇说。那个人进来了。", "‘Aze, get in,’ Zhiyong says. He comes in.")}
}
{t("志勇把门关上,反锁。锁舌咔哒一声。", "Zhiyong shuts the door and locks it. The bolt clicks.")}
{t("8:59。手机没信号。", "8:59. No signal.")}
{ marked:
    {t("门缝底下那条光闪了一下。像有什么从底下走过去。", "The light under the door flickers once. Like something passed along it.")}
}
{reason >= 3: {t("出不去了。先弄清楚这层楼要什么。", "No way out. First work out what this floor wants.")} #voice:reason}
{strength >= 5: {t("要出去,得走那条走廊。", "To get out, you walk that corridor.")} #voice:strength}
-> hub
