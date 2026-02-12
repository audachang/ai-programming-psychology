# Week 14: Large Language Models
# 第十四週：大型語言模型

> **Date 日期**: 2026/05/28  
> **Topic 主題**: NLP in Research 研究中的自然語言處理

---

## Learning Objectives 學習目標

1. 理解 **RNN** 與序列資料的處理方式
2. 掌握 **注意力機制** (Attention) 與 **Transformer** 架構的核心概念
3. 使用 Hugging Face `transformers` 進行文本分析
4. 學會使用 LLM 進行研究相關的 Prompt Engineering

---

## 1. From RNNs to Transformers
## 1. 從 RNN 到 Transformer

### 1.1 Recurrent Neural Networks (RNN)

RNNs process sequences one element at a time, maintaining a hidden state.

RNN 一次處理序列中的一個元素，並維持一個隱藏狀態。

```
x₁ → [h₁] → x₂ → [h₂] → x₃ → [h₃] → output
```

**Limitations 限制:**
- 長序列的梯度消失 (Vanishing Gradients)
- 無法平行處理 — 訓練速度慢

### 1.2 Attention Mechanism 注意力機制

Instead of compressing the entire sequence into one hidden state, attention lets the model "look back" at all positions.

注意力機制讓模型可以「回顧」所有位置，而非將整個序列壓縮成一個隱藏狀態。

**Key idea 核心概念:** For each output position, compute a weighted sum over all input positions. The weights (attention scores) indicate relevance.

```python
import torch
import torch.nn.functional as F
import numpy as np
import matplotlib.pyplot as plt

# Simplified self-attention example
# 簡化的自注意力範例
def self_attention(Q, K, V):
    """Scaled dot-product attention.
    縮放點積注意力。
    """
    d_k = Q.shape[-1]
    scores = Q @ K.transpose(-2, -1) / (d_k ** 0.5)  # Scaled scores
    weights = F.softmax(scores, dim=-1)                 # Attention weights
    output = weights @ V                                # Weighted values
    return output, weights

# Example: 4 tokens, embedding dim = 8
seq_len, d_model = 4, 8
Q = K = V = torch.randn(1, seq_len, d_model)

output, attn_weights = self_attention(Q, K, V)

# Visualize attention weights 視覺化注意力權重
fig, ax = plt.subplots(figsize=(5, 4))
tokens = ['Token1', 'Token2', 'Token3', 'Token4']
im = ax.imshow(attn_weights[0].detach().numpy(), cmap='Blues')
ax.set_xticks(range(seq_len))
ax.set_yticks(range(seq_len))
ax.set_xticklabels(tokens)
ax.set_yticklabels(tokens)
ax.set_xlabel('Key')
ax.set_ylabel('Query')
ax.set_title('Self-Attention Weights')
plt.colorbar(im)
plt.tight_layout()
plt.show()
```

### 1.3 The Transformer Architecture

| Component | Purpose |
|-----------|---------|
| **Multi-Head Attention** | Multiple parallel attention computations |
| **Feed-Forward Network** | Non-linear transformation per position |
| **Layer Normalization** | Stabilizes training |
| **Positional Encoding** | Injects sequence order information |

---

## 2. Hugging Face Transformers
## 2. Hugging Face Transformers 函式庫

### 2.1 Pipeline API — Quick Start 快速入門

```python
# pip install transformers torch
from transformers import pipeline

# Sentiment Analysis 情感分析
classifier = pipeline("sentiment-analysis")
results = classifier([
    "This experiment produced fascinating results!",
    "The participant reported feeling extremely anxious.",
    "The procedure was straightforward and uneventful.",
])

for r in results:
    print(f"  Label: {r['label']}, Score: {r['score']:.4f}")
```

### 2.2 Text Classification for Research 研究用文本分類

```python
# Zero-shot classification — no training needed!
# 零樣本分類 — 不需要訓練！
zero_shot = pipeline("zero-shot-classification")

text = "The patient has been experiencing persistent sleep difficulties and low mood for three weeks."

# Classify into custom categories 自訂分類類別
result = zero_shot(
    text,
    candidate_labels=["depression", "anxiety", "insomnia", "normal"],
)

print(f"Text: {text}")
print(f"Labels:  {result['labels']}")
print(f"Scores:  {[f'{s:.3f}' for s in result['scores']]}")
```

