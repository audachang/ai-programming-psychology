# Syllabus: 心理學程式設計與人工智慧應用

**Programming and AI Application in Psychology**

## Basic Information

| Item                     | Details                                                                                                                                  |
| :----------------------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
| **Term**                 | Spring 2026                                                                                                                              |
| **Course Title**         | 心理學程式設計與人工智慧應用 <br> The Applications of Computer Hardware and Programming Languages in Behavioral Experiments and Big-Data |
| **Course Code**          | NS5116                                                                                                                                   |
| **Classroom**            | S5-607-1                                                                                                                                 |
| **Credit Hours**         | 3.0                                                                                                                                      |
| **Class Schedule**       | Thursdays : 9:00 AM – 12:00 PM                                                                                                           |
| **Course Teacher**       | Erik Chang 張智宏                                                                                                                        |
| **Teacher Email**        | [audachang@gmail.com](mailto:audachang@gmail.com)                                                                                        |
| **Contact Number**       | 03-4227151#65209                                                                                                                         |
| **Office and Location**  | Building: Science 5, Teacher Room: 601                                                                                                   |
| **Teacher Office Hours** | by appointment                                                                                                                           |
| **Online Course Link**   | [https://classroom.google.com/c/ODQwMzEwNDQ3NjI5](https://classroom.google.com/c/ODQwMzEwNDQ3NjI5)                                       |

## Weekly Schedule

| Week  |    Date    | Topic                                                      |
| :---: | :--------: | :--------------------------------------------------------- |
|   1   | 2026/02/26 | Orientation, Python Environment Setup & Basic Libraries    |
|   2   | 2026/03/05 | PsychoPy Coder & Stimulus Presentation                     |
|   3   | 2026/03/12 | Interaction & The Event Loop                               |
|   4   | 2026/03/19 | PsychoPy Builder, Online Paradigms & Adaptive Design       |
|   5   | 2026/03/26 | Statistical Analysis & Data Visualization                  |
|   6   | 2026/04/02 | Example Designs                                            |
|   7   | 2026/04/09 | Coding with AI helpers & Sustainable Programming Practices |
|   8   | 2026/04/16 | *Midterm Project Presentation*                             |
|   9   | 2026/04/23 | Machine Learning Foundations                               |
|  10   | 2026/04/30 | Basic ML Algorithms: Regression & Classification           |
|  11   | 2026/05/07 | Advanced ML Algorithms                                     |
|  12   | 2026/05/14 | GPU Acceleration Tools                                     |
|  13   | 2026/05/21 | Deep Learning                                              |
|  14   | 2026/05/28 | Large Language Model                                       |
|  15   | 2026/06/04 | ML & AI Capstone Studio                                    |
|  16   | 2026/06/11 | *Final Poster Presentation*                                |

## Course Resources

*   **GitHub Repository**: [https://github.com/audachang/ai-programming-psychology](https://github.com/audachang/ai-programming-psychology)
*   **Google Classroom**: [https://classroom.google.com/c/ODQwMzEwNDQ3NjI5?cjc=hfwtvn66](https://classroom.google.com/c/ODQwMzEwNDQ3NjI5?cjc=hfwtvn66)

## Grading Policy

### Component Descriptions

**Assignments (40%)**
Four practical coding assignments:
1.  PsychoPy Experiment Implementation
2.  Statistical Analysis & Visualization
3.  Machine Learning Model Training (Regression/Classification)
4.  Advanced AI Pipeline (GPU/Deep Learning/LLM)

**All work must be synced to individual GitHub repositories.**

**Midterm Project (20%)**
**Experimental Demo**: Demonstration of a custom-built psychological task using Python, focusing on creativity and technical precision.

**Final Capstone (30%)**
**End-to-End AI Project**: A complete pipeline from data source to AI prediction. Presented in a professional Poster Session format.

**Participation (10%)**
Code review contributions and active participation in class discussions.

## Weekly Content Details

### Module 1: Experimental Programming & Data Science
**Focus**: *From Hypothesis to Data—Mastering the Python ecosystem to build robust behavioral experiments, ensure reproducibility, and visualize scientific results.*

#### Week 1: Orientation, Python Environment Setup & Basic Libraries
*   **Date**: 2026/02/26
*   **Topic**: **Setting the Stage for Scientific Computing**
*   **Course Content**:
    *   **The Stack**: VS Code, Anaconda/Miniconda, and managing Virtual Environments (`conda`/`venv`).
    *   **Python Refresher**: Mutable vs. Immutable types, List Comprehensions, and Modular design.
    *   **Scientific Libs**: Introduction to **NumPy** for high-performance array manipulation (essential for coordinate systems, timing, and randomization).
*   **Teaching Plan**:
    *   **Lecture**: The "Reproducibility Crisis" and how code provides the solution.
    *   **Lab Activity (Install-Fest)**: Ensure every student has a working local environment.
    *   **Homework**: "Hello Data"—Write a script that generates a synthetic dataset of reaction times using NumPy.

#### Week 2: PsychoPy Coder & Stimulus Presentation
*   **Date**: 2026/03/05
*   **Topic**: **Drawing to the Screen (Beyond the GUI)**
*   **Course Content**:
    *   **The Window**: `visual.Window`, units (`norm`, `pix`, `deg`), and frame buffering (`win.flip()`).
    *   **Stimuli**: Programmatically creating `TextStim`, `ImageStim`, and `GratingStim` (Gabor patches).
    *   **Timing**: Understanding refresh rates (Hz), frame-based timing, and precision.
*   **Teaching Plan**:
    *   **Live Coding**: Build a script from scratch that displays a fixation cross followed by a drifting Gabor patch.
    *   **Lab**: Modify the script to change the orientation of the grating dynamically based on a frame counter.

#### Week 3: Interaction & The Event Loop
*   **Date**: 2026/03/12
*   **Topic**: **The Game Loop of Research**
*   **Course Content**:
    *   **Input**: Polling (`defaultKeyboard.getKeys()`) vs. Blocking (`event.waitKeys()`).
    *   **Architecture**: Implementing the Trial → Block → Experiment hierarchy.
    *   **Data Logging**: Using `pandas` or PsychoPy’s `ExperimentHandler` to save trial-by-trial data to CSV.
*   **Teaching Plan**:
    *   **Lab Activity (The Stroop Task)**: Build a complete interactive task where participants identify font colors of conflicting words.
    *   **Crucial Step**: Students must run the task on themselves to generate real data for Week 5.

#### Week 4: PsychoPy Builder, Online Paradigms & Adaptive Design
*   **Date**: 2026/03/19
*   **Topic**: **Rapid Prototyping & Web Deployment**
*   **Course Content**:
    *   **Builder GUI**: Routines, Loops, and injecting Custom Code components.
    *   **Pavlovia**: Converting Python experiments to PsychoJS for online data collection.
    *   **Adaptive Design**: Introduction to **Staircase procedures** (e.g., Up/Down method) for finding sensory thresholds.
*   **Teaching Plan**:
    *   **Demo**: Recreate the Week 3 manual code using the Builder GUI in 15 minutes.
    *   **Workshop**: Push a simple experiment to Pavlovia and collect data from a peer.

#### Week 5: Statistical Analysis & Data Visualization
*   **Date**: 2026/03/26
*   **Topic**: **From Raw Logs to Insights**
*   **Course Content**:
    *   **Data Cleaning**: Using **Pandas** to filter outliers, group data, and handle missing values.
    *   **Visualization**: **Seaborn** and **Matplotlib** for Violin plots, Scatter plots, and Error bars.
    *   **Stats**: T-tests and correlations using `scipy.stats`.
*   **Teaching Plan**:
    *   **Data Dive**: Analyze the **Stroop Task data** generated in Week 3.
    *   **Deliverable**: A script that produces a publication-quality figure showing the "Stroop Effect" (RT difference).

#### Week 6: Example Designs
*   **Date**: 2026/04/02
*   **Topic**: **Deconstructing Classic Paradigms**
*   **Course Content**:
    *   **Paradigm 1**: Posner Cueing Task (Attentional Orienting).
    *   **Paradigm 2**: n-Back Task (Working Memory).
    *   **Logic**: Blocked vs. Interleaved designs; Counterbalancing conditions programmatically.
*   **Teaching Plan**:
    *   **Group Analysis**: Students break down the logic of these tasks and write the "pseudocode" structure before implementation.

#### Week 7: Coding with AI Helpers & Sustainable Programming Practices
*   **Date**: 2026/04/09
*   **Topic**: **Modern Coding Workflows**
*   **Course Content**:
    *   **AI Tools**: Prompt Engineering for GitHub Copilot/ChatGPT (e.g., "Explain this bug," "Refactor for speed").
    *   **Clean Code**: Modular functions, docstrings, and PEP8 standards.
    *   **Version Control**: Basics of **Git** (`init`, `commit`, `push`) and GitHub.
*   **Teaching Plan**:
    *   **Hackathon ("Refactor Day")**: Students are given a messy, broken script and must use AI tools to fix, comment, and optimize it.

#### Week 8: Midterm Project Presentation
*   **Date**: 2026/04/16
*   **Activity**: **Seminar & Demo**
*   **Requirements**:
    1.  A fully functional Python/PsychoPy experiment.
    2.  Automatic data logging.
    3.  A visualization of pilot data.
    4.  A clean GitHub repository link.

### Module 2: Machine Learning & AI Applications
**Focus**: *Transitioning from analyzing past data to predicting future outcomes using Machine Learning, Deep Learning, and LLMs.*

#### Week 9: Machine Learning Foundations
*   **Date**: 2026/04/23
*   **Topic**: **Concepts & Pipelines**
*   **Course Content**:
    *   **Concepts**: Supervised vs. Unsupervised learning; Features ($X$) and Labels ($y$).
    *   **The Pipeline**: Data preprocessing (Scaling/Normalization), One-Hot Encoding, and Train/Test splits.
    *   **Library**: Introduction to `scikit-learn`.
*   **Teaching Plan**:
    *   **Lab**: Preprocessing a behavioral dataset to prepare it for ML (e.g., converting subject IDs to categorical codes).

#### Week 10: Basic ML Algorithms: Regression & Classification
*   **Date**: 2026/04/30
*   **Topic**: **Predictive Modeling**
*   **Course Content**:
    *   **Regression**: Linear Regression (Predicting continuous variables like RT).
    *   **Classification**: Logistic Regression and SVM (Predicting binary outcomes like Error/Correct).
    *   **Evaluation**: Accuracy, Precision, Recall, Confusion Matrix.
*   **Teaching Plan**:
    *   **Challenge**: Train a model to predict if a subject will make an error on the *next* trial based on their RT in the *previous* trial.

#### Week 11: Advanced ML Algorithms
*   **Date**: 2026/05/07
*   **Topic**: **Complexity & Unsupervised Learning**
*   **Course Content**:
    *   **Ensembles**: Random Forests and Gradient Boosting (XGBoost).
    *   **Dimensionality Reduction**: **PCA** (Principal Component Analysis) for high-dimensional data (e.g., surveys/pixels).
    *   **Clustering**: K-Means.
*   **Teaching Plan**:
    *   **Lab**: Use PCA to visualize a high-dimensional dataset in 2D space, then apply K-Means to identify clusters of participants.

#### Week 12: GPU Acceleration Tools
*   **Date**: 2026/05/14
*   **Topic**: **High-Performance Computing**
*   **Course Content**:
    *   **Hardware**: CPU vs. GPU architecture differences.
    *   **Tools**: Google Colab (Cloud GPUs), **CuPy** (NumPy on GPU), and **PyTorch Tensors**.
*   **Teaching Plan**:
    *   **Benchmark Lab**: Write a script that performs massive matrix multiplication. Measure and compare execution time on CPU (NumPy) vs. GPU (PyTorch).

#### Week 13: Deep Learning
*   **Date**: 2026/05/21
*   **Topic**: **Neural Networks**
*   **Course Content**:
    *   **Basics**: Neurons, Layers, Weights, Biases, Activation Functions (ReLU).
    *   **Training**: Backpropagation and Optimizers (Adam).
    *   **Implementation**: Building a Multi-Layer Perceptron (MLP) in PyTorch.
*   **Teaching Plan**:
    *   **Lab**: "Hello World" of Deep Learning—Training a network to classify handwritten digits (MNIST) or behavioral patterns.

#### Week 14: Large Language Model (LLM)
*   **Date**: 2026/05/28
*   **Topic**: **NLP in Research**
*   **Course Content**:
    *   **Theory**: Transformer Architecture overview (Attention mechanism).
    *   **Tools**: Hugging Face `transformers` library.
    *   **Application**: Using LLMs to generate stimuli text or analyze qualitative survey responses.
*   **Teaching Plan**:
    *   **Workshop**: Build a pipeline that uses a pre-trained BERT model to perform Sentiment Analysis on a text dataset.

#### Week 15: ML & AI Capstone Studio
*   **Date**: 2026/06/04
*   **Activity**: **Guided Development / Hackathon**
*   **Details**:
    *   Students work on their final projects in class.
    *   Instructor acts as a technical consultant (debugging code, refining models).
    *   **Peer Review**: Students pair up to code-review their analysis pipelines.

#### Week 16: Final Poster Presentation
*   **Date**: 2026/06/11
*   **Activity**: **Symposium**
*   **Deliverables**:
    1.  **Scientific Poster**: Introduction, Methods (Code/Algo), Results (Vis/Stats), Conclusion.
    2.  **Code Repository**: A public GitHub link allowing others to reproduce the results.
