---
rules: { kind: sum, dice: [6, 6] }
languages: [zh, en]
difficulties: { trivial: 6, easy: 8, normal: 10, hard: 12, severe: 14, legendary: 16 }
skills:
  - { id: reason, name: { zh: 理智, en: Reason }, voice: { stance: { zh: "这说得通,撑住。", en: "It adds up. Hold on." }, color: "#7a9cff" } }
  - { id: stamina, name: { zh: 耐力, en: Stamina }, voice: { stance: { zh: 再坚持一下。, en: "Just a little longer." }, color: "#8fbf6a" } }
  - { id: charm, name: { zh: 魅力, en: Charm }, voice: { stance: { zh: 这事能谈。, en: "We can talk about this." }, color: "#e6a23c" } }
  - { id: insight, name: { zh: 洞察力, en: Insight }, voice: { stance: { zh: 注意到了吗。, en: "Did you notice?" }, color: "#b07cd8" } }
  - { id: strength, name: { zh: 力量, en: Strength }, voice: { stance: { zh: 砸。, en: "Smash it." }, color: "#e26a6a" } }
resources:
  - { id: fear, name: { zh: 恐惧, en: Fear }, min: 0, max: 100, initial: 0 }
  - { id: hp, name: { zh: 体力, en: Stamina }, min: 0, max: 10, initial: 10 }
  - { id: battery, name: { zh: 电量, en: Battery }, min: 0, max: 100, initial: 80 }
  - { id: dawn, name: { zh: 天亮前, en: Till dawn }, min: 0, max: 8, initial: 8 }
companionResources:
  - { id: fear, name: { zh: 恐惧, en: Fear }, min: 0, max: 100, initial: 20 }
  - { id: trust, name: { zh: 信任, en: Trust }, min: 0, max: 100, initial: 50 }
characters:
  - { id: xin, name: { zh: 昕, en: Xin }, skills: { reason: 3, stamina: 3, charm: 5, insight: 4, strength: 2 }, companion: { fear: 30, trust: 60 }, items: [phone] }
  - { id: yanbo, playable: false, name: { zh: 烟波, en: Yanbo }, skills: { reason: 5, stamina: 2, charm: 3, insight: 3, strength: 5 }, companion: { fear: 15, trust: 60 } }
  - { id: zhiyong, playable: false, name: { zh: 志勇, en: Zhiyong }, skills: { reason: 2, stamina: 5, charm: 2, insight: 2, strength: 6 }, companion: { fear: 35, trust: 55 } }
  - { id: yi, playable: false, name: { zh: 怡, en: Yi }, skills: { reason: 4, stamina: 2, charm: 3, insight: 5, strength: 1 }, companion: { fear: 15, trust: 50 } }
items:
  - { id: phone, name: { zh: 手机, en: Phone }, desc: { zh: 你的手机。电量在状态栏。, en: "Your phone. Its charge is in the status bar." } }
  - { id: pepper, name: { zh: 辣椒面, en: Chili powder }, desc: { zh: "上次打火锅剩的,和花椒一袋。", en: "Left over from hotpot, bagged with the peppercorns." } }
  - { id: band, name: { zh: 弹力带, en: Resistance band }, desc: { zh: "烟波的,别拉断。", en: "Yanbo's. Don't snap it." } }
  - { id: bank, name: { zh: 充电宝, en: Power bank }, desc: { zh: "怡的,满电,手机接口。", en: "Yi's, full, phone connector." } }
  - { id: notebook, name: { zh: 草稿本, en: Notebook }, desc: { zh: "怡的,上面全是数。", en: "Yi's, full of numbers." } }
  - { id: pole, name: { zh: 晾衣杆, en: Clothes pole }, desc: { zh: 阳台上摘的。, en: "From the balcony line." } }
  - { id: key, name: { zh: 303 的钥匙, en: Key to 303 }, desc: { zh: 值班室钥匙柜里缺的那把。, en: "The one missing from the office key cabinet." } }
  - { id: lighter, name: { zh: 打火机, en: Lighter }, desc: { zh: 厕所最里面那格地上捡的。, en: "Found on the floor of the last stall." } }
  - { id: card, name: { zh: 阿泽的学生证, en: Aze's student card }, desc: { zh: "303 里的。能拿在手里的证据。", en: "From 303. Proof you can hold." } }
  - { id: ledger, name: { zh: 登记本, en: Visitors' book }, desc: { zh: "值班室的。302 那行有个划掉的名字。", en: "From the office. A crossed-out name on the 302 line." } }
modifiers:
  - { kind: perStep, resource: fear, step: 25, value: -1, skill: reason, label: fear }
---

# 302

宿舍恐怖冒险的规则配置。上面的属性就是 Inkwright 游戏模式读取的 `GameConfig`,改过之后运行命令"生成游戏引擎 ink"重新生成 `_engine.ink`。

- id 全部英文(ink 变量名、选项标签里用);玩家看到的名字在 `name: { zh, en }` 里。
- 资源:恐惧是心理血条,体力是身体血条,电量是手机的光,“天亮前”是还剩几个小时(每去一个地方减一,归零天亮)。
- 物品在 `items` 里声明,引擎生成 `LIST items` 和 `VAR inv`;剧本里 `~ inv += pepper` 捡起、`{inv ? pepper: …}` 判断,状态栏显示背包。选项加 `#needs:pepper`,没有这件东西时选项灰掉、点不了。物品可以带技能加成(`modifiers: { strength: 1 }`),目前都没加。
- 技能初始值是暂定的,等角色写完再调。
- 设计稿见 `docs/设计.md`,demo 大纲见 `docs/demo.md`。
