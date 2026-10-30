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
companionResources:
  - { id: fear, name: { zh: 恐惧, en: Fear }, min: 0, max: 100, initial: 20 }
  - { id: trust, name: { zh: 信任, en: Trust }, min: 0, max: 100, initial: 50 }
characters:
  - { id: xin, name: { zh: 昕, en: Xin }, skills: { reason: 3, stamina: 3, charm: 5, insight: 4, strength: 2 } }
  - { id: yanbo, name: { zh: 烟波, en: Yanbo }, skills: { reason: 5, stamina: 3, charm: 2, insight: 4, strength: 3 }, companion: { fear: 15, trust: 60 } }
  - { id: zhiyong, name: { zh: 志勇, en: Zhiyong }, skills: { reason: 2, stamina: 5, charm: 3, insight: 2, strength: 6 }, companion: { fear: 35, trust: 55 } }
  - { id: yi, name: { zh: 怡, en: Yi }, skills: { reason: 4, stamina: 2, charm: 4, insight: 5, strength: 2 }, companion: { fear: 25, trust: 50 } }
modifiers:
  - { kind: perStep, resource: fear, step: 25, value: -1, skill: reason, label: fear }
---

# 302

宿舍恐怖冒险的规则配置。上面的属性就是 Inkwright 游戏模式读取的 `GameConfig`,改过之后运行命令"生成游戏引擎 ink"重新生成 `_engine.ink`。

- id 全部英文(ink 变量名、选项标签里用);玩家看到的名字在 `name: { zh, en }` 里。
- 资源:恐惧是心理血条,体力是身体血条,电量是手机的光。时间和道具是剧本里的普通变量。
- 技能初始值是暂定的,等角色写完再调。
- 设计稿见 `docs/设计.md`,demo 大纲见 `docs/demo.md`。
