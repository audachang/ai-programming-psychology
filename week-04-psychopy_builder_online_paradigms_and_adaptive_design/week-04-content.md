# Week 4: PsychoPy Builder, Online Paradigms & Adaptive Design
# 第四週：PsychoPy Builder、線上實驗與適應性設計

> **Date 日期**: 2026/03/19  
> **Topic 主題**: Rapid Prototyping & Web Deployment 快速原型設計與網路部署

---

## Learning Objectives 學習目標

1. 使用 PsychoPy Builder GUI 建立實驗：Routines、Loops、Code Components
2. 理解 Builder 與 Coder 的互補關係
3. 學會將 Python 實驗轉換為 PsychoJS 並部署到 Pavlovia
4. 掌握 Staircase Procedures（階梯法）進行感覺閾值測量

---

## 1. PsychoPy Builder GUI
## 1. PsychoPy Builder 圖形介面

The Builder provides a visual interface for experiment design. It generates Python scripts automatically, which can be exported and modified.

Builder 提供視覺化的實驗設計介面，自動生成 Python 腳本，可匯出並修改。

### 1.1 Core Concepts 核心概念

```
Experiment 實驗
├── Routine: "instructions" 指導語
│   ├── TextComponent (顯示文字)
│   └── KeyboardComponent (等待按鍵)
├── Routine: "trial" 試驗
│   ├── TextComponent (fixation 注視點)
│   ├── ImageComponent (stimulus 刺激)
│   ├── KeyboardComponent (response 反應)
│   └── CodeComponent (custom logic 自訂邏輯)
├── Routine: "feedback" 回饋
│   └── TextComponent
└── Loop: "trials" (wraps trial + feedback)
    └── conditions.xlsx → Loads trial parameters
```

### 1.2 Routines 常式

A Routine is a sequence of components that run simultaneously for a defined duration.

Routine 是一組同時運行、具有定義持續時間的元件序列。

**Key properties 關鍵屬性:**
- **Start/Stop**: When each component appears/disappears (in seconds or frames)
- **Duration**: How long the routine lasts
- **Force end of Routine**: A keyboard response can end the routine early

### 1.3 Loops 迴圈

Loops repeat routines with different parameters loaded from a **conditions file** (Excel or CSV).

迴圈以從**條件檔案**（Excel 或 CSV）載入的不同參數重複執行常式。

**Example conditions file** (`conditions.xlsx`):

| word | ink_color | correct_ans | congruent |
|------|-----------|-------------|-----------|
| RED | red | r | 1 |
| RED | blue | b | 0 |
| BLUE | blue | b | 1 |
| BLUE | red | r | 0 |

**Loop settings 迴圈設定:**
- `nReps`: Number of repetitions per condition
- `loopType`: `random`, `sequential`, `fullRandom`, `staircase`

### 1.4 Code Components 程式碼元件

For logic that the GUI can't express, insert a **Code Component** into a Routine.

對於 GUI 無法表達的邏輯，在 Routine 中插入**程式碼元件**。

```python
# ── Begin Experiment tab ──
# Runs once at the start
score = 0
total = 0

# ── Begin Routine tab ──
# Runs at the start of each trial
total += 1

# ── End Routine tab ──
# Runs at the end of each trial
if key_resp.corr:
    score += 1
    msg = f'Correct! ({score}/{total})'
else:
    msg = f'Wrong. ({score}/{total})'
```

> **Demo 示範**: The instructor recreates the Week 3 Stroop task using Builder in ~15 minutes.

---

## 2. Pavlovia: Online Experiments
## 2. Pavlovia：線上實驗

