---
system: { path: packs/narrative-check, version: 1 }
resources:
  - { id: battery, name: { zh: 电量, en: Battery }, min: 0, max: 100, initial: 80 }
  - { id: dawn, name: { zh: 天亮前, en: Till dawn }, min: 0, max: 8, initial: 8 }
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
---

# 302

宿舍恐怖冒险的规则配置。上面的属性就是 Inkwright 游戏模式读取的 `GameConfig`;规则、难度、五种技能和它们的声音、恐惧和体力、同伴的恐惧和信任、恐惧修正都来自规则包 `packs/narrative-check`(Inkwright 叙事检定包的一份副本,`system:` 指向它),这里只写这个游戏自己的东西。改过之后运行命令"生成游戏引擎 ink"重新生成 `_engine.ink`。

- id 全部英文(ink 变量名、选项标签里用);玩家看到的名字在 `name: { zh, en }` 里。
- 资源:恐惧是心理血条,体力是身体血条,电量是手机的光,“天亮前”是还剩几个小时(每去一个地方减一,归零天亮)。
- 物品在 `items` 里声明,引擎生成 `LIST items` 和 `VAR inv`;剧本里 `~ inv += pepper` 捡起、`{inv ? pepper: …}` 判断,状态栏显示背包。选项加 `#needs:pepper`,没有这件东西时选项灰掉、点不了。物品可以带技能加成(`modifiers: { strength: 1 }`),目前都没加。
- 技能初始值是暂定的,等角色写完再调。
- 设计稿见 `docs/设计.md`,demo 大纲见 `docs/demo.md`。
