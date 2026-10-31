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
        { erased == "yi":
            {t("门口摆着一双鞋。怡的。鞋尖朝屋里,摆得整整齐齐。怡没有去穿。", "A pair of shoes by the door. Yi's. Toes pointing into the room, set down neatly. Yi doesn't go and put them on.")}
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
{ it_gone == 0 and marked and back % 2 == 0:
    -> ambush(dest)
}
{ it_gone == 0 and not marked and back % 3 == 0:
    -> ambush(dest)
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
* [{t("打过去", "Go through it")}]
    -> fight(dest, 2)
* [{t("贴着墙绕过去", "Along the wall, round it")} #check:stamina:normal]
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
* [{t("回 302", "Back to 302")}]
    -> hub

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
~ went_water = true
{t("水房。龙头全关着,池子是湿的。", "The water room. Every tap off, the basins wet.")}
{t("(水房下一稿写。)", "(The water room is written in the next draft.)")}
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
{t("(楼梯间下一稿写。)", "(The stairwell is written in the next draft.)")}
+ [{t("回 302", "Back to 302")}]
    -> hub

=== office ===
~ went_office = true
{t("值班室。没人。茶杯是热的。", "The warden's office. Nobody. The tea is still warm.")}
{t("(值班室下一稿写。)", "(The office is written in the next draft.)")}
+ [{t("回 302", "Back to 302")}]
    -> hub

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
