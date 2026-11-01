// 302 — scene three: the hub. From 302 you pick where to go; every place costs an hour
// (the `dawn` resource counts the hours left) and the corridor is on the way to everything.
// The places themselves (water room, toilet, stairs, office, 303, the eighth door) are stubs
// in this draft; the base, the corridor and the first fight are written.

VAR corridor_known = false // walked the corridor once since the knock (the first fight)
VAR it_gone = 0            // hours it stays away after being driven off
VAR momentum = 0           // its momentum in a fight; at 0 it withdraws
VAR round = 0              // fight round
VAR braced = false         // held the line this round: its next move costs no stamina
VAR weak_known = false     // seen its weakness: it has to count, and a wrong number makes it start over
VAR back = 0               // times the hub was entered (302 changes a little every time)
VAR knocked2 = false       // the second knock has happened
VAR fled = 0               // fights run from
VAR went_water = false
VAR went_toilet = false
VAR went_stairs = false
VAR went_office = false
VAR went_303 = false
VAR noticed = false        // the building took note of you (the visitors' book moved, a name written back)
VAR heater_seen = false    // the water heater by the stairs, still running after its power-off hour
VAR zy_album = false       // saw that Zhiyong photographs everything he says he isn't looking at
VAR zy_broke = 0           // Zhiyong's shell: 0 whole / 1 broke on the stairs / 2 Yanbo has said "行了" for him

// The water room: Okiku at the basin, counting; the two from 304.
VAR datou = ""             // 大头 (304): "" not met / stall (hiding) / stairs (ran for the stairs) / dead
VAR okiku = 0              // 0 not met / 1 counting at the basin / 2 released (the tenth was counted for her)
VAR count = 0              // where her count stands during the rescue (she takes someone at nine)
VAR datou_out = false      // 大头 is out of the stall
VAR held = false           // she was held off this round
VAR okiku_known = false    // seen what she counts: what is in the water, one short
VAR clue_number = false    // the old uniform in the basin: a student number inside the collar

// The warden's office.
VAR aunt_clue = false      // the duty log: "8:59 went up"
VAR ledger_seen = false    // read the visitors' book
VAR aze_known = false      // the crossed-out name, room 303, every night for years
VAR yi_written = false     // wrote Yi's name back into the book (erased branch)

// --- clock ---------------------------------------------------------------

// The phone's clock: 21:00 after the knock, one hour per place. The wall clocks stay at 8:59.
=== function clock() ===
~ temp h = 21 + (8 - dawn)
{ h >= 24:
    ~ h = h - 24
}
~ return "{h}:00"

// An hour passes: the torch burns, and whatever was driven off comes back a little.
=== function tick() ===
~ dawn = clamp(dawn - 1, 0, 8)
~ battery = clamp(battery - 5, 0, 100)
{ it_gone > 0:
    ~ it_gone -= 1
}

// Small numbers as words: it counts "三个", not "3个".
=== function num(n) ===
{
    - n == 1:
        ~ return t("一", "One")
    - n == 2:
        ~ return t("两", "Two")
    - n == 3:
        ~ return t("三", "Three")
    - n == 4:
        ~ return t("四", "Four")
    - n == 5:
        ~ return t("五", "Five")
    - n == 6:
        ~ return t("六", "Six")
    - n == 7:
        ~ return t("七", "Seven")
    - n == 8:
        ~ return t("八", "Eight")
    - n == 9:
        ~ return t("九", "Nine")
}
~ return "{n}"

// Her count, the way they hear it.
=== function jp(n) ===
{
    - n == 1:
        ~ return "いち"
    - n == 2:
        ~ return "に"
    - n == 3:
        ~ return "さん"
    - n == 4:
        ~ return "し"
    - n == 5:
        ~ return "ご"
    - n == 6:
        ~ return "ろく"
    - n == 7:
        ~ return "しち"
    - n == 8:
        ~ return "はち"
    - n == 9:
        ~ return "きゅう"
}
~ return "{n}"

=== function scare_all(d) ===
~ scare(yanbo, d)
~ scare(zhiyong, d)
~ scare(yi, d)

// --- 302, the base ------------------------------------------------------------

=== hub ===
~ back += 1
{ dawn <= 0: -> daybreak }
{
    - back == 1:
        {t("门反锁着。{fifth:五|四}个人。手机:{clock()}。墙上的钟:8:59。", "The door is bolted. {fifth:Five|Four} of you. Phone: {clock()}. Wall clock: 8:59.")}
        {t("烟波先开口:“问题是,这层楼要什么。”", "Yanbo speaks first. ‘The question is what this floor wants.’")}
        {t("“要什么都不给。”志勇。", "‘It gets nothing,’ Zhiyong.")}
        {t("“那就得出去。出去得走走廊。走一趟,去一个地方,回来——”烟波看了眼你的手机,“怎么也得一个钟头。天亮之前,走不了几个地方。”", "‘Then we get out. Getting out means the corridor. One trip, one place, back here—’ Yanbo glances at your phone, ‘—an hour, at least. Before it's light we won't get to many.’")}
        { erased == "yi":
            {t("怡坐在你床沿上,光着袜子。“……我倾向于,先去值班室。登记本。”他说得比平时快。", "Yi sits on the edge of your bed in his socks. ‘...I'd lean towards the warden's office first. The book.’ Faster than he usually talks.")}
        }
        { hidden == "yi":
            {t("怡靠着门。“它点名没点到我。”他说,“有可能……这是个办法。”", "Yi leans on the door. ‘It skipped me at roll call,’ he says. ‘Possibly... that's a way in.’")}
        }
        { fifth:
            {t("阿泽坐在烟波床沿上,看地。没人问他想去哪。", "Aze sits on the edge of Yanbo's bed, looking at the floor. Nobody asks him where he'd go.")}
        }
        {t("志勇出去阳台,把{inv ? pole:另一根|那根}晾衣杆摘下来,在手里掂了掂。“走廊我先。”", "Zhiyong goes out to the balcony, unhooks {inv ? pole:the other|the} clothes pole and weighs it in his hand. ‘I go first in the corridor.’")}
    - back == 2:
        {t("回到 302。门锁上。{clock()}。", "Back in 302. Door locked. {clock()}.")}
        {t("墙上的钟从 8:59 跳到 9:00。你看着它。它跳回 8:59。", "The wall clock ticks from 8:59 to 9:00. You watch it. It ticks back to 8:59.")}
        ~ seen_clock = true
        ~ fear += 5
    - back == 3:
        {t("回到 302。{clock()}。", "Back in 302. {clock()}.")}
        {
        - erased == "yi" and not yi_written:
            {t("门口摆着一双鞋。怡的。鞋尖朝屋里,摆得整整齐齐。怡没有去穿。", "A pair of shoes by the door. Yi's. Toes pointing into the room, set down neatly. Yi doesn't go and put them on.")}
        - erased == "yi":
            {t("门口摆着怡的鞋。鞋尖朝外,像他自己脱的。他过去穿上了。“……谢了。”", "Yi's shoes by the door. Toes pointing out, as if he'd taken them off himself. He goes and puts them on. ‘...Thanks.’")}
            ~ scare(yi, -15)
        - else:
            {t("门口多了一双鞋。谁的都不是。鞋尖朝屋里。", "There's an extra pair of shoes by the door. Nobody's. Toes pointing into the room.")}
        }
        ~ fear += 10
    - else:
        {t("回到 302。{clock()}。", "Back in 302. {clock()}.")}
        {t("窗户映着走廊。走廊里,302 的门口站着一个人,背对着你们。", "The window reflects the corridor. In it, someone stands at 302's door, back to you.")}
        {t("你回头看门。门关着。", "You look round at the door. It's shut.")}
        ~ fear += 10
}
{ back > 1 and not (marked and back >= 3):
    {t("喘口气。", "Catch your breath.")}
    ~ fear = clamp(fear - 10, 0, 100)
    ~ hp = clamp(hp + 1, 0, 10)
}
{ zy_broke == 1:
    {t("烟波看了志勇一眼。“行了。”", "Yanbo looks at Zhiyong. ‘Right.’")}
    {t("志勇没接。", "Zhiyong doesn't answer.")}
    ~ zy_broke = 2
}
{ marked and back >= 3:
    {t("没人敢喘大气。它知道这间屋。", "Nobody breathes out. It knows this room.")}
}
{ marked and back >= 2 and not knocked2: -> knock2 }
{ battery == 0:
    {t("手机黑了。", "The phone is dead.")} #fx:dark
}
-> hub_choices

