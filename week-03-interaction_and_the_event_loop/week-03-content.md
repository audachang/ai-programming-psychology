# Week 3: Interaction & The Event Loop
# 第三週：互動與事件迴圈

> **Date 日期**: 2026/03/12  
> **Topic 主題**: The Game Loop of Research 研究中的遊戲迴圈

---

## Learning Objectives 學習目標

1. 理解 Polling（輪詢）與 Blocking（阻塞）兩種輸入偵測模式
2. 掌握 Trial → Block → Experiment 的階層式架構
3. 學會使用 `pandas` 與 PsychoPy 的 `ExperimentHandler` 記錄逐試驗資料
4. 完成一個完整的 Stroop Task 實作

---

## 1. Input Handling: Polling vs. Blocking
## 1. 輸入處理：輪詢 vs. 阻塞

### 1.1 Polling with `Keyboard` 使用 Keyboard 輪詢

Polling **checks for input on each frame** without pausing—ideal for time-critical experiments.

輪詢在**每個畫格檢查輸入**而不暫停——適合對時間敏感的實驗。

```python
from psychopy import visual, core, event
from psychopy.hardware import keyboard

win = visual.Window(size=[800, 600], color=[0, 0, 0], units='pix')
kb = keyboard.Keyboard()

stimulus = visual.TextStim(win, text='Press any key!', color='white')
clock = core.Clock()

# Non-blocking loop: check every frame
# 非阻塞迴圈：每個畫格檢查
stimulus.draw()
win.flip()
clock.reset()

response = None
while response is None:
    keys = kb.getKeys(keyList=['left', 'right', 'escape'], waitRelease=False)
    if keys:
        response = keys[0]
        rt = response.rt           # Reaction time in seconds 反應時間（秒）
        key_name = response.name   # Key pressed 按下的按鍵
        print(f"Key: {key_name}, RT: {rt:.3f}s")
    
    # You can update the display while waiting
    # 等待時可以繼續更新畫面
    stimulus.draw()
    win.flip()
```

### 1.2 Blocking with `event.waitKeys()` 使用 waitKeys 阻塞

Blocking **pauses execution** until a key is pressed—simpler but less flexible.

阻塞會**暫停執行**直到按鍵被按下——較簡單但靈活度較低。

```python
# Simple blocking wait 簡單阻塞等待
instruction = visual.TextStim(win, text='Press SPACE to start', color='white')
instruction.draw()
win.flip()

keys = event.waitKeys(keyList=['space'])  # Script pauses here 腳本在此暫停
```

### 1.3 Comparison Table 比較表

| Feature | Polling (`Keyboard`) | Blocking (`waitKeys`) |
|---------|---------------------|----------------------|
| Script pauses? | ❌ No | ✅ Yes |
| Can animate while waiting? | ✅ Yes | ❌ No |
| RT precision | Higher | Lower |
| Code complexity | Higher | Lower |
| Best for | Stimulus + response | Instructions, breaks |

---

## 2. The Experiment Hierarchy
## 2. 實驗的階層結構

```
Experiment 實驗
├── Block 1 區塊 1
│   ├── Trial 1 試驗 1
│   ├── Trial 2
│   └── Trial 3
├── Block 2 區塊 2
│   ├── Trial 1
│   └── ...
└── Block 3
    └── ...
```

### 2.1 Implementing the Hierarchy 實作階層結構

```python
import random

# Define conditions 定義條件
conditions = [
    {'word': 'RED',   'color': 'red',   'congruent': True},
    {'word': 'RED',   'color': 'blue',  'congruent': False},
    {'word': 'BLUE',  'color': 'blue',  'congruent': True},
    {'word': 'BLUE',  'color': 'red',   'congruent': False},
    {'word': 'GREEN', 'color': 'green', 'congruent': True},
    {'word': 'GREEN', 'color': 'red',   'congruent': False},
]

n_blocks = 3
n_repeats_per_block = 5  # Each condition repeated 5 times per block

for block_num in range(n_blocks):
    # Create and shuffle trial list for this block
    # 建立並打亂此區塊的試驗列表
    trial_list = conditions * n_repeats_per_block
    random.shuffle(trial_list)
    
    print(f"\n=== Block {block_num + 1} ===")
    for trial_num, trial in enumerate(trial_list):
        # Run trial... (see Section 4 for full implementation)
        print(f"  Trial {trial_num + 1}: {trial['word']} in {trial['color']}")
```

