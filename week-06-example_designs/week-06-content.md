# Week 6: Example Designs
# 第六週：範例實驗設計

> **Date 日期**: 2026/04/02  
> **Topic 主題**: Deconstructing Classic Paradigms 解構經典實驗範式

---

## Learning Objectives 學習目標

1. 理解 Posner Cueing Task（Posner 線索作業）的實驗邏輯與注意力導向
2. 理解 n-Back Task（n-Back 作業）的工作記憶測量原理
3. 掌握 Blocked vs. Interleaved 設計的差異與適用時機
4. 學會以程式碼進行條件的反平衡（Counterbalancing）

---

## 1. Paradigm 1: Posner Cueing Task
## 1. 範式一：Posner 線索作業

The Posner Cueing Task measures **attentional orienting**—how quickly attention can shift based on a spatial cue.

Posner 線索作業測量**注意力導向**——注意力根據空間線索轉移的速度。

### 1.1 Task Structure 作業結構

```
Fixation (+)     Cue (→)          Target (*)      Response
  500ms          200ms            Until response    
                                                   
    +        →      +              +      *        Press key
 center      arrow points       target appears     when you
             left or right      left or right       see *
```

**Trial types 試驗類型:**

| Type | Cue | Target | Expected RT |
|------|-----|--------|:-----------:|
| **Valid** | → (right) | Right | Fast ⚡ |
| **Invalid** | → (right) | Left | Slow 🐌 |
| **Neutral** | — (center) | Either | Medium |

### 1.2 Implementation 實作

```python
from psychopy import visual, core, event
from psychopy.hardware import keyboard
import random

win = visual.Window(size=[800, 600], color=[0, 0, 0], units='pix')
kb = keyboard.Keyboard()

# Stimuli 刺激
fixation = visual.TextStim(win, text='+', color='white', height=40)
cue_arrow = visual.TextStim(win, text='→', color='yellow', height=50)
target = visual.TextStim(win, text='*', color='white', height=50)

# Positions 位置
left_pos = (-200, 0)
right_pos = (200, 0)

# Conditions 條件
conditions = []
for _ in range(20):  # 20 repetitions per type
    conditions.append({'cue_dir': 'right', 'target_pos': 'right', 'validity': 'valid'})
    conditions.append({'cue_dir': 'right', 'target_pos': 'left',  'validity': 'invalid'})
    conditions.append({'cue_dir': 'left',  'target_pos': 'left',  'validity': 'valid'})
    conditions.append({'cue_dir': 'left',  'target_pos': 'right', 'validity': 'invalid'})
random.shuffle(conditions)

data_log = []

for trial in conditions:
    # 1. Fixation (500ms = 30 frames)
    for f in range(30):
        fixation.draw()
        win.flip()
    
    # 2. Cue (200ms = 12 frames)
    cue_arrow.text = '→' if trial['cue_dir'] == 'right' else '←'
    for f in range(12):
        fixation.draw()
        cue_arrow.draw()
        win.flip()
    
    # 3. SOA delay (300ms = 18 frames) — fixation only
    for f in range(18):
        fixation.draw()
        win.flip()
    
    # 4. Target — wait for response
    target.pos = right_pos if trial['target_pos'] == 'right' else left_pos
    target.draw()
    fixation.draw()
    win.flip()
    
    kb.clock.reset()
    keys = kb.waitKeys(keyList=['space', 'escape'], maxWait=2.0)
    
    if keys and keys[0].name == 'escape':
        break
    
    rt = keys[0].rt if keys else 2.0
    data_log.append({**trial, 'rt': rt})

# Summary 摘要
import pandas as pd
df = pd.DataFrame(data_log)
print(df.groupby('validity')['rt'].mean())
# Expected: valid < invalid (the "cueing effect")

win.close()
```

---

## 2. Paradigm 2: n-Back Task
## 2. 範式二：n-Back 作業

The n-Back task measures **working memory**. Participants judge whether the current stimulus matches the one presented *n* items ago.

n-Back 作業測量**工作記憶**。受試者判斷目前的刺激是否與 *n* 個項目前的刺激相同。

### 2.1 Task Logic (2-Back Example) 作業邏輯（2-Back 範例）

```
Sequence:  A  B  C  B  D  C  D  D
                  ↑        ↑     ↑
               2-back    2-back  2-back
               match?    match?  match?
               No (A≠C)  Yes!    Yes!
```

### 2.2 Implementation 實作