=== hub_choices ===
{ dawn <= 2:
    {t("手机 {clock()}。天快亮了。", "Phone {clock()}. Nearly light.")}
}
+ [{t("去水房", "The water room")}]
    -> corridor_walk("water")
+ [{t("去三楼厕所", "The third-floor toilet")}]
    -> corridor_walk("toilet")
+ [{t("去楼梯间", "The stairwell")}]
    -> corridor_walk("stairs")
+ {went_stairs} [{t("去值班室", "The warden's office")}]
    -> corridor_walk("office")
+ [{t("去 303", "Room 303")}]
    -> corridor_walk("room303")
+ {doors == 8} [{t("第八扇门", "The eighth door")} #needs:card]
    -> corridor_walk("door8")
+ {doors == 8 and inv ? ledger and not (inv ? card)} [{t("第八扇门,带着登记本", "The eighth door, with the visitors' book")}]
    -> corridor_walk("door8")
+ [{t("用充电宝充电", "Charge the phone from the power bank")} #needs:bank]
    ~ inv -= bank
    ~ battery = clamp(battery + 50, 0, 100)
    {t("怡的充电宝,满的。手机亮了一格,又一格。{battery}%。", "Yi's power bank, full. One bar, then another. {battery}%.")}
    -> hub_choices
+ [{t("谁都别动,再等一个钟头", "Nobody move. Wait an hour.")}]
    ~ tick()
    {t("你们等。走廊里有人数数,数得很慢,数到四停了一会儿,又从头数。", "You wait. Someone in the corridor is counting, slowly; at four it stops a while, then starts over.")}
    {t("志勇:“等个屁。”没人答他。", "Zhiyong: ‘Waiting for what.’ Nobody answers him.")}
    ~ fear += 10
    ~ scare_all(5)
    -> hub

// The second knock: this time you can get it right.
=== knock2 ===
~ knocked2 = true
{t("敲门。三下。门板正中间。", "A knock. Three. The middle of the door.")} #fx:shake
{t("“几个人?”", "‘How many of you?’")}
{t("志勇把晾衣杆横过来。烟波看你。", "Zhiyong brings the pole across. Yanbo looks at you.")}
* [{t("答:五个", "Answer: five")}]
    {t("“五个。”你说。", "‘Five,’ you say.")}
    {t("门外安静了一会儿。“……对。”", "A silence outside. ‘...Right.’")}
    {t("门缝底下的光灭了。拖鞋声走远。", "The light under the door goes out. Slippers, going away.")}
    ~ fear = clamp(fear - 5, 0, 100)
    {t("怡很轻地说:“它要的是数对。”", "Yi, very quietly: ‘It wants the number right.’")}
    ~ weak_known = true
* [{t("答:四个", "Answer: four")}]
    {t("“四个。”你说。", "‘Four,’ you say.")}
    {t("“不对。”这次没等。门板被什么从外面拍了一下,整扇门都在响。", "‘Wrong.’ No pause this time. Something slaps the door from outside, the whole slab rings.")} #fx:shake
    ~ fear += 15
    ~ scare_all(10)
* [{t("不答", "Don't answer")}]
    {t("没人出声。门外等了很久。又问了一遍。又等。", "Nobody speaks. It waits outside a long time. Asks again. Waits.")}
    {t("然后拖鞋声走了。往 303 那边。", "Then the slippers go. Towards 303.")}
    ~ fear += 10
- -> hub_choices

// --- the corridor --------------------------------------------------------

// Every trip goes through the corridor and costs an hour. The first trip meets it.
=== corridor_walk(dest) ===
~ tick()
{ battery == 0:
    {t("没有光。你们摸着墙走。", "No light. You go along the wall by hand.")}
    ~ fear += 10
}
{ not corridor_known:
    ~ corridor_known = true
    -> first_contact(dest)
}
{ it_gone == 0 and (marked or noticed) and back % 2 == 0:
    -> ambush(dest)
}
{ it_gone == 0 and not (marked or noticed) and back % 3 == 0:
    -> ambush(dest)
}
{ not heater_seen and dawn <= 6 and battery > 0:
    -> heater(dest)
}
-> arrive(dest)

=== first_contact(dest) ===
{t("志勇开门,晾衣杆在前。走廊。", "Zhiyong opens the door, pole first. The corridor.")}
{t("手电照过去,门牌一扇一扇亮起来又黑下去。301。302。303,封条。304。305。306。307。", "The torch goes down it and the number plates light up one by one and go dark. 301. 302. 303, sealed. 304. 305. 306. 307.")}
{ doors < 8:
    {t("尽头,安全出口的绿灯底下,还有一扇。矮一点。没有牌。", "At the end, under the green exit light, one more. Lower. No plate.")}
    ~ doors = 8
}
{t("走廊那头有人数数。很慢。“一个。两个。三个。四个。”停了。又从头。", "Someone at the far end is counting. Slowly. ‘One. Two. Three. Four.’ A stop. Then from the start.")}
{t("你看不见数数的人。手电照到那儿,光就散了,像照进水里。", "You can't see who's counting. Where the torch reaches, the light comes apart, like shining it into water.")}
{t("拖鞋声。朝这边。", "Slippers. Coming this way.")}
~ fear += 10
{insight >= 4: {t("它不是走过来的。它是一扇门一扇门过来的。", "It isn't walking here. It's coming door by door.")} #voice:insight}
{strength >= 4: {t("别等它数到你。", "Don't let it count you.")} #voice:strength}
-> fight(dest, 3)

// A later trip, when it is out there and not driven off.
=== ambush(dest) ===
{t("走廊里有人数数。近。", "Counting in the corridor. Close.")}
{t("“……三个。四个。”", "‘...Three. Four.’")}
~ fear += 5
+ [{t("打过去", "Go through it")}]
    -> fight(dest, 2)
+ [{t("贴着墙绕过去", "Along the wall, round it")} #check:stamina:normal]
    { check("stamina", 10) >= 3:
        {t("你们贴着墙,一步一步。它在数,没数到你们。", "You hug the wall, one step at a time. It counts, and doesn't count you.")}
        ~ fear += 5
    - else:
        {t("怡的脚踢到了什么。它停了。“五个。”", "Yi's foot catches on something. It stops. ‘Five.’")} #fx:shake
        ~ hp -= 1
        ~ fear += 15
        ~ scare(yi, 15)
    }
    -> arrive(dest)
+ [{t("回 302", "Back to 302")}]
    -> hub

// A quiet trip after half past ten: the water heater by the stairs is still running. Once.
=== heater(dest) ===
~ heater_seen = true
{t("楼梯口的开水器上贴着一张通知,A4,四个角都用透明胶贴着。", "A notice on the water heater by the stairs, A4, all four corners taped down.")}
{t("关于开水器夜间断电的通知", "NOTICE: NIGHT-TIME POWER-OFF OF THE WATER HEATER")}
{t("各宿舍:本开水器每晚 22:30 断电。", "To all rooms: this heater is switched off every night at 22:30.")}
{t("宿管办　　　　年 11 月　　日", "Dormitory Office　　November ___, ____")}
{t("年份和日子那两格被水汽泡开了,只看得出“11 月”。", "The year and the day have swollen with steam. Only ‘November’ is left.")}
{t("怡在你后面念通知上的字,念到年份那格停了。", "Yi reads it out behind you, and stops at the year.")}
{t("开水器的指示灯亮着。里面在响。", "The heater's light is on. Something inside it is running.")}
{t("烟波:“几点。”", "Yanbo: ‘Time.’")}
{t("志勇看手机。“{clock()}。{dawn * 3}%。”", "Zhiyong looks at his phone. ‘{clock()}. {dawn * 3}%.’")}
{t("“断电是十点半。”", "‘It goes off at half ten.’")}
{t("志勇搓了一下后脖子,又搓一下。“操。傻屌机器。”他走过去按开关,按不动,本来就是按死的。“寄。按死的。按死的还响,寄了。”", "Zhiyong rubs the back of his neck, then again. ‘Fuck. Stupid bastard machine.’ He goes over and pushes the switch. It doesn't move; it was jammed off already. ‘Cooked. It's jammed off. Jammed off and still running. Cooked.’")}
{t("他退回来的时候举了一下手机。闪光灯没开,咔的一声。", "On his way back he lifts the phone. No flash. A click.")}
{t("烟波又去看那张通知,看了很久。“十点半。”", "Yanbo goes back to the notice and looks at it a long time. ‘Half ten.’")}
{t("“你刚说过了。”", "‘You said that.’")}
{t("“十点半。”", "‘Half ten.’")}
{t("咕嘟。", "Glug.")}
{t("烟波没说话,抬手往开水器底下指了一下。志勇没问指的是什么,人已经挪过去了,挡在烟波前面,比烟波高半个头。他的腿在抖,左边那条。", "Yanbo says nothing and points under the heater. Zhiyong doesn't ask at what; he's already moved, in front of Yanbo, half a head taller. His leg is shaking. The left one.")}
{t("咔。又一张。咔。", "Click. Another. Click.")}
{t("“你拍什么呢。”", "‘What are you photographing.’")}
{t("“没拍。”", "‘Nothing.’")}
{t("开水器底下的地上,一圈湿的,一直连到他鞋边。", "On the floor under the heater, a ring of wet, reaching all the way to his shoe.")}
~ fear += 5
~ scare(zhiyong, 10)
* [{t("手机照开水器底下", "Point the phone under the heater")}]
    {t("光圈落下去,那圈湿的边上有一圈白的,又多了一点。志勇往前迈了半步,又退回来。“……先存个档。”说完他自己愣了一下。“没事。走。”", "The light goes down. Round the edge of the wet there's a ring of white, and it's a little wider than it was. Zhiyong takes half a step forward and comes back. ‘...Save first.’ He hears himself. ‘Nothing. Go.’")}
    ~ fear += 5
    ~ scare(zhiyong, 5)
    -> arrive(dest)
* [{t("手机照志勇的手", "Point the phone at Zhiyong's hand")}]
    {t("他攥手机的那只手青筋鼓着,屏幕亮着,相册开着,最近一张的缩略图是那张通知。他发现你在照他,把手机塞进兜里。“照路。”", "The hand round his phone has its veins up. The screen's on: the photo album, and the newest thumbnail is the notice. He sees you looking and shoves the phone in his pocket. ‘Light the floor.’")}
    ~ zy_album = true
    ~ trust(zhiyong, -5)
    -> arrive(dest)
* [{t("关掉手机的灯", "Turn the phone's light off")}]
    {t("黑了一秒,志勇的手就抓上了你手腕,劲很大,是擒拿那个位置。他没说话。你又打开灯,他松了手,在裤子上擦了擦。", "One second of dark and Zhiyong's hand is on your wrist, hard, right where the hold goes. He says nothing. You put the light back on. He lets go and wipes his hand on his trousers.")} #fx:dark
    ~ scare(zhiyong, 10)
    ~ trust(zhiyong, 5)
    -> arrive(dest)

// --- fights ------------------------------------------------------------

// It has momentum, not blood. Each round it moves first; then one action, one roll.
=== fight(dest, m) ===
~ momentum = m
~ round = 0
~ braced = false
-> fight_round(dest)

=== fight_round(dest) ===
~ round += 1
{
    - round == 1:
        {t("数数的声音停了。然后它开始数你们。", "The counting stops. Then it starts counting you.")}
        {t("“一个。”", "‘One.’")} #fx:shake
        ~ fear += 10
        ~ scare_all(10)
    - round == 2:
        {t("“两个。”", "‘Two.’")}
        { trust_zhiyong >= 50 and fear_zhiyong < 70:
            {t("志勇被什么顶了一下,退了半步,没倒。晾衣杆横在那儿。", "Something shoves Zhiyong; he gives half a step and stays up. The pole stays across.")}
            ~ scare(zhiyong, 10)
        - else:
            {t("什么东西从志勇身边过来,撞在你胸口。", "Something comes past Zhiyong and hits you in the chest.")}
            { braced:
                {t("你顶住了。", "You hold.")}
            - else:
                ~ hp -= 1
            }
        }
    - else:
        {t("“{num(round)}个。”每数一个,走廊短一截。", "‘{num(round)}.’ Every number, the corridor is a little shorter.")}
        { braced:
            {t("你顶住了这一下。", "You take this one standing.")}
        - else:
            ~ hp -= 1
            ~ fear += 5
        }
}
~ braced = false
{ hp <= 2 or fear >= 100: -> fight_lost }
{ hp <= 4:
    {t("你的腿在抖。", "Your legs are shaking.")} #fx:pulse
}
{ fear_yi >= 70:
    {t("怡贴着墙,眼睛闭着。", "Yi is flat against the wall, eyes shut.")}
}
{t("它还在。你听得出来它在哪。", "It's still there. You can hear where.")}
+ [{t("砸过去", "Hit it")} #check:strength:normal]
    { check("strength", 10):
        - 4:
            {t("你砸实了。它退了一大步,数乱了。", "You connect. It gives a long step back; the count breaks.")}
            ~ momentum -= 2
        - 3:
            {t("你砸到了什么。软的,凉的。它退了半步。", "You hit something. Soft, cold. It gives half a step.")}
            ~ momentum -= 1
        - 2:
            {t("砸到了,也被顶回来了。", "You hit it, and it shoves you back for it.")}
            ~ momentum -= 1
            ~ hp -= 1
        - else:
            {t("砸空了。它贴得更近。", "Nothing there. It's closer.")}
            ~ hp -= 1
            ~ fear += 5
    }
    -> after_action(dest)
+ [{t("用晾衣杆捅", "Jab with the clothes pole")} #needs:pole #check:strength:easy]
    { check("strength", 8) >= 3:
        {t("杆子捅进去,碰到了什么,它退了。志勇:“再来!”", "The pole goes in, meets something, and it gives. Zhiyong: ‘Again!’")}
        ~ momentum -= 1
    - else:
        {t("杆子被什么攥住了,拽了一下。你没松手。", "Something takes hold of the pole and pulls. You don't let go.")}
        ~ hp -= 1
    }
    -> after_action(dest)
+ [{t("顶住,撑过这一下", "Hold on, take the next one")} #check:stamina:easy]
    { check("stamina", 8) >= 3:
        {t("你把脚钉住。", "You dig your feet in.")}
        ~ braced = true
        ~ fear = clamp(fear - 5, 0, 100)
    - else:
        {t("腿软了一下。", "Your knees go for a second.")}
        ~ hp -= 1
    }
    -> after_action(dest)
+ [{t("稳住队友", "Steady the others")} #check:charm:normal]
    { check("charm", 10) >= 3:
        {t("“志勇!打它!”“怡,看我!”", "‘Zhiyong! Hit it!’ ‘Yi, look at me!’")}
        {t("志勇抡了过去。怡睁开眼了。", "Zhiyong swings. Yi opens his eyes.")}
        ~ momentum -= 1
        ~ scare_all(-15)
    - else:
        {t("你喊了。声音不是你的。志勇骂了一句,没动。", "You shout. The voice isn't yours. Zhiyong swears and doesn't move.")}
        ~ fear += 5
        ~ trust(zhiyong, -5)
    }
    -> after_action(dest)
+ {not weak_known} [{t("看它的破绽", "Look for its weak point")} #check:insight:hard]
    { check("insight", 12) >= 3:
        {t("它每数一个,都要停一下。像在等人答。", "Every number, it pauses. As if waiting for an answer.")}
        {t("它数不过来的时候,动不了。", "When the count won't come out, it can't move.")} #voice:insight
        ~ weak_known = true
    - else:
        {t("你盯着黑处看。看久了,黑处也在看你。", "You stare into the dark. Stare long enough and the dark stares back.")}
        ~ fear += 15
    }
    -> after_action(dest)
+ {weak_known} [{t("报一个错的数", "Call out a wrong number")} #check:reason:normal]
    { check("reason", 10) >= 3:
        {t("“七个!”你喊。", "‘Seven!’ you shout.")}
        {t("它停了。数数的声音退回去,从头。“一个……”", "It stops. The counting draws back, starts over. ‘One...’")}
        ~ momentum -= 2
    - else:
        {t("“……”你张嘴,数没出来。它数到了你。", "‘...’ Your mouth opens and no number comes. It counts you.")}
        ~ fear += 15
    }
    -> after_action(dest)
+ [{t("压住恐惧", "Get a grip")} #check:reason:normal]
    { check("reason", 10) >= 3:
        {t("你数自己的呼吸。四下。手不抖了。", "You count your own breaths. Four. Your hands stop.")}
        ~ fear = clamp(fear - 15, 0, 100)
    - else:
        {t("你数呼吸。数到三,它接了一句:“四个。”", "You count your breaths. At three it finishes for you: ‘Four.’")}
        ~ fear += 10
    }
    -> after_action(dest)
+ [{t("撒辣椒面", "Throw the chilli powder")} #needs:pepper]
    ~ inv -= pepper
    {t("一把辣椒面和花椒撒过去。它数到一半,呛住了似的,停了。", "A fistful of chilli and Sichuan pepper. Mid-number it stops, like something choking.")}
    {t("志勇:“卧槽,有用?”", "Zhiyong: ‘Fuck, that works?’")}
    ~ momentum -= 1
    -> after_action(dest)
+ [{t("跑回 302", "Run for 302")}]
    ~ fled += 1
    {t("你们跑。门在背后关上的时候,它数到了:“{fifth:五|四}个。”", "You run. As the door shuts behind you it finishes: ‘{fifth:Five|Four}.’")}
    ~ hp -= 1
    ~ fear += 15
    -> hub

=== after_action(dest) ===
{ momentum <= 0: -> fight_won(dest) }
{ hp <= 2 or fear >= 100: -> fight_lost }
-> fight_round(dest)

=== fight_won(dest) ===
{t("它退了。数数的声音退到走廊尽头,被最后那扇门收进去。", "It withdraws. The counting goes back down the corridor and the last door takes it in.")}
~ it_gone = 1
~ fear = clamp(fear - 10, 0, 100)
{t("烟波喘着气:“打不死。它只是走了。”", "Yanbo, winded: ‘Can't kill it. It just left.’")}
{t("“走了多久?”", "‘For how long?’")}
{t("“看表。”", "‘Watch the clock.’")}
{reason >= 3: {t("硬打,只能换时间。", "Fighting buys time. Only time.")} #voice:reason}
{ trust_zhiyong >= 50:
    ~ trust(zhiyong, 5)
}
-> arrive(dest)

=== fight_lost ===
{t("它从你们中间穿过去。像走过一道门。", "It goes through the middle of you. Like walking through a door.")} #fx:pulse
~ hp = clamp(hp - 2, 0, 10)
~ fear = clamp(fear + 20, 0, 100)
~ scare_all(15)
{t("后面的事你记不清。志勇拖着你,烟波拖着怡。302 的门。锁舌。", "You don't remember the rest. Zhiyong dragging you, Yanbo dragging Yi. 302's door. The bolt.")}
{t("手机:{clock()}。", "Phone: {clock()}.")}
~ tick()
{t("又一个钟头没了。", "Another hour gone.")}
-> hub

// --- the places (stubs in this draft) -------------------------------------------

=== arrive(dest) ===
{ dest == "water": -> water }
{ dest == "toilet": -> toilet }
{ dest == "stairs": -> stairs }
{ dest == "office": -> office }
{ dest == "room303": -> room303 }
{ dest == "door8": -> door8 }
-> hub

=== water ===
{ went_water: -> water_again }
~ went_water = true
{t("水房。六个龙头全拧死了。长池子却是满的,水平平的,一直到池沿。", "The water room. All six taps screwed shut. The long basin is full though, the water flat, right up to the rim.")}
{t("水面上漂着校服。一件,一件,一件。", "Uniforms float on it. One, and one, and one.")}
{ tap_seen:
    {t("排水口边上那圈白的还在。你这次蹲下去看了。瓷片。碎成末的瓷片。", "The white ring round the drain is still there. This time you crouch and look. Porcelain. Porcelain ground to dust.")}
- else:
    {t("排水口边上一圈白的,像肥皂沫。不是肥皂沫。是瓷片,碎成了末。", "A white ring round the drain, like soap scum. Not soap scum. Porcelain, ground to dust.")}
}
{t("镜子蒙着水汽。只有一块是干净的,擦过似的。", "The mirror is fogged. One patch is clear, as if wiped.")}
{t("镜子里,池边站着一个人。背对着你们,湿头发到腰,在洗什么东西。", "In the mirror someone stands at the basin. Back to you, wet hair to the waist, washing something.")}
{t("你回头。池边没有人。", "You look round. There's nobody at the basin.")}
{t("“いち……に……さん……”", "‘Ichi... ni... san...’")}
{t("数数。日语的。你们都听得出来,动画片里的数法。", "Counting. Japanese. You all know it, the way cartoons count.")}
{t("怡贴在门边,嘴唇在动。“……她数到九就从头。第九个之后停得特别久。”他看你一眼,“她少一个。”", "Yi is flat against the door, lips moving. ‘...She goes to nine and starts over. After the ninth she stops a long time.’ He looks at you. ‘She's one short.’")}
{t("“数盘子的。”你听见自己说。“井里数盘子那个。皿屋敷。”", "‘The plate counter,’ you hear yourself say. ‘The one in the well, counting plates. Sarayashiki.’")}
{t("志勇:“说人话。”", "Zhiyong: ‘In Chinese.’")}
{t("“她数够九个,就回头数人。”", "‘When she gets to nine she turns round and counts people.’")}
~ fear += 15
~ scare_all(10)
{t("池子那头,水底下有个人。脸朝下,校服,两只手还在水里搓。304 的小冯。", "At the far end someone is under the water. Face down, in uniform, both hands still rubbing. Xiaofeng, from 304.")}
{t("志勇:“别碰。”", "Zhiyong: ‘Don't.’")}
{t("最里面的淋浴隔间,门反锁着。里面有人一直在念:“两个。两个。两个。”", "The last shower stall is bolted from inside. Someone in there keeps saying: ‘Two. Two. Two.’")}
{t("大头。304 的另一个。", "Datou. The other one from 304.")}
~ datou = "stall"
~ okiku = 1
{t("“ご。”", "‘Go.’")}
{t("镜子里的人往隔间那头挪了一步。手上的东西还在洗。", "The one in the mirror takes a step towards the stall. Still washing what's in her hands.")}
{insight >= 4: {t("她每数一个走一步。到九,她就到隔间门口了。", "One step a number. At nine she's at the stall door.")} #voice:insight}
{charm >= 4: {t("大头要有人叫才出得来。", "Datou won't come out unless someone calls him.")} #voice:charm}
-> rescue

// The rescue: she counts up from five, a step a number; at nine she takes whoever is in the stall.
=== rescue ===
~ count = 5
~ datou_out = false
~ held = false
-> rescue_round

=== rescue_round ===
{ count >= 9 and not datou_out: -> rescue_lost }
{ count >= 9: -> rescue_counted }
{
    - count == 5:
        {t("她在第一个龙头。", "She's at the first tap.")}
    - count == 6:
        {t("“ろく。”第二个龙头。", "‘Roku.’ The second tap.")}
    - count == 7:
        {t("“しち。”她的手里是一件校服,拧着水。", "‘Shichi.’ What she's wringing out is a uniform.")}
    - count == 8:
        {t("“はち。”她的手搭在隔间门上了。门里面的声音停了。", "‘Hachi.’ Her hand is on the stall door. The voice inside has stopped.")}
        {t("播州那个版本。和尚替她数了第十个,她就走了。你看过。你记得。", "The Banshu version. A monk counted the tenth for her and she left. You've seen it. You remember.")} #voice:reason
}
{ datou_out:
    {t("大头在你身后,攥着你的衣服。", "Datou is behind you, holding on to your shirt.")}
}
+ {not datou_out} [{t("拽开隔间门", "Wrench the stall door open")} #check:strength:normal]
    { check("strength", 10) >= 3:
        {t("锁舌崩了。大头缩在最里面,你把他拖出来。他的脚是湿的。", "The bolt gives. Datou is curled at the back; you drag him out. His feet are wet.")}
        ~ datou_out = true
    - else:
        {t("门卡死了。门边的铁皮划开你的手。", "The door won't give. The metal edge opens your hand.")}
        ~ hp -= 1
    }
    -> rescue_after
+ {not datou_out} [{t("隔着门劝大头", "Talk Datou out through the door")} #check:charm:normal]
    { check("charm", 10) >= 3:
        {t("“大头。是我,302 的。你开门,我们带你走。”", "‘Datou. It's me, from 302. Open up, we're taking you out.’")}
        {t("里面安静了一下。锁开了。", "Quiet inside. Then the lock.")}
        ~ datou_out = true
    - else:
        {t("“大头——”“两个!两个!”他往里缩。", "‘Datou—’ ‘Two! Two!’ He shrinks further in.")}
        ~ fear += 5
    }
    -> rescue_after
+ [{t("挡在池子和隔间中间", "Get between the basin and the stall")} #check:stamina:easy]
    { check("stamina", 8) >= 3:
        {t("你站过去。镜子里她停了。数数的声音停在半截。", "You step across. In the mirror she stops. The count stops halfway through.")}
        {t("她的手冰的。你没回头看是什么碰了你。", "Her hand is cold. You don't look round at what touched you.")}
        ~ held = true
        ~ fear += 5
    - else:
        {t("湿的手摸到你的脚踝。你跳开了。", "A wet hand on your ankle. You jump clear.")}
        ~ hp -= 1
        ~ fear += 10
    }
    -> rescue_after
+ {not okiku_known} [{t("看她在数什么", "See what she's counting")} #check:insight:normal]
    { check("insight", 10) >= 3:
        {t("她数的不是人。是水里的东西。八件校服,一件一件数过去。", "It isn't people she counts. It's what's in the water. Eight uniforms, one by one.")}
        {t("八件。她要九件。", "Eight. She wants nine.")} #voice:insight
        ~ okiku_known = true
    - else:
        {t("你盯着镜子看。她回了一下头。那张脸上没有东西。", "You stare into the mirror. She turns her head a little. There's nothing on the face.")}
        ~ fear += 15
    }
    -> rescue_after
+ {not clue_number} [{t("捞池子里那件旧款校服", "Fish out the old-style uniform")}]
    {t("八件里有一件不一样。旧款的,学校十几年前换过。领口内侧用圆珠笔写着学号。", "One of the eight is different. The old cut; the school changed it over ten years ago. Inside the collar, a student number in ballpoint.")}
    {t("怡看了一眼。“记住了。”他就是记得住。", "Yi glances at it. ‘Got it.’ He just does.")}
    ~ clue_number = true
    {t("水是温的。", "The water is warm.")}
    ~ fear += 5
    -> rescue_after
+ {count == 8} [{t("喊:十", "Shout: ten")} #check:reason:normal]
    { check("reason", 10) >= 3:
        {t("“きゅう。”", "‘Kyuu.’")}
        {t("“十!”你喊。声音劈了。", "‘Ten!’ you shout. Your voice cracks.")}
        {t("她停了。镜子里的人直起身。", "She stops. The one in the mirror straightens up.")}
        {t("然后哭了一声。很短,像松了口气。", "Then one sob. Short, like a breath let go.")}
        {t("水面晃了一下。她顺着排水口下去了。水跟着她走,一直退到池底。", "The water shivers. She goes down the drain. The water goes with her, all the way to the bottom of the basin.")}
        ~ okiku = 2
        ~ fear = clamp(fear - 10, 0, 100)
        -> rescue_won
    - else:
        {t("“十——”你喊早了。她还在“はち”上。", "‘Ten—’ Too early. She's still on ‘hachi’.")}
        {t("镜子里的人回过头来。数到了你。“きゅう。”", "The one in the mirror turns round. Counts you. ‘Kyuu.’")} #fx:pulse
        ~ hp = clamp(hp - 2, 0, 10)
        ~ fear += 20
        -> rescue_counted
    }
+ {datou_out} [{t("拉着大头冲出门", "Run for the door with Datou")} #check:stamina:normal]
    { check("stamina", 10) >= 3:
        {t("你们跑。大头的鞋在地上打滑,志勇一把把他拎起来。", "You run. Datou's shoes skid; Zhiyong hauls him up by the collar.")}
        -> rescue_won
    - else:
        {t("大头摔了。你回去拽他,膝盖磕在池沿上。", "Datou goes down. You go back for him and your knee hits the rim.")}
        ~ hp -= 1
        -> rescue_after
    }
+ [{t("回 302", "Back to 302")}]
    { datou_out:
        {t("你们退出去。大头跟着。", "You back out. Datou comes.")}
        -> rescue_won
    }
    {t("你们退出去。隔间里的声音还在念:“两个。两个。”", "You back out. The voice in the stall is still going: ‘Two. Two.’")}
    {t("志勇在门口站了一秒。“操。”他跟上来了。", "Zhiyong stops in the doorway for a second. ‘Fuck.’ Then he follows.")}
    ~ datou = "dead"
    ~ fear += 20
    ~ scare_all(15)
    ~ trust(zhiyong, -10)
    -> hub

=== rescue_after ===
{ held:
    ~ held = false
- else:
    ~ count += 1
}
-> rescue_round

// At nine with someone still in the stall.
=== rescue_lost ===
{t("“きゅう。”", "‘Kyuu.’")}
{t("隔间的门自己开了。", "The stall door opens by itself.")} #fx:shake
{t("里面没有人。", "There's nobody inside.")}
{t("池子那头,水底下现在是两个人。并排。两只手都在搓。", "At the far end, under the water, there are two now. Side by side. All four hands rubbing.")}
{t("她不数了。她在洗。", "She isn't counting any more. She's washing.")}
~ datou = "dead"
~ fear += 25
~ scare_all(20)
{t("志勇一句话没说,把你推出门。", "Zhiyong doesn't say a word; he shoves you out of the door.")}
{reason >= 3: {t("怡的故事。去关龙头的人,后面怎么了。现在知道了。", "Yi's story. The one who went to turn off the tap. Now you know the rest.")} #voice:reason}
-> hub

// She counted you: out, with whoever is out.
=== rescue_counted ===
{t("腿不听使唤。志勇拖你,烟波拖{datou_out:大头|怡}。门。", "Your legs won't work. Zhiyong drags you, Yanbo drags {datou_out:Datou|Yi}. The door.")}
{ not datou_out:
    {t("隔间里的声音停了。", "The voice in the stall has stopped.")}
    ~ datou = "dead"
    ~ fear += 10
}
{ datou_out: -> rescue_won }
-> hub

=== rescue_won ===
{t("走廊里。大头靠着墙,喘。", "The corridor. Datou against the wall, panting.")}
{t("“小冯去关龙头。”他说,“门外说不对的时候,龙头就响了。他说他去关。”", "‘Xiaofeng went to turn the tap off,’ he says. ‘When the voice outside said wrong, the tap started. He said he'd go.’")}
{t("“什么门外?”", "‘What voice outside?’")}
{t("“敲门的。问几个人。我们说两个。”他看你,“穿拖鞋的。我以为是阿姨。”", "‘The knock. Asking how many. We said two.’ He looks at you. ‘Slippers. I thought it was the warden.’")}
{t("“跟我们回 302。”", "‘Come back to 302 with us.’")}
{t("他摇头。摇得很用力。“那屋就是它数的屋。”", "He shakes his head, hard. ‘That's the room it counts.’")}
{t("他往楼梯间跑了。拖鞋拍在地上的声音,一直到楼梯口才停。", "He runs for the stairwell. The slap of his slippers on the floor doesn't stop until the stair door.")}
~ datou = "stairs"
~ trust(zhiyong, 5)
{ okiku == 2:
    {t("水房里安静了。水退干净了。", "The water room is quiet. The water has drained away.")}
}
{insight >= 4: {t("两个人答两个,门外说不对。它数的不是屋里的人。", "Two said two, and the voice outside said wrong. It isn't the people in the room it counts.")} #voice:insight}
+ [{t("回 302", "Back to 302")}]
    -> hub

// Later visits.
=== water_again ===
{
    - okiku == 2:
        {t("水房。水退了,校服瘫在池底。小冯还在,脸朝下。没有人数数。", "The water room. Drained; the uniforms lie slumped on the bottom. Xiaofeng is still there, face down. Nobody is counting.")}
        { not clue_number:
            {t("八件里有一件旧款的。领口内侧写着学号。怡看了一眼,记住了。", "One of the eight is the old cut. A student number inside the collar. Yi looks once and has it.")}
            ~ clue_number = true
        }
    - else:
        {t("水房。她还在镜子里,还在数。", "The water room. She's still in the mirror, still counting.")}
        { datou == "dead":
            {t("池子那头是两个人。", "Two at the far end.")}
        }
        {t("“ご……ろく……”她回了一下头。", "‘Go... roku...’ She turns her head a little.")}
        ~ fear += 10
}
+ {okiku == 1} [{t("等她数到九,喊:十", "Wait for nine and shout: ten")} #check:reason:normal]
    { check("reason", 10) >= 3:
        {t("“きゅう。”“十!”", "‘Kyuu.’ ‘Ten!’")}
        {t("她哭了一声,顺着排水口下去了。水跟着退了。", "One sob, and she goes down the drain. The water follows.")}
        ~ okiku = 2
        ~ fear = clamp(fear - 10, 0, 100)
    - else:
        {t("喊早了。她数到了你。", "Too early. She counts you.")} #fx:pulse
        ~ hp -= 1
        ~ fear += 15
    }
    -> water_again
+ [{t("回 302", "Back to 302")}]
    -> hub

=== toilet ===
~ went_toilet = true
{t("三楼厕所。最里面那格,门关着。", "The third-floor toilet. The last stall, door shut.")}
{t("(厕所下一稿写。)", "(The toilet is written in the next draft.)")}
+ [{t("回 302", "Back to 302")}]
    -> hub

=== stairs ===
~ went_stairs = true
{t("楼梯间。往下走,下到底,推开门,还是三楼。", "The stairwell. Down, all the way, push the door: the third floor.")}
{t("往上走一层,是一楼大厅。值班室的灯亮着。", "Up one flight is the ground-floor lobby. The light is on in the warden's office.")}
{ fear_zhiyong >= 70 and zy_broke == 0: -> stairs_break }
-> stairs_tail

=== stairs_tail ===
{t("(楼梯间下一稿写。)", "(The stairwell is written in the next draft.)")}
+ [{t("回 302", "Back to 302")}]
    -> hub

// Zhiyong's shell breaks: his 90 on the sheet, 70 on the dial. Once. Yanbo says "行了" for him at the next hub.
=== stairs_break ===
~ zy_broke = 1
{t("志勇的手机屏幕亮了一下。", "Zhiyong's phone lights up.")}
{t("3%。", "3%.")}
{t("他没扣回去。", "He doesn't turn it over.")}
{t("2%。", "2%.")}
{t("他点开了一个聊天。", "He opens a chat.")}
{t("昕　20:41", "Xin　20:41")}
{t("来不来", "coming or not")}
{t("　　　　　　来", "　　　　　　coming")}
{t("1%。", "1%.")}
{t("黑了。", "Black.")} #fx:dark
{t("包掉在他脚边。", "The bag drops at his feet.")}
{t("你的手机照着台阶。往上,是黑的。", "Your phone lights the steps. Above that it's dark.")}
{t("没人骂人。", "Nobody swears.")}
{t("你等那句“啧”。", "You wait for the ‘tch’.")}
{t("没有。", "It doesn't come.")}
{t("他站着,就在你右边。你知道那是他,头顶那团黑比别处高。", "He's standing right there on your right. You know it's him: the dark over his head is taller than the dark everywhere else.")}
{ inv ? bank:
    {t("怡在你后面小声说:“充电宝……在昕那儿。”", "Behind you Yi says, quietly: ‘The power bank... Xin has it.’")}
- else:
    {t("怡在你后面把充电宝从兜里掏出来,线缠着。", "Behind you Yi gets the power bank out of his pocket, cable tangled.")}
}
{t("你伸手,摸到他胳膊。硬的。不动。", "You reach out and find his arm. Rigid. Not moving.")}
{t("然后有只手攥住了你的袖子。", "Then a hand closes on your sleeve.")}
{t("很大的一只手。", "A very big hand.")}
{t("“……昕。”", "‘...Xin.’")}
{t("“在。”", "‘Here.’")}
{t("“我腿。”", "‘My legs.’")}
* [{t("让他攥着,往后退一步", "Let him hold on, and take a step back")}]
    {t("他跟着退了一步。又一步。到了平台上,他的手还在你袖子上。", "He comes with you, a step. Another. On the landing his hand is still on your sleeve.")}
    ~ scare(zhiyong, -15)
    ~ trust(zhiyong, 5)
* [{t("把自己的手机塞进他手里", "Push your own phone into his hand")}]
    {t("他攥住了。没开灯,就攥着。屏幕朝下,和他平时一样。过了一会儿他把它翻过来,看了一眼电量,又扣回去。走的时候他把手机还你了,没说话。", "He takes it. Doesn't turn the light on, just holds it. Face down, the way he always does. After a while he turns it over, reads the charge, turns it back. When you move off he hands it back, without a word.")}
    ~ scare(zhiyong, -20)
    ~ trust(zhiyong, 10)
    ~ fear += 5
* [{t("停下来,等他自己走", "Stop, and wait for him to move")}]
    {t("你们站着。烟波没催。怡在数台阶,很小声。过了很久,志勇的手松开了,他先走的。走得很慢。", "You stand there. Yanbo doesn't hurry him. Yi is counting the steps, very quietly. After a long time Zhiyong's hand lets go, and he goes first. Slowly.")}
    ~ scare(zhiyong, -5)
    ~ fear += 5
- {t("扶手上粘着一块口香糖,干了。你们从旁边走过去。", "There's a piece of chewing gum stuck to the handrail, dried out. You walk past it.")}
-> stairs_tail

=== office ===
{ went_office: -> office_again }
~ went_office = true
{t("往上一层。楼梯间的门推开,是一楼大厅。", "One flight up. The stair door opens on the ground-floor lobby.")}
{t("玻璃大门锁着。外面是黑的。不是夜里那种黑,是什么都没有。", "The glass doors are locked. Outside is black. Not night-black; nothing-black.")}
{t("值班室的灯亮着,小电视开着。茶杯是热的。桌子底下一双拖鞋,摆得整整齐齐。人没了。", "The office light is on, the little TV on. The tea is hot. A pair of slippers under the desk, side by side. Nobody.")}
{t("电视放的是监控。三楼走廊。八扇门。", "The TV is the camera feed. Third-floor corridor. Eight doors.")}
{t("302 的门开着一条缝。", "302's door stands open a crack.")}
{t("志勇:“……我锁的。”", "Zhiyong: ‘...I locked it.’")}
~ fear += 10
{t("值班记录本摊在桌上。最后一行:8:59,上楼。", "The duty log lies open. Last line: 8:59, went up.")}
{t("阿姨从来不上楼。就这一回。", "She never goes up. Just this once.")}
{t("她的拖鞋在桌子底下。那楼上穿拖鞋走的是谁。", "Her slippers are under the desk. So whose slippers are those upstairs.")}
~ aunt_clue = true
~ fear += 5
{t("钥匙柜开着。303 那个钩子是空的,牌子还挂着。", "The key cabinet is open. The hook for 303 is empty; the tag still hangs there.")}
{t("窗户对着宿舍楼。整栋楼黑的。", "The window faces the dorm block. The whole building is dark.")}
{
    - light == "on":
        {t("只有三楼一扇窗亮着。302。窗边站着一个人,往下看。", "One window lit on the third floor. 302. Someone stands at it, looking down.")}
        ~ fear += 10
    - light == "torch":
        {t("三楼有一扇窗里有光在晃。302。你的手机在你手里。", "In one third-floor window a light is moving. 302. Your phone is in your hand.")}
        ~ fear += 10
    - else:
        {t("302 的窗是黑的。可门缝底下那条光,从楼外都看得见。", "302's window is dark. But the strip of light under the door shows even from out here.")}
        ~ fear += 5
}
{t("桌上还有一本。来访登记。", "One more book on the desk. The visitors' register.")}
-> office_choices

=== office_choices ===
+ {not ledger_seen} [{t("翻来访登记", "Open the visitors' register")}]
    -> office_ledger
+ {ledger_seen and not (inv ? ledger)} [{t("把登记本带走", "Take the register")}]
    ~ inv += ledger
    ~ noticed = true
    {t("你把本子夹在腋下。", "You tuck the book under your arm.")}
    {t("大厅的灯灭了一盏。又一盏。从大门那头灭过来。", "A lobby light goes out. Another. From the doors inward.")} #fx:dark
    {t("烟波:“它知道了。走。”", "Yanbo: ‘It knows. Go.’")}
    ~ fear += 10
    -> office_choices
+ {ledger_seen and erased == "yi" and not yi_written} [{t("把怡的名字写回去", "Write Yi's name back in")}]
    {t("桌上有笔。你在划掉的名字旁边重新写了一遍。怡。", "There's a pen on the desk. Beside the crossed-out name you write it again. Yi.")}
    {t("笔尖划过去的时候,电视里的走廊闪了一下。", "As the pen moves, the corridor on the TV flickers.")}
    {t("怡站在你旁边,没说话。手在抖。", "Yi stands beside you and says nothing. His hands are shaking.")}
    ~ yi_written = true
    ~ noticed = true
    ~ trust(yi, 15)
    ~ scare(yi, -20)
    -> office_choices
+ [{t("回 302", "Back to 302")}]
    -> hub

=== office_ledger ===
~ ledger_seen = true
{t("今晚那页。302 那行:志勇,18:25。怡,18:40。", "Tonight's page. The 302 line: Zhiyong, 18:25. Yi, 18:40.")}
{ hidden == "yi":
    {t("没有怡。只有志勇。", "No Yi. Just Zhiyong.")}
    {t("怡看了很久。“我记得我签的。”", "Yi looks a long time. ‘I remember signing.’")}
    ~ scare(yi, 10)
}
{ erased == "yi":
    {t("怡的名字上划了一道。签退那栏写着 8:59。不是他的字。", "A line through Yi's name. The sign-out column says 8:59. Not his writing.")}
    ~ scare(yi, 15)
}
{ fifth:
    {t("下面还有一个名字。阿泽。墨水是新的,字却很老,像十几年前的人写的。", "One more name below. Aze. The ink is fresh, the hand old, like someone writing ten years ago.")}
    {t("阿泽站在门口,没进来。", "Aze stands in the doorway and doesn't come in.")}
- else:
    {t("下面还有一个名字。墨水是褐色的,字很旧。入楼 6:30。签退一栏空着。", "One more name below. Brown ink, old writing. In at 6:30. Sign-out blank.")}
}
~ fear += 10
{t("你往前翻。", "You turn back.")}
{t("本子厚得不对。翻多少页都翻不到底,每一晚,302 那行都有同一个名字。都划掉了。", "The book is thicker than it should be. Page after page, no end to it, and every night the same name on the 302 line. Every one crossed out.")}
{t("最早那一页。日期是十几年前。名字。房间:303。签退那栏一条红线,旁边两个字:退宿。", "The first page. A date over ten years back. The name. Room: 303. A red line through the sign-out column, and two words beside it: moved out.")}
~ aze_known = true
{ clue_number:
    {t("学号也在。怡念出来,和池子里那件校服领口上的一个数不差。", "The student number is there too. Yi reads it out: the same as inside the collar of the uniform in the basin, to the digit.")}
    {t("阿泽。303。串门到 302,没出去。", "Aze. 303. Came visiting 302 and never left.")}
- else:
    {t("名字旁边有学号。怡记下了。", "A student number beside the name. Yi has it.")}
}
{reason >= 3: {t("它数的是这一行。这一行一直是五个。", "What it counts is this line. This line has always said five.")} #voice:reason}
{charm >= 4: {t("签退一栏是空的。替他签了,数就对了。", "The sign-out column is blank. Sign him out, and the number comes right.")} #voice:charm}
~ fear += 10
-> office_choices

=== office_again ===
{t("值班室。茶凉了。拖鞋还在。", "The office. The tea has gone cold. The slippers are still there.")}
{ inv ? ledger:
    {t("桌上少了一本。大厅的灯没再亮过。", "One book fewer on the desk. The lobby lights never came back.")}
}
{t("电视里,302 的门{marked:开着|开着一条缝}。", "On the TV, 302's door is {marked:open|open a crack}.")}
~ fear += 5
-> office_choices

=== room303 ===
~ went_303 = true
{t("303。封条还在。", "303. The seal is still on.")}
{t("(303 下一稿写。)", "(303 is written in the next draft.)")}
+ [{t("回 302", "Back to 302")}]
    -> hub

=== door8 ===
{t("最后那扇。矮一点,没有牌。", "The last one. Lower, no plate.")}
{t("(第八扇门下一稿写。)", "(The eighth door is written in the next draft.)")}
+ [{t("回 302", "Back to 302")}]
    -> hub

// --- the night runs out ------------------------------------------------------

=== daybreak ===
{t("手机:5:00。窗户亮了。", "Phone: 5:00. The window is getting light.")}
{t("亮的是窗里的走廊。走廊尽头,最后那扇门开着。", "What's lighting up is the corridor in the glass. At the end of it the last door stands open.")}
{t("楼下有人喊起床。没有人上楼。", "Someone downstairs is calling wake-up. Nobody comes up.")}
{t("第二年,302 多了一个故事。烟波讲的。", "The next year 302 had one more story. Yanbo told it.")}
-> END