---

## 3. Data Logging
## 3. 資料記錄

### 3.1 Method A: Manual Logging with `pandas`

```python
import pandas as pd

# Collect data during experiment 實驗中收集資料
all_data = []

for trial in trial_list:
    # ... run trial, get response ...
    trial_data = {
        'block': block_num,
        'trial': trial_num,
        'word': trial['word'],
        'ink_color': trial['color'],
        'congruent': trial['congruent'],
        'response': key_name,     # e.g., 'left'
        'correct': is_correct,    # True/False
        'rt': rt                  # Seconds
    }
    all_data.append(trial_data)

# Save to CSV after experiment 實驗後儲存為 CSV
df = pd.DataFrame(all_data)
df.to_csv('data/sub01_stroop_data.csv', index=False)
print(f"Saved {len(df)} trials to CSV")
```

### 3.2 Method B: PsychoPy's ExperimentHandler

```python
from psychopy import data
import os

# Setup 設定
exp_info = {'participant': '001', 'session': '01'}
filename = f"data/{exp_info['participant']}_stroop"
os.makedirs('data', exist_ok=True)

# Create ExperimentHandler 建立實驗處理器
this_exp = data.ExperimentHandler(
    name='StroopTask',
    extraInfo=exp_info,
    dataFileName=filename  # Auto-saves to .csv and .psydat
)

# Create trial handler from conditions
trials = data.TrialHandler(
    trialList=conditions,
    nReps=5,
    method='random'
)
this_exp.addLoop(trials)

for trial in trials:
    # ... run trial ...
    trials.addData('response', key_name)
    trials.addData('correct', is_correct)
    trials.addData('rt', rt)
    this_exp.nextEntry()

this_exp.close()
```

---

## 4. Lab Activity: The Stroop Task
## 4. 實作活動：Stroop 作業