```python
import random

def generate_nback_sequence(n_trials=60, n_back=2, match_fraction=0.3):
    """
    Generate an n-back stimulus sequence.
    產生 n-back 刺激序列。
    """
    letters = list('ABCDEFGHJ')  # Exclude I/O to avoid confusion
    sequence = []
    is_target = []  # True if this trial is a "match"
    
    for i in range(n_trials):
        if i >= n_back and random.random() < match_fraction:
            # Make it a match: repeat the n-back letter
            letter = sequence[i - n_back]
            is_target.append(True)
        else:
            # Non-match: pick a letter that ISN'T the n-back
            forbidden = sequence[i - n_back] if i >= n_back else None
            choices = [l for l in letters if l != forbidden]
            letter = random.choice(choices)
            is_target.append(False)
        sequence.append(letter)
    
    return sequence, is_target


# PsychoPy implementation
from psychopy import visual, core, event
from psychopy.hardware import keyboard

win = visual.Window(size=[800, 600], color=[0, 0, 0], units='pix')
kb = keyboard.Keyboard()
stim = visual.TextStim(win, text='', color='white', height=80, bold=True)
feedback_text = visual.TextStim(win, text='', color='white', height=24, pos=(0, -150))

n_back = 2
sequence, targets = generate_nback_sequence(n_trials=40, n_back=n_back)

# Instructions 指導語
instr = visual.TextStim(win, wrapWidth=600, height=20, color='white',
    text=f'{n_back}-Back Task\n\n'
         f'Press SPACE if the current letter is the same\n'
         f'as the one shown {n_back} letters ago.\n\n'
         f'Press SPACE to begin.')
instr.draw()
win.flip()
event.waitKeys(keyList=['space'])

results = []

for i, (letter, is_match) in enumerate(zip(sequence, targets)):
    # Show letter (500ms = 30 frames)
    stim.text = letter
    for f in range(30):
        stim.draw()
        win.flip()
    
    # Blank ISI with response window (1500ms)
    win.flip()
    kb.clock.reset()
    keys = kb.waitKeys(keyList=['space', 'escape'], maxWait=1.5)
    
    if keys and keys[0].name == 'escape':
        break
    
    responded = bool(keys)
    
    # Score: Hit, Miss, False Alarm, Correct Rejection
    if is_match and responded:
        result = 'hit'
    elif is_match and not responded:
        result = 'miss'
    elif not is_match and responded:
        result = 'false_alarm'
    else:
        result = 'correct_rejection'
    
    results.append({'trial': i, 'letter': letter, 
                    'is_target': is_match, 'result': result})

# Performance summary 表現摘要
import pandas as pd
df = pd.DataFrame(results)
print("\n=== n-Back Performance ===")
print(df['result'].value_counts())
hits = (df['result'] == 'hit').sum()
total_targets = df['is_target'].sum()
fa = (df['result'] == 'false_alarm').sum()
total_non = (~df['is_target']).sum()
print(f"\nHit Rate:         {hits/total_targets:.1%}")
print(f"False Alarm Rate: {fa/total_non:.1%}")

win.close()
```

---

## 3. Blocked vs. Interleaved Designs
## 3. 區塊式 vs. 交錯式設計

| Feature | Blocked 區塊式 | Interleaved 交錯式 |
|---------|:---:|:---:|
| Condition grouping | All trials of one condition together | Conditions randomly mixed |
| Expectation | Participants know what's coming | Unpredictable |
| Task switching | No switching between conditions | Switching every trial |
| Practice effects | Within-block practice | Diluted across conditions |
| Best for | Measuring "pure" performance | Measuring cognitive flexibility |

```python
# Blocked design 區塊式設計
blocked = []
for condition in ['congruent', 'incongruent']:
    block = [condition] * 30  # 30 trials per block
    blocked.extend(block)
# Result: [cong, cong, ..., incong, incong, ...]

# Interleaved design 交錯式設計
interleaved = ['congruent', 'incongruent'] * 30
random.shuffle(interleaved)
# Result: [incong, cong, incong, cong, cong, ...]
```

---

## 4. Counterbalancing 反平衡

Counterbalancing ensures that condition order doesn't confound results.

反平衡確保條件順序不會混淆結果。

### 4.1 Latin Square 拉丁方格

```python
import itertools

def latin_square(conditions):
    """
    Generate a Latin square for counterbalancing condition order.
    產生拉丁方格以反平衡條件順序。
    """
    n = len(conditions)
    square = []
    for i in range(n):
        row = [(i + j) % n for j in range(n)]
        square.append([conditions[idx] for idx in row])
    return square

conditions = ['Faces', 'Words', 'Colors']
ls = latin_square(conditions)
for i, row in enumerate(ls):
    print(f"Participant group {i+1}: {' → '.join(row)}")

# Output:
# Participant group 1: Faces → Words → Colors
# Participant group 2: Words → Colors → Faces
# Participant group 3: Colors → Faces → Words
```

### 4.2 Assigning Participants 分配受試者

```python
def get_condition_order(participant_id, conditions):
    """Assign condition order based on participant number."""
    ls = latin_square(conditions)
    group = (participant_id - 1) % len(ls)
    return ls[group]

# Example 範例
for pid in range(1, 7):
    order = get_condition_order(pid, ['Faces', 'Words', 'Colors'])
    print(f"P{pid:02d}: {' → '.join(order)}")
```

---

## 5. Group Activity: Pseudocode Breakdown
## 5. 小組活動：虛擬碼拆解

**Task 任務**: In groups of 3–4, choose one paradigm below and write the complete **pseudocode** structure before coding:

以 3–4 人為一組，選擇下方一個範式，在撰寫程式碼前完成完整的**虛擬碼**架構：

1. **Flanker Task** — Target arrow (→) flanked by congruent (→→→→→) or incongruent (←←→←←) arrows
2. **Visual Search** — Find a target letter "T" among distractors "L" (vary set size: 4, 8, 16, 32)
3. **Emotional Stroop** — Name the color of emotional vs. neutral words

**Template 模板**:
```
INITIALIZE window, stimuli, data file
SET conditions = [...]
FOR each block:
    SHUFFLE conditions
    FOR each trial:
        SHOW fixation (Xms)
        SHOW stimulus
        RECORD response + RT
        COMPUTE accuracy
        LOG trial data
    END FOR
    SHOW block break
END FOR
SAVE data
CLOSE window
```

---

## References 參考資料

- **Posner, M. I.** (1980). Orienting of Attention. *Quarterly Journal of Experimental Psychology.*
- **Kirchner, W. K.** (1958). Age differences in short-term retention. *Journal of Experimental Psychology.*
- **PsychoPy Recipes**: [https://www.psychopy.org/recipes/](https://www.psychopy.org/recipes/)