### 2.3 Named Entity Recognition (NER) 命名實體辨識

```python
# Extract entities from clinical notes
# 從臨床紀錄中擷取實體
ner = pipeline("ner", aggregation_strategy="simple")

clinical_note = "Patient John Smith, age 45, was referred by Dr. Chen from Taipei General Hospital for cognitive assessment."

entities = ner(clinical_note)
for entity in entities:
    print(f"  {entity['word']}: {entity['entity_group']} (score: {entity['score']:.3f})")
```

---

## 3. Using Pre-trained Models Directly
## 3. 直接使用預訓練模型

```python
from transformers import AutoTokenizer, AutoModel
import torch

# Load a model and tokenizer 載入模型與分詞器
model_name = "bert-base-uncased"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModel.from_pretrained(model_name)

# Tokenize text 分詞
text = "Working memory capacity predicts academic performance."
inputs = tokenizer(text, return_tensors="pt", padding=True, truncation=True)

print(f"Tokens: {tokenizer.tokenize(text)}")
print(f"Input IDs: {inputs['input_ids']}")
print(f"Attention Mask: {inputs['attention_mask']}")

# Get embeddings 取得嵌入向量
with torch.no_grad():
    outputs = model(**inputs)
    
# outputs.last_hidden_state: (batch, seq_len, hidden_dim)
embeddings = outputs.last_hidden_state
print(f"Embedding shape: {embeddings.shape}")  # (1, token_count, 768)

# Use [CLS] token embedding as sentence representation
# 使用 [CLS] token 嵌入作為句子表示
sentence_emb = embeddings[:, 0, :]
print(f"Sentence embedding shape: {sentence_emb.shape}")  # (1, 768)
```

---

## 4. Prompt Engineering for Research
## 4. 研究用的 Prompt Engineering

### 4.1 Effective Prompting Patterns

| Pattern | Example |
|---------|---------|
| **Role assignment** | "You are a psychology research assistant..." |
| **Few-shot** | Provide 2-3 examples before the task |
| **Chain-of-thought** | "Let's think step by step..." |
| **Output format** | "Respond in JSON format with keys..." |

### 4.2 Research Applications 研究應用

```python
# Example: Using an LLM to generate experimental stimuli
# 範例：使用 LLM 生成實驗刺激材料

# This demonstrates the PROMPT pattern — you would send this to an LLM API
prompt = """
You are helping design a psychology experiment on emotional word processing.

Generate 10 pairs of words, where each pair contains:
1. A neutral word
2. An emotionally valenced word (positive or negative) matched for:
   - Word length (± 1 character)
   - Word frequency (common everyday words)

Format as a table with columns: Neutral, Emotional, Valence, Length_N, Length_E

Example:
| Neutral | Emotional | Valence  | Length_N | Length_E |
|---------|-----------|----------|----------|----------|
| table   | happy     | positive | 5        | 5        |
"""

print(prompt)
# In practice, send to: openai.chat.completions.create() or similar API
```

---

## 5. Lab: Sentiment Analysis Pipeline
## 5. 實作：情感分析管道

### Task 任務

1. Prepare a list of 20+ sentences (mix of positive, negative, neutral — related to research participant feedback)
2. Use the Hugging Face `pipeline("sentiment-analysis")` to classify each sentence
3. Try `zero-shot-classification` with custom labels relevant to your research
4. Compare the two approaches — which is more flexible? More accurate?
5. **Bonus**: Use `AutoTokenizer` and `AutoModelForSequenceClassification` to manually tokenize and predict, inspecting the intermediate outputs

---

## References 參考資料

- **Hugging Face Documentation**: [https://huggingface.co/docs/transformers/](https://huggingface.co/docs/transformers/)
- **Attention Is All You Need**: Vaswani et al. (2017), *Advances in NeurIPS*, 30
- **BERT Paper**: Devlin et al. (2019), *NAACL-HLT*
- **Prompt Engineering Guide**: [https://www.promptingguide.ai/](https://www.promptingguide.ai/)
- **Hugging Face Course**: [https://huggingface.co/course/](https://huggingface.co/course/)