[Pavlovia](https://pavlovia.org/) is a platform for hosting PsychoPy experiments online. Builder can auto-translate Python to **PsychoJS** (JavaScript).

Pavlovia 是一個託管 PsychoPy 線上實驗的平台。Builder 可以自動將 Python 轉換為 **PsychoJS**（JavaScript）。

### 2.1 Workflow 工作流程

```
1. Design in Builder          在 Builder 中設計
       ↓
2. Export HTML (PsychoJS)     匯出 HTML（PsychoJS）
       ↓
3. Push to Pavlovia (GitLab)  推送到 Pavlovia（GitLab）
       ↓
4. Set to "Running"           設定為「運行中」
       ↓
5. Share URL with participants 將網址分享給受試者
       ↓
6. Download data (CSV)        下載資料（CSV）
```

### 2.2 Key Considerations for Online Experiments
### 2.2 線上實驗的關鍵注意事項

| Issue | Offline (Lab) | Online (Pavlovia) |
|-------|:---:|:---:|
| Timing precision | ±1 ms | ±10–30 ms |
| Monitor calibration | ✅ Possible | ❌ Unknown display |
| Visual angle control | ✅ | ⚠️ Approximate (via "credit card" trick) |
| Audio latency | Low | Variable |
| Sample size potential | Low | Very high |
| Cost | Lab space | Pavlovia credits |

### 2.3 Python ↔ JavaScript Gotchas
### 2.3 Python 與 JavaScript 的差異陷阱

```python
# In Code Components, use "Both" or "JS" tabs for online compatibility
# 在程式碼元件中，使用「Both」或「JS」分頁以確保線上相容

# Python                          # JavaScript (Auto tab)
my_list = [1, 2, 3]              # my_list = [1, 2, 3];
len(my_list)                      # my_list.length;
my_list.append(4)                 # my_list.push(4);
random.shuffle(my_list)           # util.shuffle(my_list);
```

**Common pitfalls 常見陷阱:**
- `import` statements don't translate — use `Begin JS Experiment` tab
- NumPy is not available online — use plain JavaScript math
- File paths may differ between OS and browser

---

## 3. Adaptive Design: Staircase Procedures
## 3. 適應性設計：階梯法

A staircase dynamically adjusts stimulus difficulty based on performance to efficiently find **psychophysical thresholds** (e.g., the smallest contrast a participant can detect).

階梯法根據表現動態調整刺激難度，以有效率地找到**心理物理閾值**（例如：受試者能偵測到的最小對比度）。

### 3.1 Simple Up/Down Method 簡單上下法

```
Rule: After a CORRECT response → make it HARDER (decrease contrast)
      After a WRONG response → make it EASIER (increase contrast)
規則：正確反應後 → 變難（降低對比度）
      錯誤反應後 → 變簡單（提高對比度）
```

### 3.2 Implementation with PsychoPy 使用 PsychoPy 實作

```python
from psychopy import data, visual, core, event
from psychopy.hardware import keyboard

win = visual.Window(size=[800, 600], color=[0, 0, 0], units='pix')
kb = keyboard.Keyboard()

gabor = visual.GratingStim(win, tex='sin', mask='gauss', 
                           size=200, sf=0.05)
fixation = visual.TextStim(win, text='+', color='white', height=40)
prompt = visual.TextStim(win, text='Did you see it? (y/n)', 
                         color='white', height=20, pos=(0, -200))

# Create staircase 建立階梯
staircase = data.StairHandler(
    startVal=0.5,          # Starting contrast 起始對比度
    stepSizes=[0.1, 0.05, 0.02, 0.01],  # Step sizes decrease over time
    stepType='lin',        # Linear steps
    nTrials=50,            # Max trials
    nUp=1,                 # 1 wrong → go up
    nDown=3,               # 3 correct → go down (targets 79.4% threshold)
    minVal=0.01,           # Minimum contrast
    maxVal=1.0             # Maximum contrast
)

for contrast in staircase:
    # Fixation
    for f in range(30):
        fixation.draw()
        win.flip()
    
    # Stimulus at current contrast
    gabor.contrast = contrast
    for f in range(6):  # 100ms at 60Hz
        gabor.draw()
        prompt.draw()
        win.flip()
    
    # Response
    prompt.draw()
    win.flip()
    keys = kb.waitKeys(keyList=['y', 'n', 'escape'])
    
    if keys[0].name == 'escape':
        break
    
    # 1 = correct detection, 0 = missed
    response = 1 if keys[0].name == 'y' else 0
    staircase.addResponse(response)
    print(f"Contrast: {contrast:.3f}, Response: {response}")

# Results 結果
threshold = staircase.mean()  # Average of last N reversals
print(f"\nEstimated threshold: {threshold:.3f}")

win.close()
```

### 3.3 Interpreting Results 解讀結果

```python
import matplotlib.pyplot as plt
import numpy as np

# Plot staircase trajectory 繪製階梯軌跡
intensities = staircase.intensities
responses = staircase.data

plt.figure(figsize=(10, 4))
plt.plot(intensities, 'b-o', markersize=4)
plt.xlabel('Trial')
plt.ylabel('Contrast')
plt.title('Staircase: Contrast Detection Threshold')
plt.axhline(y=threshold, color='r', linestyle='--', label=f'Threshold = {threshold:.3f}')
plt.legend()
plt.tight_layout()
plt.savefig('staircase_result.png', dpi=150)
plt.show()
```

---

## 4. Workshop: Push to Pavlovia
## 4. 工作坊：部署到 Pavlovia

### Steps 步驟

1. **Create a Pavlovia account** at [pavlovia.org](https://pavlovia.org/)
2. In Builder, go to **File → Export HTML**
3. Click the **globe icon** (🌐) in Builder toolbar to sync with Pavlovia
4. Set your experiment status to **"Piloting"** for testing
5. Click **"Pilot"** to open the experiment in your browser
6. Send the pilot link to a classmate and collect their data
7. Download data from the Pavlovia dashboard

---

## References 參考資料

- **PsychoPy Builder**: [https://www.psychopy.org/builder/builder.html](https://www.psychopy.org/builder/builder.html)
- **Pavlovia**: [https://pavlovia.org/docs/](https://pavlovia.org/docs/)
- **PsychoJS**: [https://github.com/psychopy/psychojs](https://github.com/psychopy/psychojs)
- **Staircase Methods**: García-Pérez, M. A. (1998). *Forced-choice staircases with fixed step sizes.* Vision Research.
- **Adaptive Methods Tutorial**: [https://www.psychopy.org/recipes/interleaveStaircases.html](https://www.psychopy.org/recipes/interleaveStaircases.html)