The [Stroop Effect](https://en.wikipedia.org/wiki/Stroop_effect) demonstrates that naming the **ink color** of a color word is slower when the word and ink are incongruent (e.g., the word "RED" printed in blue).

Stroop 效應證明，當文字與墨水顏色不一致時（例如用藍色印的「紅」字），命名**墨水顏色**的速度會變慢。

### Complete Stroop Task Script 完整 Stroop 作業腳本

```python
"""
Stroop Task — Week 3 Lab
Controls: 'r' = Red, 'g' = Green, 'b' = Blue, 'escape' = Quit
"""
from psychopy import visual, core, event, data
from psychopy.hardware import keyboard
import os, random

# ─── Configuration ───
exp_info = {'participant': '001'}
n_blocks = 2
n_reps = 4

conditions = [
    {'word': 'RED',   'ink': 'red',   'correct_key': 'r', 'congruent': 'yes'},
    {'word': 'RED',   'ink': 'green', 'correct_key': 'g', 'congruent': 'no'},
    {'word': 'RED',   'ink': 'blue',  'correct_key': 'b', 'congruent': 'no'},
    {'word': 'GREEN', 'ink': 'red',   'correct_key': 'r', 'congruent': 'no'},
    {'word': 'GREEN', 'ink': 'green', 'correct_key': 'g', 'congruent': 'yes'},
    {'word': 'GREEN', 'ink': 'blue',  'correct_key': 'b', 'congruent': 'no'},
    {'word': 'BLUE',  'ink': 'red',   'correct_key': 'r', 'congruent': 'no'},
    {'word': 'BLUE',  'ink': 'green', 'correct_key': 'g', 'congruent': 'no'},
    {'word': 'BLUE',  'ink': 'blue',  'correct_key': 'b', 'congruent': 'yes'},
]

# ─── Setup ───
win = visual.Window(size=[800, 600], color=[0, 0, 0], units='pix')
kb = keyboard.Keyboard()
fixation = visual.TextStim(win, text='+', color='white', height=40)
stimulus = visual.TextStim(win, text='', height=60, bold=True)
feedback = visual.TextStim(win, text='', height=30)

os.makedirs('data', exist_ok=True)
filename = f"data/{exp_info['participant']}_stroop"
this_exp = data.ExperimentHandler(name='Stroop', extraInfo=exp_info,
                                  dataFileName=filename)

# ─── Instructions ───
instructions = visual.TextStim(win, wrapWidth=600, height=22, color='white',
    text='Stroop Task\n\n'
         'Name the INK COLOR of each word:\n'
         '  r = Red | g = Green | b = Blue\n\n'
         'Respond as quickly and accurately as possible.\n\n'
         'Press SPACE to begin.')
instructions.draw()
win.flip()
event.waitKeys(keyList=['space'])

# ─── Run Experiment ───
for block in range(n_blocks):
    trial_list = conditions * n_reps
    random.shuffle(trial_list)
    
    trials = data.TrialHandler(trialList=trial_list, nReps=1, method='sequential')
    this_exp.addLoop(trials)
    
    for trial in trials:
        # Fixation (500ms = 30 frames at 60Hz)
        for frame in range(30):
            fixation.draw()
            win.flip()
        
        # Stimulus: show word in ink color
        stimulus.text = trial['word']
        stimulus.color = trial['ink']
        stimulus.draw()
        win.flip()
        
        # Collect response
        kb.clock.reset()
        keys = kb.waitKeys(keyList=['r', 'g', 'b', 'escape'], maxWait=3.0)
        
        if keys and keys[0].name == 'escape':
            win.close()
            core.quit()
        
        if keys:
            resp = keys[0].name
            rt = keys[0].rt
            correct = int(resp == trial['correct_key'])
        else:
            resp = 'none'
            rt = 3.0
            correct = 0
        
        # Log data 記錄資料
        trials.addData('response', resp)
        trials.addData('correct', correct)
        trials.addData('rt', rt)
        trials.addData('block', block + 1)
        this_exp.nextEntry()
        
        # Brief feedback (200ms)
        feedback.text = '✓' if correct else '✗'
        feedback.color = 'lime' if correct else 'red'
        for frame in range(12):
            feedback.draw()
            win.flip()
    
    # Block break (except after last block)
    if block < n_blocks - 1:
        brk = visual.TextStim(win, color='white', height=22,
            text=f'Block {block + 1} complete.\nPress SPACE for next block.')
        brk.draw()
        win.flip()
        event.waitKeys(keyList=['space'])

# ─── End ───
thanks = visual.TextStim(win, text='Thank you!\nData saved.', color='white')
thanks.draw()
win.flip()
core.wait(2)
win.close()
core.quit()
```

> **Crucial Step 關鍵步驟**: Run this task on yourself to generate real data. You will analyze this data in Week 5!
> 
> 在自己身上執行此作業以產生真實資料。你將在第五週分析這些資料！

---

## References 參考資料

- **PsychoPy Keyboard**: [https://www.psychopy.org/api/hardware/keyboard.html](https://www.psychopy.org/api/hardware/keyboard.html)
- **ExperimentHandler**: [https://www.psychopy.org/api/data.html](https://www.psychopy.org/api/data.html)
- **Stroop Effect (Wikipedia)**: [https://en.wikipedia.org/wiki/Stroop_effect](https://en.wikipedia.org/wiki/Stroop_effect)
- **Pandas Documentation**: [https://pandas.pydata.org/docs/](https://pandas.pydata.org/docs/)
